import { VersionModel } from "../common/model/VersionModel";

@ObservedV2
export class HomlViewModel{
  @Trace versions: VersionModel[] = []
  @Trace current?: VersionModel


  loadVersions(){

    this.versions.push(
      {
        id: 0,
        name: '1.21.11-Fabric 0.18.4',
        version_code: '1.21.11',
        mod: 'fabric',
        mod_version: '0.18.4',
        global: true,
        isolation: false,
        ignore_java_comp: false,
        file_verification: true
      },
      {
        id: 1,
        name: 'Hy',
        version_code: '1.21.11',
        mod: 'normal',
        mod_version: '',
        global: true,
        isolation: true,
        ignore_java_comp: true,
        file_verification: false
      },
      {
        id: 2,
        name: 'Hy',
        version_code: '1.21.11',
        mod: 'normal',
        mod_version: '',
        global: true,
        isolation: true,
        ignore_java_comp: true,
        file_verification: false
      }
    )
  }
}