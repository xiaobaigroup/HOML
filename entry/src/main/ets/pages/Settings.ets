import { Xb_ActionType, Xb_getPersistence, Xb_SettingsItemData } from "xb_components"
import { SettingsListStartOffset, SettingsTopBlankHeight } from "../common/BreakPoint"
import { HOMLState, UISettings, _HOMLState } from "../entryability/AppState"
import { LengthMetrics, window } from "@kit.ArkUI"


@ComponentV2
export struct Settings {

  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!
  private pageStack: NavPathStack = new NavPathStack()

  build() {
    Column() {
      Blank()
        .height(SettingsTopBlankHeight(HOMLState.widthBp, HOMLState.heightBp))
      if (HOMLState.widthBp < 2 ) {
        this.SettingsList()
      } else {
        Navigation(this.pageStack) {
          this.SettingsList()
        }
        .width('100%')
        .height('100%')
        .hideToolBar(true)
        .hideTitleBar(true)
        .onDisAppear(() => {
          this.pageStack.clear()
        })
        .onAppear(() => {
          if (HOMLState.canClearMainPageInfo) {
            HOMLState.pageStack.clear()
          }
          if (HOMLState.widthBp >= 2 ) {
            this.pageStack.replacePathByName(HOMLState.currentSettingsPageName, true)
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .backgroundColor(this.UIstate.HomeBackground == 'image' ? Color.Transparent : $r('sys.color.background_secondary'))
    .padding({ left: HOMLState.leftAvoidWidth, right: HOMLState.rightAvoidWidth })

  }

  @Builder
  SettingsList() {
    List({ space: HOMLState.widthBp < 2 ? 12 : 3 }) {
      ForEach(this.getSettings(), (item: Xb_SettingsItemData) => {
        ListItem() {
          Flex({ direction: FlexDirection.Row, space: { main: LengthMetrics.vp(10) }, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            SymbolGlyph(item.icon)
              .fontColor([(item.id == HOMLState.currentSettingsPageName) && HOMLState.widthBp >= 2 ? HOMLState.currentThemeColor || $r('app.color.blue') : $r('sys.color.font_primary')])
              .fontSize(24)
            Text(item.label)
              .fontSize(18)
              .fontColor((item.id == HOMLState.currentSettingsPageName) && HOMLState.widthBp >= 2 ? HOMLState.currentThemeColor || $r('app.color.blue') : $r('sys.color.font_primary'))
          }
        }
        .padding(12)
        .borderRadius(16)
        .margin({ left: 12, right: 12 })
        .backgroundColor(item.id == HOMLState.currentSettingsPageName || HOMLState.widthBp < 2 ? $r('app.color.settings_switch_button_floor') : undefined)
        .onClick(() => {
          if (item.id == 'virtual_control_button') {
            HOMLState.canClearMainPageInfo = false
            HOMLState.pageStack.pushPathByName(item.id, true)
            return // 无需更新，结束执行
          }
          HOMLState.canClearMainPageInfo = true
          // 更新侧栏高亮
          HOMLState.currentSettingsPageName = item.id!
          // 根据窗口尺寸决定路由
          if (HOMLState.widthBp < 2) {
            // 使用全局栈（全屏跳转）
            HOMLState.pageStack.pushPathByName(item.id, true)
          } else {
            // 使用分栏内部栈（右侧刷新）
            this.pageStack.replacePathByName(item.id, true)
          }
        })
      })
    }
    .contentStartOffset(SettingsListStartOffset(HOMLState.widthBp, HOMLState.heightBp))
  }

  getSettings(): Xb_SettingsItemData[] {
    return [
      {
        id: 'global_game_options',
        label: '全局游戏选项',
        icon: $r('sys.symbol.scenes'),
        actionType: Xb_ActionType.TEXT
      },
      {
        id: 'game_folder',
        label: '游戏目录',
        icon: $r('sys.symbol.folder_fill'),
        actionType: Xb_ActionType.TEXT
      },
      {
        id: 'launcher_appearance',
        label: '启动器外观',
        icon: $r('sys.symbol.brush_fill'),
        actionType: Xb_ActionType.TEXT
      },
      {
        id: 'virtual_control_button',
        label: '虚拟按键配置',
        icon: $r('sys.symbol.gamecontroller_fill'),
        actionType: Xb_ActionType.TEXT
      },
      {
        id: 'about_help',
        label: '关于和帮助',
        icon: $r('sys.symbol.info_circle_fill'),
        actionType: Xb_ActionType.TEXT
      }
    ]
  }

}