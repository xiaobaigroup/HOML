
import { OAuth, Callback, GrantFlow, Result as OAuthResult, AuthenticationException, ServerDisconnectException, ServerResponseMalformedException, RemoteAuthenticationException,
  Options,
  ResponseCodeException,
  toJson,
  withQuery, } from './OAuth';
import { http } from '@kit.NetworkKit';
import { MinecraftAccount } from '../model/MinecraftAccount';
import { Xb_GetResourceString } from 'xb_components';

// 常量
const SCOPE = "XboxLive.signin offline_access";

// // 日志接口
// export interface Logger {
//   info(message: string): void;
//   warning(message: string): void;
//   log(level: string, message: string, error?: Error): void;
// }
//
// export const LOG: Logger = {
//   info: (message: string) => console.log(`[INFO] ${message}`),
//   warning: (message: string) => console.warn(`[WARNING] ${message}`),
//   log: (level: string, message: string, error?: Error) => {
//     if (error) {
//       console.log(`[${level}] ${message}`, error);
//     } else {
//       console.log(`[${level}] ${message}`);
//     }
//   }
// };

// Microsoft 服务类
export class MicrosoftService {
  private readonly callback: Callback;

  constructor(callback: Callback) {
    this.callback = callback;
  }


  async authenticate(): Promise<MicrosoftSession> {
    const result = await OAuth.MICROSOFT.authenticate(GrantFlow.DEVICE, new Options(SCOPE, this.callback));
    return await this.authenticateViaLiveAccessToken(result.accessToken, result.refreshToken);
  }

  async refresh(oldSession: MicrosoftSession): Promise<MicrosoftSession> {
    const result = await OAuth.MICROSOFT.refresh(oldSession.refreshToken, new Options(SCOPE, this.callback));
    return await this.authenticateViaLiveAccessToken(result.accessToken, result.refreshToken);
  }

  private getUhs(response: XBoxLiveAuthenticationResponse | undefined, existingUhs: string | undefined): string {
    if (response && response.errorCode && response.errorCode !== 0) {
      throw new XboxAuthorizationException(response.errorCode, response.redirectUrl || '');
    }

    if ((response && !response.DisplayClaims?.xui?.length) || (response && !response.DisplayClaims?.xui[0].uhs)) {
      // LOG.warning(`Unrecognized xbox authorization response ${JSON.stringify(response)}`);
      throw new NoXuiException();
    }
    if(!response)
      throw new ServerResponseMalformedException('uhs mismatched');
    const uhs = response.DisplayClaims!.xui[0].uhs as string;
    if (existingUhs && uhs !== existingUhs) {
      throw new ServerResponseMalformedException('uhs mismatched');
    }
    return uhs;
  }

  private async authenticateViaLiveAccessToken(
    liveAccessToken?: string,
    liveRefreshToken?: string
  ): Promise<MicrosoftSession> {
    let uhs: string | undefined;
    let xboxResponse: XBoxLiveAuthenticationResponse;
    let minecraftXstsResponse: XBoxLiveAuthenticationResponse;

    try {
      // Authenticate with XBox Live
      let response = (await http.createHttp().request('https://user.auth.xboxlive.com/user/authenticate', {
        method: http.RequestMethod.POST,
        extraData:{
          Properties: {
            AuthMethod: 'RPS',
            SiteName: 'user.auth.xboxlive.com',
            RpsTicket: `d=${liveAccessToken}`
          },
          RelyingParty: 'http://auth.xboxlive.com',
          TokenType: 'JWT'
        },
        header:{
          "Content-Type": "application/json", "accept": "application/json"
        }
      }
      ));
      xboxResponse = toJson<XBoxLiveAuthenticationResponse>( response)
      uhs = this.getUhs(xboxResponse, undefined);
      const Response = (await http.createHttp().request('https://xsts.auth.xboxlive.com/xsts/authorize', {
        method: http.RequestMethod.POST,
        extraData: {
          "Properties": {
            "SandboxId": 'RETAIL',
            "UserTokens": [xboxResponse.Token]
          },
          "RelyingParty": 'rp://api.minecraftservices.com/',
          "TokenType": 'JWT'
        },
        header: {
          "Content-Type": "application/json", "accept": "application/json"
        }
      }
      ));
      minecraftXstsResponse = toJson<XBoxLiveAuthenticationResponse>(Response)
    } catch (e) {
      if ( e.responseCode === 400) {
        throw new XBox400Exception();
      }
    }

    this.getUhs(minecraftXstsResponse!, uhs!);

    // Authenticate with Minecraft
    const xresponse = (await http.createHttp().request('https://api.minecraftservices.com/authentication/login_with_xbox', {
      method: http.RequestMethod.POST,
      extraData: {
        identityToken: `XBL3.0 x=${uhs};${minecraftXstsResponse!.Token}`
      },
      header:{  "Content-Type": "application/json",  "accept": "application/json", "Authorization": `Bearer ${minecraftXstsResponse!.Token}` } }
    ));
    const minecraftResponse = toJson<MinecraftLoginWithXBoxResponse>(xresponse)

    const notAfter = minecraftResponse.expires_in * 1000 + Date.now();

    // Check MC ownership
    const response = (await http.createHttp().request('https://api.minecraftservices.com/entitlements/mcstore', {
      method: http.RequestMethod.GET, header:{ "accept": "application/json", "Authorization": `Bearer ${minecraftResponse.access_token}` } }
    ));

    if (response.responseCode !== 200) {
      throw new ResponseCodeException('https://api.minecraftservices.com/entitlements/mcstore', response.responseCode);
    }

    // Get Minecraft Account UUID
    const profileResponse = await this.getMinecraftProfile(minecraftResponse.token_type, minecraftResponse.access_token);
    this.handleErrorResponse(profileResponse);

    return new MicrosoftSession(
      minecraftResponse.token_type,
      minecraftResponse.access_token,
      notAfter,
      liveRefreshToken!,
      new MicrosoftSessionUser(minecraftResponse.username, uhs ?? ""),
      new MicrosoftGameProfile(profileResponse.id, profileResponse.name)
    );
  }

  async getCompleteProfile(authorization: string): Promise<MinecraftProfileResponse | null> {
    try {
      const response = (await http.createHttp().request('https://api.minecraftservices.com/minecraft/profile', {
        method: http.RequestMethod.GET, header:{ "Authorization": authorization } }
      ));
      return toJson<MinecraftProfileResponse>(response)
    } catch (e) {
      throw Error(e.message);
    }
  }

  async validate(notAfter: number, tokenType: string, accessToken: string): Promise<boolean> {
    if (!tokenType || !accessToken) {
      throw new Error('tokenType and accessToken are required');
    }

    if (Date.now() > notAfter) {
      return false;
    }

    try {
      await this.getMinecraftProfile(tokenType, accessToken);
      return true;
    } catch (e) {
      if (e instanceof ResponseCodeException) {
        return false;
      }
      if (e instanceof Error && e.name === 'IOException') {
        throw new ServerDisconnectException(e);
      }
      throw Error(e);
    }
  }

  private handleErrorResponse(response: MinecraftErrorResponse): void {
    if (response.error) {
      throw new RemoteAuthenticationException(
        response.error,
        response.errorMessage || '',
        response.developerMessage || ''
      );
    }
  }

  static getTextures(profile: MinecraftProfileResponse): Map<TextureType, Texture> | null {
    if (!profile) return null;

    const textures = new Map<TextureType, Texture>();

    if (profile.skins && profile.skins.length > 0) {
      textures.set(TextureType.SKIN, {url:profile.skins[0].url, metadata: undefined});
    }
    // if (profile.capes && profile.capes.length > 0) {
    //   textures.set(TextureType.CAPE, new Texture(profile.capes[0].url, null));
    // }

    return textures;
  }

  private static async getXBoxProfile(uhs: string, xstsToken: string): Promise<void> {
    (await http.createHttp().request('https://api.minecraftservices.com/minecraft/profile', {
      method: http.RequestMethod.GET, extraData: {
        "settings":"GameDisplayName,AppDisplayName,AppDisplayPicRaw,GameDisplayPicRaw,"
          + "PublicGamerpic,ShowUserAsAvatar,Gamerscore,Gamertag,ModernGamertag,ModernGamertagSuffix,"
          + "UniqueModernGamertag,AccountTier,TenureLevel,XboxOneRep,"
          + "PreferredColor,Location,Bio,Watermarks,"
          + "RealName,RealNameOverride,IsQuarantined"
      }, header:{ "accept": `application/json`, 'Authorization':`XBL3.0 x=${uhs};${xstsToken}`, 'x-xbl-contract-version': '3' } }
    )).result;
  }

  private async getMinecraftProfile(tokenType: string, accessToken: string): Promise<MinecraftProfileResponse> {
    // const conn = await HttpRequest.GET('https://api.minecraftservices.com/minecraft/profile')
    //   .authorization(`${tokenType} ${accessToken}`)
    //   .createConnection();
    const response = (await http.createHttp().request('https://api.minecraftservices.com/minecraft/profile', {
      method: http.RequestMethod.GET, header:{ "Authorization": `${tokenType} ${accessToken}` } }
    ));
    const responseCode = response.responseCode;
    if (responseCode === 404) {
      throw new NoMinecraftJavaEditionProfileException();
    } else if (responseCode !== 200) {
      throw new ResponseCodeException('https://api.minecraftservices.com/minecraft/profile', responseCode);
    }
    return toJson<MinecraftProfileResponse>(response)
  }

  async getCompleteGameProfile(uuid: string): Promise<CompleteGameProfile | null> {
    if (!uuid) throw new Error('uuid is required');

    try {
      const result = await this.request<CompleteGameProfile>(
        `https://sessionserver.mojang.com/session/minecraft/profile/${uuid}`,
        undefined
      );
      return result;
    } catch (e) {
      if (e instanceof AuthenticationException) {
        throw e;
      }
      return null;
    }
  }

  private async request<T>(url: string, payload: object | undefined): Promise<T> {
    try {
      if (payload === null) {
        const response = (await http.createHttp().request(url, {
          method: http.RequestMethod.GET, header:{ } }
        ));
        return toJson<T>(response)
      } else {
        const response = (await http.createHttp().request(url, {
          method: http.RequestMethod.POST,
          extraData:  typeof payload === 'string' ? payload : JSON.stringify(payload),
          header:{ 'accept':'application/json'} }
        ));
        return toJson<T>(response)
      }
    } catch (e) {
      if (e instanceof Error && e.name === 'IOException') {
        throw new ServerDisconnectException(e);
      }
      throw Error(e)
    }
  }
}

// 异常类
export class XboxAuthorizationException extends AuthenticationException {
  static readonly BANNED = 2148916227;
  static readonly MISSING_XBOX_ACCOUNT = 2148916233;
  static readonly COUNTRY_UNAVAILABLE = 2148916235;
  static readonly ADD_FAMILY = 2148916238;
  public readonly errorCode: number;
  public readonly redirect: string;

  constructor(
    errorCode: number,
    redirect: string
  ) {
    super(`Xbox authorization failed: ${errorCode}`);
    this.errorCode = errorCode;
    this.redirect = redirect;
  }
}

export class XBox400Exception extends AuthenticationException {
  constructor() {
    super('Xbox 400 error');
  }
}

export class NoMinecraftJavaEditionProfileException extends AuthenticationException {
  constructor() {
    super('No Minecraft Java Edition profile found');
  }
}

export class NoXuiException extends AuthenticationException {
  constructor() {
    super('No XUI found');
  }
}

// 会话类
export class MicrosoftSession {
  public readonly tokenType: string;
  public readonly accessToken: string;
  public readonly notAfter: number;
  public readonly refreshToken: string;
  public readonly user: MicrosoftSessionUser
  public readonly profile: MicrosoftGameProfile;

  constructor(
    tokenType: string,
    accessToken: string,
    notAfter: number,
    refreshToken: string,
    user: MicrosoftSessionUser,
    profile: MicrosoftGameProfile
  ) {
    this.tokenType = tokenType;
    this.accessToken = accessToken;
    this.notAfter = notAfter;
    this.refreshToken = refreshToken;
    this.user = user;
    this.profile = profile;
  }

  toAccount(){
    const account = new MinecraftAccount()
    account.accessToken = this.accessToken
    account.profileId = this.profile.id
    account.username = this.user.username
    account.xuid = undefined
    account.clientToken = Xb_GetResourceString($r("app.string.MicrosortAuthClientId"))
    account.session = this
    return account;
  }


}
class MicrosoftSessionUser {
  public readonly username: string;
  public readonly uhs: string;
  constructor(username: string, uhs: string) {
    this.username = username;
    this.uhs = uhs
  }
};
class MicrosoftGameProfile {
  public readonly id: string;
  public readonly name: string;
  public constructor(id: string, name: string) {
    this.id = id;
    this.name = name;
  }
}

// 响应类型定义
export interface XBoxLiveAuthenticationResponseDisplayClaims {
  xui: Array<Record<string, string>>;
}

export interface MicrosoftErrorResponse {
  XErr?: number;
  Message?: string;
  Redirect?: string;
}

export interface XBoxLiveAuthenticationResponse extends MicrosoftErrorResponse {
  IssueInstant?: string;
  NotAfter?: string;
  Token: string;
  DisplayClaims?: XBoxLiveAuthenticationResponseDisplayClaims;
  errorCode: number;
  redirectUrl?: string;
}

export interface MinecraftLoginWithXBoxResponse {
  username: string;
  roles?: string[];
  access_token: string;
  token_type: string;
  expires_in: number;
}

export interface MinecraftStoreResponseItem {
  name: string;
  signature: string;
}

export interface MinecraftStoreResponse extends MinecraftErrorResponse {
  items?: MinecraftStoreResponseItem[];
  signature?: string;
  keyId?: string;
}

export interface MinecraftProfileResponseSkin {
  id: string;
  state: string;
  url: string;
  variant: string; // CLASSIC, SLIM
  alias?: string;

  validate(): void;
}

export interface MinecraftProfileResponseCape {}

export interface MinecraftProfileResponse extends MinecraftErrorResponse {
  id: string;
  name: string;
  skins: MinecraftProfileResponseSkin[];
  capes: MinecraftProfileResponseCape[];

  validate(): void;
}

export interface MinecraftErrorResponse {
  path?: string;
  errorType?: string;
  error?: string;
  errorMessage?: string;
  developerMessage?: string;
}

// 其他类型
export enum TextureType {
  SKIN = 'SKIN',
  CAPE = 'CAPE'
}

export interface  Texture {
  readonly url: string,
  readonly metadata?: object
}

export interface CompleteGameProfile {
  id: string;
  name: string;
  properties: Array<Record<string, string>>;
}