import { Xb_ActionType, Xb_SettingsItem, Xb_SettingsItemData,
  Xb_getPersistence,
  Xb_MakeSettingsGroupData,
  Xb_MenuSelectItem} from "xb_components"
import { SettingsListView } from "../components/SettingsListView"
import { HOMLState, UISettings, _HOMLState } from "../entryability/AppState"
import { SegmentButtonV2Items, TabSegmentButtonV2 } from "@kit.ArkUI"
import { RENDERER_LIB, VersionSetting } from "../model/VersionSetting"
import { deviceInfo } from "@kit.BasicServicesKit"
import { HomlViewModel } from "../core/HomlViewModel"
import { JAVA_VERSION } from "../core/JVMLauncher"

@Builder
export function GameOptionsBuilder(name: string, param: Object) {
  GameOptions()
}

@ComponentV2
struct GameOptions {

  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!
  @Local offlineSkins: SegmentButtonV2Items = new SegmentButtonV2Items([
    { text: 'Stave 史蒂夫', icon: getIconResource('stave') },
    { text: 'Alex 艾利克斯', icon: getIconResource('alex') },
    { text: '正版玩家皮肤', icon: getIconResource('default') },
  ]);
  @Local viewModel: HomlViewModel = new HomlViewModel()
  @Local offlineSkinIndex: number = 0 // 临时

  build() {
    NavDestination() {
      SettingsListView({
        groups: Xb_MakeSettingsGroupData(this.optionsSettingsGroups),
        endBuilder: () => {
          this.skins()
        }
      })
    }
    .title('全局选项')
    .padding({ top: HOMLState.topRectHeight })
    .backgroundColor(this.UIstate.HomeBackground == 'image' && HOMLState.widthBp > 1 ? Color.Transparent : $r('sys.color.ohos_id_color_sub_background'))
    .onReady((ctx) => {
      HOMLState.currentSettingsPageName = ctx.pathInfo.name
    })
  }

  @LocalBuilder
  skins() {
    ListItem() {
      TabSegmentButtonV2({
        items: this.offlineSkins,
        selectedIndex: this.offlineSkinIndex,
        onItemClicked: (tab) => {
          this.offlineSkinIndex = tab
        }
      })
    }
    .margin({ left: 12, right: 12})
    if (this.offlineSkinIndex == 2) {
      ListItem() {
        Xb_SettingsItem({
          item: {
            label: '选择皮肤',
            actionType: Xb_ActionType.JUMP,
            onChange: () => {
              // TODO 选择皮肤
            }
          },
          themeType: this.UIstate.DarkMode as number,
        })
      }
      .borderRadius(16)
      .margin({ left: 12, right: 12})
      .padding({ top: 12, bottom: 12, left: 6, right: 6 })
      .backgroundColor($r('sys.color.background_primary'))
    }
  }

  get optionsSettingsGroups(): Xb_SettingsItemData[] {
    const gameItems = this.buildGameItems(this.viewModel)
    // 高级选项（固定项）
    const advancedItems: Xb_SettingsItemData[] = [
      {
        label: '温馨提示',
        icon: $r('sys.symbol.info_circle'),
        iconColor: HOMLState.currentThemeColor,
        content: '更改高级选项可能导致一些不可预测的严重问题，除非您有所把握，不建议更改高级选项。更改高级选项导致的问题启动器概不负责。',
        actionType: Xb_ActionType.TEXT,
      },
    ]
    // 高级选项动态项
    const advancedStateItems = this.buildAdvancedItems(this.viewModel)
    // 离线皮肤分组（固定项）
    const offlineSkinItems: Xb_SettingsItemData[] = [
      {
        label: '温馨提示',
        icon: $r('sys.symbol.info_circle'),
        iconColor: HOMLState.currentThemeColor,
        content: '受技术限制，离线皮肤选项可能仅对 1.19.2 以前的版本生效。',
        actionType: Xb_ActionType.TEXT,
      },
    ]
    // 拼装
    return [
      {label:'选项', actionType: Xb_ActionType.GROUP},
      ...gameItems,
      {label:'高级选项', actionType: Xb_ActionType.GROUP},
      ...advancedItems,
      {label:undefined, actionType: Xb_ActionType.GROUP},
      ...advancedStateItems,
      ...buildVersionSettings(this.viewModel.globalSetting),
      {label:'离线皮肤', actionType: Xb_ActionType.GROUP},
      ...offlineSkinItems,
    ]
  }

  buildGameItems(state: HomlViewModel): Xb_SettingsItemData[] {
    return [
      {
        label: '版本隔离',
        value: state.globalSetting.isolation,
        iconColor: HOMLState.currentThemeColor,
        content: '建议开启，隔离各版本的存档、材质、Mod等内容，可防止Mod及其配置文件的冲突问题',
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          state.globalSetting.isolation = v as boolean
        }
      },
      {
        label: '自动设置语言',
        iconColor: HOMLState.currentThemeColor,
        value:  state.globalSetting.autoSetGameLang,
        content: `自动将语言设置为${'系统语言(简体中文)'}`,
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          state.globalSetting.autoSetGameLang = v as boolean
        }
      },
      {
        label: "虚拟布局",
        value: state.globalSetting?.controller,
        content: '支持导入导出自定义布局文件',
        actionType: Xb_ActionType.MENU,
        menuSelectList: this.viewModel.controllerViewModel.controllerList.map(d=>{
          return { label:d.name, value:d.id ?? d.name } as Xb_MenuSelectItem
        }),
        onChange: (v) => {
          if(state.globalSetting){
            state.globalSetting.controller = v as string
          }
        }
      },
      {
        label: "Java版本",
        value: state.globalSetting?.jreVersion,
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
          state.globalSetting.jreVersion = v as JAVA_VERSION
        }
      },
      {
        label: "渲染驱动",
        value: state.globalSetting?.renderer,
        content: '建议使用MOBILEGLUES',
        actionType: Xb_ActionType.MENU,
        menuSelectList: [
          {label:"MOBILEGLUES", value: RENDERER_LIB.RENDERER_NAME_MOBILEGLUES},
          {label:"NG_GL4ES", value: RENDERER_LIB.RENDERER_NAME_NG_GL4ES},
          {label:"OPENGLV4(鸿蒙PC)", value: RENDERER_LIB.RENDERER_NAME_GLV4},
        ],
        menuDisabled:(item, index: number)=>{
          if(item.value == RENDERER_LIB.RENDERER_NAME_GLV4 && (deviceInfo.deviceType == "Phone" )){
            return true
          }else{
            return false
          }
        },
        onChange: (v) => {
          state.globalSetting.renderer = v as RENDERER_LIB
        }
      }
    ]
  }

  buildAdvancedItems(state: HomlViewModel): Xb_SettingsItemData[] {
    return [
      {
        label: '忽略Java兼容性警告',
        value: state.globalSetting.notCheckJVM,
        content: '使用启动器的全局设置，关闭此选项以单独为此版本进行配置',
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          state.globalSetting.notCheckJVM = v as boolean
        }
      },
      {
        label: '关闭文件校验',
        // UI 语义是“关闭校验”，底层存的是 file_verification
        value: !state.globalSetting.fileVerification,
        iconColor: HOMLState.currentThemeColor,
        content: '在启动时不校验版本文件完整性，仅建议在您修改了版本文件时启用',
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          state.globalSetting.fileVerification = !(v as boolean)
        }
      }
    ]
  }

}

/**
 * 获取图片资源引用
 * @param icon 图片名称
 * @returns Resource
 */
function getIconResource(icon: string): Resource {
  return $r(`app.media.minecraft_skin_${icon}`)
}


export function buildVersionSettings(version: VersionSetting): Xb_SettingsItemData[] {
	return [
    {
      label: '自定义UUID',
      content: '自定义UUID',
      value: version.uuid,
      actionType: Xb_ActionType.Input,
      onChange: (v) => {
        version.uuid = v as string
      }
    },
    {
      label: '服务器Ip',
      content: '启动后自动连接服务器',
      value: version.serverIp,
      actionType: Xb_ActionType.Input,
      onChange: (v) => {
        version.serverIp = v as string
      }
    },
    {
      label: '附加参数',
      content: '在启动的命令行命令添加额外参数',
      value: version.minecraftArgs,
      actionType: Xb_ActionType.Input,
      onChange: (v) => {
        version.minecraftArgs = v as string
      }
    },
    {
      label: 'Jvm参数',
      content: 'Jvm的额外参数',
      value: version.javaArgs,
      actionType: Xb_ActionType.Input,
      onChange: (v) => {
        version.javaArgs = v as string
      }
    }
  ]
}