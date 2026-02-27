import { Xb_GameLayout, Xb_GameMenuState, Xb_getAppStore, Xb_getPersistence, Xb_GlobalContext } from "xb_components";
import {KeyboardAvoidMode} from '@kit.ArkUI'
import { KeyCode } from "@kit.InputKit";
import { FCLKeycodes } from "../core/FCLKeycode";
import { GameViewModel } from "../core/GameViewModel";
import { HomlViewModel } from "../core/HomlViewModel";
import { window } from "@kit.ArkUI";
import { LogsView } from "../view/LogsView";
import { NativeInput } from "../core/NativeInput";
import { jvmLauncher } from "../core/JVMLauncher";

class GameXComponentController extends XComponentController{
  onSurfaceCreated(surfaceId: string): void {
    jvmLauncher.bridge.surfaceChanged(parseInt(surfaceId), 0, 0)
  }
  onSurfaceChanged(surfaceId: string, rect: SurfaceRect): void {
    jvmLauncher.bridge.surfaceChanged(parseInt(surfaceId), 800, 800)
  }
  onSurfaceDestroyed(surfaceId: string): void {
  }
}
@Builder
export function GameBuilder(route: string, version:string){
  Game({version})
}

@ComponentV2
struct Game {
  xController = new GameXComponentController();
  @Param @Require version: string
  @Local viewModel: HomlViewModel = Xb_getAppStore(HomlViewModel, ()=> new HomlViewModel())!
  @Local nativeInput: NativeInput = Xb_getAppStore(NativeInput, ()=> new NativeInput())!

  @LocalBuilder
  gameView(){
    XComponent({id:"java-game", type: XComponentType.TEXTURE, controller: this.xController})
      .backgroundColor(Color.Black)
      .width('100%')
      .height('100%')
      .constraintSize({ maxWidth: '100%', maxHeight: '100%' })
      .onLoad(()=>{
        setTimeout(()=> {
          this.viewModel.launch()
        }, 1000)
      })
      LogsView()
  }
  build() {
    NavDestination(){
      Xb_GameLayout({gameView: this.gameView, eventHandler: new GameViewModel(), inGame: true, onNormKeyCode: FCLKeycodes.onNormKeyCode})
    }.hideTitleBar(true).onBackPressed(()=>{
      this.nativeInput.sendKeyEvent(KeyCode.KEYCODE_ESCAPE, true)
      return true;
    })
  }
  onBackPress(): boolean | void {
    this.nativeInput.sendKeyEvent(KeyCode.KEYCODE_ESCAPE, true)
    return true;
  }
  aboutToAppear(): void {

    let orientation = window.Orientation.LANDSCAPE
    this.setScreenOrientation(orientation)
  }

  aboutToDisappear(): void {
    let orientation = window.Orientation.AUTO_ROTATION_RESTRICTED
    this.setScreenOrientation(orientation)
  }
  setScreenOrientation(orientation: window.Orientation) {
    let windowClass: window.Window | undefined = undefined;
    const context = this.getUIContext()
    context.setKeyboardAvoidMode(KeyboardAvoidMode.NONE)
    window.getLastWindow(Xb_GlobalContext.getContext()).then((data) => {
      windowClass = data
      windowClass.setWindowSystemBarEnable([])
      windowClass.setPreferredOrientation(orientation).catch((error: BusinessError) => {
        console.error(`setPreferredOrientation error name: ${error.name} message: ${error.message}`)
      })
    }).catch((err: BusinessError) => {
      console.error(`getLastWindow error name: ${err.name} message: ${err.message}`)
    })
  }
}
