import { JAVA_VERSION } from "../core/JVMLauncher"

export enum RENDERER_LIB{
  RENDERER_NAME_NG_GL4ES = "libng_gl4es.so",
  RENDERER_NAME_MOBILEGLUES = "libmobileglues.so",
  RENDERER_NAME_GLV4 = "libGLv4.so"
}

@ObservedV2
export class VersionSetting {
  @Trace global: boolean = true
  @Trace isolation: boolean  = false
  @Trace autoSetGameLang: boolean = false
  @Trace notCheckJVM: boolean = false
  @Trace notCheckMod: boolean = false
  @Trace fileVerification: boolean = false
  @Trace javaArgs: string = ""
  @Trace minecraftArgs: string = ""
  @Trace maxMemory: number = 2048
  @Trace minMemory: number = 1024
  @Trace autoMemory: boolean = false
  @Trace serverIp: string = ""
  @Trace renderer: string = RENDERER_LIB.RENDERER_NAME_MOBILEGLUES
  @Trace uuid: string = ""
  @Trace controller: string = "00000000"
  @Trace jreVersion: JAVA_VERSION = JAVA_VERSION.JAVA17
}