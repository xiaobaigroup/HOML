import { homl_bridge } from 'launcher';

export { homl_bridge, HOMLBridge } from 'launcher';
export const test = (args: string[])=>{
  homl_bridge.jvm_Launcher(args)
}