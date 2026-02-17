import { Xb_ActionType, Xb_SettingsItem, Xb_SettingsItemData, ThemeType,
  Xb_makePersistenceSettings } from "xb_components"
import { PADDING_VALUE_12 } from "xb_components/src/main/ets/components/Constants"
import { GroupDataModel } from "../common/model/GroupDataModel"
import { SettingsListView } from "../components/SettingsListView"
import { HomlViewModel } from "../core/HomlViewModel"
import { HOMLState } from "../entryability/AppState"

@Builder
export function GameOptionsBuilder(name: string, param: Object) {
  GameOptions()
}

@ComponentV2
struct GameOptions {

  private pageStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      SettingsListView({
        groups: this.optionsSettingsGroups
      })
    }
    .title('全局游戏选项')
    .padding({ top: HOMLState.topRectHeight })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .onReady((ctx) => {
      this.pageStack = ctx.pathStack
    })

  }

  @Builder
  title(title?: ResourceStr) {
    Text(title || "")
      .fontSize(16)
      .padding({ top: 6, bottom: 0, left: 16 })
      .fontColor( $r("sys.color.font_secondary"))
  }

  get optionsSettingsGroups(): GroupDataModel[] {
    // makePersistenceSettings 返回 state 后生成各 item
    const gameItems = Xb_makePersistenceSettings<HomlViewModel>(
      HomlViewModel,
      () => new HomlViewModel(),
      (state) => this.buildGameItems(state)
    )
    // 高级选项（固定项）
    const advancedItems: Xb_SettingsItemData[] = [
      {
        label: '温馨提示',
        icon: $r('sys.symbol.info_circle'),
        content: '更改高级选项可能导致一些不可预测的严重问题，除非您有所把握，不建议更改高级选项。更改高级选项导致的问题启动器概不负责。',
        actionType: Xb_ActionType.TEXT,
      },
    ]
    // 高级选项动态项
    const advancedStateItems = Xb_makePersistenceSettings<HomlViewModel>(
      HomlViewModel,
      () => new HomlViewModel(),
      (state) => this.buildAdvancedItems(state)
    )
    // 离线皮肤分组（固定项）
    const offlineSkinItems: Xb_SettingsItemData[] = [
      {
        label: '温馨提示',
        icon: $r('sys.symbol.info_circle'),
        content: '受技术限制，离线皮肤选项可能仅对 1.19.2 以前的版本生效。',
        actionType: Xb_ActionType.TEXT,
      },
    ]
    // 拼装
    return [
      {
        title: '游戏选项',
        items: gameItems
      },
      {
        title: '高级选项',
        items: [...advancedItems, ...advancedStateItems]
      },
      {
        title: undefined, // 无标题组
        items: [
          {
            label: '附加参数',
            value: '在启动游戏的命令行命令添加额外参数',
            actionType: Xb_ActionType.JUMP,
            onChange: (v) => {
              // TODO: 打开附加参数编辑页
            }
          }
        ]
      },
      {
        title: '离线皮肤',
        items: offlineSkinItems
      }
    ]
  }

  buildGameItems(state: HomlViewModel): Xb_SettingsItemData[] {
    return [
      {
        label: '版本隔离',
        value: state.isolation,
        content: '建议开启，隔离各版本的存档、材质、Mod等内容，可防止Mod及其配置文件的冲突问题',
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          state.isolation = v as boolean
        }
      },
      {
        label: '自动设置游戏语言',
        value: state.autoSetGameLang,
        content: `自动将游戏语言设置为${'系统语言(简体中文)'}`,
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          state.autoSetGameLang = v as boolean
        }
      }
    ]
  }

  buildAdvancedItems(state: HomlViewModel): Xb_SettingsItemData[] {
    return [
      {
        label: '忽略Java兼容性警告',
        value: state.ignore_java_comp,
        content: '使用启动器的全局设置，关闭此选项以单独为此版本进行配置',
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          state.ignore_java_comp = v as boolean
        }
      },
      {
        label: '关闭文件校验',
        // UI 语义是“关闭校验”，底层存的是 file_verification
        value: !state.file_verification,
        content: '在启动游戏时不校验游戏版本文件完整性，仅建议在您修改了Minecraft版本文件时启用',
        actionType: Xb_ActionType.TOGGLE,
        onChange: (v) => {
          state.file_verification = !(v as boolean)
        }
      }
    ]
  }

}