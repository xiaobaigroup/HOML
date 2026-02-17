import { KeyCode } from "@kit.InputKit";

export enum LWJGLKeycode {
  UNKNOWN = 0, // should be -1

  // Printable keys
  SPACE = 32,
  APOSTROPHE = 39,
  COMMA = 44,
  MINUS = 45,
  PERIOD = 46,
  SLASH = 47,
  KEY_0 = 48,
  KEY_1 = 49,
  KEY_2 = 50,
  KEY_3 = 51,
  KEY_4 = 52,
  KEY_5 = 53,
  KEY_6 = 54,
  KEY_7 = 55,
  KEY_8 = 56,
  KEY_9 = 57,
  SEMICOLON = 59,
  EQUAL = 61,
  A = 65,
  B = 66,
  C = 67,
  D = 68,
  E = 69,
  F = 70,
  G = 71,
  H = 72,
  I = 73,
  J = 74,
  K = 75,
  L = 76,
  M = 77,
  N = 78,
  O = 79,
  P = 80,
  Q = 81,
  R = 82,
  S = 83,
  T = 84,
  U = 85,
  V = 86,
  W = 87,
  X = 88,
  Y = 89,
  Z = 90,
  LEFT_BRACKET = 91,
  BACKSLASH = 92,
  RIGHT_BRACKET = 93,
  GRAVE_ACCENT = 96,
  WORLD_1 = 161,
  WORLD_2 = 162,

  // Function keys
  ESCAPE = 256,
  ENTER = 257,
  TAB = 258,
  BACKSPACE = 259,
  INSERT = 260,
  DELETE = 261,
  RIGHT = 262,
  LEFT = 263,
  DOWN = 264,
  UP = 265,
  PAGE_UP = 266,
  PAGE_DOWN = 267,
  HOME = 268,
  END = 269,
  CAPS_LOCK = 280,
  SCROLL_LOCK = 281,
  NUM_LOCK = 282,
  PRINT_SCREEN = 283,
  PAUSE = 284,
  F1 = 290,
  F2 = 291,
  F3 = 292,
  F4 = 293,
  F5 = 294,
  F6 = 295,
  F7 = 296,
  F8 = 297,
  F9 = 298,
  F10 = 299,
  F11 = 300,
  F12 = 301,
  F13 = 302,
  F14 = 303,
  F15 = 304,
  F16 = 305,
  F17 = 306,
  F18 = 307,
  F19 = 308,
  F20 = 309,
  F21 = 310,
  F22 = 311,
  F23 = 312,
  F24 = 313,
  F25 = 314,
  KP_0 = 320,
  KP_1 = 321,
  KP_2 = 322,
  KP_3 = 323,
  KP_4 = 324,
  KP_5 = 325,
  KP_6 = 326,
  KP_7 = 327,
  KP_8 = 328,
  KP_9 = 329,
  KP_DECIMAL = 330,
  KP_DIVIDE = 331,
  KP_MULTIPLY = 332,
  KP_SUBTRACT = 333,
  KP_ADD = 334,
  KP_ENTER = 335,
  KP_EQUAL = 336,
  LEFT_SHIFT = 340,
  LEFT_CONTROL = 341,
  LEFT_ALT = 342,
  LEFT_SUPER = 343,
  RIGHT_SHIFT = 344,
  RIGHT_CONTROL = 345,
  RIGHT_ALT = 346,
  RIGHT_SUPER = 347,
  MENU = 348,
  KEY_LAST = MENU,

  // Modifier key flags
  MOD_SHIFT = 0x1,
  MOD_CONTROL = 0x2,
  MOD_ALT = 0x4,
  MOD_SUPER = 0x8,
  MOD_CAPS_LOCK = 0x10,
  MOD_NUM_LOCK = 0x20,

  // Mouse buttons
  MOUSE_BUTTON_1 = 0,
  MOUSE_BUTTON_2 = 1,
  MOUSE_BUTTON_3 = 2,
  MOUSE_BUTTON_4 = 3,
  MOUSE_BUTTON_5 = 4,
  MOUSE_BUTTON_6 = 5,
  MOUSE_BUTTON_7 = 6,
  MOUSE_BUTTON_8 = 7,
  MOUSE_BUTTON_LAST = MOUSE_BUTTON_8,
  MOUSE_BUTTON_LEFT = MOUSE_BUTTON_1,
  MOUSE_BUTTON_RIGHT = MOUSE_BUTTON_2,
  MOUSE_BUTTON_MIDDLE = MOUSE_BUTTON_3,
}

export const toGLFW = (code: KeyCode): LWJGLKeycode => {
  switch (code) {
    // Printable keys
    case KeyCode.KEYCODE_SPACE: return LWJGLKeycode.SPACE;
    case KeyCode.KEYCODE_APOSTROPHE: return LWJGLKeycode.APOSTROPHE;
    case KeyCode.KEYCODE_COMMA: return LWJGLKeycode.COMMA;
    case KeyCode.KEYCODE_MINUS: return LWJGLKeycode.MINUS;
    case KeyCode.KEYCODE_PERIOD: return LWJGLKeycode.PERIOD;
    case KeyCode.KEYCODE_SLASH: return LWJGLKeycode.SLASH;
    case KeyCode.KEYCODE_0: return LWJGLKeycode.KEY_0;
    case KeyCode.KEYCODE_1: return LWJGLKeycode.KEY_1;
    case KeyCode.KEYCODE_2: return LWJGLKeycode.KEY_2;
    case KeyCode.KEYCODE_3: return LWJGLKeycode.KEY_3;
    case KeyCode.KEYCODE_4: return LWJGLKeycode.KEY_4;
    case KeyCode.KEYCODE_5: return LWJGLKeycode.KEY_5;
    case KeyCode.KEYCODE_6: return LWJGLKeycode.KEY_6;
    case KeyCode.KEYCODE_7: return LWJGLKeycode.KEY_7;
    case KeyCode.KEYCODE_8: return LWJGLKeycode.KEY_8;
    case KeyCode.KEYCODE_9: return LWJGLKeycode.KEY_9;
    case KeyCode.KEYCODE_SEMICOLON: return LWJGLKeycode.SEMICOLON;
    case KeyCode.KEYCODE_EQUALS: return LWJGLKeycode.EQUAL;
    case KeyCode.KEYCODE_A: return LWJGLKeycode.A;
    case KeyCode.KEYCODE_B: return LWJGLKeycode.B;
    case KeyCode.KEYCODE_C: return LWJGLKeycode.C;
    case KeyCode.KEYCODE_D: return LWJGLKeycode.D;
    case KeyCode.KEYCODE_E: return LWJGLKeycode.E;
    case KeyCode.KEYCODE_F: return LWJGLKeycode.F;
    case KeyCode.KEYCODE_G: return LWJGLKeycode.G;
    case KeyCode.KEYCODE_H: return LWJGLKeycode.H;
    case KeyCode.KEYCODE_I: return LWJGLKeycode.I;
    case KeyCode.KEYCODE_J: return LWJGLKeycode.J;
    case KeyCode.KEYCODE_K: return LWJGLKeycode.K;
    case KeyCode.KEYCODE_L: return LWJGLKeycode.L;
    case KeyCode.KEYCODE_M: return LWJGLKeycode.M;
    case KeyCode.KEYCODE_N: return LWJGLKeycode.N;
    case KeyCode.KEYCODE_O: return LWJGLKeycode.O;
    case KeyCode.KEYCODE_P: return LWJGLKeycode.P;
    case KeyCode.KEYCODE_Q: return LWJGLKeycode.Q;
    case KeyCode.KEYCODE_R: return LWJGLKeycode.R;
    case KeyCode.KEYCODE_S: return LWJGLKeycode.S;
    case KeyCode.KEYCODE_T: return LWJGLKeycode.T;
    case KeyCode.KEYCODE_U: return LWJGLKeycode.U;
    case KeyCode.KEYCODE_V: return LWJGLKeycode.V;
    case KeyCode.KEYCODE_W: return LWJGLKeycode.W;
    case KeyCode.KEYCODE_X: return LWJGLKeycode.X;
    case KeyCode.KEYCODE_Y: return LWJGLKeycode.Y;
    case KeyCode.KEYCODE_Z: return LWJGLKeycode.Z;
    case KeyCode.KEYCODE_LEFT_BRACKET: return LWJGLKeycode.LEFT_BRACKET;
    case KeyCode.KEYCODE_BACKSLASH: return LWJGLKeycode.BACKSLASH;
    case KeyCode.KEYCODE_RIGHT_BRACKET: return LWJGLKeycode.RIGHT_BRACKET;
    case KeyCode.KEYCODE_GRAVE: return LWJGLKeycode.GRAVE_ACCENT;

    // Function keys
    case KeyCode.KEYCODE_ESCAPE: return LWJGLKeycode.ESCAPE;
    case KeyCode.KEYCODE_ENTER: return LWJGLKeycode.ENTER;
    case KeyCode.KEYCODE_TAB: return LWJGLKeycode.TAB;
    case KeyCode.KEYCODE_DEL: return LWJGLKeycode.BACKSPACE;
    case KeyCode.KEYCODE_INSERT: return LWJGLKeycode.INSERT;
    case KeyCode.KEYCODE_FORWARD_DEL: return LWJGLKeycode.DELETE;
    case KeyCode.KEYCODE_DPAD_RIGHT: return LWJGLKeycode.RIGHT;
    case KeyCode.KEYCODE_DPAD_LEFT: return LWJGLKeycode.LEFT;
    case KeyCode.KEYCODE_DPAD_DOWN: return LWJGLKeycode.DOWN;
    case KeyCode.KEYCODE_DPAD_UP: return LWJGLKeycode.UP;
    case KeyCode.KEYCODE_PAGE_UP: return LWJGLKeycode.PAGE_UP;
    case KeyCode.KEYCODE_PAGE_DOWN: return LWJGLKeycode.PAGE_DOWN;
    case KeyCode.KEYCODE_MOVE_HOME: return LWJGLKeycode.HOME;
    case KeyCode.KEYCODE_MOVE_END: return LWJGLKeycode.END;
    case KeyCode.KEYCODE_CAPS_LOCK: return LWJGLKeycode.CAPS_LOCK;
    case KeyCode.KEYCODE_SCROLL_LOCK: return LWJGLKeycode.SCROLL_LOCK;
    case KeyCode.KEYCODE_NUM_LOCK: return LWJGLKeycode.NUM_LOCK;
    case KeyCode.KEYCODE_SYSRQ: return LWJGLKeycode.PRINT_SCREEN;
    case KeyCode.KEYCODE_BREAK: return LWJGLKeycode.PAUSE;
    case KeyCode.KEYCODE_F1: return LWJGLKeycode.F1;
    case KeyCode.KEYCODE_F2: return LWJGLKeycode.F2;
    case KeyCode.KEYCODE_F3: return LWJGLKeycode.F3;
    case KeyCode.KEYCODE_F4: return LWJGLKeycode.F4;
    case KeyCode.KEYCODE_F5: return LWJGLKeycode.F5;
    case KeyCode.KEYCODE_F6: return LWJGLKeycode.F6;
    case KeyCode.KEYCODE_F7: return LWJGLKeycode.F7;
    case KeyCode.KEYCODE_F8: return LWJGLKeycode.F8;
    case KeyCode.KEYCODE_F9: return LWJGLKeycode.F9;
    case KeyCode.KEYCODE_F10: return LWJGLKeycode.F10;
    case KeyCode.KEYCODE_F11: return LWJGLKeycode.F11;
    case KeyCode.KEYCODE_F12: return LWJGLKeycode.F12;
    case KeyCode.KEYCODE_F13: return LWJGLKeycode.F13;
    case KeyCode.KEYCODE_F14: return LWJGLKeycode.F14;
    case KeyCode.KEYCODE_F15: return LWJGLKeycode.F15;
    case KeyCode.KEYCODE_F16: return LWJGLKeycode.F16;
    case KeyCode.KEYCODE_F17: return LWJGLKeycode.F17;
    case KeyCode.KEYCODE_F18: return LWJGLKeycode.F18;
    case KeyCode.KEYCODE_F19: return LWJGLKeycode.F19;

    // Numpad keys
    case KeyCode.KEYCODE_NUMPAD_0: return LWJGLKeycode.KP_0;
    case KeyCode.KEYCODE_NUMPAD_1: return LWJGLKeycode.KP_1;
    case KeyCode.KEYCODE_NUMPAD_2: return LWJGLKeycode.KP_2;
    case KeyCode.KEYCODE_NUMPAD_3: return LWJGLKeycode.KP_3;
    case KeyCode.KEYCODE_NUMPAD_4: return LWJGLKeycode.KP_4;
    case KeyCode.KEYCODE_NUMPAD_5: return LWJGLKeycode.KP_5;
    case KeyCode.KEYCODE_NUMPAD_6: return LWJGLKeycode.KP_6;
    case KeyCode.KEYCODE_NUMPAD_7: return LWJGLKeycode.KP_7;
    case KeyCode.KEYCODE_NUMPAD_8: return LWJGLKeycode.KP_8;
    case KeyCode.KEYCODE_NUMPAD_9: return LWJGLKeycode.KP_9;
    case KeyCode.KEYCODE_NUMPAD_DOT: return LWJGLKeycode.KP_DECIMAL;
    case KeyCode.KEYCODE_NUMPAD_DIVIDE: return LWJGLKeycode.KP_DIVIDE;
    case KeyCode.KEYCODE_NUMPAD_MULTIPLY: return LWJGLKeycode.KP_MULTIPLY;
    case KeyCode.KEYCODE_NUMPAD_SUBTRACT: return LWJGLKeycode.KP_SUBTRACT;
    case KeyCode.KEYCODE_NUMPAD_ADD: return LWJGLKeycode.KP_ADD;
    case KeyCode.KEYCODE_NUMPAD_ENTER: return LWJGLKeycode.KP_ENTER;
    case KeyCode.KEYCODE_NUMPAD_EQUALS: return LWJGLKeycode.KP_EQUAL;

    // Modifier keys
    case KeyCode.KEYCODE_SHIFT_LEFT: return LWJGLKeycode.LEFT_SHIFT;
    case KeyCode.KEYCODE_CTRL_LEFT: return LWJGLKeycode.LEFT_CONTROL;
    case KeyCode.KEYCODE_ALT_LEFT: return LWJGLKeycode.LEFT_ALT;
    case KeyCode.KEYCODE_META_LEFT: return LWJGLKeycode.LEFT_SUPER;
    case KeyCode.KEYCODE_SHIFT_RIGHT: return LWJGLKeycode.RIGHT_SHIFT;
    case KeyCode.KEYCODE_CTRL_RIGHT: return LWJGLKeycode.RIGHT_CONTROL;
    case KeyCode.KEYCODE_ALT_RIGHT: return LWJGLKeycode.RIGHT_ALT;
    case KeyCode.KEYCODE_META_RIGHT: return LWJGLKeycode.RIGHT_SUPER;

    // Special keys
    case KeyCode.KEYCODE_MENU: return LWJGLKeycode.MENU;

    default: return LWJGLKeycode.UNKNOWN;
  }
};

export const fromGLFW = (glfwCode: LWJGLKeycode): KeyCode => {
  switch (glfwCode) {
    // Printable keys
    case LWJGLKeycode.SPACE: return KeyCode.KEYCODE_SPACE;
    case LWJGLKeycode.APOSTROPHE: return KeyCode.KEYCODE_APOSTROPHE;
    case LWJGLKeycode.COMMA: return KeyCode.KEYCODE_COMMA;
    case LWJGLKeycode.MINUS: return KeyCode.KEYCODE_MINUS;
    case LWJGLKeycode.PERIOD: return KeyCode.KEYCODE_PERIOD;
    case LWJGLKeycode.SLASH: return KeyCode.KEYCODE_SLASH;
    case LWJGLKeycode.KEY_0: return KeyCode.KEYCODE_0;
    case LWJGLKeycode.KEY_1: return KeyCode.KEYCODE_1;
    case LWJGLKeycode.KEY_2: return KeyCode.KEYCODE_2;
    case LWJGLKeycode.KEY_3: return KeyCode.KEYCODE_3;
    case LWJGLKeycode.KEY_4: return KeyCode.KEYCODE_4;
    case LWJGLKeycode.KEY_5: return KeyCode.KEYCODE_5;
    case LWJGLKeycode.KEY_6: return KeyCode.KEYCODE_6;
    case LWJGLKeycode.KEY_7: return KeyCode.KEYCODE_7;
    case LWJGLKeycode.KEY_8: return KeyCode.KEYCODE_8;
    case LWJGLKeycode.KEY_9: return KeyCode.KEYCODE_9;
    case LWJGLKeycode.SEMICOLON: return KeyCode.KEYCODE_SEMICOLON;
    case LWJGLKeycode.EQUAL: return KeyCode.KEYCODE_EQUALS;
    case LWJGLKeycode.A: return KeyCode.KEYCODE_A;
    case LWJGLKeycode.B: return KeyCode.KEYCODE_B;
    case LWJGLKeycode.C: return KeyCode.KEYCODE_C;
    case LWJGLKeycode.D: return KeyCode.KEYCODE_D;
    case LWJGLKeycode.E: return KeyCode.KEYCODE_E;
    case LWJGLKeycode.F: return KeyCode.KEYCODE_F;
    case LWJGLKeycode.G: return KeyCode.KEYCODE_G;
    case LWJGLKeycode.H: return KeyCode.KEYCODE_H;
    case LWJGLKeycode.I: return KeyCode.KEYCODE_I;
    case LWJGLKeycode.J: return KeyCode.KEYCODE_J;
    case LWJGLKeycode.K: return KeyCode.KEYCODE_K;
    case LWJGLKeycode.L: return KeyCode.KEYCODE_L;
    case LWJGLKeycode.M: return KeyCode.KEYCODE_M;
    case LWJGLKeycode.N: return KeyCode.KEYCODE_N;
    case LWJGLKeycode.O: return KeyCode.KEYCODE_O;
    case LWJGLKeycode.P: return KeyCode.KEYCODE_P;
    case LWJGLKeycode.Q: return KeyCode.KEYCODE_Q;
    case LWJGLKeycode.R: return KeyCode.KEYCODE_R;
    case LWJGLKeycode.S: return KeyCode.KEYCODE_S;
    case LWJGLKeycode.T: return KeyCode.KEYCODE_T;
    case LWJGLKeycode.U: return KeyCode.KEYCODE_U;
    case LWJGLKeycode.V: return KeyCode.KEYCODE_V;
    case LWJGLKeycode.W: return KeyCode.KEYCODE_W;
    case LWJGLKeycode.X: return KeyCode.KEYCODE_X;
    case LWJGLKeycode.Y: return KeyCode.KEYCODE_Y;
    case LWJGLKeycode.Z: return KeyCode.KEYCODE_Z;
    case LWJGLKeycode.LEFT_BRACKET: return KeyCode.KEYCODE_LEFT_BRACKET;
    case LWJGLKeycode.BACKSLASH: return KeyCode.KEYCODE_BACKSLASH;
    case LWJGLKeycode.RIGHT_BRACKET: return KeyCode.KEYCODE_RIGHT_BRACKET;
    case LWJGLKeycode.GRAVE_ACCENT: return KeyCode.KEYCODE_GRAVE;
    case LWJGLKeycode.WORLD_1: return KeyCode.KEYCODE_UNKNOWN;
    case LWJGLKeycode.WORLD_2: return KeyCode.KEYCODE_UNKNOWN;

    // Function keys
    case LWJGLKeycode.ESCAPE: return KeyCode.KEYCODE_ESCAPE;
    case LWJGLKeycode.ENTER: return KeyCode.KEYCODE_ENTER;
    case LWJGLKeycode.TAB: return KeyCode.KEYCODE_TAB;
    case LWJGLKeycode.BACKSPACE: return KeyCode.KEYCODE_BACK;
    case LWJGLKeycode.INSERT: return KeyCode.KEYCODE_INSERT;
    case LWJGLKeycode.DELETE: return KeyCode.KEYCODE_DEL;
    case LWJGLKeycode.RIGHT: return KeyCode.KEYCODE_DPAD_RIGHT;
    case LWJGLKeycode.LEFT: return KeyCode.KEYCODE_DPAD_LEFT;
    case LWJGLKeycode.DOWN: return KeyCode.KEYCODE_DPAD_DOWN;
    case LWJGLKeycode.UP: return KeyCode.KEYCODE_DPAD_UP;
    case LWJGLKeycode.PAGE_UP: return KeyCode.KEYCODE_PAGE_UP;
    case LWJGLKeycode.PAGE_DOWN: return KeyCode.KEYCODE_PAGE_DOWN;
    case LWJGLKeycode.HOME: return KeyCode.KEYCODE_MOVE_HOME;
    case LWJGLKeycode.END: return KeyCode.KEYCODE_MOVE_END;
    case LWJGLKeycode.CAPS_LOCK: return KeyCode.KEYCODE_CAPS_LOCK;
    case LWJGLKeycode.SCROLL_LOCK: return KeyCode.KEYCODE_SCROLL_LOCK;
    case LWJGLKeycode.NUM_LOCK: return KeyCode.KEYCODE_NUM_LOCK;
    case LWJGLKeycode.PRINT_SCREEN: return KeyCode.KEYCODE_SYSRQ;
    case LWJGLKeycode.PAUSE: return KeyCode.KEYCODE_BREAK;
    case LWJGLKeycode.F1: return KeyCode.KEYCODE_F1;
    case LWJGLKeycode.F2: return KeyCode.KEYCODE_F2;
    case LWJGLKeycode.F3: return KeyCode.KEYCODE_F3;
    case LWJGLKeycode.F4: return KeyCode.KEYCODE_F4;
    case LWJGLKeycode.F5: return KeyCode.KEYCODE_F5;
    case LWJGLKeycode.F6: return KeyCode.KEYCODE_F6;
    case LWJGLKeycode.F7: return KeyCode.KEYCODE_F7;
    case LWJGLKeycode.F8: return KeyCode.KEYCODE_F8;
    case LWJGLKeycode.F9: return KeyCode.KEYCODE_F9;
    case LWJGLKeycode.F10: return KeyCode.KEYCODE_F10;
    case LWJGLKeycode.F11: return KeyCode.KEYCODE_F11;
    case LWJGLKeycode.F12: return KeyCode.KEYCODE_F12;
    case LWJGLKeycode.F13: return KeyCode.KEYCODE_F13;
    case LWJGLKeycode.F14: return KeyCode.KEYCODE_F14;
    case LWJGLKeycode.F15: return KeyCode.KEYCODE_F15;
    case LWJGLKeycode.F16: return KeyCode.KEYCODE_F16;
    case LWJGLKeycode.F17: return KeyCode.KEYCODE_F17;
    case LWJGLKeycode.F18: return KeyCode.KEYCODE_F18;
    case LWJGLKeycode.F19: return KeyCode.KEYCODE_F19;

    // Numpad keys
    case LWJGLKeycode.KP_0: return KeyCode.KEYCODE_NUMPAD_0;
    case LWJGLKeycode.KP_1: return KeyCode.KEYCODE_NUMPAD_1;
    case LWJGLKeycode.KP_2: return KeyCode.KEYCODE_NUMPAD_2;
    case LWJGLKeycode.KP_3: return KeyCode.KEYCODE_NUMPAD_3;
    case LWJGLKeycode.KP_4: return KeyCode.KEYCODE_NUMPAD_4;
    case LWJGLKeycode.KP_5: return KeyCode.KEYCODE_NUMPAD_5;
    case LWJGLKeycode.KP_6: return KeyCode.KEYCODE_NUMPAD_6;
    case LWJGLKeycode.KP_7: return KeyCode.KEYCODE_NUMPAD_7;
    case LWJGLKeycode.KP_8: return KeyCode.KEYCODE_NUMPAD_8;
    case LWJGLKeycode.KP_9: return KeyCode.KEYCODE_NUMPAD_9;
    case LWJGLKeycode.KP_DECIMAL: return KeyCode.KEYCODE_NUMPAD_DOT;
    case LWJGLKeycode.KP_DIVIDE: return KeyCode.KEYCODE_NUMPAD_DIVIDE;
    case LWJGLKeycode.KP_MULTIPLY: return KeyCode.KEYCODE_NUMPAD_MULTIPLY;
    case LWJGLKeycode.KP_SUBTRACT: return KeyCode.KEYCODE_NUMPAD_SUBTRACT;
    case LWJGLKeycode.KP_ADD: return KeyCode.KEYCODE_NUMPAD_ADD;
    case LWJGLKeycode.KP_ENTER: return KeyCode.KEYCODE_NUMPAD_ENTER;
    case LWJGLKeycode.KP_EQUAL: return KeyCode.KEYCODE_NUMPAD_EQUALS;

    // Modifier keys
    case LWJGLKeycode.LEFT_SHIFT: return KeyCode.KEYCODE_SHIFT_LEFT;
    case LWJGLKeycode.LEFT_CONTROL: return KeyCode.KEYCODE_CTRL_LEFT;
    case LWJGLKeycode.LEFT_ALT: return KeyCode.KEYCODE_ALT_LEFT;
    case LWJGLKeycode.LEFT_SUPER: return KeyCode.KEYCODE_META_LEFT;
    case LWJGLKeycode.RIGHT_SHIFT: return KeyCode.KEYCODE_SHIFT_RIGHT;
    case LWJGLKeycode.RIGHT_CONTROL: return KeyCode.KEYCODE_CTRL_RIGHT;
    case LWJGLKeycode.RIGHT_ALT: return KeyCode.KEYCODE_ALT_RIGHT;
    case LWJGLKeycode.RIGHT_SUPER: return KeyCode.KEYCODE_META_RIGHT;

    // Special keys
    case LWJGLKeycode.MENU: return KeyCode.KEYCODE_MENU;

    default: return KeyCode.KEYCODE_UNKNOWN;
  }
};
export default LWJGLKeycode;