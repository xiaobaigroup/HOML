import { Xb_ActionType, Xb_SettingsItem, Xb_SettingsItemData, ThemeType, EventHub,
  Xb_getPersistence,
  Xb_RadioGroupData,
  Xb_ThemeColorUtil} from "xb_components"
import { SettingsListView } from "../components/SettingsListView"
import { SegmentButtonV2Items, TabSegmentButtonV2 } from "@kit.ArkUI"
import { HOMLState, UISettings } from "../entryability/AppState"
import { EventKey } from "../common/EventKey"
import { GroupDataModel } from "../model/GroupDataModel"

@Builder
export function AppearanceBuilder(name: string, param: Object) {
  Appearance()
}

@ComponentV2
struct Appearance {

  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!
  @Local darkModeItems: SegmentButtonV2Items = new SegmentButtonV2Items([
    { text: '跟随系统', icon: getIconResource('system') },
    { text: '始终浅色', icon: getIconResource('light') },
    { text: '始终深色', icon: getIconResource('dark') },
  ]);

  build() {
    NavDestination() {
      SettingsListView({
        groups: this.appearanceSettingsGroups(),
        headerBuilder: () => {
          this.darkMode()
        }
      })
    }
    .title('启动器外观')
    .padding({ top: HOMLState.topRectHeight })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .onReady((ctx) => {
      HOMLState.currentSettingsPageName = ctx.pathInfo.name
    })
  }

  @Builder
  darkMode() {
    ListItemGroup({ header: this.title('深色模式'), space: 2 }) {
      ListItem() {
        TabSegmentButtonV2({
          items: this.darkModeItems,
          selectedIndex: this.UIstate.DarkMode!!,
          onItemClicked: (tab) => {
            EventHub.sendEvent(EventKey.SwitchDarkMode, tab)
          }
        })
      }
    }
    .margin({ left: 12, right: 12 })
  }

  @LocalBuilder
  title(title?: ResourceStr) {
    Text(title || "")
      .fontSize(16)
      .padding({ top: 6, left: 18 })
      .fontColor( $r("sys.color.font_secondary"))
  }

  appearanceSettingsGroups(): GroupDataModel[] {
    console.debug(`Theme appearanceSettingsGroups 当前主题色：${this.UIstate.ThemeColor}`)
    const themeColorRadioGroup: Xb_RadioGroupData = new Xb_RadioGroupData(this.UIstate.ThemeColor, 'theme_color')
    const backgroundRadioGroup: Xb_RadioGroupData = new Xb_RadioGroupData(this.UIstate.HomeBackground, 'background')
    return [
      {
        title: '主题色',
        items: [
          {
            label: '多彩',
            value: 'default',
            image: $r('app.media.theme_colorful_icon'),
            radioGroup: themeColorRadioGroup,
            content: '每个页面都有主题色',
            actionType: Xb_ActionType.RADIO,
            onChange: (v) => {
              const value = v as string
              this.UIstate.ThemeColor = value
              HOMLState.currentThemeColor = undefined
            }
          },
          {
            label: '星河蓝',
            value: 'blue',
            icon: $r('sys.symbol.circle_fill'),
            iconColor: $r('app.color.blue'),
            radioGroup: themeColorRadioGroup,
            content: '鸿蒙默认主题色',
            actionType: Xb_ActionType.RADIO,
            onChange: (v) => {
              const value = v as string
              this.changeThemeColor(value)
            }
          },
          {
            label: '开源绿',
            value: 'green',
            icon: $r('sys.symbol.circle_fill'),
            iconColor: $r('app.color.theme_color_main_green'),
            radioGroup: themeColorRadioGroup,
            content: '开源精神',
            actionType: Xb_ActionType.RADIO,
            onChange: (v) => {
              const value = v as string
              this.changeThemeColor(value)
            }
          },
          {
            label: '华为红',
            value: 'red',
            icon: $r('sys.symbol.circle_fill'),
            iconColor: $r('app.color.theme_color_main_red'),
            radioGroup: themeColorRadioGroup,
            content: '中华有为',
            actionType: Xb_ActionType.RADIO,
            onChange: (v) => {
              const value = v as string
              this.changeThemeColor(value)
            }
          },
          {
            label: '猫咪蓝',
            value: 'catBlue',
            icon: $r('sys.symbol.circle_fill'),
            iconColor: $r('app.color.theme_color_main_cat_blue'),
            radioGroup: themeColorRadioGroup,
            content: '喵，这里是一只可爱的小猫咪',
            actionType: Xb_ActionType.RADIO,
            onChange: (v) => {
              const value = v as string
              this.changeThemeColor(value)
            }
          },
          {
            label: '就酱紫',
            value: 'purple',
            content: '嗯嗯，就酱紫',
            icon: $r('sys.symbol.circle_fill'),
            iconColor: $r('app.color.theme_color_main_purple'),
            actionType: Xb_ActionType.RADIO,
            radioGroup: themeColorRadioGroup,
            onChange: (v) => {
              const value = v as string
              this.changeThemeColor(value)
            }
          },
          {
            label: '秋收黄',
            value: 'yellow',
            content: '丰收季节',
            icon: $r('sys.symbol.circle_fill'),
            iconColor: $r('app.color.theme_color_main_yellow'),
            actionType: Xb_ActionType.RADIO,
            radioGroup: themeColorRadioGroup,
            onChange: (v) => {
              const value = v as string
              this.changeThemeColor(value)
            }
          },
          {
            label: '哔哩粉',
            value: 'pink',
            icon: $r('sys.symbol.circle_fill'),
            iconColor: $r('app.color.theme_color_main_pink'),
            content: '你所热爱的，就是你的生活',
            actionType: Xb_ActionType.RADIO,
            radioGroup: themeColorRadioGroup,
            onChange: (v) => {
              const value = v as string
              this.changeThemeColor(value)
            }
          },
          {
            label: '科蓝',
            value: 'ke_blue',
            icon: $r('sys.symbol.circle_fill'),
            iconColor: $r('app.color.theme_color_main_ke_blue'),
            content: '说是科蓝',
            actionType: Xb_ActionType.RADIO,
            radioGroup: themeColorRadioGroup,
            onChange: (v) => {
              const value = v as string
              this.changeThemeColor(value)
            }
          },
        ]
      },
      {
        title: undefined, // 无标题组
        items: [
          {
            label: '随机主题色',
            value: this.UIstate.RandomTheme,
            content: '启动时随机选择一种主题色',
            iconColor: HOMLState.currentThemeColor,
            actionType: Xb_ActionType.TOGGLE,
            onChange: (v) => {
              this.UIstate.RandomTheme = v as boolean
              if (v) {
                // 随机主题色
                const randomName = Xb_ThemeColorUtil.getRandomThemeName()
                this.UIstate.ThemeColor = randomName.replace('AppTheme', '')
                HOMLState.currentThemeColor = Xb_ThemeColorUtil.getThemeColor(randomName)
              }
            }
          }
        ]
      },
      {
        title: '主页背景',
        items: [
          {
            label: '纯色',
            value: 'pure',
            radioGroup: backgroundRadioGroup,
            iconColor: HOMLState.currentThemeColor,
            content: '默认纯色背景',
            actionType: Xb_ActionType.RADIO,
            onChange: (v) => {
              this.changeBackground(v)
            }
          },
          {
            label: '图片',
            value: 'image',
            radioGroup: backgroundRadioGroup,
            iconColor: HOMLState.currentThemeColor,
            content: '自定义图片背景',
            actionType: Xb_ActionType.RADIO,
            onChange: (v) => {
              this.changeBackground(v)
            }
          }
        ]
      }
    ]
  }

  changeThemeColor(theme: string) {
    this.UIstate.ThemeColor = theme
    console.debug(`Theme changeThemeColor 当前主题色：${this.UIstate.ThemeColor}`)
    HOMLState.currentThemeColor = Xb_ThemeColorUtil.getThemeColor(`${theme}AppTheme`)
  }

  changeBackground(value: number | boolean | ResourceStr) {
    const bg = value as 'image' | 'pure'
    this.UIstate.HomeBackground = bg
    if (bg == 'image') {
      // 图片背景

    }
  }

}

/**
 * 获取图片资源引用
 * @param icon 图片名称
 * @returns Resource
 */
function getIconResource(icon: string): Resource {
  return $r(`app.media.color_mode_${icon}`)
}