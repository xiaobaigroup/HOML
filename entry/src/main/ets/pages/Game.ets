import { Xb_GameLayout, Xb_GameMenuState, Xb_getAppStore, Xb_getPersistence } from "xb_components";
import { nativeInput } from "../core/NativeInput";
import { KeyCode } from "@kit.InputKit";
import { JVMLauncher } from "../core/JVMLauncher";
import { FCLKeycodes } from "../core/FCLKeycode";
import { GameViewModel } from "../core/GameViewModel";

class GameXComponentController extends XComponentController{
  onSurfaceCreated(surfaceId: string): void {
    //JVMLauncher.surfaceChanged(parseInt(surfaceId), 0, 0)
  }
  onSurfaceChanged(surfaceId: string, rect: SurfaceRect): void {
    // JVMLauncher.surfaceChanged(parseInt(surfaceId), 800, 800)
  }
  onSurfaceDestroyed(surfaceId: string): void {
  }
}
@Builder
export function GameBuilder(route: string, version:string){
  Game({version})
}

@Entry
@ComponentV2
struct Game {
  xController = new GameXComponentController();
  @Local widthPx: number = 900;
  @Local heightPx: number = 900;
  @Param @Require version: string
  @Local viewModel?: GameViewModel = Xb_getAppStore(GameViewModel)
  @Local menuState?: Xb_GameMenuState = Xb_getPersistence(Xb_GameMenuState)
  async aboutToAppear(): Promise<void> {
    JVMLauncher.currentVersion = this.version
  }
  @LocalBuilder
  gameView(){
    XComponent({id:"java-game",type: XComponentType.TEXTURE, controller: this.xController})
      .backgroundColor(Color.Black)
      .width('100%')
      .height('100%')
      .constraintSize({ maxWidth: '100%', maxHeight: '100%' })
      .onLoad(()=>{
        const context = this.getUIContext().getHostContext()
        setTimeout(()=> {
          JVMLauncher.launch(context!, "xiaobai", {id: JVMLauncher.currentVersion, arguments:[]}, this.menuState?.screenWidth, this.menuState?.screenHeight)
        }, 1000)
      })
    //LogsView()
  }
  build() {
    NavDestination(){
      Xb_GameLayout({gameView: this.gameView, eventHandler: this.viewModel, inGame: true, onNormKeyCode: FCLKeycodes.onNormKeyCode})
    }.hideTitleBar(true)
  }
  onBackPress(): boolean | void {
    nativeInput.sendKeyEvent(KeyCode.KEYCODE_ESCAPE, true)
    return false;
  }
}
