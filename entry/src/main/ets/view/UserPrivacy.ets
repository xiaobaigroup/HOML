import { Xb_getPersistence, Xb_GetResourceString, Xb_PriUserComWeb } from "xb_components"
import { UISettings } from "../entryability/AppState"


@Builder
export function UserPageBuilder(name: string) {
  User()
}

@ComponentV2
export struct User {

  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!

  private pageStack: NavPathStack = new NavPathStack()

  build() {
    // 欢迎页
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
        } : undefined,
        onLeftCheck: undefined,
        priuserPageInfos: this.pageStack,
        currentLanguage: 'zh-CN',
        docSrc: $rawfile('html/user_agreement.html'),
      })
      Row() {
        Text('用户协议')
          .fontWeight(FontWeight.Regular)
      }
      .height(56)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('sys.color.background_secondary'))
    }
    .alignContent(Alignment.Top)
  }

}


@Builder
export function PrivacyPageBuilder(name: string) {
  Privacy()
}

@ComponentV2
struct Privacy {

  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!
  private pageStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Stack() {
        Xb_PriUserComWeb({
          isEnd: !this.UIstate.FirstStart,
          appName: Xb_GetResourceString($r('app.string.EntryAbility_label'), this),
          needAccount: true,
          needOpenSource: false,
          onLeftCheck: undefined,
          onRightCheck: this.UIstate.FirstStart ? () => {
            this.UIstate.FirstStart = false
          } : undefined,
          isWelcomeStack: this.UIstate.FirstStart,
          priuserPageInfos: this.pageStack,
          currentLanguage: 'zh-CN',
          docSrc: $rawfile('html/privacy.html'),
        })
        Row() {
          Text('隐私声明')
            .fontWeight(FontWeight.Regular)
        }
        .height(56)
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('sys.color.background_secondary'))
      }
      .alignContent(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .hideToolBar(true)
    .onReady((ctx) => {
      this.pageStack = ctx.pathStack
    })
  }

}