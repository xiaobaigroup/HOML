import { EventHub, Xb_Copy, Xb_FileUtils, Xb_GoToWeb, Xb_ToastUtil } from 'xb_components';
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
    Xb_Copy(userCode)
    Xb_ToastUtil.showToast({message:"设备码已复制"})
  }

  async openBrowser(url: string): Promise<void> {
    Xb_GoToWeb(url)
  }

  getClientId(): string {
    return "c0acdfdd-c70d-4abc-b081-419b93817b7a"
  }

  getClientSecret(): string | null {
    return null
  }

  isPublicClient(): boolean {
   return true
  }



}