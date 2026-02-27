import { EventHub, Xb_ColorModeManager,
  Xb_CrashUtils,
  Xb_getAppStore, Xb_getPersistence,
  Xb_SwitchButton,
  Xb_ThemeColorUtil} from 'xb_components';
import { LogoTextMargin, MainTabButtonMargin, MainTabButtonWidth,
  WelcomePageHeight,
  WelcomePageWidth,
  WindowLogoTextMargin,
  WindowMainTabButtonMargin } from '../common/BreakPoint';
import { EventKey } from '../common/EventKey';
import { getColorWithTransparency } from '../common/util/ColorWithTransparency';
import { HomlViewModel } from '../core/HomlViewModel';
import { JAVA_VERSION } from '../core/JVMLauncher';
import { HOMLState, UISettings, _HOMLState } from '../entryability/AppState';
import { installJre } from '../utils';
import { User } from '../view/UserPrivacy';
import { Home } from './Home';
import { Settings } from './Settings';


@Entry
@ComponentV2
struct Index {
  @Local viewmodel: HomlViewModel = Xb_getAppStore(HomlViewModel,()=> new HomlViewModel())!
  @Local UIstate: UISettings = Xb_getPersistence(UISettings, () => new UISettings())!

  private panOptionL: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left })
  private panOptionR: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Right })

   aboutToAppear(): void {
    Xb_CrashUtils.initPathStack(HOMLState.pageStack)
    this.viewmodel.initHome()
    // 注册所有事件
    this.registerEvent()
    // 发送初始化事件
    this.sendEvent()
    // 初始化所有热更新状态
    this.initState()

  }

  aboutToDisappear(): void {
    // 注销事件
    this.unregister()
  }

  build() {
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
  }

  @Builder
  Main() {
    Stack() {
      // 背景图
      Image(HOMLState.mainBackgroundImage)
        .width('100%')
        .height('100%')
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
            selectedColor: getColorWithTransparency(this.getUIContext().getHostContext()!, (HOMLState.currentThemeColor || (HOMLState.mainCurrentTab == 0 ? $r('app.color.green') : $r('app.color.blue'))), 0.9),
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
        // if (HOMLState.windowMode) {
        //   Row() {
        //
        //   }.width(120)
        //   .height(56)
        //   .borderColor(Color.Black)
        //   .borderWidth(2)
        //   .id('window_control')
        //   .alignRules({
        //     right: { anchor: '__container__', align: HorizontalAlign.End },
        //     top: { anchor: '__container__', align: VerticalAlign.Top }
        //   })
        // }
      }
      .height(56)
      .margin({ left: 12, top: HOMLState.topRectHeight })

      if (this.UIstate.FirstStart) {
        this.UserPriBuilder()
      }

    }
    .height('100%')
    .align(Alignment.Top)
    .backgroundColor(this.UIstate.HomeBackground == 'image' ? Color.Transparent : $r('sys.color.background_secondary'))
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

  @LocalBuilder
  UserPriBuilder() {
    Column() {
      Column() {
        User()
      }
      .clip(true)
      .borderRadius({
        topLeft: 32,
        topRight: 32,
        bottomLeft: HOMLState.widthBp > 1 ? 32 : 0,
        bottomRight: HOMLState.widthBp > 1 ? 32 : 0
      })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .width(WelcomePageWidth(HOMLState.widthBp))
      .height(WelcomePageHeight(HOMLState.widthBp))
      .onAppear(() => {
        console.info('Index-bindSheet', 'UserPriBuilder Column onAppear 被调用')
      })
      .onAttach(() => {
        console.info('Index-bindSheet', 'UserPriBuilder Column onAttach 半模态组件已挂载上树')
      })
      .onDetach(() => {
        console.info('Index-bindSheet', 'UserPriBuilder Column onDetach 半模态组件已卸载')
      })
    }
    .clip(true)
    .height('100%').width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(HOMLState.widthBp > 1 ? FlexAlign.Center : FlexAlign.End)
    .backgroundBlurStyle(BlurStyle.Thin,
      { colorMode: ThemeColorMode.SYSTEM, adaptiveColor: AdaptiveColor.DEFAULT, scale: 0.3 })
  }

  // 注册事件
  registerEvent() {
    // 深色模式切换事件
    EventHub.on(EventKey.SwitchDarkMode, (color_mode?: ThemeColorMode) => {
      let darkMode = color_mode
      if (!darkMode) {
        darkMode = this.UIstate.DarkMode
      }
      Xb_ColorModeManager.setThemeColorMode(_HOMLState.context, darkMode)
    })
    EventHub.on(EventKey.CustomBackground, () => {
      HOMLState.getBackgroundImage()
    })
  }

  // 发送事件
  sendEvent() {
    // 初始化深色模式
    EventHub.sendEvent(EventKey.SwitchDarkMode)
  }

  // 状态初始化
  initState() {
    // 初始化主题色
    if (this.UIstate.RandomTheme) {
      const randomName = Xb_ThemeColorUtil.getRandomThemeName()
      this.UIstate.ThemeColor = randomName.replace('AppTheme', '')
    }
    if (this.UIstate.ThemeColor !== 'default') {
      HOMLState.currentThemeColor = Xb_ThemeColorUtil.getThemeColor(`${this.UIstate.ThemeColor}AppTheme`)
    }

  }

  // 注销事件
  unregister() {
    EventHub.off(EventKey.SwitchDarkMode)
    EventHub.off(EventKey.CustomBackground)
  }

}
