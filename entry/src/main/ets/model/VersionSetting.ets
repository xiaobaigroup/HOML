
export interface VersionSetting{
  global: boolean
  isolation: boolean
  ignore_java_comp: boolean
  file_verification: boolean
  javaArgs: string
  minecraftArgs: string
  maxMemory: number
  minMemory: number
  autoMemory: boolean
  serverIp: string
  renderer: string
  uuid: string
  notCheckMod: boolean
  notCheckJVM: boolean
  controller: boolean
}