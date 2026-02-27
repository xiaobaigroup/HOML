import { KeyCode } from "@kit.InputKit";

export enum LWJGLGLFWKeycode {
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

export const toGLFW = (code: KeyCode): LWJGLGLFWKeycode => {
  switch (code) {
    // Printable keys
    case KeyCode.KEYCODE_SPACE: return LWJGLGLFWKeycode.SPACE;
    case KeyCode.KEYCODE_APOSTROPHE: return LWJGLGLFWKeycode.APOSTROPHE;
    case KeyCode.KEYCODE_COMMA: return LWJGLGLFWKeycode.COMMA;
    case KeyCode.KEYCODE_MINUS: return LWJGLGLFWKeycode.MINUS;
    case KeyCode.KEYCODE_PERIOD: return LWJGLGLFWKeycode.PERIOD;
    case KeyCode.KEYCODE_SLASH: return LWJGLGLFWKeycode.SLASH;
    case KeyCode.KEYCODE_0: return LWJGLGLFWKeycode.KEY_0;
    case KeyCode.KEYCODE_1: return LWJGLGLFWKeycode.KEY_1;
    case KeyCode.KEYCODE_2: return LWJGLGLFWKeycode.KEY_2;
    case KeyCode.KEYCODE_3: return LWJGLGLFWKeycode.KEY_3;
    case KeyCode.KEYCODE_4: return LWJGLGLFWKeycode.KEY_4;
    case KeyCode.KEYCODE_5: return LWJGLGLFWKeycode.KEY_5;
    case KeyCode.KEYCODE_6: return LWJGLGLFWKeycode.KEY_6;
    case KeyCode.KEYCODE_7: return LWJGLGLFWKeycode.KEY_7;
    case KeyCode.KEYCODE_8: return LWJGLGLFWKeycode.KEY_8;
    case KeyCode.KEYCODE_9: return LWJGLGLFWKeycode.KEY_9;
    case KeyCode.KEYCODE_SEMICOLON: return LWJGLGLFWKeycode.SEMICOLON;
    case KeyCode.KEYCODE_EQUALS: return LWJGLGLFWKeycode.EQUAL;
    case KeyCode.KEYCODE_A: return LWJGLGLFWKeycode.A;
    case KeyCode.KEYCODE_B: return LWJGLGLFWKeycode.B;
    case KeyCode.KEYCODE_C: return LWJGLGLFWKeycode.C;
    case KeyCode.KEYCODE_D: return LWJGLGLFWKeycode.D;
    case KeyCode.KEYCODE_E: return LWJGLGLFWKeycode.E;
    case KeyCode.KEYCODE_F: return LWJGLGLFWKeycode.F;
    case KeyCode.KEYCODE_G: return LWJGLGLFWKeycode.G;
    case KeyCode.KEYCODE_H: return LWJGLGLFWKeycode.H;
    case KeyCode.KEYCODE_I: return LWJGLGLFWKeycode.I;
    case KeyCode.KEYCODE_J: return LWJGLGLFWKeycode.J;
    case KeyCode.KEYCODE_K: return LWJGLGLFWKeycode.K;
    case KeyCode.KEYCODE_L: return LWJGLGLFWKeycode.L;
    case KeyCode.KEYCODE_M: return LWJGLGLFWKeycode.M;
    case KeyCode.KEYCODE_N: return LWJGLGLFWKeycode.N;
    case KeyCode.KEYCODE_O: return LWJGLGLFWKeycode.O;
    case KeyCode.KEYCODE_P: return LWJGLGLFWKeycode.P;
    case KeyCode.KEYCODE_Q: return LWJGLGLFWKeycode.Q;
    case KeyCode.KEYCODE_R: return LWJGLGLFWKeycode.R;
    case KeyCode.KEYCODE_S: return LWJGLGLFWKeycode.S;
    case KeyCode.KEYCODE_T: return LWJGLGLFWKeycode.T;
    case KeyCode.KEYCODE_U: return LWJGLGLFWKeycode.U;
    case KeyCode.KEYCODE_V: return LWJGLGLFWKeycode.V;
    case KeyCode.KEYCODE_W: return LWJGLGLFWKeycode.W;
    case KeyCode.KEYCODE_X: return LWJGLGLFWKeycode.X;
    case KeyCode.KEYCODE_Y: return LWJGLGLFWKeycode.Y;
    case KeyCode.KEYCODE_Z: return LWJGLGLFWKeycode.Z;
    case KeyCode.KEYCODE_LEFT_BRACKET: return LWJGLGLFWKeycode.LEFT_BRACKET;
    case KeyCode.KEYCODE_BACKSLASH: return LWJGLGLFWKeycode.BACKSLASH;
    case KeyCode.KEYCODE_RIGHT_BRACKET: return LWJGLGLFWKeycode.RIGHT_BRACKET;
    case KeyCode.KEYCODE_GRAVE: return LWJGLGLFWKeycode.GRAVE_ACCENT;

    // Function keys
    case KeyCode.KEYCODE_ESCAPE: return LWJGLGLFWKeycode.ESCAPE;
    case KeyCode.KEYCODE_ENTER: return LWJGLGLFWKeycode.ENTER;
    case KeyCode.KEYCODE_TAB: return LWJGLGLFWKeycode.TAB;
    case KeyCode.KEYCODE_DEL: return LWJGLGLFWKeycode.BACKSPACE;
    case KeyCode.KEYCODE_INSERT: return LWJGLGLFWKeycode.INSERT;
    case KeyCode.KEYCODE_FORWARD_DEL: return LWJGLGLFWKeycode.DELETE;
    case KeyCode.KEYCODE_DPAD_RIGHT: return LWJGLGLFWKeycode.RIGHT;
    case KeyCode.KEYCODE_DPAD_LEFT: return LWJGLGLFWKeycode.LEFT;
    case KeyCode.KEYCODE_DPAD_DOWN: return LWJGLGLFWKeycode.DOWN;
    case KeyCode.KEYCODE_DPAD_UP: return LWJGLGLFWKeycode.UP;
    case KeyCode.KEYCODE_PAGE_UP: return LWJGLGLFWKeycode.PAGE_UP;
    case KeyCode.KEYCODE_PAGE_DOWN: return LWJGLGLFWKeycode.PAGE_DOWN;
    case KeyCode.KEYCODE_MOVE_HOME: return LWJGLGLFWKeycode.HOME;
    case KeyCode.KEYCODE_MOVE_END: return LWJGLGLFWKeycode.END;
    case KeyCode.KEYCODE_CAPS_LOCK: return LWJGLGLFWKeycode.CAPS_LOCK;
    case KeyCode.KEYCODE_SCROLL_LOCK: return LWJGLGLFWKeycode.SCROLL_LOCK;
    case KeyCode.KEYCODE_NUM_LOCK: return LWJGLGLFWKeycode.NUM_LOCK;
    case KeyCode.KEYCODE_SYSRQ: return LWJGLGLFWKeycode.PRINT_SCREEN;
    case KeyCode.KEYCODE_BREAK: return LWJGLGLFWKeycode.PAUSE;
    case KeyCode.KEYCODE_F1: return LWJGLGLFWKeycode.F1;
    case KeyCode.KEYCODE_F2: return LWJGLGLFWKeycode.F2;
    case KeyCode.KEYCODE_F3: return LWJGLGLFWKeycode.F3;
    case KeyCode.KEYCODE_F4: return LWJGLGLFWKeycode.F4;
    case KeyCode.KEYCODE_F5: return LWJGLGLFWKeycode.F5;
    case KeyCode.KEYCODE_F6: return LWJGLGLFWKeycode.F6;
    case KeyCode.KEYCODE_F7: return LWJGLGLFWKeycode.F7;
    case KeyCode.KEYCODE_F8: return LWJGLGLFWKeycode.F8;
    case KeyCode.KEYCODE_F9: return LWJGLGLFWKeycode.F9;
    case KeyCode.KEYCODE_F10: return LWJGLGLFWKeycode.F10;
    case KeyCode.KEYCODE_F11: return LWJGLGLFWKeycode.F11;
    case KeyCode.KEYCODE_F12: return LWJGLGLFWKeycode.F12;
    case KeyCode.KEYCODE_F13: return LWJGLGLFWKeycode.F13;
    case KeyCode.KEYCODE_F14: return LWJGLGLFWKeycode.F14;
    case KeyCode.KEYCODE_F15: return LWJGLGLFWKeycode.F15;
    case KeyCode.KEYCODE_F16: return LWJGLGLFWKeycode.F16;
    case KeyCode.KEYCODE_F17: return LWJGLGLFWKeycode.F17;
    case KeyCode.KEYCODE_F18: return LWJGLGLFWKeycode.F18;
    case KeyCode.KEYCODE_F19: return LWJGLGLFWKeycode.F19;

    // Numpad keys
    case KeyCode.KEYCODE_NUMPAD_0: return LWJGLGLFWKeycode.KP_0;
    case KeyCode.KEYCODE_NUMPAD_1: return LWJGLGLFWKeycode.KP_1;
    case KeyCode.KEYCODE_NUMPAD_2: return LWJGLGLFWKeycode.KP_2;
    case KeyCode.KEYCODE_NUMPAD_3: return LWJGLGLFWKeycode.KP_3;
    case KeyCode.KEYCODE_NUMPAD_4: return LWJGLGLFWKeycode.KP_4;
    case KeyCode.KEYCODE_NUMPAD_5: return LWJGLGLFWKeycode.KP_5;
    case KeyCode.KEYCODE_NUMPAD_6: return LWJGLGLFWKeycode.KP_6;
    case KeyCode.KEYCODE_NUMPAD_7: return LWJGLGLFWKeycode.KP_7;
    case KeyCode.KEYCODE_NUMPAD_8: return LWJGLGLFWKeycode.KP_8;
    case KeyCode.KEYCODE_NUMPAD_9: return LWJGLGLFWKeycode.KP_9;
    case KeyCode.KEYCODE_NUMPAD_DOT: return LWJGLGLFWKeycode.KP_DECIMAL;
    case KeyCode.KEYCODE_NUMPAD_DIVIDE: return LWJGLGLFWKeycode.KP_DIVIDE;
    case KeyCode.KEYCODE_NUMPAD_MULTIPLY: return LWJGLGLFWKeycode.KP_MULTIPLY;
    case KeyCode.KEYCODE_NUMPAD_SUBTRACT: return LWJGLGLFWKeycode.KP_SUBTRACT;
    case KeyCode.KEYCODE_NUMPAD_ADD: return LWJGLGLFWKeycode.KP_ADD;
    case KeyCode.KEYCODE_NUMPAD_ENTER: return LWJGLGLFWKeycode.KP_ENTER;
    case KeyCode.KEYCODE_NUMPAD_EQUALS: return LWJGLGLFWKeycode.KP_EQUAL;

    // Modifier keys
    case KeyCode.KEYCODE_SHIFT_LEFT: return LWJGLGLFWKeycode.LEFT_SHIFT;
    case KeyCode.KEYCODE_CTRL_LEFT: return LWJGLGLFWKeycode.LEFT_CONTROL;
    case KeyCode.KEYCODE_ALT_LEFT: return LWJGLGLFWKeycode.LEFT_ALT;
    case KeyCode.KEYCODE_META_LEFT: return LWJGLGLFWKeycode.LEFT_SUPER;
    case KeyCode.KEYCODE_SHIFT_RIGHT: return LWJGLGLFWKeycode.RIGHT_SHIFT;
    case KeyCode.KEYCODE_CTRL_RIGHT: return LWJGLGLFWKeycode.RIGHT_CONTROL;
    case KeyCode.KEYCODE_ALT_RIGHT: return LWJGLGLFWKeycode.RIGHT_ALT;
    case KeyCode.KEYCODE_META_RIGHT: return LWJGLGLFWKeycode.RIGHT_SUPER;

    // Special keys
    case KeyCode.KEYCODE_MENU: return LWJGLGLFWKeycode.MENU;

    default: return LWJGLGLFWKeycode.UNKNOWN;
  }
};

export const fromGLFW = (glfwCode: LWJGLGLFWKeycode): KeyCode => {
  switch (glfwCode) {
    // Printable keys
    case LWJGLGLFWKeycode.SPACE: return KeyCode.KEYCODE_SPACE;
    case LWJGLGLFWKeycode.APOSTROPHE: return KeyCode.KEYCODE_APOSTROPHE;
    case LWJGLGLFWKeycode.COMMA: return KeyCode.KEYCODE_COMMA;
    case LWJGLGLFWKeycode.MINUS: return KeyCode.KEYCODE_MINUS;
    case LWJGLGLFWKeycode.PERIOD: return KeyCode.KEYCODE_PERIOD;
    case LWJGLGLFWKeycode.SLASH: return KeyCode.KEYCODE_SLASH;
    case LWJGLGLFWKeycode.KEY_0: return KeyCode.KEYCODE_0;
    case LWJGLGLFWKeycode.KEY_1: return KeyCode.KEYCODE_1;
    case LWJGLGLFWKeycode.KEY_2: return KeyCode.KEYCODE_2;
    case LWJGLGLFWKeycode.KEY_3: return KeyCode.KEYCODE_3;
    case LWJGLGLFWKeycode.KEY_4: return KeyCode.KEYCODE_4;
    case LWJGLGLFWKeycode.KEY_5: return KeyCode.KEYCODE_5;
    case LWJGLGLFWKeycode.KEY_6: return KeyCode.KEYCODE_6;
    case LWJGLGLFWKeycode.KEY_7: return KeyCode.KEYCODE_7;
    case LWJGLGLFWKeycode.KEY_8: return KeyCode.KEYCODE_8;
    case LWJGLGLFWKeycode.KEY_9: return KeyCode.KEYCODE_9;
    case LWJGLGLFWKeycode.SEMICOLON: return KeyCode.KEYCODE_SEMICOLON;
    case LWJGLGLFWKeycode.EQUAL: return KeyCode.KEYCODE_EQUALS;
    case LWJGLGLFWKeycode.A: return KeyCode.KEYCODE_A;
    case LWJGLGLFWKeycode.B: return KeyCode.KEYCODE_B;
    case LWJGLGLFWKeycode.C: return KeyCode.KEYCODE_C;
    case LWJGLGLFWKeycode.D: return KeyCode.KEYCODE_D;
    case LWJGLGLFWKeycode.E: return KeyCode.KEYCODE_E;
    case LWJGLGLFWKeycode.F: return KeyCode.KEYCODE_F;
    case LWJGLGLFWKeycode.G: return KeyCode.KEYCODE_G;
    case LWJGLGLFWKeycode.H: return KeyCode.KEYCODE_H;
    case LWJGLGLFWKeycode.I: return KeyCode.KEYCODE_I;
    case LWJGLGLFWKeycode.J: return KeyCode.KEYCODE_J;
    case LWJGLGLFWKeycode.K: return KeyCode.KEYCODE_K;
    case LWJGLGLFWKeycode.L: return KeyCode.KEYCODE_L;
    case LWJGLGLFWKeycode.M: return KeyCode.KEYCODE_M;
    case LWJGLGLFWKeycode.N: return KeyCode.KEYCODE_N;
    case LWJGLGLFWKeycode.O: return KeyCode.KEYCODE_O;
    case LWJGLGLFWKeycode.P: return KeyCode.KEYCODE_P;
    case LWJGLGLFWKeycode.Q: return KeyCode.KEYCODE_Q;
    case LWJGLGLFWKeycode.R: return KeyCode.KEYCODE_R;
    case LWJGLGLFWKeycode.S: return KeyCode.KEYCODE_S;
    case LWJGLGLFWKeycode.T: return KeyCode.KEYCODE_T;
    case LWJGLGLFWKeycode.U: return KeyCode.KEYCODE_U;
    case LWJGLGLFWKeycode.V: return KeyCode.KEYCODE_V;
    case LWJGLGLFWKeycode.W: return KeyCode.KEYCODE_W;
    case LWJGLGLFWKeycode.X: return KeyCode.KEYCODE_X;
    case LWJGLGLFWKeycode.Y: return KeyCode.KEYCODE_Y;
    case LWJGLGLFWKeycode.Z: return KeyCode.KEYCODE_Z;
    case LWJGLGLFWKeycode.LEFT_BRACKET: return KeyCode.KEYCODE_LEFT_BRACKET;
    case LWJGLGLFWKeycode.BACKSLASH: return KeyCode.KEYCODE_BACKSLASH;
    case LWJGLGLFWKeycode.RIGHT_BRACKET: return KeyCode.KEYCODE_RIGHT_BRACKET;
    case LWJGLGLFWKeycode.GRAVE_ACCENT: return KeyCode.KEYCODE_GRAVE;
    case LWJGLGLFWKeycode.WORLD_1: return KeyCode.KEYCODE_UNKNOWN;
    case LWJGLGLFWKeycode.WORLD_2: return KeyCode.KEYCODE_UNKNOWN;

    // Function keys
    case LWJGLGLFWKeycode.ESCAPE: return KeyCode.KEYCODE_ESCAPE;
    case LWJGLGLFWKeycode.ENTER: return KeyCode.KEYCODE_ENTER;
    case LWJGLGLFWKeycode.TAB: return KeyCode.KEYCODE_TAB;
    case LWJGLGLFWKeycode.BACKSPACE: return KeyCode.KEYCODE_BACK;
    case LWJGLGLFWKeycode.INSERT: return KeyCode.KEYCODE_INSERT;
    case LWJGLGLFWKeycode.DELETE: return KeyCode.KEYCODE_DEL;
    case LWJGLGLFWKeycode.RIGHT: return KeyCode.KEYCODE_DPAD_RIGHT;
    case LWJGLGLFWKeycode.LEFT: return KeyCode.KEYCODE_DPAD_LEFT;
    case LWJGLGLFWKeycode.DOWN: return KeyCode.KEYCODE_DPAD_DOWN;
    case LWJGLGLFWKeycode.UP: return KeyCode.KEYCODE_DPAD_UP;
    case LWJGLGLFWKeycode.PAGE_UP: return KeyCode.KEYCODE_PAGE_UP;
    case LWJGLGLFWKeycode.PAGE_DOWN: return KeyCode.KEYCODE_PAGE_DOWN;
    case LWJGLGLFWKeycode.HOME: return KeyCode.KEYCODE_MOVE_HOME;
    case LWJGLGLFWKeycode.END: return KeyCode.KEYCODE_MOVE_END;
    case LWJGLGLFWKeycode.CAPS_LOCK: return KeyCode.KEYCODE_CAPS_LOCK;
    case LWJGLGLFWKeycode.SCROLL_LOCK: return KeyCode.KEYCODE_SCROLL_LOCK;
    case LWJGLGLFWKeycode.NUM_LOCK: return KeyCode.KEYCODE_NUM_LOCK;
    case LWJGLGLFWKeycode.PRINT_SCREEN: return KeyCode.KEYCODE_SYSRQ;
    case LWJGLGLFWKeycode.PAUSE: return KeyCode.KEYCODE_BREAK;
    case LWJGLGLFWKeycode.F1: return KeyCode.KEYCODE_F1;
    case LWJGLGLFWKeycode.F2: return KeyCode.KEYCODE_F2;
    case LWJGLGLFWKeycode.F3: return KeyCode.KEYCODE_F3;
    case LWJGLGLFWKeycode.F4: return KeyCode.KEYCODE_F4;
    case LWJGLGLFWKeycode.F5: return KeyCode.KEYCODE_F5;
    case LWJGLGLFWKeycode.F6: return KeyCode.KEYCODE_F6;
    case LWJGLGLFWKeycode.F7: return KeyCode.KEYCODE_F7;
    case LWJGLGLFWKeycode.F8: return KeyCode.KEYCODE_F8;
    case LWJGLGLFWKeycode.F9: return KeyCode.KEYCODE_F9;
    case LWJGLGLFWKeycode.F10: return KeyCode.KEYCODE_F10;
    case LWJGLGLFWKeycode.F11: return KeyCode.KEYCODE_F11;
    case LWJGLGLFWKeycode.F12: return KeyCode.KEYCODE_F12;
    case LWJGLGLFWKeycode.F13: return KeyCode.KEYCODE_F13;
    case LWJGLGLFWKeycode.F14: return KeyCode.KEYCODE_F14;
    case LWJGLGLFWKeycode.F15: return KeyCode.KEYCODE_F15;
    case LWJGLGLFWKeycode.F16: return KeyCode.KEYCODE_F16;
    case LWJGLGLFWKeycode.F17: return KeyCode.KEYCODE_F17;
    case LWJGLGLFWKeycode.F18: return KeyCode.KEYCODE_F18;
    case LWJGLGLFWKeycode.F19: return KeyCode.KEYCODE_F19;

    // Numpad keys
    case LWJGLGLFWKeycode.KP_0: return KeyCode.KEYCODE_NUMPAD_0;
    case LWJGLGLFWKeycode.KP_1: return KeyCode.KEYCODE_NUMPAD_1;
    case LWJGLGLFWKeycode.KP_2: return KeyCode.KEYCODE_NUMPAD_2;
    case LWJGLGLFWKeycode.KP_3: return KeyCode.KEYCODE_NUMPAD_3;
    case LWJGLGLFWKeycode.KP_4: return KeyCode.KEYCODE_NUMPAD_4;
    case LWJGLGLFWKeycode.KP_5: return KeyCode.KEYCODE_NUMPAD_5;
    case LWJGLGLFWKeycode.KP_6: return KeyCode.KEYCODE_NUMPAD_6;
    case LWJGLGLFWKeycode.KP_7: return KeyCode.KEYCODE_NUMPAD_7;
    case LWJGLGLFWKeycode.KP_8: return KeyCode.KEYCODE_NUMPAD_8;
    case LWJGLGLFWKeycode.KP_9: return KeyCode.KEYCODE_NUMPAD_9;
    case LWJGLGLFWKeycode.KP_DECIMAL: return KeyCode.KEYCODE_NUMPAD_DOT;
    case LWJGLGLFWKeycode.KP_DIVIDE: return KeyCode.KEYCODE_NUMPAD_DIVIDE;
    case LWJGLGLFWKeycode.KP_MULTIPLY: return KeyCode.KEYCODE_NUMPAD_MULTIPLY;
    case LWJGLGLFWKeycode.KP_SUBTRACT: return KeyCode.KEYCODE_NUMPAD_SUBTRACT;
    case LWJGLGLFWKeycode.KP_ADD: return KeyCode.KEYCODE_NUMPAD_ADD;
    case LWJGLGLFWKeycode.KP_ENTER: return KeyCode.KEYCODE_NUMPAD_ENTER;
    case LWJGLGLFWKeycode.KP_EQUAL: return KeyCode.KEYCODE_NUMPAD_EQUALS;

    // Modifier keys
    case LWJGLGLFWKeycode.LEFT_SHIFT: return KeyCode.KEYCODE_SHIFT_LEFT;
    case LWJGLGLFWKeycode.LEFT_CONTROL: return KeyCode.KEYCODE_CTRL_LEFT;
    case LWJGLGLFWKeycode.LEFT_ALT: return KeyCode.KEYCODE_ALT_LEFT;
    case LWJGLGLFWKeycode.LEFT_SUPER: return KeyCode.KEYCODE_META_LEFT;
    case LWJGLGLFWKeycode.RIGHT_SHIFT: return KeyCode.KEYCODE_SHIFT_RIGHT;
    case LWJGLGLFWKeycode.RIGHT_CONTROL: return KeyCode.KEYCODE_CTRL_RIGHT;
    case LWJGLGLFWKeycode.RIGHT_ALT: return KeyCode.KEYCODE_ALT_RIGHT;
    case LWJGLGLFWKeycode.RIGHT_SUPER: return KeyCode.KEYCODE_META_RIGHT;

    // Special keys
    case LWJGLGLFWKeycode.MENU: return KeyCode.KEYCODE_MENU;

    default: return KeyCode.KEYCODE_UNKNOWN;
  }
};
export default LWJGLGLFWKeycode;