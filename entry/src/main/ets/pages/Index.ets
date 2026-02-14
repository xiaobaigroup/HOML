import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import { Xb_SwitchButton } from 'xb_components';
import { Xb_TopTitleBar } from 'xb_components/src/main/ets/components/Xb_TopTitleBar';
import { MainTabButtonWidth } from '../common/BreakPoint';
import { HOMLState } from '../entryability/AppState';
import { Home } from './Home';
import { Settings } from './Settings';


@Entry
@ComponentV2
struct Index {

  build() {
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
          .alignRules({
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            top: { anchor: '__container__', align: VerticalAlign.Top }
          })

        Row() {
          Xb_SwitchButton({
            switchOne: HOMLState.mainCurrentTab,
            items: [
              { text: '主页', symbol: $r('sys.symbol.house_fill') },
              { text: '设置', symbol: $r('sys.symbol.gearshape_fill') },
            ],
            onClickUse: (index) => {
              HOMLState.mainCurrentTab = index
            }
          })
        }
        .width(MainTabButtonWidth(HOMLState.widthBp))
        .id('main_tab_button')
        .alignRules({
          middle: { anchor: "__container__", align: HorizontalAlign.Center },
          top: { anchor: "__container__", align: VerticalAlign.Top }
        })
        // 自定义窗口控制区
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
      .height(56)
      .margin({ left: 12, top: HOMLState.topRectHeight })
    }
    .height('100%')
    .align(Alignment.Top)
    .foregroundBlurStyle(HOMLState.showBackgroundBlur ? BlurStyle.Thin : BlurStyle.NONE,
      { colorMode: ThemeColorMode.SYSTEM, adaptiveColor: AdaptiveColor.DEFAULT, scale: 0.3 })
  }

}
