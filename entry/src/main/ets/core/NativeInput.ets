import { send_key, send_cursor_pos, send_mouse_button, on_cursor_enabled, send_char_mods, send_char } from "libhoml_bridge.so";
import { KeyCode, } from "@kit.InputKit";
import LWJGLGLFWKeycode, { toGLFW } from "./LWJGLKeycode";
import { Xb_getPersistence, Xb_GameMenuState, Xb_MouseButtonCode } from "xb_components";

export class NativeInput {
  menu: Xb_GameMenuState = Xb_getPersistence(Xb_GameMenuState)!

  OHOS_MOUSE_MAP: Map<number, number> = new Map([
    [Xb_MouseButtonCode.Left, LWJGLGLFWKeycode.MOUSE_BUTTON_1],
    [Xb_MouseButtonCode.Right, LWJGLGLFWKeycode.MOUSE_BUTTON_2],
    [Xb_MouseButtonCode.Middle, LWJGLGLFWKeycode.MOUSE_BUTTON_3],
    [Xb_MouseButtonCode.Forward, LWJGLGLFWKeycode.MOUSE_BUTTON_4],
    [Xb_MouseButtonCode.Back, LWJGLGLFWKeycode.MOUSE_BUTTON_5],
  ])
  constructor() {
    on_cursor_enabled((result: boolean)=>{
      console.debug("NativeInput on_cursor_enabled: " + result)
      const menu = Xb_getPersistence(Xb_GameMenuState)!
      menu.cursorEnabled = !result;
    })
  }
  public sendCursor(x:number, y: number){
    send_cursor_pos(x, y)
  }
  public handleKeyEvent(event: KeyEvent){
    const keycode = event.keyCode
    const type = event.type
    this.sendNativeKeycode(keycode, '\u0000', 0, this.getCurrentMods(), type == KeyType.Down)
    if (type == KeyType.Down && this.menu.cursorEnabled){
      this.sendCharByUnicode(event.unicode ?? 0)
      if(keycode == KeyCode.KEYCODE_DEL){
        this.sendNativeKeycode(KeyCode.KEYCODE_BACK, '\u0008', 0, this.getCurrentMods(), type == KeyType.Down)
      }
    }
  }
  public sendChar(char: string, mods: number = 0){
    let code = char.codePointAt(0);
    send_char_mods(code, mods);
    send_char(code);
  }
  sendBackspace() {
    this.sendNativeKeycode(KeyCode.KEYCODE_BACK, '\u0008', 0, this.getCurrentMods(), true)
    // this.sendNativeKeycode(KeyCode.KEYCODE_BACK, '\u0008', 0, this.getCurrentMods(), false)
  }
  sendEnter() {
    this.sendKeyEvent(KeyCode.KEYCODE_ENTER, true);
    this.sendKeyEvent(KeyCode.KEYCODE_ENTER, false);
  }
  public sendCharByUnicode(char: number, mods: number = 0){
    send_char_mods(char, mods);
    send_char(char);
  }
  public sendKeyEvent(code: number, press: boolean){
    if (this.OHOS_MOUSE_MAP.has(code)) {
      this.sendMouseButton(code, press)
    }else{
      this.sendNativeKeycode(code, '\u0000', 0, this.getCurrentMods(), press)
    }
  }
  public getCurrentMods() {
    let currMods = 0;
    // if (holdingAlt) {
    //   currMods |= LWJGLGLFWKeycode.GLFW_MOD_ALT;
    // }
    // if (holdingCapslock) {
    //   currMods |= LwjglGlfwKeycode.GLFW_MOD_CAPS_LOCK;
    // }
    // if (holdingCtrl) {
    //   currMods |= LwjglGlfwKeycode.GLFW_MOD_CONTROL;
    // }
    // if (holdingNumlock) {
    //   currMods |= LwjglGlfwKeycode.GLFW_MOD_NUM_LOCK;
    // }
    // if (holdingShift) {
    //   currMods |= LwjglGlfwKeycode.GLFW_MOD_SHIFT;
    // }
    return currMods;
  }
  public sendKeycode(keycode: number, isDown: boolean){

  }
  public sendNativeKeycode(keycode: KeyCode, keychar: string, scancode: number, modifiers: number, isDown: boolean){
    if (keycode != 0) {
      const code = toGLFW(keycode)
      if (code <= 0) {
        return;
      }
      send_key(code, scancode, isDown ? 1 : 0, modifiers);
    }
    if (isDown && keychar != '\u0000') {
      this.sendChar(keychar, modifiers)
    }
  }
  public sendMouseEvent(e:MouseEvent){
    if(e.source != SourceType.Mouse)
      return;
    if(e.action == MouseAction.Press || e.action == MouseAction.Release || e.action == MouseAction.CANCEL){
      this.sendMouseButton(e.button, e.action == MouseAction.Press )
    }
  }
  public sendMouseButton(keycode:number, down: boolean){
    let code = this.OHOS_MOUSE_MAP.get(keycode);
    send_mouse_button(code, down ? 1: 0, 0)
  }

}
export const nativeInput = new NativeInput()
