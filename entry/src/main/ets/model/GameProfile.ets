
export enum HomeDirectoryType{
  Sandbox,
  Download,
  Custom
}

@ObservedV2
export class GameProfile {
  @Trace lastVersion: string = ""
  @Trace lastAccount: string = "xiaobai"
  @Trace homeType: HomeDirectoryType = HomeDirectoryType.Sandbox
  @Trace customHomeDir: string = ""
}