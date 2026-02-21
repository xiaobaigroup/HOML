import { AbilityConstant, ConfigurationConstant, UIAbility, Want, common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { SmartAvoidance, Xb_AvoidanceManager, Xb_GlobalContext, Xb_ToastUtil } from 'xb_components';
import { HOMLState, _HOMLState } from './AppState';
import display from '@ohos.display';

const DOMAIN = 0x0000;
const BREAKPOINT_RATIO_LANDSCAPE = 0.79;
const BREAKPOINT_RATIO_PORTRAIT = 1.2;

export default class EntryAbility extends UIAbility {

  private avoidManager: Xb_AvoidanceManager | undefined = undefined;
  private avoidListener: (avoidance: SmartAvoidance) => void = (newAvoidance) => {
    HOMLState.bottomRectHeight = newAvoidance.bottom
    HOMLState.topRectHeight = newAvoidance.top
    HOMLState.leftAvoidWidth = newAvoidance.left
    HOMLState.rightAvoidWidth = newAvoidance.right
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Xb_GlobalContext.initContext(this.context)
    _HOMLState.context = this.context
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    const windowClass = windowStage.getMainWindowSync();
    Xb_GlobalContext.initWindow(windowClass);
    (async () => {
      try {
        await this.prepareWindowLayout(windowStage, windowClass);
      } catch (e) {
        console.error('Init', 'Prepare layout failed', e);
      }
      windowStage.loadContent('pages/Index', async (err) => {
        if (err.code) {
          hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
          return;
        }
        try {
          const uiContext = windowClass.getUIContext();
          _HOMLState.UIContext = uiContext;
          Xb_ToastUtil.initContext(uiContext, uiContext.getHostContext() as common.UIAbilityContext);
          // 初始化避让管理器
          this.initAvoidanceManager(windowClass, uiContext);
          // 使用 UIContext 精确校准断点和尺寸
          this.updateUIStateWithUIContext(uiContext);
          // 注册窗口大小变化监听
          this.registerWindowSizeChangeListener(windowStage, windowClass, uiContext);
        } catch (error) {
          console.error('WindowStage', 'Failed to initialize post-load components.', error);
        }
        hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
      });
    })();
  }

  onWindowStageWillDestroy(windowStage: window.WindowStage): void {
    if (this.avoidManager) {
      this.avoidManager.offChangeListener(this.avoidListener);
      this.avoidManager.destroy();
      this.avoidManager = undefined;
    }
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  async onWindowModeChange(windowStage: window.WindowStage, windowClass: window.Window) {
    try {
      windowClass.setWindowDecorVisible(false)
      windowClass.setWindowTitleButtonVisible(true, true, true)
      await windowClass.setTitleAndDockHoverShown(false, false)
      HOMLState.windowMode = true
      console.info("WindowMode", `当前为PC窗口模式 bottom: ${HOMLState.bottomRectHeight} mode: ${HOMLState.windowMode}`)
    } catch (exception) {
      console.error("WindowMode", `#onWindowModeChange error: ${JSON.stringify(exception)}`)
      HOMLState.windowMode = false
      console.info("WindowMode", `当前为普通窗口模式 bottom: ${HOMLState.bottomRectHeight} mode: ${HOMLState.windowMode}`)
    }
  }

  onWidthBpChange(uiContext: UIContext) {
    const widthBp: WidthBreakpoint = uiContext.getWindowWidthBreakpoint();
    HOMLState.widthBp = widthBp;
    console.info('WindowRect', `宽度断点：${widthBp}`);
  }

  onHeightBpChange(windowHeight: number, windowWidth: number) {
    let heightBp = 0;
    const windowAspectRatio = windowHeight / windowWidth;
    if (windowAspectRatio < BREAKPOINT_RATIO_LANDSCAPE) {
      heightBp = 0;
    } else if (windowAspectRatio >= BREAKPOINT_RATIO_LANDSCAPE && windowAspectRatio < BREAKPOINT_RATIO_PORTRAIT) {
      heightBp = 1;
    } else if (windowAspectRatio >= BREAKPOINT_RATIO_PORTRAIT) {
      heightBp = 2;
    }
    HOMLState.heightBp = heightBp;
    console.info('WindowRect', `高度断点：${heightBp} 高宽比：${windowAspectRatio}`);
  }

  private async prepareWindowLayout(windowStage: window.WindowStage, windowClass: window.Window) {
    try {
      await windowClass.setWindowLayoutFullScreen(true);
      console.info('WindowRect', 'Succeeded in setting the window layout to full-screen mode.');
    } catch (err) {
      console.error('WindowRect', 'Failed to set the window layout to full-screen mode.', err);
    }
    let density = 1;
    try {
      const displayInfo = display.getDefaultDisplaySync();
      density = displayInfo.densityPixels;
      console.info('Display', `density: density = ${density}`);
    } catch (e) {
      console.warn('Display', 'Failed to get display density');
    }

    try {
      const systemAvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      const cutoutAvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT);

      const topPx = Math.max(systemAvoidArea.topRect.height, cutoutAvoidArea.topRect.height);
      const bottomPx = Math.max(systemAvoidArea.bottomRect.height, cutoutAvoidArea.bottomRect.height);

      HOMLState.topRectHeight = topPx / density;
      HOMLState.bottomRectHeight = bottomPx / density;
      console.info('WindowRect', `手动避让初始化: Top=${HOMLState.topRectHeight}, Bottom=${HOMLState.bottomRectHeight}`);
    } catch (e) {
      console.error('WindowRect', 'Failed to get avoid area manually', e);
      HOMLState.topRectHeight = 0;
      HOMLState.bottomRectHeight = 0;
    }
    const properties = windowClass.getWindowProperties();
    const rect = properties.windowRect;
    _HOMLState.window = windowClass;
    _HOMLState.windowWidth_px = rect.width;
    _HOMLState.windowHeight_px = rect.height;
    // 计算初始尺寸 (vp)
    const windowWidth = rect.width / density;
    const windowHeight = rect.height / density;
    HOMLState.windowWidth = windowWidth;
    HOMLState.windowHeight = windowHeight;
    // 初始化高度断点
    this.onHeightBpChange(windowHeight, windowWidth);
    // 初始化窗口模式
    await this.onWindowModeChange(windowStage, windowClass);
  }

  private initAvoidanceManager(windowClass: window.Window, uiContext: UIContext) {
    try {
      this.avoidManager = new Xb_AvoidanceManager(windowClass, uiContext);
      this.avoidManager.init();
      this.avoidManager.onChangeListener(this.avoidListener);
      console.info('Avoidance', 'Manager initialized and listener registered.');
    } catch (e) {
      console.error('Avoidance', 'Failed to init manager', e);
    }
  }

  private updateUIStateWithUIContext(uiContext: UIContext) {
    try {
      // 校准宽度断点
      const widthBp: WidthBreakpoint = uiContext.getWindowWidthBreakpoint();
      HOMLState.widthBp = widthBp;
      // 校准尺寸
      if (_HOMLState.windowWidth_px && _HOMLState.windowHeight_px) {
        HOMLState.windowWidth = uiContext.px2vp(_HOMLState.windowWidth_px);
        HOMLState.windowHeight = uiContext.px2vp(_HOMLState.windowHeight_px);
        // 校准高度断点
        this.onHeightBpChange(HOMLState.windowHeight, HOMLState.windowWidth);
      }
      console.info('WindowRect', `UIContext校准后尺寸: ${HOMLState.windowWidth}x${HOMLState.windowHeight}`);
    } catch (e) {
      console.error('WindowRect', 'Failed to calibrate with UIContext', e);
    }
  }

  // 注册窗口大小变化监听
  private registerWindowSizeChangeListener(windowStage: window.WindowStage, windowClass: window.Window, uiContext: UIContext) {
    windowClass.on('windowSizeChange', async (data) => {
      // 监听窗口模式变化
      await this.onWindowModeChange(windowStage, windowClass);
      console.info('WindowChange', 'Window size changed. Data: ' + JSON.stringify(data));
      // 转换尺寸
      const newWidth = uiContext.px2vp(data.width);
      const newHeight = uiContext.px2vp(data.height);
      // 更新状态
      HOMLState.windowWidth = newWidth;
      HOMLState.windowHeight = newHeight;
      _HOMLState.windowWidth_px = data.width;
      _HOMLState.windowHeight_px = data.height;
      // 更新断点
      this.onWidthBpChange(uiContext);
      this.onHeightBpChange(newHeight, newWidth);
    });
  }


}
