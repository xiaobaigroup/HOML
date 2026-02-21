import { Xb_FileUtils,
  Xb_GameMenuState,
  Xb_getPersistence,
  Xb_getPersistenceByName, Xb_GlobalContext, Xb_ToastUtil } from "xb_components";
import { zlib } from "@kit.BasicServicesKit";
import { fileIo } from "@kit.CoreFileKit";
import { MinecraftVersion } from "../model/MinecraftVersion";
import { VersionSetting } from "../model/VersionSetting";
import { jvmLauncher } from "./JVMLauncher";
import { MinecraftAccount } from "../model/MinecraftAccount";
import { GameProfile, HomeDirectoryType } from "../model/GameProfile";
import { MicrosoftService } from "../auth/MicrosoftService";
import { OAuthServer } from "../auth/OAuthServer";

@ObservedV2
export class HomlViewModel {

  @Trace versions: MinecraftVersion[] = []
  @Trace current?: MinecraftVersion
  @Trace gameProfile: GameProfile = Xb_getPersistence(GameProfile, ()=>new GameProfile())!;
  @Trace globalSetting: VersionSetting = Xb_getPersistenceByName(VersionSetting, "global",() => new VersionSetting())!

  @Trace zipLoading: boolean = false
  @Trace homeDir: string = ""
  @Trace gameRootDir: string = ""

  ms: MicrosoftService = new MicrosoftService(new OAuthServer())

  selectVersion(version: MinecraftVersion){
    this.current = version;
    this.gameProfile.lastVersion = version.id
  }

  async toLogin(){
    try {
      await this.ms.authenticate()
    } catch (e) {
      Xb_ToastUtil.showToast({message:"登录失败:" + e.message})
      console.error("authenticate failure:" + e.message, e.stack)
    }

  }
  async changeHome(){
    let homeDir = ""
    if (this.gameProfile.homeType == HomeDirectoryType.Sandbox){
      const context = Xb_GlobalContext.getContext()
      homeDir = context.filesDir + "/HOML/"
    }
    if (this.gameProfile.homeType == HomeDirectoryType.Download){
      homeDir = Xb_GlobalContext.downloadDir + "/HOML/"
    }
    if(this.gameProfile.customHomeDir == "" && this.gameProfile.homeType == HomeDirectoryType.Custom)
      return;
    if (this.gameProfile.homeType == HomeDirectoryType.Custom){
      homeDir = this.gameProfile.customHomeDir + "/"
      await Xb_FileUtils.activatePermissionDir(this.gameProfile.customHomeDir)
    }
    try {
      if (!await fileIo.access(homeDir)){
        await fileIo.mkdir(homeDir)
      }
    }catch (e) {
      Xb_ToastUtil.showToast({message:"创建目录失败:" + this.homeDir})
      return
    }

    this.homeDir  = homeDir;
    this.gameRootDir = homeDir + ".minecraft/"
    fixLibs(this.gameRootDir)
    createOfflineAccount(this.gameProfile.lastAccount, this.homeDir)
    await this.loadVersions()
    const version = this.versions.find(d=>d.id == this.gameProfile.lastVersion)
    if (version){
      this.current = version
    }
  }
  async initHome(){
    this.changeHome()
  }

  async loadVersions(){
    let versionsPath =  this.gameRootDir + "versions/"
    let result: MinecraftVersion[] = []
    try {
      let files = await fileIo.listFile(versionsPath)
      for (let f of files.filter( v=> !v.endsWith("removed"))){
        let dir  = await fileIo.stat(versionsPath + f);
        if(dir.isDirectory()){
          try {
            const json = await fileIo.readText(versionsPath + f + "/" + f + ".json")
            result.push(JSON.parse(json) as MinecraftVersion)
          }catch (_) {
          }
        }
      }
    } catch (error) {
    }
    this.versions = result;
  }

  async loadZip(){
    const context = Xb_GlobalContext.getContext()
    let gameUri = await Xb_FileUtils.openFile(Xb_GlobalContext.getContext())
    if(gameUri?.endsWith("zip")){
      let targetFile = context.tempDir + "/temp.zip";
      try {
        this.zipLoading = true
        await fileIo.copyFile(gameUri, targetFile);
        await zlib.decompressFile(targetFile, this.homeDir)
        await fileIo.unlink(targetFile)
        Xb_ToastUtil.showToast({message:"加载成功"})
        this.zipLoading = false
        this.loadVersions()
      }catch (e) {
        this.zipLoading = false
        Xb_ToastUtil.showToast({message:"加载失败:" + e.message})
      }
    }else{
      Xb_ToastUtil.showToast({message:"仅zip"})
    }
  }

  getRunDirectory(id:string): string {
    const settings = getVersionSetting(id)
    return getRunDirectory(id,this.gameRootDir, settings)
	}
  launch(){
    const id = this.current!.id
    const gameMenuState = Xb_getPersistence(Xb_GameMenuState)
    jvmLauncher.launch(Xb_GlobalContext.getContext(),
      "xiaobai",
      {id: this.current!.id, homeDir: this.homeDir, gameRootDir: this.gameRootDir, settings: getVersionSetting(id),arguments:[]},
      gameMenuState?.screenWidth, gameMenuState?.screenHeight)
  }
}

export function fixLibs(dirGameNew: string){
  if (!fileIo.accessSync(dirGameNew + "/libraries/com/github/oshi/oshi-core/6.2.2")) {
    try {
      fileIo.mkdirSync(dirGameNew + "/libraries/com/github/oshi/oshi-core/6.2.2", true)
      fileIo.copyFileSync(
        dirGameNew + "/libraries/com/github/oshi/oshi-core/6.3.0/oshi-core-6.3.0.jar",
        dirGameNew + "/libraries/com/github/oshi/oshi-core/6.2.2/oshi-core-6.2.2.jar")
    }catch (e) {
    }
  }

}
export function createOfflineAccount(username: string, home:string){
  if (!fileIo.accessSync(home + "accounts/")) {
    fileIo.mkdirSync(home + "accounts/", true)
    if (!fileIo.accessSync(`${home}/accounts/${username}.json`)){
      let file = fileIo.openSync(home + `/accounts/${username}.json`, fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.CREATE);
      fileIo.writeSync(file.fd, JSON.stringify(new MinecraftAccount()))
      fileIo.close(file.fd)
    }
  }
}


export function getRunDirectory(id:string, gameDir: string, settings: VersionSetting | undefined): string {
  if(!settings)
    return gameDir;
  if(settings.isolation){
    return gameDir + "/versions/" + id
  }else{
    return gameDir
  }
}
// 获取当前版本对应的Settings
export function getVersionSetting(id:string): VersionSetting {
  const versionSettings = Xb_getPersistenceByName(VersionSetting, id);
  if (versionSettings && !versionSettings.global){
    return versionSettings
  }
  return  Xb_getPersistenceByName(VersionSetting, "global",() => new VersionSetting())!
}

