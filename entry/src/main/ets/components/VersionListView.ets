import { Xb_getAppStore } from "xb_components";
import { getColorWithTransparency } from "../common/util/ColorWithTransparency";
import { HomlViewModel } from "../core/HomlViewModel";
import { HOMLState } from "../entryability/AppState";
import { MinecraftVersion } from "../model/MinecraftVersion";
import { ModType } from "../model/ModType";


@ComponentV2
export struct VersionListView {
  @Local viewmodel: HomlViewModel = Xb_getAppStore(HomlViewModel)!

  @Param items: MinecraftVersion[] = []
  @Param smallType: boolean = false
  @Param contentEndOffset: number = 0
  @Param itemBackgroundColor: Resource | string | number = $r('app.color.blue')

  @Event onItemClick: (data: MinecraftVersion) => void

  build() {
    List({ space: 10 }) {
      ForEach(this.items, (item: MinecraftVersion) => {
        ListItem() {
          VersionItemView(item, this.smallType)
        }
        .borderRadius(8)
        .backgroundColor(this.viewmodel.current?.id == item.id ?
          getColorWithTransparency(this.getUIContext().getHostContext()!, this.itemBackgroundColor, 0.2) : undefined)
        .padding({ left: this.smallType ? 6 : 12, right: this.smallType ? 6 : 12 })
        .onClick(() => {
          this.viewmodel.selectVersion(item)
          this.onItemClick(item)
        })
      }, (item: MinecraftVersion) => `${item.id}`)
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

function version_code(item:MinecraftVersion){
  let game = item.patches?.find(d => d.id == "game")
  if(!game)
    game = item.patches?.[0]
  if(game)
    return game.version
  if(item.clientVersion)
    return item.clientVersion
  return ""
}
function mod_version(item: MinecraftVersion){
  if(!item.patches)
    return ""
  if(item.patches.length > 1){
    return item.patches[1].version
  }
  return ""
}
function mod_name(item: MinecraftVersion){
  // fcl
  if (item.patches && item.patches.length > 1){
    return item.patches[1].id
  }
  // pcl
  if(mainClassModTypeMap[item.mainClass])
    return mainClassModTypeMap[item.mainClass]

  return "normal"
}
@Builder
export function VersionItemView(item: MinecraftVersion, small: boolean = false) {
  Row({ space: small ? 5 : 10 }) {
    Image(getIconResource(mod_name(item)))
      .width(small ? 25 : 40)
      .height(small ? 25 : 40)
    Column({ space: 2 }) {
      Text(item.id)
        .fontWeight(FontWeight.Medium)
        .fontSize(small ? 16 : 19)
      Text(`${version_code(item)} · ${VersionNameMap[mod_name(item)]} ${mod_version(item)}`)
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

//Forge/NeoForge/LiteLoader/OptiFine/Fabric/Quilt
const VersionNameMap: Record<string, string> = {
  'normal': '原版',
  'fabric': 'Fabric',
  'forge': 'Forge',
  'neoforge': 'NeoForge',
  'liteloader': 'LiteLoader',
  'optifine': 'OptiFine',
  'quilt': 'Quilt',
}

const mainClassModTypeMap: Record<string, string> = {
  'net.fabricmc.loader.impl.launch.knot.KnotClient': ModType.fabric,
  'cpw.mods.bootstraplauncher.BootstrapLauncher': ModType.forge,
  'net.neoforged.fml.startup.Client': ModType.neoforge,
  'org.quiltmc.loader.impl.launch.knot.KnotClient': ModType.quilt,
  'cpw.mods.modlauncher.Launcher': ModType.optifine,
  'com.mumfrey.liteloader.launch.LiteLoaderTweaker': ModType.liteloader,
}