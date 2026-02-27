import { archiveLib } from '@mysoft/archive'
import { fileIo } from '@kit.CoreFileKit';

export { homl_bridge, HOMLBridge } from 'launcher';

export const install = async (context: Context)=> {
  let target = context.resourceDir.replace("bundle/entry", "bundle/jre25") + "/jre25-ohos-arm64-20251224-release.tar.xz"
  let out = context.filesDir +"/jre25"
  if (!await fileIo.access(out))
    await decompressXz(target, out)
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