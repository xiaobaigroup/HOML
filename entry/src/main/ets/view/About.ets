import { Xb_ActionType, Xb_SettingsItemData, ThemeType, EventHub,
  Xb_getPersistence,
  Xb_MakeSettingsGroupData,
  Xb_GoToWeb} from "xb_components"
import { SettingsListView } from "../components/SettingsListView"
import { HOMLState, UISettings } from "../entryability/AppState"
import { XbStudioNavInfo } from "xb_components/src/main/ets/entity/Common"

@Builder
export function AboutBuilder(name: string, param: Object) {
  About()
}

@ComponentV2
struct About {

  private pageStack: NavPathStack = new NavPathStack()
  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!

  build() {
    NavDestination() {
      SettingsListView({
        groups: Xb_MakeSettingsGroupData( this.appearanceSettingsGroups()),
      })
    }
    .title('关于和帮助')
    .padding({ top: HOMLState.topRectHeight })
    .backgroundColor(this.UIstate.HomeBackground == 'image' && HOMLState.widthBp > 1 ? Color.Transparent : $r('sys.color.ohos_id_color_sub_background'))
    .onReady((ctx) => {
      this.pageStack = ctx.pathStack
      HOMLState.currentSettingsPageName = ctx.pathInfo.name
    })
  }

  appearanceSettingsGroups(): Xb_SettingsItemData[] {
    return [
      {
        label: '小白工坊',
        icon: $r('sys.symbol.hand_thumbsup_fill'),
        actionType: Xb_ActionType.JUMP,
        onChange: (v) => {
          const params: XbStudioNavInfo = {
            needClose: false,
            iconSize: 20,
            topRectHeight: 0,
            itemBackgroundCorlor: $r('sys.color.background_primary'),
            topButtonColor: $r('sys.color.comp_background_tertiary'),
            pageBackgroundColor: $r('sys.color.background_secondary')
          }
          this.pageStack.pushPathByName('XbStudio', params, true)
        }
      },
      {
        label: '开源仓库',
        icon: $r('sys.symbol.house_fill'),
        actionType: Xb_ActionType.JUMP,
        onChange: (v) => {
          Xb_GoToWeb('https://github.com/xiaobaigroup/HOML')
        }
      },
    ]
  }

}
