
import { Context } from "@kit.AbilityKit";
import { fileIo } from "@kit.CoreFileKit";
import { Xb_GlobalContext, Xb_ToastUtil } from "xb_components";
import { getRunDirectory } from "./HomlViewModel";
import { RENDERER_LIB, VersionSetting } from "../model/VersionSetting";
import { MinecraftVersion } from "../model/MinecraftVersion";
import { HOMLBridge } from "./HOMLBridge";
import { hasJreXz, installJre } from "../utils";


export enum JAVA_VERSION{
  JAVA8 = "jre8",
  JAVA17 = "jre17",
  JAVA21 = "jre21",
  JAVA25 = "jre25",
}

export function hasJre(jre:string): boolean {
  try {
    return fileIo.accessSync(Xb_GlobalContext.getContext().filesDir + "/" + jre)
  } catch (error) {
    return false
  }
}


interface  LaunchTarget {
    id: string
    homeDir: string
    gameRootDir: string
    settings?: VersionSetting
    version: MinecraftVersion
    arguments?: string[]
}

export class JVMLauncher {
  bridge!: HOMLBridge
  jre: string = JAVA_VERSION.JAVA25
  constructor() {
    this.jre = JAVA_VERSION.JAVA25
  }
  async switchJre(jre: JAVA_VERSION): Promise<boolean>{
    const context = Xb_GlobalContext.getContext()
    this.jre = jre
    if (!hasJreXz(context, jre)){
      Xb_ToastUtil.showToast({message:`请安装hsp(${jre})`})
      return false
    }
    try {
      await installJre(context, jre)
      let ns: ESObject = await import(jre);
      this.bridge = ns.homl_bridge
      return true
    }catch (e) {
      Xb_ToastUtil.showToast({message:`加载hsp(${jre})失败:` + e.message})
    }
    return false
  }

  launch(
    context: Context,
    username: string,
    launchTarget: string | LaunchTarget = "test_lwjgl-1.0.jar",
    width = 900, height = 900
  ) {

    const jreVersion = this.jre
    let appName = "鸿蒙版";
    let javaHome = context.filesDir+ `/${jreVersion}`;
    let dirCache = context.tempDir;
    let nativeLibDir = context.bundleCodeDir + `/${jreVersion}/libs/arm64/`;
    let dirAccountNew = username
    let displayWidth = width.toFixed(0);
    let displayHeight = height.toFixed(0);
    let resolvFile =  javaHome + "/resolv.conf";
    let settings = (launchTarget as LaunchTarget)?.settings
    let dirGameNew = (launchTarget as LaunchTarget)?.gameRootDir
    let dirHome = (launchTarget as LaunchTarget)?.homeDir
    let version = (launchTarget as LaunchTarget)?.id
    let versionData = (launchTarget as LaunchTarget)?.version
    let maxMemory = settings?.maxMemory
    let minMemory = settings?.minMemory
    let jvmMemory: string[] = []
    let javaArgs = settings?.javaArgs.split(" ") ?? [];

    if(maxMemory && maxMemory > 0 && (javaArgs.indexOf("noXmx") == -1)){
      jvmMemory.push("-Xmx" + maxMemory + "m")
    }
    if(minMemory && minMemory > 0 && (!maxMemory || maxMemory >= minMemory)){
      jvmMemory.push("-Xms" + minMemory + "m")
    }
    let serverIp = settings?.serverIp
    let renderer = settings?.renderer ?? RENDERER_LIB.RENDERER_NAME_MOBILEGLUES
    const overridableArguments = [
      nativeLibDir + "/bin/java",
      ...javaArgs.filter(d => d != "" && d != "noXmx"),
      `-Djava.home=${javaHome}`,
      `-DServer_Ip=${serverIp}`,
      `-Djava.io.tmpdir=${dirCache}`,
      `-Djna.boot.library.path=${nativeLibDir}`,
      `-Djna.nosys=false`,
      `-Doshi.util.disable.cpufrequency=true`,
      `-Doshi.util.disable.powersource=true`,
      `-Duser.home=${dirHome}`,
      `-DPOJAV_HOME=${dirHome}`,
      `-DPOJAV_GAME_DIR=${dirGameNew}`,
      `-Duser.dir=${getRunDirectory(version, dirGameNew, settings)}`,
      `-DBUNDLE_PATH=${context.resourceDir}`,
      `-Dorg.lwjgl.glfw.checkThread0=false`,
      `-Dorg.lwjgl.system.allocator=system`,
      `-Dlog4j2.formatMsgNoLookups=true`,
      "-XX:+UnlockExperimentalVMOptions",
      `-DDEBUG=true`,
      `-Duser.language=zh`,
      `-Duser.country=CN`,
      `-Dos.name=Linux`,
      `-Dos.version=harmonyos`,
      `-Dpojav.path.minecraft=${dirGameNew}`,
      `-Dpojav.path.private.account=${dirAccountNew}`,
      ...jvmMemory,
      `-XX:ActiveProcessorCount=8`,
      `-Dsun.rmi.transport.logLevel=verbose`,
      `-Dsun.rmi.transport.tcp.logLevel=verbose`,
      `-Dorg.lwjgl.opengl.libname=${renderer}`,
      `-Duser.timezone=Asia/Shanghai`,
      `-Dorg.lwjgl.vulkan.libname=libvulkan.so`,
      // LWJGL 3 DEBUG FLAGS
      `-Dorg.lwjgl.opengl.Debug=true`,
      `-Dorg.lwjgl.opengl.DebugOutput=true`,
      `-Dorg.lwjgl.opengl.DebugOutputSynchronous=true`,
      `-Dorg.lwjgl.util.Debug=true`,
      `-Dorg.lwjgl.util.DebugFunctions=true`,
      `-Dorg.lwjgl.util.DebugLoader=true`,
      `-DUIScreen.maximumFramesPerSecon=100`,
      // GLFW Stub width height
      `-Dglfwstub.windowWidth=${displayWidth}`,
      `-Dglfwstub.windowHeight=${displayHeight}`,
      `-Dglfwstub.initEgl=false`,
      `-Dext.net.resolvPath=${resolvFile}`,

      `-Dnet.minecraft.clientmodname=${appName}`,
      `-Dfml.earlyprogresswindow=false`, // Forge 1.14+ workaround
      `-Dloader.disable_forked_guis=true`,
      `-Dsodium.checks.issue2561=false`,
      `-Dcpu.name=harmonyos`,
      `-Djdk.lang.Process.launchMechanism=FORK`
    ];

    overridableArguments.push(`-javaagent:${context.resourceDir}/patchjna_agent.jar=`)
    overridableArguments.push(`-javaagent:${context.resourceDir}/arc_dns_injector.jar=23.95.137.176`)
    let isJre8 = false
    //TODO awt 目前不能工作
    let cacioEnv: string[] = [
      "-Djava.awt.headless=true",
      "-Dcacio.font.fontmanager=sun.awt.X11FontManager",
      "-Dcacio.font.fontscaler=sun.font.FreetypeFontScaler",
      "-Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel",
      `-Dcacio.managed.screensize=${displayWidth}x${displayHeight}`,
    ]
    if (!isJre8) {
      cacioEnv = [...cacioEnv, ...[
        // awt 渲染
        "-Dawt.toolkit=com.github.caciocavallosilano.cacio.ctc.CTCToolkit",
        "-Djava.awt.graphicsenv=com.github.caciocavallosilano.cacio.ctc.CTCGraphicsEnvironment",
        "-Djava.system.class.loader=com.github.caciocavallosilano.cacio.ctc.CTCPreloadClassLoader",
        "--add-exports=java.desktop/java.awt=ALL-UNNAMED",
        "--add-exports=java.desktop/java.awt.peer=ALL-UNNAMED",
        "--add-exports=java.desktop/sun.awt.image=ALL-UNNAMED",
        "--add-exports=java.desktop/sun.java2d=ALL-UNNAMED",
        "--add-exports=java.desktop/java.awt.dnd.peer=ALL-UNNAMED",
        "--add-exports=java.desktop/sun.awt=ALL-UNNAMED",
        "--add-exports=java.desktop/sun.awt.event=ALL-UNNAMED",
        "--add-exports=java.desktop/sun.awt.datatransfer=ALL-UNNAMED",
        "--add-exports=java.desktop/sun.font=ALL-UNNAMED",
        "--add-exports=java.base/sun.security.action=ALL-UNNAMED",
        "--add-opens=java.desktop/java.awt=ALL-UNNAMED",
        "--add-opens=java.desktop/sun.font=ALL-UNNAMED",
        "--add-opens=java.desktop/sun.java2d=ALL-UNNAMED",
        "--add-opens=java.base/java.util=ALL-UNNAMED",
        "--add-opens=java.base/java.lang.reflect=ALL-UNNAMED",
        "--add-opens=java.base/java.net=ALL-UNNAMED",
      ]]
    } else {
    }

    overridableArguments.push(...cacioEnv)
    // Add Caciocavallo bootclasspath
    let list = fileIo.listFileSync(context.resourceDir + "/app_runtime/caciocavallo17")
    let caciocavallo = "-Xbootclasspath/a" // jre8 p
    for (let f of list) {
      caciocavallo += (":" + context.resourceDir + "/app_runtime/caciocavallo17/" + f);
    }
    overridableArguments.push(caciocavallo)
    overridableArguments.push(`-Dlog4j2.debug=true`)
    let enableDebug = false;
    if (enableDebug) {
      let suppend = "y"
      overridableArguments.push(`-agentlib:jdwp=transport=dt_socket,server=y,suspend=${suppend},address=0.0.0.0:5005`)
    }
    let classPath = context.resourceDir + "/*";
    let jar = true;

    classPath += (":" + context.resourceDir + "/app_runtime/oshi-core-6.3.0.jar")
    if (typeof launchTarget == "string") {
      jar = true
      classPath += (":" + context.resourceDir + "/" + launchTarget)
    } else {
      jar = false;
    }
    if (!jar) {
      overridableArguments.push("-Djava.system.class.loader=net.kdt.pojavlaunch.PojavClassLoader")
    }
    const argMap: Record<string,string> = {
      "launcher_name": "homl",
      "launcher_version": "1.0.0",
      "classpath": classPath,
      "classpath_separator": ":",
      "library_directory": dirGameNew + "/libraries",
      "version_name": version,
      "natives_directory": context.cacheDir,
    }
    const jvmArgs = this.getMinecraftJVMArgs(versionData, argMap)
    overridableArguments.push(...jvmArgs)
    overridableArguments.push("net.kdt.pojavlaunch.PojavLauncher")
    if (jar) {
      overridableArguments.push("-jar")
    } else {
      overridableArguments.push(username)
    }
    if (typeof launchTarget == "string") {
      overridableArguments.push(context.resourceDir + "/" + launchTarget)
    } else {
      overridableArguments.push(version)
    }
    if(this.initEnv(context, dirHome, javaHome, nativeLibDir, renderer)){
      this.bridge.jvm_Launcher(overridableArguments)
    }
  }
   initEnv(context: Context, dirHome:string, java_home: string, java_dl_dir: string,  glibName: string): boolean{
    const setenv = this.bridge.set_env
    if (glibName == RENDERER_LIB.RENDERER_NAME_NG_GL4ES){
      setenv("POJAV_RENDERER", "opengles3");
    }
    else if (glibName == RENDERER_LIB.RENDERER_NAME_MOBILEGLUES) {
      setenv("POJAV_RENDERER", "opengles_mobileglues");
    }
    else {
      setenv("POJAV_RENDERER", "openglv4");
    }
    setenv("HOME", dirHome);
    setenv("LIBGL_USE_MC_COLOR", "1");
    setenv("LIBGL_GL", "31");
    setenv("LIBGL_ES", "3");
    setenv("NGG_DIR_PATH", context.cacheDir + "/");
    setenv("DLOPEN", "libspirv-cross-c-shared.so");
    setenv("LIBGL_NORMALIZE", "1");
    setenv("LIBGL_NOINTOVLHACK", "1");
    setenv("LIBGL_NOERROR", "0");

    setenv("ALSOFT_LOGLEVEL", "0");
    // hap需要手动设置 javahome和dl_dir
    setenv("OHOS_DL_DIR", java_dl_dir);
    setenv("OHOS_JAVA_HOME", java_home);
    setenv("LD_LIBRARY_PATH", java_dl_dir);
    setenv("jli_path", java_dl_dir + "libjli.so");
    let ret =  this.bridge.dl_open(glibName);
    if(!ret){
      if(glibName == RENDERER_LIB.RENDERER_NAME_GLV4){
        Xb_ToastUtil.showToast({message: "当前图形驱动仅鸿蒙pc或平板可用"})
      }else{
        Xb_ToastUtil.showToast({message: "图形驱动加载失败"})
      }
    }
    return ret;
  }
 getMinecraftJVMArgs(version: MinecraftVersion | undefined, argsMap: Record<string,string> = {}): string[]{
    if(!version || !version.arguments || !version.arguments.jvm)
      return ["-cp", argsMap["classpath"]]
    const jvmArgs :string[] = []
    version.arguments.jvm.forEach(arg=>{
      if(typeof arg == "string"){
        jvmArgs.push(arg)
      }
    })
    return replaceAllArgs(jvmArgs, argsMap)
  }

}



function replaceAllArgs(args: string[], kv: Record<string,string>){
  const replaceOneArgs = (value: string, kv: Record<string,string>)=>{
    let newValue = value;
    for (let k of Object.keys(kv)){
      newValue = newValue.replaceAll('$'+`{${k}}`, kv[k] ?? "")
    }
    return newValue;
  }

  for (let i = 0; i < args.length; i++) {
    args[i] = replaceOneArgs(args[i], kv)
  }
  return args
}

export const jvmLauncher = new JVMLauncher()
