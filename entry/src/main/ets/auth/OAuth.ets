import { http } from "@kit.NetworkKit";
import { uri } from "@kit.ArkTS";

// 自定义错误类型
export class AuthenticationException extends Error {}

export class ResponseCodeException extends AuthenticationException {
  constructor(public url?: string, code?: number) {
    super('ResponseCodeException ' + url + " " + code);
  }
}
export class ServerDisconnectException extends AuthenticationException {
  constructor(public cause?: Error) {
    super('Server disconnected');
  }
}
export class NoSelectedCharacterException extends AuthenticationException {
  constructor() {
    super('No character selected');
  }
}
export class ServerResponseMalformedException extends AuthenticationException {
  constructor(public cause?: string) {
    super('Server response malformed');
  }
}
export class CredentialExpiredException extends AuthenticationException {
  constructor() {
    super('Credential expired');
  }
}
export class RemoteAuthenticationException extends AuthenticationException {
  constructor(
    public error: string,
    public errorDescription: string,
    public errorUri: string
  ) {
    super(`${error}: ${errorDescription}`);
  }
}

// 工具函数
export function mapOf<K extends string, V>(...pairs: [K, V][]): Record<K, V> {
  return pairs.reduce((acc, [key, value]) => {
    acc[key] = value;
    return acc;
  }, {} as Record<K, V>);
}

export function toJson<T>(response: http.HttpResponse){
  if(response.resultType == http.HttpDataType.STRING){
    const result = response.result as string;
    return JSON.parse(result) as T;
  } else {
    return response.result as T;
  }
}


// 网络工具
export class NetworkUtils {
  static withQuery(url: string, params: Record<string, string>): string {
    const urlObj = new uri.URI(url);
    Object.entries(params).forEach(([key, value]) => {
      urlObj.addQueryValue(key, value)
    });
    return urlObj.toString();
  }
}

// OAuth 类
export class OAuth {
  public static readonly MICROSOFT = new OAuth(
    'https://login.live.com/oauth20_authorize.srf',
    'https://login.live.com/oauth20_token.srf',
    'https://login.microsoftonline.com/consumers/oauth2/v2.0/devicecode',
    'https://login.microsoftonline.com/consumers/oauth2/v2.0/token'
  );

  constructor(
    private readonly authorizationURL: string,
    private readonly accessTokenURL: string,
    private readonly deviceCodeURL: string,
    private readonly tokenURL: string
  ) {}

  async authenticate(grantFlow: GrantFlow, options: Options): Promise<Result> {
    try {
      switch (grantFlow) {
        case GrantFlow.AUTHORIZATION_CODE:
          return await this.authenticateAuthorizationCode(options);
        case GrantFlow.DEVICE:
          return await this.authenticateDevice(options);
        default:
          throw new Error(`grant flow ${grantFlow}`);
      }
    } catch (e) {
      if (e instanceof Error) {
        if (e.name === 'IOException') {
          throw new ServerDisconnectException(e);
        }
        if (e.name === 'InterruptedException') {
          throw new NoSelectedCharacterException();
        }
        if (e.name === 'JsonParseException') {
          throw new ServerResponseMalformedException(e.message);
        }
      }
      throw e;
    }
  }

  private async authenticateAuthorizationCode(options: Options): Promise<Result> {
    const session = await options.callback.startServer();
    await options.callback.openBrowser(
      NetworkUtils.withQuery(this.authorizationURL, {
        client_id: options.callback.getClientId(),
        response_type: 'code',
        redirect_uri: session.getRedirectURI(),
        scope: options.scope,
        prompt: 'select_account'
      })
    );

    const code = await session.waitFor();

    // Authorization Code -> Token
    const response = (await http.createHttp().request(this.accessTokenURL, {
      method: http.RequestMethod.POST,
      extraData: {
        'client_id': options.callback.getClientId(),
        'code': code,
        'grant_type': 'authorization_code',
        'client_secret': options.callback.getClientSecret(),
        'redirect_uri': session.getRedirectURI(),
        'scope': options.scope
      }}
    )).result as AuthorizationResponse;


    this.handleErrorResponse(response);
    return new Result(response.access_token, response.refresh_token);
  }

  private async authenticateDevice(options: Options): Promise<Result> {
    const deviceTokenResponse = (await http.createHttp().request(this.deviceCodeURL, {
      method: http.RequestMethod.POST,
      extraData: {
        'client_id': options.callback.getClientId(),
        'scope': options.scope
      }}
    )).result as DeviceTokenResponse;
    this.handleErrorResponse(deviceTokenResponse);
    options.callback.grantDeviceCode(deviceTokenResponse.user_code, deviceTokenResponse.verification_uri);
    // Microsoft OAuth Flow
    await options.callback.openBrowser(deviceTokenResponse.verification_uri);

    const startTime = Date.now();
    let interval = deviceTokenResponse.interval * 1000; // Convert to milliseconds

    while (true) {
      await this.sleep(Math.max(interval, 1));

      // We stop waiting if user does not respond our authentication request in 15 minutes.
      const estimatedTime = Date.now() - startTime;
      if (estimatedTime / 1000 >= Math.min(deviceTokenResponse.expires_in, 900)) {
        throw new NoSelectedCharacterException();
      }
      const tokenResponse = (await http.createHttp().request(this.tokenURL, {
        method: http.RequestMethod.POST,
        extraData: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
          'code': deviceTokenResponse.device_code,
          'client_id': options.callback.getClientId(),

        },
      })).result as TokenResponse
      if (tokenResponse.error === 'authorization_pending') {
        continue;
      }
      if (tokenResponse.error === 'expired_token') {
        throw new NoSelectedCharacterException();
      }
      if (tokenResponse.error === 'slow_down') {
        interval += 5000;
        continue;
      }
      return new Result(tokenResponse.access_token, tokenResponse.refresh_token);
    }
  }

  async refresh(refreshToken: string, options: Options): Promise<Result> {
    try {
      const query: Record<string, string> = {
        client_id: options.callback.getClientId(),
        refresh_token: refreshToken,
        grant_type: 'refresh_token'
      };

      if (!options.callback.isPublicClient()) {
        query.client_secret = options.callback.getClientSecret();
      }
      const response = await http.createHttp().request(this.tokenURL, {
          method: http.RequestMethod.POST,
          extraData: query,
      })
      const result = response.result as RefreshResponse
      this.handleErrorResponse(result);
      return new Result(result.access_token, result.refresh_token);
    } catch (e) {
      if (e instanceof Error) {
        if (e.name === 'IOException') {
          throw new ServerDisconnectException(e);
        }
        if (e.name === 'JsonParseException') {
          throw new ServerResponseMalformedException(e.message);
        }
      }
      throw e;
    }
  }

  private handleErrorResponse(response: ErrorResponse): void {
    if (!response.error || !response.error_description) {
      return;
    }

    if (response.error === 'invalid_grant' &&
    response.error_description?.includes('AADSTS70000')) {
      throw new CredentialExpiredException();
    }
    throw new RemoteAuthenticationException(
      response.error,
      response.error_description || '',
      ''
    );
  }

  private sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

export class Options {
  userAgent?: string;

  constructor(
    public readonly scope: string,
    public readonly callback: Callback
  ) {}

  setUserAgent(userAgent: string): this {
    this.userAgent = userAgent;
    return this;
  }
}

export interface Session {
  getRedirectURI(): string;

  /**
   * Wait for authentication
   *
   * @returns authentication code
   * @throws InterruptedException if interrupted
   * @throws ExecutionException if an I/O error occurred.
   */
  waitFor(): Promise<string>;

  getIdToken?(): string | null;
}

export interface Callback {
  /**
   * Start OAuth callback server at localhost.
   *
   * @throws IOException if an I/O error occurred.
   */
  startServer(): Promise<Session>;

  grantDeviceCode(userCode: string, verificationURI: string): void;

  /**
   * Open browser
   *
   * @param url OAuth url.
   */
  openBrowser(url: string): Promise<void>;

  getClientId(): string;

  getClientSecret(): string;

  isPublicClient(): boolean;
}

export enum GrantFlow {
  AUTHORIZATION_CODE = 'AUTHORIZATION_CODE',
  DEVICE = 'DEVICE'
}

export class Result {
  constructor(
    public readonly accessToken: string,
    public readonly refreshToken: string
  ) {}
}

// 响应类型定义
interface DeviceTokenResponse extends ErrorResponse {
  user_code: string;
  device_code: string;
  verification_uri: string;
  expires_in: number;
  interval: number;
}

interface TokenResponse extends ErrorResponse {
  token_type?: string;
  expires_in?: number;
  ext_expires_in?: number;
  scope?: string;
  access_token?: string;
  refresh_token?: string;
}

interface ErrorResponse {
  error?: string;
  error_description?: string;
  correlation_id?: string;
}

/**
 * Error response: {"error":"invalid_grant","error_description":"The provided
 * value for the 'redirect_uri' is not valid. The value must exactly match the
 * redirect URI used to obtain the authorization
 * code.","correlation_id":"??????"}
 */
export interface AuthorizationResponse extends ErrorResponse {
  token_type?: string;
  expires_in?: number;
  scope?: string;
  access_token?: string;
  refresh_token?: string;
  user_id?: string;
  foci?: string;
}

export interface RefreshResponse extends ErrorResponse {
  expires_in?: number;
  access_token?: string;
  refresh_token?: string;
}