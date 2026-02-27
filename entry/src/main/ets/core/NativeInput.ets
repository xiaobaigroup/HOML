
import { KeyCode, } from "@kit.InputKit";
import LWJGLGLFWKeycode, { toGLFW } from "./LWJGLKeycode";

import { Xb_getPersistence, Xb_GameMenuState, Xb_MouseButtonCode } from "xb_components";
import { jvmLauncher } from "./JVMLauncher";

export class NativeInput {
  menu: Xb_GameMenuState = Xb_getPersistence(Xb_GameMenuState, ()=>new Xb_GameMenuState())!
  OHOS_MOUSE_MAP: Map<number, number> = new Map([
    [Xb_MouseButtonCode.Left, LWJGLGLFWKeycode.MOUSE_BUTTON_1],
    [Xb_MouseButtonCode.Right, LWJGLGLFWKeycode.MOUSE_BUTTON_2],
    [Xb_MouseButtonCode.Middle, LWJGLGLFWKeycode.MOUSE_BUTTON_3],
    [Xb_MouseButtonCode.Forward, LWJGLGLFWKeycode.MOUSE_BUTTON_4],
    [Xb_MouseButtonCode.Back, LWJGLGLFWKeycode.MOUSE_BUTTON_5],
  ])
  constructor() {
    jvmLauncher.bridge.on_cursor_enabled((result: boolean)=>{
      console.debug("NativeInput on_cursor_enabled: " + result)
      const menu = Xb_getPersistence(Xb_GameMenuState)!
      menu.cursorEnabled = !result;
    })
  }
  public sendCursor(x:number, y: number){
    jvmLauncher.bridge.send_cursor_pos(x, y)
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
    jvmLauncher.bridge.send_char_mods(code, mods);
    jvmLauncher.bridge.send_char(code);
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
    jvmLauncher.bridge.send_char_mods(char, mods);
    jvmLauncher.bridge.send_char(char);
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
      jvmLauncher.bridge.send_key(code, scancode, isDown ? 1 : 0, modifiers);
    }
    if (isDown && keychar != '\u0000') {
      this.sendChar(keychar, modifiers)
    }
  }
  public sendAxisEvent(e: AxisEvent){
    let value =  e.getVerticalAxisValue()
    for (let i = 0; i < Math.abs(value); i++) {
      this.sendMouseButton(value > 0 ? Xb_MouseButtonCode.Forward : Xb_MouseButtonCode.Back, true)
    }
  }
  public sendMouseEvent(e:MouseEvent){
    if(e.source != SourceType.Mouse)
      return;
    if(e.action == MouseAction.Press || e.action == MouseAction.Release || e.action == MouseAction.CANCEL){
      let button = Xb_MouseButtonCode.Left
      if(e.button == MouseButton.Right)
        button = Xb_MouseButtonCode.Right
      if(e.button == MouseButton.Middle)
        button = Xb_MouseButtonCode.Middle
      if(e.button == MouseButton.Forward)
        button = Xb_MouseButtonCode.Forward
      if(e.button == MouseButton.Back)
        button = Xb_MouseButtonCode.Back
      this.sendMouseButton(button, e.action == MouseAction.Press)
    }

  }
  public sendMouseButton(keycode:number, down: boolean){
    let code = this.OHOS_MOUSE_MAP.get(keycode);
    if(code == 3){
      if(down)
        jvmLauncher.bridge.send_scroll(0, 1)
    } else if(code == 4){
      if(down)
        jvmLauncher.bridge.send_scroll(0, -1)
    } else {
      jvmLauncher.bridge.send_mouse_button(code, down ? 1 : 0, 0)
    }
  }

}