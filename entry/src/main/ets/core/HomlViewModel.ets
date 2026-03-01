import {
  hasJit,
  Xb_FileUtils,
  Xb_GameControllerViewModel,
  Xb_GameMenuState,
  Xb_getAppStore,
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
import { HOMLState } from "../entryability/AppState";
import { FCLKeycodes } from "./FCLKeycode";

@ObservedV2
export class HomlViewModel {

  @Trace versions: MinecraftVersion[] = []
  @Trace acc: MinecraftVersion[] = []
  @Trace current?: MinecraftVersion
  @Trace accounts: MinecraftAccount[] = []

  @Trace gameProfile: GameProfile = Xb_getPersistence(GameProfile, ()=>new GameProfile())!;
  @Trace globalSetting: VersionSetting = Xb_getPersistenceByName(VersionSetting, "global",() => new VersionSetting())!
  @Trace controllerViewModel: Xb_GameControllerViewModel = Xb_getAppStore(Xb_GameControllerViewModel, ()=> new Xb_GameControllerViewModel())!
  @Trace zipLoading: boolean = false
  @Trace homeDir: string = ""
  @Trace gameRootDir: string = ""

  @Trace searchVersion: string = ""
  @Trace hasJit = false

  ms: MicrosoftService = new MicrosoftService(new OAuthServer())

  currentAccountName(){
    let account = this.accounts.find(d => d.username == this.gameProfile.lastAccount) ?? new MinecraftAccount()
    return account.session?.profile?.name ?? account.username + "(离线)"
  }
  async initHome(){
    await this.changeHome()
    this.hasJit = hasJit()
    this.controllerViewModel.loadControllerList(Xb_GlobalContext.getContext(), undefined, FCLKeycodes.onNormKeyCode)
    this.loadAccounts()
  }

  selectVersion(version: MinecraftVersion){
    this.current = version;
    this.gameProfile.lastVersion = version.id
  }
  filterVersion(versions: MinecraftVersion[], search:string){
    if(search == "")
      return versions
    return versions.filter(d=> d.id.indexOf(search) > -1)
  }
  async toLogin(){
    try {
      let session = await this.ms.authenticate()
      let account = session.toAccount()
      saveAccount(account, this.homeDir, true)
      this.gameProfile.lastAccount = account.username
      Xb_ToastUtil.showToast({message:"登录成功"})
      await this.loadAccounts()
    } catch (e) {
      Xb_ToastUtil.showToast({message:"登录失败:" + e.message})
      console.error("authenticate failure:" + e.message, e.stack)
    }
  }
  launching = false
  async toGame(){
    if (hasJit()){
      if(this.launching){
        return
      }else {
        this.launching = true
        if(await this.switchJre()){
          this.launching = false
          HOMLState.pageStack.pushPathByName("GamePage", true)
        }
      }

    } else {
      const versionSettings = getVersionSetting(this.current!.id)
      this.controllerViewModel.switchController(versionSettings.controller)
      HOMLState.pageStack.pushPathByName("virtual_control_button", true)
    }
  }
  async changeHome(){
    let homeDir = ""
    if (this.gameProfile.homeType == HomeDirectoryType.Sandbox){
      const context = Xb_GlobalContext.getContext()
      homeDir = context.filesDir + "/HOML/"
    }
    if (this.gameProfile.homeType == HomeDirectoryType.Download){
      await Xb_GlobalContext.initDownloadDir()
      homeDir = Xb_GlobalContext.downloadDir + "/HOML/"
    }
    if(this.gameProfile.customHomeDir == "" && this.gameProfile.homeType == HomeDirectoryType.Custom)
      return;
    if (this.gameProfile.homeType == HomeDirectoryType.Custom){
      homeDir = this.gameProfile.customHomeDir
      if(homeDir.endsWith(".minecraft")){
        let end = homeDir.lastIndexOf(".minecraft")
        homeDir = homeDir.substring(0, end)
        Xb_ToastUtil.showToast({message:"请选择上级目录!"})
        return
      }
      if(!homeDir.endsWith("/")){
        homeDir += "/"
      }
      this.gameProfile.customHomeDir = homeDir
      await Xb_FileUtils.activatePermissionDir(homeDir)
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
    await this.loadVersions()
    const version = this.versions.find(d=>d.id == this.gameProfile.lastVersion)
    if (version){
      this.current = version
    }
  }

  async loadVersions(){
    let versionsPath = this.gameRootDir + "versions/"
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
    this.zipLoading = true
    let gameUri = await Xb_FileUtils.openFile(Xb_GlobalContext.getContext())
    if(gameUri?.endsWith("zip")){
      try {
        let targetFile = context.tempDir + "/temp.zip";
        let outDir = this.homeDir + "out";
        if(! await fileIo.access(outDir)){
          await fileIo.mkdir(outDir)
        }
        await fileIo.copyFile(gameUri, targetFile);
        await zlib.decompressFile(targetFile, outDir)
        await fileIo.unlink(targetFile)
        const result = await this.fixGameHome(outDir)
        if(result){
          Xb_ToastUtil.showToast({message:"加载成功"})
        }
        this.loadVersions()
      }catch (e) {
        this.zipLoading = false
        Xb_ToastUtil.showToast({message:"加载失败:" + e.message})
      }
    } else if(gameUri && gameUri != "") {
      Xb_ToastUtil.showToast({message:"仅zip"})
    }
    this.zipLoading = false
  }


  async fixGameHome(outDir: string): Promise<boolean>{
    try {
     const foundDir = await findMinecraftDir(outDir);
      if (foundDir) {
        // 如果找到的是 .minecraft 目录
        if (foundDir.endsWith('.minecraft/')) {
          const sourceDir = foundDir.substring(0, foundDir.length - 11); // 去掉 .minecraft/
          await fileIo.moveDir(sourceDir, this.homeDir, 2);
        }
        // 如果找到的是包含 versions 的目录
        else if (await fileIo.access(foundDir + "/versions/")) {
          const gameHome = this.homeDir + ".minecraft/"
          if (!await fileIo.access(gameHome)){
            await fileIo.mkdir(gameHome)
          }
          await fileIo.moveDir(foundDir + "/", gameHome, 2);
        }
      } else {
        console.log("No Minecraft directory found in " + outDir);
      }
    } catch (err) {
      Xb_ToastUtil.showToast({ message: "移动目录失败:" + err.message })
      return false
    }
    return true
  }

  getRunDirectory(id:string): string {
    const settings = getVersionSetting(id)
    return getRunDirectory(id, this.gameRootDir, settings)
	}
  launch(){
    const id = this.current!.id
    const gameMenuState = Xb_getPersistence(Xb_GameMenuState)
    const settings = getVersionSetting(id)
    jvmLauncher.launch(Xb_GlobalContext.getContext(),
      this.gameProfile.lastAccount,
      {id: this.current!.id, homeDir: this.homeDir, gameRootDir: this.gameRootDir, settings: settings, version: this.current!, arguments:[]},
      gameMenuState?.screenWidth, gameMenuState?.screenHeight)
  }
  async switchJre(){
    const id = this.current!.id
    const settings = getVersionSetting(id)
    return await jvmLauncher.switchJre(settings.jreVersion)
  }

  async loadAccounts(){
    let accountPath = this.homeDir + "accounts/"
    let result: MinecraftAccount[] = []
    try {
      let files = await fileIo.listFile(accountPath)
      for (let f of files.filter( v=> !v.endsWith("removed"))){
        let dir  = await fileIo.stat(accountPath + f);
        if(!dir.isDirectory()){
          try {
            const json = await fileIo.readText(accountPath + f)
            const acc = JSON.parse(json) as MinecraftAccount
            result.push(acc)
          }catch (_) {
          }
        }

      }
    } catch (error) {
    }
    this.accounts = result;

    if(this.accounts.length == 0){
      let xiaobai = new MinecraftAccount()
      saveAccount(xiaobai, this.homeDir)
      this.accounts.push(xiaobai)
    }
  }
}

export function fixLibs(dirGameNew: string){
  if (!fileIo.accessSync(dirGameNew + "/libraries/com/github/oshi/oshi-core/6.2.2") && fileIo.accessSync(dirGameNew + "/libraries/com/github/oshi/oshi-core/6.3.0/oshi-core-6.3.0.jar")) {
    try {
      fileIo.mkdirSync(dirGameNew + "/libraries/com/github/oshi/oshi-core/6.2.2", true)
      fileIo.copyFileSync(
        dirGameNew + "/libraries/com/github/oshi/oshi-core/6.3.0/oshi-core-6.3.0.jar",
        dirGameNew + "/libraries/com/github/oshi/oshi-core/6.2.2/oshi-core-6.2.2.jar")
    }catch (e) {
    }
  }

}
export function saveAccount(account: MinecraftAccount, home: string, update = false){
  if (!fileIo.accessSync(home + "accounts/"))
    fileIo.mkdirSync(home + "accounts/", true)
  let path = `${home}accounts/${account.username}.json`
  if (fileIo.accessSync(path) && !update){
    return;
  }
  let file = fileIo.openSync(path, fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC);
  fileIo.writeSync(file.fd, JSON.stringify(account))
  fileIo.fsyncSync(file.fd)
  fileIo.close(file.fd)
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


const MAX_DEPTH = 5;
const findMinecraftDir = async (dir: string, depth: number = 0): Promise<string | null> => {
  if (depth > MAX_DEPTH) return null;
  try {
    // 检查当前目录
    if (await fileIo.access(dir + "/.minecraft/")) {
      return dir + "/.minecraft/";
    }
    if (await fileIo.access(dir + "/versions/")) {
      return dir;
    }

    // 获取子目录
    const children = await fileIo.listFile(dir);
    const subDirs: string[] = [];

    // 过滤出目录
    for (const child of children) {
      const fullPath = dir + "/" + child;
      const file = await fileIo.stat(fullPath)
      if (file.isDirectory()) {
        subDirs.push(fullPath);
      }
    }
    // 递归查找子目录
    for (const subDir of subDirs) {
      const result = await findMinecraftDir(subDir, depth + 1);
      if (result) {
        return result;
      }
    }
  } catch (err) {
    // 忽略权限错误等，继续查找
    console.debug(`Cannot access directory ${dir}: ${err.message}`);
  }
  return null;
};