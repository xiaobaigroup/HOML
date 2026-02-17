
export interface VersionModel {
  id: number | null
  name: string,
  version_code: string,
  mod: string,
  mod_version?: string,
  global: boolean,
  isolation: boolean,
  ignore_java_comp: boolean,
  file_verification: boolean

}