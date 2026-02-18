import { Xb_BreakpointFunction, Xb_BreakpointFunction2D } from "xb_components"

/** 主分段按钮宽度 */
export const MainTabButtonWidth = Xb_BreakpointFunction2D<Length>({
  ['sm']: {['hsm']: '86%', ['hmd']: '86%', ['hlg']: '86%' },
  ['md']: {['hsm']: '46%', ['hmd']: '69%', ['hlg']: '69%' },
  ['lg']: {['hsm']: '18.6%', ['hmd']: '18.6%', ['hlg']: '18.6%' },
  ['xl']: {['hsm']: '18.6%', ['hmd']: '18.6%', ['hlg']: '18.6%' },
})

/** 主分段按钮外边距 */
export const MainTabButtonMargin = Xb_BreakpointFunction2D<Padding>({
  ['sm']: {['hsm']: { top: 45 }, ['hmd']: { top: 45 }, ['hlg']: { top: 45 } },
  ['md']: {['hsm']: { top: 10 }, ['hmd']: { top: 56 }, ['hlg']: { top: 56 } },
  ['lg']: {['hsm']: { top: 0 }, ['hmd']: { top: 0 }, ['hlg']: { top: 0 } },
  ['xl']: {['hsm']: { top: 0 }, ['hmd']: { top: 0 }, ['hlg']: { top: 0 } },
})
/** 主分段按钮外边距(窗口) */
export const WindowMainTabButtonMargin = Xb_BreakpointFunction2D<Padding>({
  ['sm']: {['hsm']: { top: 50 }, ['hmd']: { top: 50 }, ['hlg']: { top: 50 } },
  ['md']: {['hsm']: { top: 10 }, ['hmd']: { top: 50 }, ['hlg']: { top: 50 } },
  ['lg']: {['hsm']: { top: 10 }, ['hmd']: { top: 10 }, ['hlg']: { top: 10 } },
  ['xl']: {['hsm']: { top: 10 }, ['hmd']: { top: 10 }, ['hlg']: { top: 10 } },
})

/** LogoText外边距 */
export const LogoTextMargin = Xb_BreakpointFunction2D<Padding>({
  ['sm']: {['hsm']: { top: 0 }, ['hmd']: { top: 0 }, ['hlg']: { top: 0 } },
  ['md']: {['hsm']: { top: 10 }, ['hmd']: { top: 0 }, ['hlg']: { top: 0 } },
  ['lg']: {['hsm']: { top: 0 }, ['hmd']: { top: 0 }, ['hlg']: { top: 0 } },
  ['xl']: {['hsm']: { top: 0 }, ['hmd']: { top: 0 }, ['hlg']: { top: 0 } },
})
/** LogoText外边距(窗口) */
export const WindowLogoTextMargin = Xb_BreakpointFunction2D<Padding>({
  ['sm']: {['hsm']: { top: 5 }, ['hmd']: { top: 5 }, ['hlg']: { top: 5 } },
  ['md']: {['hsm']: { top: 15 }, ['hmd']: { top: 5 }, ['hlg']: { top: 5 } },
  ['lg']: {['hsm']: { top: 5 }, ['hmd']: { top: 10 }, ['hlg']: { top: 10 } },
  ['xl']: {['hsm']: { top: 5 }, ['hmd']: { top: 10 }, ['hlg']: { top: 10 } },
})

/** 设置页顶部空白高度 */
export const SettingsTopBlankHeight = Xb_BreakpointFunction2D<Length>({
  ['sm']: {['hsm']: 0, ['hmd']: 0, ['hlg']: 0 },
  ['md']: {['hsm']: 0, ['hmd']: 115, ['hlg']: 115 },
  ['lg']: {['hsm']: 0, ['hmd']: 0, ['hlg']: 0 },
  ['xl']: {['hsm']: 0, ['hmd']: 0, ['hlg']: 0 },
})

/** 设置页顶部空白高度 */
export const SettingsListStartOffset = Xb_BreakpointFunction2D<number>({
  ['sm']: {['hsm']: 121, ['hmd']: 121, ['hlg']: 121 },
  ['md']: {['hsm']: 59, ['hmd']: 9, ['hlg']: 9 },
  ['lg']: {['hsm']: 79, ['hmd']: 79, ['hlg']: 79 },
  ['xl']: {['hsm']: 79, ['hmd']: 79, ['hlg']: 79 },
})