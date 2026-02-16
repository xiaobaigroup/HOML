import { Xb_ActionType, ThemeType, Xb_SettingsItem, Xb_SettingsItemData, Xb_CapsuleButton } from "xb_components"
import { PADDING_VALUE_12 } from "xb_components/src/main/ets/components/Constants"
import { VersionItemView } from "../components/VersionListView"
import { VersionFunctionModel } from "../common/model/VersionFunctionModel"
import { HOMLState } from "../entryability/AppState"
import { MinecraftVersion } from "../model/MinecraftVersion"
import { VersionSetting } from "../model/VersionSetting"


@Builder
export function VersionDetailBuilder(name: string, param: Object) {
  VersionDetail()
}

@ComponentV2
struct VersionDetail {

  @Local options: GroupData[] = []
  @Local currentVersion: MinecraftVersion | null = null
  @Local versionSetting: VersionSetting | null = null

  private pageStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      List({ space: 10 }) {
        ListItemGroup({ header: this.title('基本信息'), space: 2 }) {
          ListItem() {
            Column() {
              VersionItemView(this.currentVersion!)
              List({space: 3}) {
                ForEach(this.getVersionBarModel(), (item: VersionFunctionModel, index) => {
                  ListItem() {
                    Xb_CapsuleButton({
                      icon: item.icon,
                      text: item.title,
                      iconColor: item?.iconColor || $r('app.color.blue'),
                      theBackgroundColor: item?.backgroundColor || $r('sys.color.button_background_color_transparent'),
                      onCheck: () => {
                      },
                    })
                  }
                })
              }
              .scrollBar(BarState.Off)
              .listDirection(Axis.Horizontal)
              .alignListItem(ListItemAlign.Center)
              .padding({ left: 3, right: 8, bottom: 12 })
            }
            .alignItems(HorizontalAlign.Start)
          }
          .borderRadius(16)
          .backgroundColor($r('sys.color.background_primary'))
          .padding({ left: 13, right: 13 })
        }
        .padding({ left: PADDING_VALUE_12, right: PADDING_VALUE_12, bottom: 3 })
        ForEach(this.options, (group: GroupData) => {
          ListItemGroup({ header: group.title ? this.title(group.title) : undefined, space: 2 }) {
            ForEach(group.items, (item: Xb_SettingsItemData, index: number) => {
              ListItem() {
                Xb_SettingsItem({
                  item: item,
                  themeType: ThemeType.Auto,
                  dialogContent: (d) => {
                  }
                })
              }
              .padding({ top: 12, bottom: 12, left: 6, right: 6 })
              .backgroundColor($r('sys.color.background_primary'))
              .borderRadius({
                topLeft: index == 0 ? 16 : undefined,
                topRight: index == 0 ? 16 : undefined,
                bottomLeft: index == group.items.length - 1 ? 16 : undefined,
                bottomRight: index == group.items.length - 1 ? 16 : undefined
              })
            }, (item: Xb_SettingsItemData) => JSON.stringify(item))
          }
          .borderRadius(24)
          .padding({ left: PADDING_VALUE_12, right: PADDING_VALUE_12, bottom: 3 })
          .divider({ color: $r("app.color.divider_light"), strokeWidth: 1, startMargin: 3, endMargin: 3 })
        }, (item: GroupData) => JSON.stringify(item))
      }
      .contentEndOffset(HOMLState.bottomRectHeight)
    }
    .title('版本选项')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .onReady((ctx) => {
      this.pageStack = ctx.pathStack
      const param = ctx.pathInfo.param as MinecraftVersion
      this.currentVersion = param
      this.initOptions()
    })

  }

  @LocalBuilder
  title(title: ResourceStr) {
    Text(title ?? "")
      .fontSize(16)
      .padding({ top: 6, bottom: 0, left: 16 })
      .fontColor( $r("sys.color.font_secondary"))
  }

  initOptions(): void {
    this.options = []
    this.options.push(
      {
        title: "游戏选项",
        items: [
          {
            label: "使用全局设置",
            value: this.versionSetting?.global,
            content: '使用启动器的全局设置，关闭此选项以单独为此版本进行配置',
            actionType: Xb_ActionType.TOGGLE,
            onChange: (v) => {
              if(this.versionSetting){
                this.versionSetting.global = v as boolean
              }
            }
          },
          {
            label: "版本隔离",
            value: this.versionSetting?.isolation,
            content: '建议开启，隔离各版本的存档、材质、Mod等内容，可防止Mod及其配置文件的冲突问题',
            actionType: Xb_ActionType.TOGGLE,
            onChange: (v) => {
              if(this.versionSetting){
                this.versionSetting.isolation = v as boolean
              }
            }
          }
        ]
      },
      {
        title: "高级选项",
        items: [
          {
            label: "温馨提示",
            icon: $r('sys.symbol.info_circle'),
            content: '更改高级选项可能导致一些不可预测的严重问题，除非您有所把握，不建议更改高级选项。更改高级选项导致的问题启动器概不负责。',
            actionType: Xb_ActionType.TEXT,
          },
        ]
      },
      {
        title: undefined,
        items: [
          {
            label: "忽略Java兼容性警告",
            value: this.versionSetting?.notCheckJVM,
            content: '使用启动器的全局设置，关闭此选项以单独为此版本进行配置',
            actionType: Xb_ActionType.TOGGLE,
            onChange: (v) => {
              if(this.versionSetting){
                this.versionSetting.notCheckJVM = v as boolean
              }
            }
          },
          {
            label: "关闭文件校验",
            value: this.versionSetting?.file_verification,
            content: '在启动游戏时不校验游戏版本文件完整性，仅建议在您修改了Minecraft版本文件时启用',
            actionType: Xb_ActionType.TOGGLE,
            onChange: (v) => {
              if(this.versionSetting){
                this.versionSetting.file_verification = v as boolean
              }
            }
          },
          {
            label: "附加参数",
            value: this.versionSetting?.javaArgs,
            content: '在启动游戏的命令行命令添加额外参数',
            actionType: Xb_ActionType.JUMP,
            onChange: (v) => {

            }
          },
        ]
      }
    )
  }

  getVersionBarModel(): VersionFunctionModel[] {
    return [
      {
        icon: $r('sys.symbol.play_fill'),
        title: '启动游戏',
        iconColor: $r('sys.color.font_on_primary'),
        backgroundColor: $r('app.color.green'),
        onAction: async () => {

        }
      },
      {
        icon: $r('sys.symbol.square_and_pencil'),
        title: '编辑信息',
        onAction: async () => {

        }
      },
      {
        icon: $r('sys.symbol.folder'),
        title: '打开目录',
        onAction: async () => {

        }
      },
      {
        icon: $r('sys.symbol.rectangle_on_rectangle'),
        title: '创建副本',
        onAction: async () => {

        }
      },
      {
        icon: $r('sys.symbol.trash'),
        title: '删除',
        iconColor: Color.Red,
        onAction: async () => {

        }
      }
    ]
  }

}


interface GroupData {
  title?: ResourceStr
  items: Xb_SettingsItemData[]
}

