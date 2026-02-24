import { StartButtonWidth } from "../common/constants/Constants"
import { VersionListView } from "../components/VersionListView"
import { HOMLState, UISettings } from "../entryability/AppState"
import { Versions } from "../view/Versions"
import { LengthMetrics, PersistenceV2 } from "@kit.ArkUI"
import { Xb_CapsuleButton, Xb_getAppStore, Xb_getPersistence } from "xb_components"
import { HomlViewModel } from "../core/HomlViewModel"

PersistenceV2.notifyOnError((key, reason, msg) => {
  console.error(`Error key: ${key}, reason: ${reason}, message: ${msg}`);
});

@ComponentV2
export struct Home {

  @Local viewmodel: HomlViewModel = Xb_getAppStore(HomlViewModel)!
  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!

  build() {
    RelativeContainer() {
      // 用户管理
      Column({ space: 10 }) {
        if (HOMLState.showUserInfo) {
          this.avatarAndName()
          this.UserInfoConfig()
        } else {
          Text('早上好，')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
          this.avatarAndName()
        }
      }
      .borderRadius(16)
      .alignItems(HorizontalAlign.Start)
      .padding(HOMLState.showUserInfo ? 9 : 0)
      .constraintSize({ maxWidth: 210, maxHeight: 112 })
      .margin({ bottom: HOMLState.widthBp < 2 ? 76 : 10 })
      .backgroundColor(HOMLState.showUserInfo ? $r('sys.color.background_primary') : undefined)
      .shadow(HOMLState.showUserInfo ? { radius: 32, color: $r('sys.color.ohos_id_blur_style_background_thin_color') } : undefined)
      .id('user')
      .alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })
      .onClick(() => {
        HOMLState.showUserInfo = !HOMLState.showUserInfo
      })
      .onHover((isHover) => {
        HOMLState.showUserInfo = isHover
      })

      // 版本管理区
      Row({ space: 10 }) {
        // 版本信息半模态窗口
        Button({ type: ButtonType.Normal }) {
          SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
            .fontColor([$r('sys.color.font_primary')])
            .fontSize(29)
        }
        .width(56)
        .height(56)
        .borderRadius(12)
        .backgroundColor($r("app.color.settings_switch_button_floor"))
        .onClick(() => {
          HOMLState.showVersions = true
          console.log(`showVersions：${HOMLState.showVersions}`)
        })
        // 启动游戏
        Button({ type: ButtonType.Normal }) {
          Column({ space: 5 }) {
            Text('启动 Minecraft')
              .fontSize(18)
              .fontColor($r('sys.color.font_on_primary'))
            // 版本
            Text(this.viewmodel.current?.id ?? '未选择')
              .fontSize(15)
              .fontColor($r('sys.color.font_on_primary'))
          }
        }
        .width(StartButtonWidth)
        .height(56)
        .borderRadius(12)
        .margin({ right: 12 })
        .backgroundColor(HOMLState.currentThemeColor || $r('app.color.green'))
        .bindContextMenu(this.MenuBuilder, ResponseType.LongPress, {
          placement: Placement.Top,
        })
        .onClick(() => {
          if (!this.viewmodel.current) {
            HOMLState.showVersions = true
          } else {
            this.viewmodel.toGame()
          }
        })
      }
      .height(72)
      .id('edit_start')
      .alignRules({
        right: { anchor: '__container__', align: HorizontalAlign.End },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })

    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.UIstate.HomeBackground == 'image' ? Color.Transparent : $r('sys.color.background_secondary'))
    .padding({ left: 12,  top: HOMLState.topRectHeight, bottom: HOMLState.bottomRectHeight})
    .bindSheet(HOMLState.showVersions!!, this.VersionsBuilder(), {
      detents: [HOMLState.windowHeight - HOMLState.topRectHeight - 56],
      keyboardAvoidMode: SheetKeyboardAvoidMode.RESIZE_ONLY,
      scrollSizeMode: ScrollSizeMode.CONTINUOUS,
      backgroundColor: Color.Transparent,
      preferType: SheetType.BOTTOM,
      blurStyle: BlurStyle.Thin,
      width: '100%',
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
  }

  @Builder
  VersionsBuilder() {
    Versions()
  }

  @Builder
  avatarAndName() {
    Flex({ direction: FlexDirection.Row, space: { main: LengthMetrics.vp(10) }, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      Image($r('app.media.default_avatar'))
        .width(40)
        .height(40)
      Text('默认用户')
        .fontSize(21)
        .fontWeight(FontWeight.Bold)
    }
  }

  @Builder
  UserInfoConfig() {
    List({space: 3}) {
      ForEach(this.getUserFunBar, (item: UserInfoFunctionModel, index) => {
        ListItem() {
          Xb_CapsuleButton({
            icon: item.icon,
            image: item.image,
            text: item.title,
            iconColor: HOMLState.currentThemeColor || $r('app.color.blue'),
            theBackgroundColor: $r('sys.color.button_background_color_transparent'),
            onCheck: () => {
              item.onAction()
            },
          })
        }
      })
    }
    .height(30)
    .scrollBar(BarState.Off)
    .listDirection(Axis.Horizontal)
    .alignListItem(ListItemAlign.Center)
  }

  @Builder MenuBuilder() {
    Column() {
      VersionListView({
        items: this.viewmodel.versions,
        smallType: true,
        itemBackgroundColor: $r('app.color.green'),
        onItemClick: (data) => {
        }
      })
    }
    .width(StartButtonWidth - 20)
    .padding(6)
  }

  get getUserFunBar(): UserInfoFunctionModel[] {
    return [
      {
        icon: $r('sys.symbol.clothing_fill'),
        title: '更衣间',
        onAction: async () => {

        }
      },
      {
        icon: $r('sys.symbol.arrow_2_circlepath'),
        title: '换账号',
        onAction: async () => {

        }
      },
      {
        image: $r('app.media.microsoft'),
        title: '微软',
        onAction: async () => {
          this.viewmodel.toLogin()
        }
      }
    ]
  }

}


interface UserInfoFunctionModel {
  icon?: Resource
  image?: Resource
  title: ResourceStr
  onAction: () => void
}