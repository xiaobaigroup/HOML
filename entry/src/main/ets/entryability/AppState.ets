import { window } from "@kit.ArkUI";
import { VersionModel } from "../common/model/VersionModel";

@ObservedV2
export class _HOMLState {

  // -- 界面 --
  @Trace mainCurrentTab: number = 0
  @Trace showUserInfo: boolean = false
  @Trace showVersions: boolean = false
  @Trace showBackgroundBlur: boolean = false
  @Trace pageStack: NavPathStack = new NavPathStack()

  // -- 窗口相关 --
  public static UIContext: UIContext
  public static window: window.Window;
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

}

export const HOMLState = new _HOMLState()