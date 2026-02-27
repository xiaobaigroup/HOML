
import { archiveLib } from '@mysoft/archive'

export async function decompressXz(target: string, dir: string){
  const ret = await archiveLib.decompress({
    inFile: target,
    outFile: dir,
    onProgress: (current, total) => {
      console.log(`解压进度: ${current}/${total} 字节`)
    }
  })
}