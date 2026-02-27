import { StickAxisEvent, Xb_ControllerEventHandler, Xb_getAppStore } from "xb_components";
import { NativeInput } from "./NativeInput";

@ObservedV2
export class GameViewModel implements Xb_ControllerEventHandler{
  nativeInput: NativeInput = Xb_getAppStore(NativeInput, ()=> new NativeInput())!

  onAxisEvent(e: AxisEvent): void {
    this.nativeInput.sendAxisEvent(e)
  }
  onKeyEvent(e: KeyEvent): void {
    this.nativeInput.handleKeyEvent(e)
  }

  onMouseEvent(e: MouseEvent, x: number, y: number, width: number, height: number): void {
    this.nativeInput.sendMouseEvent(e)
  }

  onTouchEvent(e: TouchEvent, width: number, height: number): void {
  }

  onStickAxisEvent(e: StickAxisEvent): void {
  }

  onSendMouseKey(keycode: number, isPress: boolean): void {
    this.nativeInput.sendMouseButton(keycode, isPress)
  }

  onSendStickKey(deviceId: number, keycode: number, isPress: boolean): void {
  }

  onSendKey(deviceId: number, keycode: number, isPress: boolean): void {
    this.nativeInput.sendKeyEvent(keycode, isPress)
  }

  onSendKeysEvent(keycodes: number[]): void {
  }

  onSendCursorPostion(x: number, y: number, deltaX: number, deltaY: number, cursorEnabled: boolean, width: number,
    height: number): void {
    this.nativeInput.sendCursor(x,y)
  }

}