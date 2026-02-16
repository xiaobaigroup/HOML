import { Xb_FileUtils, Xb_GlobalContext, Xb_ToastUtil } from "xb_components";
import { VersionModel } from "../common/model/VersionModel";
import { zlib } from "@kit.BasicServicesKit";
import { fileIo } from "@kit.CoreFileKit";
import { MinecraftVersion } from "../model/MinecraftVersion";

@ObservedV2
export class HomlViewModel{
  @Trace versions: MinecraftVersion[] = []
  @Trace current?: MinecraftVersion
  @Trace zipLoading: boolean = false
  @Trace homeDir: string = ""

  async initHome(){
    const context = Xb_GlobalContext.getContext()
    const sanbox = context.filesDir + "/HOML/"
    if(!await fileIo.access(sanbox)){
      await fileIo.mkdir(sanbox)
    }
    this.homeDir  = sanbox;
    this.loadVersions()
  }

  async loadVersions(){
    // this.versions.push(
    //   {
    //     id: 0,
    //     name: '1.21.11-Fabric 0.18.4',
    //     version_code: '1.21.11',
    //     mod: 'fabric',
    //     mod_version: '0.18.4',
    //     global: true,
    //     isolation: false,
    //     ignore_java_comp: false,
    //     file_verification: true
    //   },
    //   {
    //     id: 1,
    //     name: 'Hy',
    //     version_code: '1.21.11',
    //     mod: 'normal',
    //     mod_version: '',
    //     global: true,
    //     isolation: true,
    //     ignore_java_comp: true,
    //     file_verification: false
    //   },
    //   {
    //     id: 2,
    //     name: 'Hy',
    //     version_code: '1.21.11',
    //     mod: 'normal',
    //     mod_version: '',
    //     global: true,
    //     isolation: true,
    //     ignore_java_comp: true,
    //     file_verification: false
    //   }
    // )
    let versionsPath = this.homeDir + ".minecraft/versions"
    let result: MinecraftVersion[] = []
    try {
      let files = await fileIo.listFile(versionsPath)
      for (let f of files.filter( v=> !v.endsWith("removed"))){
        let dir  = await fileIo.stat(versionsPath + "/" + f);
        if(dir.isDirectory()){
          try {
            const json = await fileIo.readText(versionsPath + "/" + f + "/" + f + ".json")
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

}