export const jvm_Launcher: (args: string[]) => number;
export const surfaceChanged: (id: number, w:number, h : number) => void
export const send_mouse_button: (button: number, action:number, mods : number) => void
export const send_cursor_pos: (x:number, y : number) => void
export const send_screen_size: (w:number, h : number) => void
export const send_key: (key:number, scancode:number, action:number, mods:number) => void
export const send_char_mods: (key:number, mods:number) => void
export const send_char: (key:number) => void
export const send_scroll: (x:number, y:number) => void
export const set_env: (key:string, value:string) => void
export const dl_open: (key:string) => boolean
export const on_cursor_enabled: (callback:(result: boolean)=>void) => void
export const on_crash_message: (callback:(message: string)=>void) => void
export const on_log_message: (callback:(message: string)=>void) => void
export const on_nominal_exit: (callback:(message: number)=>void) => void
export const accessClipboard: (callback:(message: string)=>void) => void


export const javaCmd: (jarString: string, mainClass: string, cmd:string, callabck:(number)=>void) => number;
export const hasJit: () => boolean;