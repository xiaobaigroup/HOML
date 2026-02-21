
import { Xb_SettingsItem, Xb_SettingsItemData, ThemeType, Xb_SettingsGroupData } from 'xb_components'
import { HOMLState } from '../entryability/AppState'

@ComponentV2
export struct SettingsListView {
  // 接收配置数据
  @Param groups: Xb_SettingsGroupData[] = []
  // 接收可能的自定义头部
  @BuilderParam headerBuilder?: () => void
  // 接收可能的自定义尾部
  @BuilderParam endBuilder?: () => void
  // 标题构建器
  @Builder
  title(title?: ResourceStr) {
    Text(title || "")
      .fontSize(16)
      .padding({ top: 6, bottom: 0, left: 18 })
      .fontColor($r("sys.color.font_secondary"))
  }

  build() {
    List({ space: 10 }) {
      // 自定义头部
      if (this.headerBuilder) {
        this.headerBuilder()
      }
      // 遍历分组
      ForEach(this.groups, (group: Xb_SettingsGroupData) => {
        ListItemGroup({
          header: group?.group ? this.title(group.group.label) : undefined,
          space: 2
        }) {
          // 遍历组内项
          ForEach(group.items, (item: Xb_SettingsItemData) => {
            ListItem() {
              Xb_SettingsItem({
                item: item,
                themeType: ThemeType.Auto,
                dialogContent: (d) => {} // 预留弹窗槽位
              })
            }
            .padding({ top: 12, bottom: 12 })
          }, (item: Xb_SettingsItemData) => `${item.label}_${item.value as string}`)
        }
        .borderRadius(16)
        .margin({ left: 12, right: 12 })
        .divider({ color: $r("app.color.divider_light"), strokeWidth: 1 })
        .backgroundColor($r('sys.color.background_primary'))
      }, (group: Xb_SettingsGroupData) => `${group.group?.label}${group.items.length * Math.random() }`)
      // 自定义尾部
      if (this.endBuilder) {
        this.endBuilder()
      }
    }
    .contentEndOffset(HOMLState.bottomRectHeight + 12) // 通用底部避让
  }
}
