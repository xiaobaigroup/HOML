import { MicrosoftSession } from "../auth/MicrosoftService";

export class MinecraftAccount {
  accessToken:string = "0"  // access token
  clientToken:string = "${clientId}" // clientID: refresh and invalidate
  profileId: string= "00000000-0000-0000-0000-000000000000"; // authenticate UUID
  username:string = "xiaobai";
  xuid: string = "${auth_xuid}"
  session?: MicrosoftSession
}