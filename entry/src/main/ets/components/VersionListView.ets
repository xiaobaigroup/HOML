import { VersionModel } from "../common/model/VersionModel";
import { getColorWithTransparency } from "../common/util/ColorWithTransparency";
import { HOMLState } from "../entryability/AppState";


@ComponentV2
export struct VersionListView {

  @Local currentVersionID: number | null = 0

  @Param items: VersionModel[] = []
  @Param smallType: boolean = false
  @Param contentEndOffset: number = 0
  @Param itemBackgroundColor: Resource | string | number = $r('app.color.blue')

  @Event onItemClick: (data: VersionModel) => void

  build() {
    List({ space: 10 }) {
      ForEach(this.items, (item: VersionModel) => {
        ListItem() {
          VersionItemView(item, this.smallType)
        }
        .borderRadius(8)
        .backgroundColor(this.currentVersionID == item.id ?
          getColorWithTransparency(this.getUIContext().getHostContext()!, this.itemBackgroundColor, 0.2) : undefined)
        .padding({ left: this.smallType ? 6 : 12, right: this.smallType ? 6 : 12 })
        .onClick(() => {
          this.currentVersionID = item.id
          this.onItemClick(item)
        })
      })
    }
    .width('100%')
    .contentEndOffset(this.contentEndOffset)
  }

  aboutToAppear(): void {
    if (this.items.length > 0 && HOMLState.widthBp >= 2) {
      this.onItemClick(this.items[0])
    }
  }

}

@Builder
export function VersionItemView(item: VersionModel, small: boolean = false) {
  Row({ space: small ? 5 : 10 }) {
    Image(getIconResource(item.mod))
      .width(small ? 25 : 40)
      .height(small ? 25 : 40)
    Column({ space: 2 }) {
      Text(item.name)
        .fontWeight(FontWeight.Medium)
        .fontSize(small ? 16 : 19)
      Text(`${item.version_code} · ${VersionMap[item.mod]} ${item?.mod_version}`)
        .fontSize(small ? 14 : 16)
    }
    .alignItems(HorizontalAlign.Start)
  }
  .width('100%')
  .justifyContent(FlexAlign.Start)
  .padding({ left: 3, right: 3, top: 12, bottom: 12 })
}

/**
 * 获取图片资源引用
 * @param icon 图片名称
 * @returns Resource
 */
function getIconResource(icon: string): Resource {
  return $r(`app.media.icon_${icon}`)
}


const VersionMap: Record<string, string> = {
  'normal': '原版',
  'fabric': 'Fabric',
  'forge': 'Forge'
}