// getColorWithTransparency(this.getUIContext().getHostContext()!, $r('app.color.green'), 0.6)

/**
 * 获取带有透明度的颜色值
 * @param context Context上下文，用于解析Resource资源
 * @param color 原始颜色（支持 string, number, Color, Resource）
 * @param transparency 透明度 (0.0 ~ 1.0)，0为全透明，1为完全不透明
 * @returns 返回一个 number 类型的 ARGB 颜色值
 */
export function getColorWithTransparency(context: Context, color: Resource | number | string, transparency: number): number {
  // 限制透明度范围在 0.0 - 1.0 之间
  let opacity = transparency
  if (opacity < 0) opacity = 0
  if (opacity > 1) opacity = 1

  // 将百分比转换为 0-255 的整数
  const alpha = Math.round(opacity * 255)

  // 解析不同类型的颜色值为标准的 number (RGB)
  let colorValue: number = 0
  if (typeof color === 'number') {
    // 数字类型直接使用
    colorValue = color
  } else if (typeof color === 'string') {
    // 字符串类型解析 (支持 #RGB, #RRGGBB, #AARRGGBB)
    colorValue = parseColorString(color)
  } else {
    // Resource 类型通过 ResourceManager 解析
    try {
      colorValue = context.resourceManager.getColorSync(color)
    } catch (e) {
      console.error(`getColorWithTransparency: Invalid Resource`, e)
      return 0
    }
  }

  // 组合 ARGB
  // 先清除原有的 Alpha 通道 (取低 24 位)，再叠加新的 Alpha
  return (alpha << 24) | (colorValue & 0x00FFFFFF)
}

/**
 * 辅助函数：解析颜色字符串
 */
function parseColorString(colorStr: string): number {
  let hex = colorStr.replace('#', '')

  // 处理简写 #RGB -> #RRGGBB
  if (hex.length === 3) {
    hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2]
  }

  // 处理 #AARRGGBB (如果字符串自带透明度，通常我们希望去掉它，使用函数参数的透明度)
  if (hex.length === 8) {
    // 截取后6位作为RGB
    hex = hex.substring(2)
  }

  // 此时应该是 6 位 RRGGBB
  if (hex.length !== 6) {
    console.warn(`getColorWithTransparency: Unsupported color string format: ${colorStr}`)
    return 0
  }

  return parseInt(hex, 16)
}
