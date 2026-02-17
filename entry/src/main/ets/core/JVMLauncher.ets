import { Context } from "@kit.AbilityKit";
import { fileIo } from "@kit.CoreFileKit";
import { Xb_getAppStore } from "xb_components";
import { HomlViewModel } from "./HomlViewModel";

export enum RENDERER_LIB{
  RENDERER_NAME_NG_GL4ES = "libng_gl4es.so",
  RENDERER_NAME_MOBILEGLUES = "libmobileglues.so",
  RENDERER_NAME_GLV4 = "libGLv4.so"
}
export enum JAVA_VERSION{
  JAVA17 = "jre17",
  JAVA21 = "jre21",
  JAVA25 = "jre25",
}

class MinecraftAccount {
  accessToken:string = "0"  // access token
  clientToken:string = "${clientId}" // clientID: refresh and invalidate
  profileId: string= "00000000-0000-0000-0000-000000000000"; // authenticate UUID
  username:string = "xiaobai";
  xuid: string = "${auth_xuid}"
}
class LaunchTarget {
    id: string = ""
    arguments:string[] = []
}
export class JVMLauncher {
  static glLibName: string = RENDERER_LIB.RENDERER_NAME_MOBILEGLUES
  static jreVersion: string = JAVA_VERSION.JAVA25
  static serverIp: string = ""
  static launch(context: Context, username: string, launchTarget: string | LaunchTarget = "test_lwjgl-1.0.jar",
    width = 900, height = 900) {
    const viewModel = Xb_getAppStore(HomlViewModel)!;
    const dirHome = viewModel.homeDir;
    const dirGameNew = dirHome + ".minecraft";
    if (!fileIo.accessSync(dirGameNew + "/libraries/com/github/oshi/oshi-core/6.2.2")) {
      try {
        fileIo.mkdirSync(dirGameNew + "/libraries/com/github/oshi/oshi-core/6.2.2", true)
        fileIo.copyFileSync(
          dirGameNew + "/libraries/com/github/oshi/oshi-core/6.3.0/oshi-core-6.3.0.jar",
          dirGameNew + "/libraries/com/github/oshi/oshi-core/6.2.2/oshi-core-6.2.2.jar")
      }catch (e) {
      }
    }
    if (!fileIo.accessSync(dirHome + "accounts/")) {
      fileIo.mkdirSync(dirHome + "accounts/", true)
      if (!fileIo.accessSync(`${dirHome}/accounts/${username}.json`)){
        let file = fileIo.openSync(dirHome + `/accounts/${username}.json`, fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.CREATE);
        fileIo.writeSync(file.fd, JSON.stringify(new MinecraftAccount()))
        fileIo.close(file.fd)
      }
    }
    const jreVersion = JVMLauncher.jreVersion

    let appName = "鸿蒙版";
    let javaHome = context.resourceDir + `/${jreVersion}`;
    let dirCache = context.tempDir;
    let nativeLibDir = context.bundleCodeDir + "/libs/arm64/";


    let dirAccountNew = username
    let displayWidth = width.toFixed(0);
    let displayHeight = height.toFixed(0);
    let resolvFile = "";
    let version = ""
    if (typeof launchTarget != "string") {
     // version = (launchTarget as LaunchTarget).id
      version = viewModel.current!.id
    }
    const glLibName = JVMLauncher.glLibName
    const overridableArguments = [
      nativeLibDir + "/bin/java",
      `-Djava.home=${javaHome}`,
      `-DServer_Ip=${JVMLauncher.serverIp}`,
      `-Djava.io.tmpdir=${dirCache}`,
      `-Djna.boot.library.path=${nativeLibDir}`,
      `-Djna.nosys=false`,
      `-Doshi.util.disable.cpufrequency=true`,
      `-Doshi.util.disable.powersource=true`,
      `-Duser.home=${dirHome}`,
      `-DPOJAV_HOME=${dirHome}`,
      `-DPOJAV_GAME_DIR=${dirGameNew}`,
      `-Duser.dir=${dirGameNew}/versions/${version}`,
      `-DBUNDLE_PATH=${context.resourceDir}`,
      `-Dorg.lwjgl.glfw.checkThread0=false`,
      `-Dorg.lwjgl.system.allocator=system`,
      `-Dlog4j2.formatMsgNoLookups=true`,
      "-XX:+UnlockExperimentalVMOptions",
      `-DDEBUG=true`,
      `-Duser.language=zh`,
      `-Dos.name=Linux`,
      `-Dos.version=harmonyos`,
      `-Dpojav.path.minecraft=${dirGameNew}`,
      `-Dpojav.path.private.account=${dirAccountNew}`,
      `-Xms1G`,
      `-Xmx4G`,
      `-XX:ActiveProcessorCount=8`,
      `-Dsun.rmi.transport.logLevel=verbose`,
      `-Dsun.rmi.transport.tcp.logLevel=verbose`,
      `-Dorg.lwjgl.opengl.libname=${glLibName}`,
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
      `-Dcpu.name=12412`,
      `-Djdk.lang.Process.launchMechanism=FORK`
    ];

    overridableArguments.push(`-javaagent:${context.resourceDir}/patchjna_agent.jar=`)
    if (true) {
      overridableArguments.push(`-javaagent:${context.resourceDir}/arc_dns_injector.jar=23.95.137.176`)
    }
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
        "--add-opens=java.base/java.util=ALL-UNNAMED",
        "--add-opens=java.desktop/java.awt=ALL-UNNAMED",
        "--add-opens=java.desktop/sun.font=ALL-UNNAMED",
        "--add-opens=java.desktop/sun.java2d=ALL-UNNAMED",
        "--add-opens=java.base/java.lang.reflect=ALL-UNNAMED",
        "--add-opens=java.base/java.net=ALL-UNNAMED",
        // TODO: workaround, will be removed once the startup part works without PLaunchApp
        "--add-exports=cpw.mods.bootstraplauncher/cpw.mods.bootstraplauncher=ALL-UNNAMED",
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
    let classPath = context.resourceDir + "/*:" + context.resourceDir + "/launcher.jar";
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
    overridableArguments.push("-cp", classPath, "net.kdt.pojavlaunch.PojavLauncher")
    if (jar) {
      overridableArguments.push("-jar")
    } else {
      overridableArguments.push(username)
    }
    if (typeof launchTarget == "string") {
      overridableArguments.push(context.resourceDir + "/" + launchTarget)
    } else {
      overridableArguments.push(launchTarget.id)
    }
    if(JVMLauncher.initEnv(context, dirHome, jreVersion)){
      //JavaLauncher.jvm_Launcher(overridableArguments)
    }
  }
  static initEnv(context: Context, dirHome:string, jreVersion: string): boolean{
    return true
    // if (JVMLauncher.glLibName == RENDERER_LIB.RENDERER_NAME_NG_GL4ES){
    //   setenv("POJAV_RENDERER", "opengles3");
    // }
    // else if (JVMLauncher.glLibName == RENDERER_LIB.RENDERER_NAME_MOBILEGLUES) {
    //   setenv("POJAV_RENDERER", "opengles_mobileglues");
    // }
    // else {
    //   setenv("POJAV_RENDERER", "openglv4");
    // }
    // setenv("HOME", dirHome);
    // setenv("LIBGL_USE_MC_COLOR", "1");
    // setenv("LIBGL_GL", "31");
    // setenv("LIBGL_ES", "3");
    // setenv("NGG_DIR_PATH", context.cacheDir + "/");
    // setenv("DLOPEN", "libspirv-cross-c-shared.so");
    // setenv("LIBGL_NORMALIZE", "1");
    // setenv("LIBGL_NOINTOVLHACK", "1");
    // setenv("LIBGL_NOERROR", "0");
    //
    // setenv("ALSOFT_LOGLEVEL", "0");
    // // hap需要手动设置 javahome和dl_dir
    // let java_dl_dir =  context.bundleCodeDir + "/libs/arm64/";
    // setenv("OHOS_DL_DIR", java_dl_dir);
    // setenv("OHOS_JAVA_HOME", "/data/storage/el1/bundle/entry/resources/resfile/" + jreVersion);
    // setenv("LD_LIBRARY_PATH", java_dl_dir);
    // setenv("jli_path", java_dl_dir + "/libjli.so");
    // // TODO 修改修改支持绝对路径，目前不支持load libjvm.so，不能动态切换java版本
    // // let ret = dl_open("/data/storage/el1/bundle/libs/arm64/jre25/libjimage.so")
    // let ret = dl_open(JVMLauncher.glLibName);
    // if(!ret){
    //   if(JVMLauncher.glLibName == RENDERER_LIB.RENDERER_NAME_GLV4){
    //     Xb_ToastUtil.showToast({message: "当前图形驱动仅鸿蒙pc可用"})
    //   }else{
    //     Xb_ToastUtil.showToast({message: "图形驱动加载失败"})
    //   }
    // }
    // return ret;
  }

}