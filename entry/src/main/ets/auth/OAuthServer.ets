import { EventHub, Xb_FileUtils, Xb_GoToWeb } from 'xb_components';
import { EventKey } from '../common/EventKey';
import { Callback, Session,} from './OAuth';

export interface GrantDeviceCodeEvent{
  userCode: string
  verificationUri: string
}

export class OAuthServer implements Callback{

  startServer(): Promise<Session> {
    throw new Error('Method not implemented.');
  }

  grantDeviceCode(userCode: string, verificationUri: string): void {
    EventHub.sendEvent<GrantDeviceCodeEvent>(EventKey.GrantDeviceCodeEvent, {userCode, verificationUri})
  }

  async openBrowser(url: string): Promise<void> {
    Xb_GoToWeb(url)
  }

  getClientId(): string {
    return "xxxxxx"
  }

  getClientSecret(): string | null {
    return null
  }

  isPublicClient(): boolean {
   return true
  }



}