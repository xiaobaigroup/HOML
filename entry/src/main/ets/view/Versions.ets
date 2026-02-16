import { Xb_getAppStore } from "xb_components"
import { VersionListView } from "../components/VersionListView"
import { HomlViewModel } from "../core/HomlViewModel"
import { HOMLState } from "../entryability/AppState"


@ComponentV2
export struct Versions {
  @Local viewmodel: HomlViewModel = Xb_getAppStore(HomlViewModel)!
  private pageStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.pageStack) {
      Column({ space: 10 }) {
        // 标题
        Row({ space: 10 }) {
          SymbolGlyph($r('sys.symbol.arrowtriangle_down_fill'))
            .fontSize(14)
          Column({ space: 2 }) {
            Text('默认文件夹')
              .fontWeight(FontWeight.Bold)
              .fontSize(20)
            Text('/User')
              .fontSize(16)
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .margin({ top: 12 })
        .padding({ left: 16, right: 12 })
        .justifyContent(FlexAlign.Start)
        // 搜索框
        Search({
          placeholder: '搜索版本...'
        })
          .margin({ left: 12, right: 12 })
          .onSubmit((data) => {

          })
        // 版本列表
        VersionListView({
          items: this.viewmodel.versions,
          contentEndOffset: 100 + HOMLState.bottomRectHeight,
          itemBackgroundColor: $r('app.color.blue'),
          onItemClick: (data) => {
            if (HOMLState.widthBp < 2) {
              this.pageStack.pushPathByName('version_detail', data, true)
            } else {
              this.pageStack.replacePathByName('version_detail', data, true)
            }
          }
        })
          .padding({ left: 12, right: 12 })
      }
      .width('100%')
      .height('100%')

    }
    .navBarWidth(330)
    .hideToolBar(true)
    .hideTitleBar(true)
    .hideBackButton(true)
  }

}
