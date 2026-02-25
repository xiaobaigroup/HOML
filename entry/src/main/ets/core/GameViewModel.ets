import { StickAxisEvent, Xb_ControllerEventHandler } from "xb_components";
import { nativeInput } from "./NativeInput";

@ObservedV2
export class GameViewModel implements Xb_ControllerEventHandler{
  onKeyEvent(e: KeyEvent): void {
    nativeInput.handleKeyEvent(e)
  }

  onMouseEvent(e: MouseEvent, x: number, y: number, width: number, height: number): void {
    this.nativeInput.sendMouseEvent(e)
  }

  onTouchEvent(e: TouchEvent, width: number, height: number): void {
  }

  onStickAxisEvent(e: StickAxisEvent): void {
  }

  onSendMouseKey(keycode: number, isPress: boolean): void {
    nativeInput.sendMouseButton(keycode, isPress)
  }

  onSendStickKey(deviceId: number, keycode: number, isPress: boolean): void {
  }

  onSendKey(deviceId: number, keycode: number, isPress: boolean): void {
    nativeInput.sendKeyEvent(keycode, isPress)
  }

  onSendKeysEvent(keycodes: number[]): void {
  }

  onSendCursorPostion(x: number, y: number, deltaX: number, deltaY: number, cursorEnabled: boolean, width: number,
    height: number): void {
    nativeInput.sendCursor(x,y)
  }

}