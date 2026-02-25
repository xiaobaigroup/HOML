import { KeyCode } from "@kit.InputKit";
import { Xb_MouseButtonCode } from "xb_components";

export class FCLKeycodes {
  // 保留键
  static readonly KEY_RESERVED: number = 0;
  // 主键盘区
  static readonly KEY_ESC: number = 1;
  static readonly KEY_1: number = 2;
  static readonly KEY_2: number = 3;
  static readonly KEY_3: number = 4;
  static readonly KEY_4: number = 5;
  static readonly KEY_5: number = 6;
  static readonly KEY_6: number = 7;
  static readonly KEY_7: number = 8;
  static readonly KEY_8: number = 9;
  static readonly KEY_9: number = 10;
  static readonly KEY_0: number = 11;
  static readonly KEY_MINUS: number = 12; // -
  static readonly KEY_EQUAL: number = 13; // =
  static readonly KEY_BACKSPACE: number = 14; // 退格
  static readonly KEY_TAB: number = 15; // Tab
  static readonly KEY_Q: number = 16;
  static readonly KEY_W: number = 17;
  static readonly KEY_E: number = 18;
  static readonly KEY_R: number = 19;
  static readonly KEY_T: number = 20;
  static readonly KEY_Y: number = 21;
  static readonly KEY_U: number = 22;
  static readonly KEY_I: number = 23;
  static readonly KEY_O: number = 24;
  static readonly KEY_P: number = 25;
  static readonly KEY_LEFTBRACE: number = 26; // [
  static readonly KEY_RIGHTBRACE: number = 27; // ]
  static readonly KEY_ENTER: number = 28; // 回车
  static readonly KEY_LEFTCTRL: number = 29; // 左Ctrl
  static readonly KEY_A: number = 30;
  static readonly KEY_S: number = 31;
  static readonly KEY_D: number = 32;
  static readonly KEY_F: number = 33;
  static readonly KEY_G: number = 34;
  static readonly KEY_H: number = 35;
  static readonly KEY_J: number = 36;
  static readonly KEY_K: number = 37;
  static readonly KEY_L: number = 38;
  static readonly KEY_SEMICOLON: number = 39; // ;
  static readonly KEY_APOSTROPHE: number = 40; // '
  static readonly KEY_GRAVE: number = 41; // `
  static readonly KEY_LEFTSHIFT: number = 42; // 左Shift
  static readonly KEY_BACKSLASH: number = 43; // \
  static readonly KEY_Z: number = 44;
  static readonly KEY_X: number = 45;
  static readonly KEY_C: number = 46;
  static readonly KEY_V: number = 47;
  static readonly KEY_B: number = 48;
  static readonly KEY_N: number = 49;
  static readonly KEY_M: number = 50;
  static readonly KEY_COMMA: number = 51; // ,
  static readonly KEY_DOT: number = 52; // .
  static readonly KEY_SLASH: number = 53; // /
  static readonly KEY_RIGHTSHIFT: number = 54; // 右Shift
  static readonly KEY_KPASTERISK: number = 55; // 小键盘*
  static readonly KEY_LEFTALT: number = 56; // 左Alt
  static readonly KEY_SPACE: number = 57; // 空格
  static readonly KEY_CAPSLOCK: number = 58; // 大写锁定

  // 功能键
  static readonly KEY_F1: number = 59;
  static readonly KEY_F2: number = 60;
  static readonly KEY_F3: number = 61;
  static readonly KEY_F4: number = 62;
  static readonly KEY_F5: number = 63;
  static readonly KEY_F6: number = 64;
  static readonly KEY_F7: number = 65;
  static readonly KEY_F8: number = 66;
  static readonly KEY_F9: number = 67;
  static readonly KEY_F10: number = 68;
  static readonly KEY_NUMLOCK: number = 69; // 数字锁定
  static readonly KEY_SCROLLLOCK: number = 70; // 滚动锁定

  // 小键盘
  static readonly KEY_KP7: number = 71; // 小键盘7
  static readonly KEY_KP8: number = 72; // 小键盘8
  static readonly KEY_KP9: number = 73; // 小键盘9
  static readonly KEY_KPMINUS: number = 74; // 小键盘-
  static readonly KEY_KP4: number = 75; // 小键盘4
  static readonly KEY_KP5: number = 76; // 小键盘5
  static readonly KEY_KP6: number = 77; // 小键盘6
  static readonly KEY_KPPLUS: number = 78; // 小键盘+
  static readonly KEY_KP1: number = 79; // 小键盘1
  static readonly KEY_KP2: number = 80; // 小键盘2
  static readonly KEY_KP3: number = 81; // 小键盘3
  static readonly KEY_KP0: number = 82; // 小键盘0
  static readonly KEY_KPDOT: number = 83; // 小键盘.

  // 扩展功能键
  static readonly KEY_F11: number = 87;
  static readonly KEY_F12: number = 88;
  static readonly KEY_KPENTER: number = 96; // 小键盘回车
  static readonly KEY_RIGHTCTRL: number = 97; // 右Ctrl
  static readonly KEY_KPSLASH: number = 98; // 小键盘/
  static readonly KEY_SYSRQ: number = 99; // 系统请求
  static readonly KEY_RIGHTALT: number = 100; // 右Alt

  // 导航键
  static readonly KEY_HOME: number = 102; // Home
  static readonly KEY_UP: number = 103; // 上箭头
  static readonly KEY_PAGEUP: number = 104; // Page Up
  static readonly KEY_LEFT: number = 105; // 左箭头
  static readonly KEY_RIGHT: number = 106; // 右箭头
  static readonly KEY_END: number = 107; // End
  static readonly KEY_DOWN: number = 108; // 下箭头
  static readonly KEY_PAGEDOWN: number = 109; // Page Down
  static readonly KEY_INSERT: number = 110; // Insert
  static readonly KEY_DELETE: number = 111; // Delete

  // 其他键
  static readonly KEY_KPEQUAL: number = 117; // 小键盘=
  static readonly KEY_PAUSE: number = 119; // Pause/Break
  static readonly KEY_KPCOMMA: number = 121; // 小键盘,

  // Meta键（Windows键/Command键）
  static readonly KEY_LEFTMETA: number = 125; // 左Meta
  static readonly KEY_RIGHTMETA: number = 126; // 右Meta

  // 扩展功能键（F13-F24）
  static readonly KEY_F13: number = 183;
  static readonly KEY_F14: number = 184;
  static readonly KEY_F15: number = 185;
  static readonly KEY_F16: number = 186;
  static readonly KEY_F17: number = 187;
  static readonly KEY_F18: number = 188;
  static readonly KEY_F19: number = 189;
  static readonly KEY_F20: number = 190;
  static readonly KEY_F21: number = 191;
  static readonly KEY_F22: number = 192;
  static readonly KEY_F23: number = 193;
  static readonly KEY_F24: number = 194;

  // 未知键
  static readonly KEY_UNKNOWN: number = 240;

  static readonly MOUSE_LEFT: number = 1000;
  static readonly MOUSE_MIDDLE: number = 1001;
  static readonly MOUSE_RIGHT: number = 1002;
  static readonly MOUSE_SCROLL_UP: number = 1003;
  static readonly MOUSE_SCROLL_DOWN: number= 1004;


  static readonly mapping: Map<number, number> = new Map([
    // 数字键映射
    [FCLKeycodes.KEY_0, KeyCode.KEYCODE_0],
    [FCLKeycodes.KEY_1, KeyCode.KEYCODE_1],
    [FCLKeycodes.KEY_2, KeyCode.KEYCODE_2],
    [FCLKeycodes.KEY_3, KeyCode.KEYCODE_3],
    [FCLKeycodes.KEY_4, KeyCode.KEYCODE_4],
    [FCLKeycodes.KEY_5, KeyCode.KEYCODE_5],
    [FCLKeycodes.KEY_6, KeyCode.KEYCODE_6],
    [FCLKeycodes.KEY_7, KeyCode.KEYCODE_7],
    [FCLKeycodes.KEY_8, KeyCode.KEYCODE_8],
    [FCLKeycodes.KEY_9, KeyCode.KEYCODE_9],

    // 字母键映射
    [FCLKeycodes.KEY_A, KeyCode.KEYCODE_A],
    [FCLKeycodes.KEY_B, KeyCode.KEYCODE_B],
    [FCLKeycodes.KEY_C, KeyCode.KEYCODE_C],
    [FCLKeycodes.KEY_D, KeyCode.KEYCODE_D],
    [FCLKeycodes.KEY_E, KeyCode.KEYCODE_E],
    [FCLKeycodes.KEY_F, KeyCode.KEYCODE_F],
    [FCLKeycodes.KEY_G, KeyCode.KEYCODE_G],
    [FCLKeycodes.KEY_H, KeyCode.KEYCODE_H],
    [FCLKeycodes.KEY_I, KeyCode.KEYCODE_I],
    [FCLKeycodes.KEY_J, KeyCode.KEYCODE_J],
    [FCLKeycodes.KEY_K, KeyCode.KEYCODE_K],
    [FCLKeycodes.KEY_L, KeyCode.KEYCODE_L],
    [FCLKeycodes.KEY_M, KeyCode.KEYCODE_M],
    [FCLKeycodes.KEY_N, KeyCode.KEYCODE_N],
    [FCLKeycodes.KEY_O, KeyCode.KEYCODE_O],
    [FCLKeycodes.KEY_P, KeyCode.KEYCODE_P],
    [FCLKeycodes.KEY_Q, KeyCode.KEYCODE_Q],
    [FCLKeycodes.KEY_R, KeyCode.KEYCODE_R],
    [FCLKeycodes.KEY_S, KeyCode.KEYCODE_S],
    [FCLKeycodes.KEY_T, KeyCode.KEYCODE_T],
    [FCLKeycodes.KEY_U, KeyCode.KEYCODE_U],
    [FCLKeycodes.KEY_V, KeyCode.KEYCODE_V],
    [FCLKeycodes.KEY_W, KeyCode.KEYCODE_W],
    [FCLKeycodes.KEY_X, KeyCode.KEYCODE_X],
    [FCLKeycodes.KEY_Y, KeyCode.KEYCODE_Y],
    [FCLKeycodes.KEY_Z, KeyCode.KEYCODE_Z],

    // 功能键映射
    [FCLKeycodes.KEY_F1, KeyCode.KEYCODE_F1],
    [FCLKeycodes.KEY_F2, KeyCode.KEYCODE_F2],
    [FCLKeycodes.KEY_F3, KeyCode.KEYCODE_F3],
    [FCLKeycodes.KEY_F4, KeyCode.KEYCODE_F4],
    [FCLKeycodes.KEY_F5, KeyCode.KEYCODE_F5],
    [FCLKeycodes.KEY_F6, KeyCode.KEYCODE_F6],
    [FCLKeycodes.KEY_F7, KeyCode.KEYCODE_F7],
    [FCLKeycodes.KEY_F8, KeyCode.KEYCODE_F8],
    [FCLKeycodes.KEY_F9, KeyCode.KEYCODE_F9],
    [FCLKeycodes.KEY_F10, KeyCode.KEYCODE_F10],
    [FCLKeycodes.KEY_F11, KeyCode.KEYCODE_F11],
    [FCLKeycodes.KEY_F12, KeyCode.KEYCODE_F12],
    [FCLKeycodes.KEY_F13, KeyCode.KEYCODE_F13],
    [FCLKeycodes.KEY_F14, KeyCode.KEYCODE_F14],
    [FCLKeycodes.KEY_F15, KeyCode.KEYCODE_F15],
    [FCLKeycodes.KEY_F16, KeyCode.KEYCODE_F16],
    [FCLKeycodes.KEY_F17, KeyCode.KEYCODE_F17],
    [FCLKeycodes.KEY_F18, KeyCode.KEYCODE_F18],
    [FCLKeycodes.KEY_F19, KeyCode.KEYCODE_F19],
    [FCLKeycodes.KEY_F20, KeyCode.KEYCODE_F20],
    [FCLKeycodes.KEY_F21, KeyCode.KEYCODE_F21],
    [FCLKeycodes.KEY_F22, KeyCode.KEYCODE_F22],
    [FCLKeycodes.KEY_F23, KeyCode.KEYCODE_F23],
    [FCLKeycodes.KEY_F24, KeyCode.KEYCODE_F24],

    // 控制键映射
    [FCLKeycodes.KEY_ESC, KeyCode.KEYCODE_ESCAPE],
    [FCLKeycodes.KEY_BACKSPACE, KeyCode.KEYCODE_DEL],
    [FCLKeycodes.KEY_TAB, KeyCode.KEYCODE_TAB],
    [FCLKeycodes.KEY_ENTER, KeyCode.KEYCODE_ENTER],
    [FCLKeycodes.KEY_LEFTCTRL, KeyCode.KEYCODE_CTRL_LEFT],
    [FCLKeycodes.KEY_RIGHTCTRL, KeyCode.KEYCODE_CTRL_RIGHT],
    [FCLKeycodes.KEY_LEFTSHIFT, KeyCode.KEYCODE_SHIFT_LEFT],
    [FCLKeycodes.KEY_RIGHTSHIFT, KeyCode.KEYCODE_SHIFT_RIGHT],
    [FCLKeycodes.KEY_LEFTALT, KeyCode.KEYCODE_ALT_LEFT],
    [FCLKeycodes.KEY_RIGHTALT, KeyCode.KEYCODE_ALT_RIGHT],
    [FCLKeycodes.KEY_LEFTMETA, KeyCode.KEYCODE_META_LEFT],
    [FCLKeycodes.KEY_RIGHTMETA, KeyCode.KEYCODE_META_RIGHT],
    [FCLKeycodes.KEY_SPACE, KeyCode.KEYCODE_SPACE],
    [FCLKeycodes.KEY_CAPSLOCK, KeyCode.KEYCODE_CAPS_LOCK],
    [FCLKeycodes.KEY_NUMLOCK, KeyCode.KEYCODE_NUM_LOCK],
    [FCLKeycodes.KEY_SCROLLLOCK, KeyCode.KEYCODE_SCROLL_LOCK],

    // 符号键映射
    [FCLKeycodes.KEY_MINUS, KeyCode.KEYCODE_MINUS],
    [FCLKeycodes.KEY_EQUAL, KeyCode.KEYCODE_EQUALS],
    [FCLKeycodes.KEY_LEFTBRACE, KeyCode.KEYCODE_LEFT_BRACKET],
    [FCLKeycodes.KEY_RIGHTBRACE, KeyCode.KEYCODE_RIGHT_BRACKET],
    [FCLKeycodes.KEY_SEMICOLON, KeyCode.KEYCODE_SEMICOLON],
    [FCLKeycodes.KEY_APOSTROPHE, KeyCode.KEYCODE_APOSTROPHE],
    [FCLKeycodes.KEY_GRAVE, KeyCode.KEYCODE_GRAVE],
    [FCLKeycodes.KEY_BACKSLASH, KeyCode.KEYCODE_BACKSLASH],
    [FCLKeycodes.KEY_COMMA, KeyCode.KEYCODE_COMMA],
    [FCLKeycodes.KEY_DOT, KeyCode.KEYCODE_PERIOD],
    [FCLKeycodes.KEY_SLASH, KeyCode.KEYCODE_SLASH],

    // 导航键映射
    [FCLKeycodes.KEY_HOME, KeyCode.KEYCODE_HOME],
    [FCLKeycodes.KEY_UP, KeyCode.KEYCODE_DPAD_UP],
    [FCLKeycodes.KEY_PAGEUP, KeyCode.KEYCODE_PAGE_UP],
    [FCLKeycodes.KEY_LEFT, KeyCode.KEYCODE_DPAD_LEFT],
    [FCLKeycodes.KEY_RIGHT, KeyCode.KEYCODE_DPAD_RIGHT],
    [FCLKeycodes.KEY_END, KeyCode.KEYCODE_MOVE_END],
    [FCLKeycodes.KEY_DOWN, KeyCode.KEYCODE_DPAD_DOWN],
    [FCLKeycodes.KEY_PAGEDOWN, KeyCode.KEYCODE_PAGE_DOWN],
    [FCLKeycodes.KEY_INSERT, KeyCode.KEYCODE_INSERT],
    [FCLKeycodes.KEY_DELETE, KeyCode.KEYCODE_DEL],

    // 小键盘映射
    [FCLKeycodes.KEY_KP7, KeyCode.KEYCODE_NUMPAD_7],
    [FCLKeycodes.KEY_KP8, KeyCode.KEYCODE_NUMPAD_8],
    [FCLKeycodes.KEY_KP9, KeyCode.KEYCODE_NUMPAD_9],
    [FCLKeycodes.KEY_KPMINUS, KeyCode.KEYCODE_NUMPAD_SUBTRACT],
    [FCLKeycodes.KEY_KP4, KeyCode.KEYCODE_NUMPAD_4],
    [FCLKeycodes.KEY_KP5, KeyCode.KEYCODE_NUMPAD_5],
    [FCLKeycodes.KEY_KP6, KeyCode.KEYCODE_NUMPAD_6],
    [FCLKeycodes.KEY_KPPLUS, KeyCode.KEYCODE_NUMPAD_ADD],
    [FCLKeycodes.KEY_KP1, KeyCode.KEYCODE_NUMPAD_1],
    [FCLKeycodes.KEY_KP2, KeyCode.KEYCODE_NUMPAD_2],
    [FCLKeycodes.KEY_KP3, KeyCode.KEYCODE_NUMPAD_3],
    [FCLKeycodes.KEY_KP0, KeyCode.KEYCODE_NUMPAD_0],
    [FCLKeycodes.KEY_KPDOT, KeyCode.KEYCODE_NUMPAD_DOT],
    [FCLKeycodes.KEY_KPENTER, KeyCode.KEYCODE_NUMPAD_ENTER],
    [FCLKeycodes.KEY_KPSLASH, KeyCode.KEYCODE_NUMPAD_DIVIDE],

    [FCLKeycodes.KEY_KPASTERISK, KeyCode.KEYCODE_MEDIA_PLAY_PAUSE],

    [FCLKeycodes.KEY_KPEQUAL, KeyCode.KEYCODE_NUMPAD_EQUALS],
    [FCLKeycodes.KEY_KPCOMMA, KeyCode.KEYCODE_NUMPAD_COMMA],

    // 系统键映射
    [FCLKeycodes.KEY_PAUSE, KeyCode.KEYCODE_PASTE],
    [FCLKeycodes.KEY_SYSRQ, KeyCode.KEYCODE_SYSRQ],

    [FCLKeycodes.MOUSE_LEFT, 9001],
    [FCLKeycodes.MOUSE_RIGHT, Xb_MouseButtonCode.Right],
    [FCLKeycodes.MOUSE_MIDDLE, Xb_MouseButtonCode.Middle],
    [FCLKeycodes.MOUSE_SCROLL_UP, Xb_MouseButtonCode.Forward],
    [FCLKeycodes.MOUSE_SCROLL_DOWN, Xb_MouseButtonCode.Back]
  ]);

  static FCL_MOUSE_MAP: Map<number, number> = new Map([
    [FCLKeycodes.MOUSE_LEFT, Xb_MouseButtonCode.Left],
    [FCLKeycodes.MOUSE_RIGHT, Xb_MouseButtonCode.Right],
    [FCLKeycodes.MOUSE_MIDDLE, Xb_MouseButtonCode.Middle],
    [FCLKeycodes.MOUSE_SCROLL_UP, Xb_MouseButtonCode.Forward],
    [FCLKeycodes.MOUSE_SCROLL_DOWN, Xb_MouseButtonCode.Back],
  ])
  static onNormKeyCode(key:number): number{
    if(FCLKeycodes.FCL_MOUSE_MAP.has(key)){
      let val = FCLKeycodes.FCL_MOUSE_MAP.get(key)
      if(val){
        return val
      }
    }
    let val = FCLKeycodes.mapping.get(key)
    if(val){
      return val
    } else {
      return key
    }
  }

}

