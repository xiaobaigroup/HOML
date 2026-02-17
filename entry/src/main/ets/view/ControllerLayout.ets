import { Xb_ActionType, Xb_SettingsItem, Xb_SettingsItemData, ThemeType, EventHub,
  Xb_getPersistence,
  Xb_getPersistenceByName,
  Xb_GameLayout} from "xb_components"
import { SettingsListView } from "../components/SettingsListView"
import { SegmentButtonV2Items, TabSegmentButtonV2 } from "@kit.ArkUI"
import { HOMLState, UISettings } from "../entryability/AppState"
import { EventKey } from "../common/EventKey"
import { FCLKeycodes } from "../core/FCLKeycode"

@Builder
export function ControllerLayoutBuilder(name: string, param: Object) {
  ControllerLayout()
}

@ComponentV2
struct ControllerLayout {

  @Local UIstate: UISettings = Xb_getPersistence(UISettings, () => new UISettings())!
  private pageStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Xb_GameLayout({inGame: false, onNormKeyCode: FCLKeycodes.onNormKeyCode})
    }
    .title('控制器布局')
    .padding({ top: HOMLState.topRectHeight })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .onReady((ctx) => {
      this.pageStack = ctx.pathStack
    })

  }
}

/**
 * 获取图片资源引用
 * @param icon 图片名称
 * @returns Resource
 */
function getIconResource(icon: string): Resource {
  return $r(`app.media.color_mode_${icon}`)
}