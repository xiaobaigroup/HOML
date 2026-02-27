
import { archiveLib } from '@mysoft/archive'
import { fileIo } from '@kit.CoreFileKit'
import { Xb_ToastUtil } from 'xb_components'


export const hasJreXz = async (context: Context, version: string) => {
  let target = context.resourceDir.replace("bundle/entry", "bundle/"+version) + "/" + version + "-ohos-arm64.tar.xz"
  return await fileIo.access(target)
}
export const installJre = async (context: Context, version: string)=> {
  let target = context.resourceDir.replace("bundle/entry", "bundle/"+version) + "/" + version + "-ohos-arm64.tar.xz"
  let out = context.filesDir +"/" + version
  if (!await fileIo.access(out)){
    Xb_ToastUtil.showToast({message:`${version}安装中...`})
    await decompressXz(target, out)
  }

}

export async function decompressXz(target: string, dir: string){
  try {
    await archiveLib.decompress({
      inFile: target,
      outFile: dir,
      onProgress: (current, total) => {
        console.log(`解压进度: ${current}/${total} 字节`)
      }
    })
  }catch (e) {
    console.error("decompressXz err:" + e.message)
  }
}