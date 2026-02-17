
import { Xb_SettingsItem, Xb_SettingsItemData, ThemeType } from 'xb_components'
import { PADDING_VALUE_12 } from 'xb_components/src/main/ets/components/Constants'
import { GroupDataModel } from '../common/model/GroupDataModel'
import { HOMLState } from '../entryability/AppState'

@ComponentV2
export struct SettingsListView {
  // 接收配置数据
  @Param groups: GroupDataModel[] = []
  // 接收可能的自定义头部
  @BuilderParam headerBuilder?: () => void
  // 标题构建器
  @Builder
  title(title?: ResourceStr) {
    Text(title || "")
      .fontSize(16)
      .padding({ top: 6, bottom: 0, left: 16 })
      .fontColor($r("sys.color.font_secondary"))
  }

  build() {
    List({ space: 10 }) {
      // 自定义头部
      if (this.headerBuilder) {
        this.headerBuilder()
      }
      // 遍历分组
      ForEach(this.groups, (group: GroupDataModel) => {
        ListItemGroup({
          header: group?.title ? this.title(group.title) : undefined,
          space: 2
        }) {
          // 遍历组内项
          ForEach(group.items, (item: Xb_SettingsItemData, index: number) => {
            ListItem() {
              Xb_SettingsItem({
                item: item,
                themeType: ThemeType.Auto,
                dialogContent: (d) => {} // 预留弹窗槽位
              })
            }
            // 通用样式
            .padding({ top: 12, bottom: 12, left: 6, right: 6 })
            .backgroundColor($r('sys.color.background_primary'))
            // 通用圆角逻辑
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
      }, (item: GroupDataModel) => JSON.stringify(item))
    }
    .contentEndOffset(HOMLState.bottomRectHeight) // 通用底部避让
  }
}
