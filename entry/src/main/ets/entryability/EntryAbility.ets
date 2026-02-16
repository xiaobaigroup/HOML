import { AbilityConstant, ConfigurationConstant, UIAbility, Want, common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { SmartAvoidance, Xb_AvoidanceManager, Xb_GlobalContext, Xb_ToastUtil } from 'xb_components';
import { HOMLState, _HOMLState } from './AppState';


const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  private avoidManager: Xb_AvoidanceManager | undefined = undefined;
  private avoidListener: (avoidance: SmartAvoidance) => void = (newAvoidance) => {
    HOMLState.bottomRectHeight = newAvoidance.bottom
    HOMLState.topRectHeight = newAvoidance.top
    HOMLState.leftAvoidWidth = newAvoidance.left
    HOMLState.rightAvoidWidth = newAvoidance.right
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      Xb_GlobalContext.initContext(this.context)
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    Xb_GlobalContext.initWindow(windowStage.getMainWindowSync())
    windowStage.loadContent('pages/Index', async (err) => {
      await Xb_GlobalContext.initDownloadDir()
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      try {
        const data = await windowStage.getMainWindow()
        // 初始化通知工具
        Xb_ToastUtil.initContext(data.getUIContext(), data.getUIContext().getHostContext() as common.UIAbilityContext)
        // 初始化 window
        this.intRectWindow(windowStage, data.getUIContext())
        // 初始化UI上下文
        _HOMLState.UIContext = data.getUIContext()
      } catch (error) {
        console.error('WindowStage', 'Failed to get the Main Window.', error);
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageWillDestroy(windowStage: window.WindowStage): void {
    // 销毁避让管理器并移除监听
    if (this.avoidManager) {
      this.avoidManager.offChangeListener(this.avoidListener);
      this.avoidManager.destroy();
      this.avoidManager = undefined;
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  // 初始化窗口
  async intRectWindow(windowStage: window.WindowStage, UIContext: UIContext) {
    // 设置自动记忆最后关闭的窗口大小(仅2in1设备生效)
    try {
      await windowStage.setWindowRectAutoSave(true);
      console.info("WindowAutoSave", 'Succeeded in setting window rect auto-save')
    } catch (exception) {
      console.error("WindowAutoSave", `Failed to set window rect auto-save. Cause code: ${exception.code} smessage: ${exception.message}` )
    }
    // 获取应用主窗口
    try {
      const windowClass: window.Window = windowStage.getMainWindowSync();
      // 设置窗口全屏
      windowClass.setWindowLayoutFullScreen(true).then(() => {
        console.info('WindowRect', 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        console.error('WindowRect', 'Failed to set the window layout to full-screen mode.', err);
      });

      // 获取布局避让遮挡的区域
      this.avoidManager = new Xb_AvoidanceManager(windowClass, UIContext);
      await this.avoidManager.init();
      // 注册监听器，当避让值变化时，更新UI状态
      this.avoidManager.onChangeListener(this.avoidListener);
      console.info('WindowRect', 'Manager initialized and listener registered.');

      // 应用窗口初始高度和宽度
      try {
        let properties = windowClass.getWindowProperties()
        let rect = properties.windowRect
        let WindowHeight = UIContext.px2vp(rect.height)
        let WindowWidth = UIContext.px2vp(rect.width)
        const widthBp: WidthBreakpoint = UIContext.getWindowWidthBreakpoint()
        // 获取窗口宽度和高度
        _HOMLState.window = windowStage.getMainWindowSync();
        _HOMLState.windowWidth_px = rect.width;
        _HOMLState.windowHeight_px = rect.height;
        HOMLState.widthBp = widthBp
        HOMLState.windowHeight = WindowHeight
        HOMLState.windowWidth = WindowWidth
        console.info('WindowRect', `窗口高度：${rect.height} px 宽度：${rect.width} px`)
        // 初始化设备窗口模式
        // this.onWindowModeChange(windowStage, windowClass)
        // 监听窗口大小变化
        windowClass.on('windowSizeChange', async (data) => {
          // 动态监听设备窗口模式
          this.onWindowModeChange(windowStage, windowClass)
          console.info('WindowChange', 'Succeeded in enabling the listener for window size changes. Data: ' + JSON.stringify(data))
          WindowWidth = UIContext.px2vp(data.width)!
          WindowHeight = UIContext.px2vp(data.height)!
          // 980px 约等于 512vp
          HOMLState.windowHeight = WindowHeight
          HOMLState.windowWidth = WindowWidth
          _HOMLState.windowWidth_px = data.width;
          _HOMLState.windowHeight_px = data.height;
          // 动态监听断点
          this.onWidthBpChange(UIContext)
          this.onHeightBpChange(WindowHeight, WindowWidth)
        })
      } catch (error) {
        console.error('WindowChange', `#intRectWindow Failed to getWindowProperties.`, error)
      }
    } catch (error) {
      console.error('WindowChange', `#intRectWindow Failed to getMainWindowSync.`, error)
    }
  }

  onWidthBpChange(UIContext: UIContext) {
    const widthBp: WidthBreakpoint = UIContext.getWindowWidthBreakpoint();
    HOMLState.widthBp = widthBp
    console.info('WindowRect', `宽度断点：${widthBp}`)
  }

  onHeightBpChange(WindowHeight: number, WindowWidth: number) {
    let heightBp = 0
    const WindowAspectRatio = WindowHeight / WindowWidth // 重写高度断点
    if (WindowAspectRatio < BREAKPOINT_RATIO_LANDSCAPE) {
      heightBp = 0
      console.debug('Layout', `断点测试 heightBp: ${heightBp} 高宽比：${WindowAspectRatio}`)
    } else if (WindowAspectRatio >= BREAKPOINT_RATIO_LANDSCAPE && WindowAspectRatio < BREAKPOINT_RATIO_PORTRAIT) {
      heightBp = 1
      console.debug('Layout', `断点测试 heightBp: ${heightBp} 高宽比：${WindowAspectRatio}`)
    } else if (WindowAspectRatio >= BREAKPOINT_RATIO_PORTRAIT) {
      heightBp = 2
      console.debug('Layout', `断点测试 heightBp: ${heightBp} 高宽比：${WindowAspectRatio}`)
    }
    HOMLState.heightBp = heightBp
  }

  async onWindowModeChange(windowStage: window.WindowStage, windowClass: window.Window) {
    try {
      // 设置默认标题栏是否显示
      windowClass.setWindowDecorVisible(false)
      // 设置默认标题栏功能按钮是否显示
      windowClass.setWindowTitleButtonVisible(true, true, true)
      // 全屏时鼠标移动至顶部不显示标题栏和dock栏，平板自由多窗则是无法唤起状态栏
      await windowClass.setTitleAndDockHoverShown(false, false)
      /*      try {
              if (this.isFirstStart) {
                const systemLimits = windowClass.getWindowLimits()
                this.windowLimits.maxWidth = systemLimits.maxWidth
                this.windowLimits.maxHeight = systemLimits.maxHeight
                this.isFirstStart = false
              }
              console.info(`WindowMode  the window limits. FirstLimits: ${JSON.stringify(this.windowLimits)}`);
              let promise = windowClass.setWindowLimits(this.windowLimits, true);
              promise.then((data) => {
                console.info(`WindowMode Succeeded in changing the window limits. limits: ${JSON.stringify(data)}`);
              }).catch((err: BusinessError) => {
                console.error(`WindowMode Failed to change the window limits. Cause code: ${err.code}, message: ${err.message}`);
              });
            } catch (exception) {
              console.error(`WindowMode Failed to change the window limits. Cause code: ${exception.code}, message: ${exception.message}`);
            }*/
      // 设置标题栏高度
      HOMLState.windowMode = true
      console.info("WindowMode", `当前为PC窗口模式 bottom: ${HOMLState.bottomRectHeight} mode: ${HOMLState.windowMode}`)
    } catch (exception) {
      console.error("WindowMode", `#onWindowModeChange error: ${JSON.stringify(exception)}`)
      HOMLState.windowMode = false
      console.info("WindowMode", `当前为普通窗口模式 bottom: ${HOMLState.bottomRectHeight} mode: ${HOMLState.windowMode}`)
    }
  }

}

const BREAKPOINT_RATIO_LANDSCAPE = 0.79;
const BREAKPOINT_RATIO_PORTRAIT = 1.2;