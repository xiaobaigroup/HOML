import { VersionListView } from "../components/VersionListView"
import { HOMLState } from "../entryability/AppState"
import { Versions } from "../view/Versions"


@ComponentV2
export struct Home {

  build() {
    RelativeContainer() {
      // 用户管理
      Row() {
        Text('用户空间')
      }.width(150)
      .height(69)
      .borderColor(Color.Black)
      .borderWidth(2)
      .id('user')
      .alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })

      // 启动
      Row({ space: 10 }) {
        // 版本信息半模态窗口
        Button({ type: ButtonType.Normal }) {
          SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
            .fontSize(29)
        }
        .width(56)
        .height(56)
        .borderRadius(12)
        .backgroundColor($r('sys.color.button_background_color_transparent'))
        .onClick(() => {
          HOMLState.showVersions = true
          console.log(`showVersions：${HOMLState.showVersions}`)
        })
        // 启动
        Button({ type: ButtonType.Normal }) {
          Column({ space: 5 }) {
            Text('启动 Minecraft')
              .fontSize(18)
              .fontColor($r('sys.color.font_on_primary'))
            // 版本
            Text('1.21.1')
              .fontSize(15)
              .fontColor($r('sys.color.font_on_primary'))
          }
        }
        .width(232)
        .height(56)
        .borderRadius(12)
        .margin({ right: 12 })
        .backgroundColor($r('app.color.green'))
        .bindContextMenu(this.MenuBuilder, ResponseType.LongPress, {
          placement: Placement.Top,
        })
      }
      .height(69)
      .id('edit_start')
      .alignRules({
        right: { anchor: '__container__', align: HorizontalAlign.End },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })

    }
    .width('100%')
    .height('100%')
    .padding({ left: 12,  top: HOMLState.topRectHeight, bottom: HOMLState.bottomRectHeight})
    .bindSheet(HOMLState.showVersions!!, this.VersionsBuilder(), {
      detents: [HOMLState.windowHeight - HOMLState.topRectHeight - 56],
      keyboardAvoidMode: SheetKeyboardAvoidMode.RESIZE_ONLY,
      scrollSizeMode: ScrollSizeMode.CONTINUOUS,
      backgroundColor: Color.Transparent,
      preferType: SheetType.BOTTOM,
      blurStyle: BlurStyle.Thin,
      onWillAppear: () => {
        HOMLState.showBackgroundBlur = true
      },
      onWillDisappear: () => {
        HOMLState.showBackgroundBlur = false
      },
      onDisappear: async () => {
      },
      onWillSpringBackWhenDismiss: () => {} // 注册回调，防止反向回弹
    })
  }

  aboutToAppear(): void {
    HOMLState.versions.push({
      id: 0,
      name: '1.21.11-Fabric 0.18.4',
      version_code: '1.21.11',
      mod: 'fabric',
      mod_version: '0.18.4',
      global: true,
      isolation: false,
      ignore_java_comp: false,
      file_verification: true
    },
      {
        id: 1,
        name: 'Hy',
        version_code: '1.21.11',
        mod: 'normal',
        mod_version: '',
        global: true,
        isolation: true,
        ignore_java_comp: true,
        file_verification: false
      })
  }

  @Builder
  VersionsBuilder() {
    Versions()
  }

  @Builder MenuBuilder() {
    Column() {
      VersionListView({
        items: HOMLState.versions,
        smallType: true,
        itemBackgroundColor: $r('app.color.green'),
        onItemClick: (data) => {

        }
      })
    }
    .width(217)
    .padding(6)
  }

}