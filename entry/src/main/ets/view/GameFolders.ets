import { Xb_ActionType, Xb_FileUtils,
  Xb_getAppStore,
  Xb_getPersistence, Xb_GlobalContext, Xb_RadioGroupData} from "xb_components"
import { GroupDataModel } from "../model/GroupDataModel"
import { SettingsListView } from "../components/SettingsListView"
import { HOMLState, UISettings, _HOMLState } from "../entryability/AppState"
import { HomlViewModel } from "../core/HomlViewModel"
import { HomeDirectoryType } from "../model/GameProfile"
import { picker } from "@kit.CoreFileKit"

@Builder
export function GameFoldersBuilder(name: string, param: Object) {
  GameFolders()
}

@ComponentV2
struct GameFolders {

  @Local UIstate: UISettings = Xb_getPersistence(UISettings)!
  @Local viewModel: HomlViewModel = Xb_getAppStore(HomlViewModel)!

  build() {
    NavDestination() {
      SettingsListView({
        groups: this.getFoldersManager(),
      })
    }
    .title('游戏目录管理')
    .padding({ top: HOMLState.topRectHeight })
    .backgroundColor(this.UIstate.HomeBackground == 'image' && HOMLState.widthBp > 1 ? Color.Transparent : $r('sys.color.ohos_id_color_sub_background'))
    .onReady((ctx) => {
      HOMLState.currentSettingsPageName = ctx.pathInfo.name
    })
  }

  getFoldersManager(): GroupDataModel[] {
    const folderRadioGroup: Xb_RadioGroupData = new Xb_RadioGroupData(this.viewModel.gameProfile.homeType.toString(), 'folder')
    return [
      {
        title: '游戏目录',
        items: [
          {
            label: '沙箱目录',
            value: HomeDirectoryType.Sandbox,
            radioGroup: folderRadioGroup,
            iconColor: HOMLState.currentThemeColor,
            content: this.viewModel.gameProfile.homeType == HomeDirectoryType.Sandbox ? this.viewModel.homeDir : "",
            actionType: Xb_ActionType.RADIO,
            onChange: (v) => {
              this.changeGameFolder(v)
            }
          },
          {
            label: '下载目录',
            value: HomeDirectoryType.Download,
            radioGroup: folderRadioGroup,
            iconColor: HOMLState.currentThemeColor,
            content: this.viewModel.gameProfile.homeType == HomeDirectoryType.Download ? this.viewModel.homeDir : "",
            actionType: Xb_ActionType.RADIO,
            onChange: (v) => {
              this.changeGameFolder(v)
            }
          },
          {
            label: '自定义目录',
            value: HomeDirectoryType.Custom,
            radioGroup: folderRadioGroup,
            iconColor: HOMLState.currentThemeColor,
            content: this.viewModel.gameProfile.customHomeDir,
            actionType: Xb_ActionType.RADIO,
            onChange: (v) => {
              this.changeGameFolder(v)
            }
          }
        ]
      },
      ...(this.viewModel.gameProfile.homeType == HomeDirectoryType.Custom ? [{
        title: undefined, // 无标题组
        items: [
          {
            label: '选择目录',
            iconColor: HOMLState.currentThemeColor,
            actionType: Xb_ActionType.JUMP,
            onChange: async (v) => {
              const dir = await Xb_FileUtils.selectDir()
              if (dir) {
                this.viewModel.gameProfile.customHomeDir
              }
              // TODO 拉起选择弹窗
            }
          }
        ]
      } as GroupDataModel] : []),
    ]
  }

  changeGameFolder(v: number | boolean | ResourceStr) {
    const value = v as HomeDirectoryType
    this.viewModel.gameProfile.homeType = value
    this.viewModel.changeHome()
  }


}