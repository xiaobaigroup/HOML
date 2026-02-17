import { Xb_FileUtils, Xb_getPersistenceByName, Xb_GlobalContext, Xb_ToastUtil } from "xb_components";
import { zlib } from "@kit.BasicServicesKit";
import { fileIo } from "@kit.CoreFileKit";
import { MinecraftVersion } from "../model/MinecraftVersion";
import { VersionSetting } from "../model/VersionSetting";

@ObservedV2
export class HomlViewModel {

  @Trace versions: MinecraftVersion[] = []
  @Trace current?: MinecraftVersion
  @Trace zipLoading: boolean = false
  @Trace globalSetting: VersionSetting = Xb_getPersistenceByName(VersionSetting, "global",() => new VersionSetting())!
  @Trace homeDir: string = ""
  @Trace gameRootDir: string = ""

  async initHome(){
    const context = Xb_GlobalContext.getContext()
    const sanbox = context.filesDir + "/HOML/"
    if(!await fileIo.access(sanbox)){
      await fileIo.mkdir(sanbox)
    }
    this.homeDir  = sanbox;
    this.gameRootDir = this.homeDir + ".minecraft/"
    this.loadVersions()
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
      this.versions = result;
    } catch (error) {

    }
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
    if(settings.isolation){
      return this.gameRootDir + "/versions/" + id
    }else{
      return this.gameRootDir
    }
	}
}

// 获取当前版本对应的Settings
function getVersionSetting(id:string): VersionSetting {
  const versionSettings = Xb_getPersistenceByName(VersionSetting, id);
  if (versionSettings && !versionSettings.global){
    return versionSettings
  }
  return  Xb_getPersistenceByName(VersionSetting, "global",() => new VersionSetting())!
}

