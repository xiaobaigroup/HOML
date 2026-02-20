import { window } from "@kit.ArkUI";
import { common } from "@kit.AbilityKit";
import { fileUri } from "@kit.CoreFileKit";

@ObservedV2
export class _HOMLState {

  // -- 界面 --
  @Trace mainCurrentTab: number = 0
  @Trace showUserInfo: boolean = false
  @Trace showVersions: boolean = false
  @Trace showBackgroundBlur: boolean = false
  @Trace canClearMainPageInfo: boolean = true
  @Trace mainBackgroundImage: string = ''
  @Trace currentThemeColor?: ResourceColor = undefined
  @Trace pageStack: NavPathStack = new NavPathStack()
  @Trace currentSettingsPageName: string = 'global_game_options'

  // -- 窗口相关 --
  public static UIContext: UIContext
  public static window: window.Window;
  public static context: common.UIAbilityContext
  /** @description 窗口高度 -vp */
  @Trace windowHeight: number = 0
  /** @description 窗口宽度 -vp */
  @Trace windowWidth: number = 0
  /** @description 窗口高度 -px */
  public static windowWidth_px: number;
  /** @description 窗口高度 -px */
  public static windowHeight_px: number;
  /** @description 状态栏高度 -px */
  public static topAvoidAreaHeight_px: number;
  /** @description 导航栏高度 -px */
  public static navigationIndicatorHeight_px: number;
  /** @description 导航栏高度 */
  @Trace bottomRectHeight: number = 0
  /** @description 状态栏高度 */
  @Trace topRectHeight: number = 0
  /** @description 左侧避让宽度 */
  @Trace leftAvoidWidth: number = 0
  /** @description 右侧避让宽度 */
  @Trace rightAvoidWidth: number = 0
  /** @description 当前宽度断点 */
  @Trace widthBp: number = 0
  /** @description 当前宽度断点 */
  @Trace heightBp: number = 0
  /** @description 窗口模式 true为PC窗口模式 false为普通窗口模式 */
  @Trace windowMode: boolean = false

  @Monitor('widthBp')
  getBackgroundImage() {
    const filePath = _HOMLState.context.filesDir +
      ((HOMLState.windowWidth < HOMLState.windowHeight) ? '/background_portrait.jpg' : '/background_landscape.jpg');
    console.debug(`getBackgroundImage 切换背景图 ${filePath}`)
    this.mainBackgroundImage = fileUri.getUriFromPath(filePath)
  }

}

@ObservedV2
export class UISettings {
  // 深色模式
  @Trace DarkMode: ThemeColorMode = ThemeColorMode.SYSTEM
  // 主题色
  @Trace ThemeColor: string = 'default'
  // 随机主题色
  @Trace RandomTheme: boolean = false
  // 主页背景
  @Trace HomeBackground: 'image' | 'pure' = 'pure'
  // 首次打开应用
  @Trace FirstStart: boolean = true
}


export const HOMLState = new _HOMLState()