
import { VersionListView } from "../components/VersionListView"
import { HOMLState } from "../entryability/AppState"


@ComponentV2
export struct Versions {

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
          items: HOMLState.versions,
          itemBackgroundColor: $r('app.color.blue'),
          onItemClick: (data) => {
            this.pageStack.replacePathByName('version_detail', data, true)
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
