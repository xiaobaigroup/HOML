import { StickAxisEvent, Xb_ControllerEventHandler } from "xb_components";
import { nativeInput } from "./NativeInput";

@ObservedV2
export class GameViewModel implements Xb_ControllerEventHandler{
  onKeyEvent(e: KeyEvent): void {
    nativeInput.handleKeyEvent(e)
  }

  onMouseEvent(e: MouseEvent, x: number, y: number, width: number, height: number): void {
    throw new Error("Method not implemented.");
  }

  onTouchEvent(e: TouchEvent, width: number, height: number): void {
    throw new Error("Method not implemented.");
  }

  onStickAxisEvent(e: StickAxisEvent): void {
    throw new Error("Method not implemented.");
  }

  onSendMouseKey(keycode: number, isPress: boolean): void {
    nativeInput.sendMouseButton(keycode, isPress)
  }

  onSendStickKey(deviceId: number, keycode: number, isPress: boolean): void {
    throw new Error("Method not implemented.");
  }

  onSendKey(deviceId: number, keycode: number, isPress: boolean): void {
    nativeInput.sendKeyEvent(keycode, isPress)
  }

  onSendKeysEvent(keycodes: number[]): void {
    throw new Error("Method not implemented.");
  }

  onSendCursorPostion(x: number, y: number, deltaX: number, deltaY: number, cursorEnabled: boolean, width: number,
    height: number): void {
    nativeInput.sendCursor(x,y)
  }

}