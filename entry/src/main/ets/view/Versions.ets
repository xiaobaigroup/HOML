import { Xb_ActionType,
  Xb_CircleButton,
  Xb_FileUtils,
  Xb_getAppStore, Xb_getPersistence, Xb_SettingsItem, Xb_SettingsItemData,
  Xb_ToastUtil } from "xb_components"
import { getColorWithTransparency } from "../common/util/ColorWithTransparency"
import { VersionListView } from "../components/VersionListView"
import { HomlViewModel } from "../core/HomlViewModel"
import { HOMLState, UISettings, _HOMLState } from "../entryability/AppState"
import { HomeDirectoryType } from "../model/GameProfile"


@ComponentV2
export struct Versions {
  @Local viewmodel: HomlViewModel = Xb_getAppStore(HomlViewModel)!
  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!
  @Local showFolderSelect: boolean = false
  private pageStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.pageStack) {
      Stack() {
        Column({ space: 10 }) {
          // 标题
          Row({ space: 10 }) {
            SymbolGlyph($r(`sys.symbol.${this.showFolderSelect ? 'arrowtriangle_up_fill' : 'arrowtriangle_down_fill'}`))
              .fontSize(14)
            Column({ space: 2 }) {
              Text('默认文件夹')
                .fontWeight(FontWeight.Bold)
                .fontSize(20)
              Text(this.viewmodel.homeDir)
                .fontSize(16)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .margin({ top: 12 })
          .padding({ left: 16, right: 12 })
          .justifyContent(FlexAlign.Start)
          .bindContextMenu(this.showFolderSelect!!, this.FolderSelect(), {
            placement: Placement.Bottom,
            backgroundColor: Color.Transparent,
            backgroundBlurStyle: BlurStyle.Thin
          })
          .onClick(() => {
            this.showFolderSelect = !this.showFolderSelect
          })
          // 搜索框
          Search({
            placeholder: '搜索版本...'
          })
            .margin({ left: 12 + HOMLState.leftAvoidWidth, right: 12 })
            .onSubmit((data) => {
                this.viewmodel.searchVersion = data
            })
          // 版本列表
          VersionListView({
            items: this.viewmodel.filterVersion(this.viewmodel.versions, this.viewmodel.searchVersion),
            contentEndOffset: 100 + HOMLState.bottomRectHeight,
            itemBackgroundColor: HOMLState.currentThemeColor || $r('app.color.blue'),
            onItemClick: (data) => {
              if (HOMLState.widthBp < 2) {
                this.pageStack.pushPathByName('version_detail', data, true)
              } else {
                this.pageStack.replacePathByName('version_detail', data, true)
              }
            }
          })
            .padding({ left: 12 + HOMLState.leftAvoidWidth, right: 12 })
        }
        .width('100%')
        .height('100%')
        // 工具
        Row({ space: 5 }) {
          Xb_CircleButton({
            icon: $r('sys.symbol.text_and_arrow_down'),
            iconBackgroundColor: Color.Transparent,
            iconColor: $r('sys.color.font_primary'),
            theBackgroundColor: Color.Transparent,
            onCheck: () => {
              Xb_ToastUtil.showToast({ message: '开发中' })
            }
          })
          Xb_CircleButton({
            icon: $r('sys.symbol.plus_circle'),
            iconBackgroundColor: Color.Transparent,
            iconColor: $r('sys.color.font_primary'),
            theBackgroundColor: Color.Transparent,
            onCheck: async () => {
              await this.viewmodel.loadZip()
            }
          })
        }
        .height(48)
        .borderRadius(25)
        .margin({ bottom: HOMLState.bottomRectHeight })
        .backgroundColor($r('sys.color.ohos_id_color_hover'))

        if (this.viewmodel.zipLoading) {
          Column() {
            LoadingProgress()
              .width(69)
          }.width('100%').height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundBlurStyle(BlurStyle.Thin,
            { colorMode: ThemeColorMode.SYSTEM, adaptiveColor: AdaptiveColor.DEFAULT, scale: 0.3 })
        }

      }
      .width('100%')
      .height('100%')
      .alignContent(Alignment.Bottom)
    }
    .width('100%')
    .navBarWidth(330)
    .hideToolBar(true)
    .hideTitleBar(true)
    .hideBackButton(true)
  }

  @Builder
  FolderSelect() {
    List() {
      ForEach(this.getFolders(), (item: Xb_SettingsItemData) => {
        ListItem() {
          Xb_SettingsItem({
            item: item,
            themeType: this.UIstate.DarkMode as number,
          })
        }
        .borderRadius(8)
        .padding({ top: 6, bottom: 6})
        .backgroundColor(this.viewmodel.gameProfile.homeType == item.value ? getColorWithTransparency(_HOMLState.context, HOMLState.currentThemeColor || $r('app.color.blue'), 0.2) : undefined)
      })
      ListItem() {
        Xb_SettingsItem({
          item: {
            label: '管理游戏目录',
            icon: $r('sys.symbol.folder_badge_ellipsis'),
            actionType: Xb_ActionType.JUMP,
            onChange: () => {
              this.showFolderSelect = false
              HOMLState.showVersions = false
              HOMLState.mainCurrentTab = 1
              HOMLState.needPush = true
            }
          },
          themeType: this.UIstate.DarkMode as number,
        })
      }
      .padding({ top: 6, bottom: 6})
    }
    .padding(7)
  }

  getFolders(): Xb_SettingsItemData[] {
    return [
      {
        label: '沙箱目录',
        content: this.viewmodel.gameProfile.homeType == HomeDirectoryType.Sandbox ? this.viewmodel.homeDir : "", // 沙箱目录地址
        value: HomeDirectoryType.Sandbox,
        actionType: Xb_ActionType.TEXT,
        onChange: (v) => {
          this.changeGameFolder(v)
        }
      },
      {
        label: '下载目录',
        content: this.viewmodel.gameProfile.homeType == HomeDirectoryType.Download ? this.viewmodel.homeDir : "", // 下载目录地址
        value: HomeDirectoryType.Download,
        actionType: Xb_ActionType.TEXT,
        onChange: (v) => {
          this.changeGameFolder(v)
        }
      },
      {
        label: '自定义目录(仅PC)',
        content: this.viewmodel.gameProfile.customHomeDir, // 自定义目录地址
        value: HomeDirectoryType.Custom,
        actionType: Xb_ActionType.TEXT,
        onChange: async (v) => {
          const old = this.viewmodel.gameProfile.homeType
          this.changeGameFolder(v)
          if (this.viewmodel.gameProfile.customHomeDir && this.viewmodel.gameProfile.customHomeDir != "") return
          const dir = await Xb_FileUtils.selectDir()
          if (dir) {
            this.viewmodel.gameProfile.customHomeDir = dir
            Xb_FileUtils.persistPermissionDir(dir)
            this.viewmodel.changeHome()
          }
          if(!this.viewmodel.gameProfile.customHomeDir ||  this.viewmodel.gameProfile.customHomeDir == ""){
            this.viewmodel.gameProfile.homeType = old
          }

        }
      }
    ]
  }

  async changeGameFolder(v: number | boolean | ResourceStr) {
    const value = v as HomeDirectoryType
    this.viewmodel.gameProfile.homeType = value
    await this.viewmodel.changeHome()
  }

}
