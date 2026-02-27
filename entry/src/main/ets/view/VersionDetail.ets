import {
  hasJit,
  Xb_ActionType, Xb_CapsuleButton, Xb_getAppStore, Xb_getPersistenceByName,
  Xb_MakeSettingsGroupData,
  Xb_MenuSelectItem,
  Xb_SettingsItemData,
  Xb_ToastUtil} from "xb_components"
import { PADDING_VALUE_12 } from "xb_components/src/main/ets/components/Constants"
import { VersionItemView } from "../components/VersionListView"
import { VersionFunctionModel } from "../model/VersionFunctionModel"
import { MinecraftVersion } from "../model/MinecraftVersion"
import { RENDERER_LIB, VersionSetting } from "../model/VersionSetting"
import { deviceInfo } from "@kit.BasicServicesKit"
import { SettingsListView } from "../components/SettingsListView"
import { HomlViewModel } from "../core/HomlViewModel"
import { buildVersionSettings } from "./GameOptions"
import { HOMLState } from "../entryability/AppState"
import { JAVA_VERSION } from "../core/JVMLauncher"


@Builder
export function VersionDetailBuilder(name: string, param: Object) {
  VersionDetail({currentVersion: param as MinecraftVersion})
}

@ComponentV2
struct VersionDetail {

  @Require @Param currentVersion: MinecraftVersion
  @Local viewmodel: HomlViewModel = Xb_getAppStore(HomlViewModel)!
  @Local versionSetting: VersionSetting = Xb_getPersistenceByName(VersionSetting, this.currentVersion.id,()=> new VersionSetting())!

  build() {
    NavDestination() {
      SettingsListView({
        groups: Xb_MakeSettingsGroupData(this.getOptions()),
        headerBuilder: () => {
          this.buildVersionHeader()
        }
      })
    }
    .title('版本选项')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }

  @Builder
  buildVersionHeader() {
    ListItemGroup({ header: this.title('基本信息'), space: 2 }) {
      ListItem() {
        Column() {
          VersionItemView(this.currentVersion!)
          List({space: 3}) {
            ForEach(this.getVersionBarModel(), (item: VersionFunctionModel, index) => {
              ListItem() {
                Xb_CapsuleButton({
                  icon: item.icon,
                  text: item.title,
                  iconColor: item?.iconColor || $r('app.color.blue'),
                  theBackgroundColor: item?.backgroundColor || $r('sys.color.button_background_color_transparent'),
                  onCheck: () => {
                    item.onAction()
                  },
                })
              }
            })
          }
          .scrollBar(BarState.Off)
          .listDirection(Axis.Horizontal)
          .alignListItem(ListItemAlign.Center)
          .padding({ left: 3, right: 8, bottom: 12 })
        }
        .alignItems(HorizontalAlign.Start)
      }
      .borderRadius(16)
      .backgroundColor($r('sys.color.background_primary'))
      .padding({ left: 13, right: 13 })
    }
    .padding({ left: PADDING_VALUE_12, right: PADDING_VALUE_12, bottom: 3 })
  }

  @LocalBuilder
  title(title?: ResourceStr) {
    Text(title || "")
      .fontSize(16)
      .padding({ top: 6, left: 16 })
      .fontColor( $r("sys.color.font_secondary"))
  }

  getOptions(): Xb_SettingsItemData[] {
    return [
      {label:"选项", actionType: Xb_ActionType.GROUP},
      {
        label: "使用全局设置",
        value: this.versionSetting?.global,
        content: '使用启动器的全局设置，关闭此选项以单独为此版本进行配置',
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          if(this.versionSetting){
            this.versionSetting.global = v as boolean
          }
        }
      },
      {
        label: "版本隔离",
        value: this.versionSetting?.isolation,
        content: '建议开启，隔离各版本的存档、材质、Mod等内容，可防止Mod及其配置文件的冲突问题',
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          if(this.versionSetting){
            this.versionSetting.isolation = v as boolean
          }
        }
      },
      {
        label: "虚拟布局",
        value: this.versionSetting?.controller,
        content: '支持导入导出自定义布局文件',
        actionType: Xb_ActionType.MENU,
        menuSelectList: this.viewmodel.controllerViewModel.controllerList.map(d=>{
          return { label:d.name, value:d.id ?? d.name} as Xb_MenuSelectItem
        }),
        onChange: (v) => {
          if(this.versionSetting){
            this.versionSetting.controller = v as string
          }
        }
      },
      {
        label: "Java版本",
        value: this.versionSetting?.jreVersion,
        content: '切换java运行时版本',
        actionType: Xb_ActionType.MENU,
        menuSelectList: [
          {label:"java8", value: JAVA_VERSION.JAVA8},
          {label:"java17", value: JAVA_VERSION.JAVA17},
          {label:"java21", value: JAVA_VERSION.JAVA21},
          {label:"java25", value: JAVA_VERSION.JAVA25},
        ],
        menuDisabled:(item, index: number)=>{
          if(item.value == JAVA_VERSION.JAVA17 || item.value == JAVA_VERSION.JAVA25 ){
            return false
          }else{
            return true
          }
        },
        onChange: (v) => {
          this.versionSetting.jreVersion = v as JAVA_VERSION
        }
      },
      {
        label: "渲染驱动",
        value: this.versionSetting?.renderer,
        content: '建议使用MOBILEGLUES',
        actionType: Xb_ActionType.MENU,
        menuSelectList: [
          {label:"MOBILEGLUES", value: RENDERER_LIB.RENDERER_NAME_MOBILEGLUES},
          {label:"NG_GL4ES", value: RENDERER_LIB.RENDERER_NAME_NG_GL4ES},
          {label:"OPENGLV4(鸿蒙pc)", value: RENDERER_LIB.RENDERER_NAME_GLV4},
        ],
        menuDisabled:(item, index: number)=>{
          if(item.value == RENDERER_LIB.RENDERER_NAME_GLV4 && (deviceInfo.deviceType == "Phone" )){
            return true
          }else{
            return false
          }
        },
        onChange: (v) => {
          if(this.versionSetting){
            this.versionSetting.renderer = v as RENDERER_LIB
          }
        }
      },
      {label:"高级选项", actionType: Xb_ActionType.GROUP},
      {
        label: "温馨提示",
        icon: $r('sys.symbol.info_circle'),
        content: '更改高级选项可能导致一些不可预测的严重问题，除非您有所把握，不建议更改高级选项。更改高级选项导致的问题启动器概不负责。',
        actionType: Xb_ActionType.TEXT,
      },
      {label:undefined, actionType: Xb_ActionType.GROUP},
      {
        label: "忽略Java兼容性警告",
        value: this.versionSetting?.notCheckJVM,
        content: '使用启动器的全局设置，关闭此选项以单独为此版本进行配置',
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          if(this.versionSetting){
            this.versionSetting.notCheckJVM = v as boolean
          }
        }
      },
      {
        label: "关闭文件校验",
        value: this.versionSetting?.fileVerification,
        content: '在启动时不校验游戏版本文件完整性，仅建议在您修改了Minecraft版本文件时启用',
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          if(this.versionSetting){
            this.versionSetting.fileVerification = v as boolean
          }
        }
      },
      ...buildVersionSettings( this.versionSetting!)
    ]
  }

  getVersionBarModel(): VersionFunctionModel[] {
    return [
      {
        icon: $r('sys.symbol.play_fill'),
        title: this.viewmodel.hasJit ? "启动游戏": '预览虚拟布局',
        iconColor: $r('sys.color.font_on_primary'),
        backgroundColor: $r('app.color.green'),
        onAction: async () => {
          this.viewmodel.selectVersion(this.currentVersion)
          this.viewmodel.toGame()
        }
      },
      // {
      //   icon: $r('sys.symbol.square_and_pencil'),
      //   title: '编辑信息',
      //   onAction: async () => {
      //
      //   }
      // },
      // {
      //   icon: $r('sys.symbol.folder'),
      //   title: '打开目录',
      //   onAction: async () => {
      //
      //   }
      // },
      // {
      //   icon: $r('sys.symbol.rectangle_on_rectangle'),
      //   title: '创建副本',
      //   onAction: async () => {
      //
      //   }
      // },
      // {
      //   icon: $r('sys.symbol.trash'),
      //   title: '删除',
      //   iconColor: Color.Red,
      //   onAction: async () => {
      //
      //   }
      // }
    ]
  }

}


