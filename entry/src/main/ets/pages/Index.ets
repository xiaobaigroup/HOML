import { Xb_getAppStore, Xb_SwitchButton } from 'xb_components';
import { LogoTextMargin, MainTabButtonMargin, MainTabButtonWidth, WindowLogoTextMargin,
  WindowMainTabButtonMargin } from '../common/BreakPoint';
import { getColorWithTransparency } from '../common/util/ColorWithTransparency';
import { HomlViewModel } from '../core/HomlViewModel';
import { HOMLState, _HOMLState } from '../entryability/AppState';
import { Home } from './Home';
import { Settings } from './Settings';


@Entry
@ComponentV2
struct Index {
  @Local viewmodel: HomlViewModel = Xb_getAppStore(HomlViewModel,()=> new HomlViewModel())!
  aboutToAppear(): void {
    this.viewmodel.initHome()
  }

  private panOptionL: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left })
  private panOptionR: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Right })

  build() {
    if (HOMLState.widthBp < 2) {
      Navigation(HOMLState.pageStack) {
        this.Main()
      }
      .height('100%')
      .hideToolBar(true)
      .hideTitleBar(true)
      .mode(NavigationMode.Stack)
      .onDisAppear(() => {
        HOMLState.pageStack.clear()
      })
    } else {
      this.Main()
    }
  }

  @Builder
  Main() {
    Stack() {
      if (HOMLState.mainCurrentTab == 0) {
        Home()
      } else {
        Settings()
      }
      RelativeContainer() {
        Text('Homo Launcher')
          .id('homo')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin(HOMLState.windowMode ? WindowLogoTextMargin(HOMLState.widthBp, HOMLState.heightBp) : LogoTextMargin(HOMLState.widthBp, HOMLState.heightBp))
          .alignRules({
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            top: { anchor: '__container__', align: VerticalAlign.Top }
          })

        Row() {
          Xb_SwitchButton({
            switchOne: HOMLState.mainCurrentTab,
            selectedColor: getColorWithTransparency(this.getUIContext().getHostContext()!, HOMLState.mainCurrentTab == 0 ? $r('app.color.green') : $r('app.color.blue'), 0.9),
            items: [
              { text: '主页', symbol: $r('sys.symbol.house_fill') },
              { text: '设置', symbol: $r('sys.symbol.gearshape_fill') },
            ],
            onClickUse: (index) => {
              HOMLState.mainCurrentTab = index
            }
          })
        }
        .margin(HOMLState.windowMode ? WindowMainTabButtonMargin(HOMLState.widthBp, HOMLState.heightBp) : MainTabButtonMargin(HOMLState.widthBp, HOMLState.heightBp))
        .width(MainTabButtonWidth(HOMLState.widthBp, HOMLState.heightBp))
        .id('main_tab_button')
        .alignRules({
          middle: { anchor: "__container__", align: HorizontalAlign.Center },
          top: { anchor: "__container__", align: VerticalAlign.Top }
        })
        // 自定义窗口控制区
        if (HOMLState.windowMode) {
          Row() {

          }.width(120)
          .height(56)
          .borderColor(Color.Black)
          .borderWidth(2)
          .id('window_control')
          .alignRules({
            right: { anchor: '__container__', align: HorizontalAlign.End },
            top: { anchor: '__container__', align: VerticalAlign.Top }
          })
        }
      }
      .height(56)
      .margin({ left: 12, top: HOMLState.topRectHeight })
    }
    .height('100%')
    .align(Alignment.Top)
    .backgroundColor($r('sys.color.background_secondary'))
    .foregroundBlurStyle(HOMLState.showBackgroundBlur ? BlurStyle.Thin : BlurStyle.NONE,
      { colorMode: ThemeColorMode.SYSTEM, adaptiveColor: AdaptiveColor.DEFAULT, scale: 0.3 })
    // 左滑手势
    .gesture(
      PanGesture(this.panOptionL)
        .onActionStart((event: GestureEvent) => {
          if (event) {
            _HOMLState.UIContext.animateTo({
              duration: 300,
              curve: Curve.EaseOut,
              playMode: PlayMode.Normal,
            }, () => {
              HOMLState.mainCurrentTab = 1
            })
          }
        }),
    )
    // 右滑滑手势
    .gesture(
      PanGesture(this.panOptionR)
        .onActionStart((event: GestureEvent) => {
          if (event) {
            _HOMLState.UIContext.animateTo({
              duration: 300,
              curve: Curve.EaseOut,
              playMode: PlayMode.Normal,
            }, () => {
              HOMLState.mainCurrentTab = 0
            })
          }
        }),
    )
  }

}
