import { Xb_GameLayout} from "xb_components"
import { HOMLState, _HOMLState } from "../entryability/AppState"
import { FCLKeycodes } from "../core/FCLKeycode"
import { window } from "@kit.ArkUI"

@Builder
export function ControllerLayoutBuilder(name: string, param: Object) {
  ControllerLayout()
}

@ComponentV2
struct ControllerLayout {

  build() {
    NavDestination() {
      Xb_GameLayout({inGame: false, onNormKeyCode: FCLKeycodes.onNormKeyCode})
    }
    .title('控制器布局')
    .backgroundColor(Color.Gray)
    .padding({ top: HOMLState.topRectHeight })
  }

  aboutToAppear(): void {
    let orientation = window.Orientation.LANDSCAPE
    this.setScreenOrientation(orientation)
  }

  aboutToDisappear(): void {
    let orientation = window.Orientation.AUTO_ROTATION_RESTRICTED
    this.setScreenOrientation(orientation)
  }

  // 设置屏幕显示方向
  setScreenOrientation(orientation: window.Orientation) {
    let windowClass: window.Window | undefined = undefined;
    window.getLastWindow(_HOMLState.context).then((data) => {
      windowClass = data
      windowClass.setPreferredOrientation(orientation).catch((error: BusinessError) => {
        console.error(`setPreferredOrientation error name: ${error.name} message: ${error.message}`)
      })
    }).catch((err: BusinessError) => {
      console.error(`getLastWindow error name: ${err.name} message: ${err.message}`)
    })
  }

}
