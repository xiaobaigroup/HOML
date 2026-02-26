import { Xb_getPersistence, Xb_GetResourceString, Xb_PriUserComWeb } from "xb_components"
import { HOMLState, UISettings } from "../entryability/AppState"


@Builder
export function UserPageBuilder(name: string) {
  UserNavb()
}

@ComponentV2
struct UserNavb {

  @Local needTopMargin: boolean = false
  @Local pageStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      User({
        needTopMargin: this.needTopMargin,
        normalPageStack: this.pageStack
      })
    }
    .hideBackButton(true)
    .hideTitleBar(true)
    .onReady((ctx) => {
      this.pageStack = ctx.pathStack
      const param = ctx.pathInfo.param as boolean
      if (param) {
        this.needTopMargin = param
      }
    })
  }

}

@ComponentV2
export struct User {

  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!
  @Param normalPageStack: NavPathStack = new NavPathStack()
  @Param needTopMargin: boolean = false

  private pageStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.pageStack) {
      this.Content()
    }
    .width('100%')
    .height('100%')
    .hideToolBar(true)
    .mode(NavigationMode.Stack)
  }

  @Builder
  Content() {
    Stack() {
      Xb_PriUserComWeb({
        appName: Xb_GetResourceString($r('app.string.EntryAbility_label'), this),
        needAccount: true,
        needOpenSource: false,
        isWelcomeStack: this.UIstate.FirstStart,
        nextPage: 'privacy',
        onRightCheck: this.UIstate.FirstStart ? () => {
          this.pageStack.pushPathByName('privacy', false, true)
        } : () => {
          this.normalPageStack.pushPathByName('privacy', this.needTopMargin, true)
        },
        onLeftCheck: this.UIstate.FirstStart ? undefined : () => {
          this.normalPageStack.pop(true)
        },
        priuserPageInfos: this.pageStack,
        currentLanguage: 'zh-CN',
        docSrc: $rawfile('html/user_agreement.html'),
      })
      Row() {
        Text('用户协议')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
      }
      .height(27 +HOMLState.topRectHeight)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('sys.color.background_secondary'))
      .padding({ top: this.needTopMargin ? HOMLState.topRectHeight : undefined })
    }
    .alignContent(Alignment.Top)
    .backgroundColor($r('sys.color.background_secondary'))
  }

}


@Builder
export function PrivacyPageBuilder(name: string) {
  Privacy()
}

@ComponentV2
struct Privacy {

  @Local needTopMargin: boolean = false
  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!
  private pageStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Xb_PriUserComWeb({
        isEnd: !this.UIstate.FirstStart,
        appName: Xb_GetResourceString($r('app.string.EntryAbility_label'), this),
        needAccount: true,
        needOpenSource: false,
        onLeftCheck: undefined,
        onRightCheck: this.UIstate.FirstStart ? () => {
          this.pageStack.pushPathByName('welcome', false, true)
        } : () => {
          this.pageStack.clear()
        },
        isWelcomeStack: this.UIstate.FirstStart,
        priuserPageInfos: this.pageStack,
        currentLanguage: 'zh-CN',
        docSrc: $rawfile('html/privacy.html'),
      })
    }
    .title('隐私声明')
    .width('100%')
    .height('100%')
    .padding({ top: this.needTopMargin ? 21 : 0 })
    .onReady((ctx) => {
      this.pageStack = ctx.pathStack
      const param = ctx.pathInfo.param as boolean
      if (param) {
        this.needTopMargin = param
      }
    })
  }

}

@Builder
export function WelcomePageBuilder(name: string) {
  Welcome()
}

@ComponentV2
struct Welcome {

  @Local UIstate: UISettings = Xb_getPersistence(UISettings, () => new UISettings())!
  private pageStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Column() {
        Image($r('app.media.startIcon'))
          .width(79)
          .height(79)
          .margin({ bottom: 36 })
        Text('欢迎来到 Homo Launcher')
          .fontSize(18)
        Text('为了更好的使用体验，请前往目录管理设置目录类型')
          .fontSize(18)
        Blank()
        Row({ space: 12 }) {
          Button('稍后')
            .width('48%')
            .backgroundColor(HOMLState.currentThemeColor)
            .onClick(() => {
              this.UIstate.FirstStart = false
            })
          Button('立即前往')
            .width('48%')
            .backgroundColor(HOMLState.currentThemeColor)
            .onClick(() => {
              this.UIstate.FirstStart = false
              HOMLState.mainCurrentTab = 1
              HOMLState.needPush = true
            })
        }
        .width('90%')
        .padding({ top: 12, bottom: 20 })
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .title('欢迎')
    .width('100%')
    .height('100%')
    .onReady((ctx) => {
      this.pageStack = ctx.pathStack
    })
  }

}