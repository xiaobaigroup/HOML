
export interface HOMLBridge{
  jvm_Launcher(args: string[]): number;
  surfaceChanged(id: number, w: number, h: number): void;
  send_mouse_button(button: number, action: number, mods: number): void;
  send_cursor_pos(x: number, y: number): void;
  send_screen_size(w: number, h: number): void;
  send_key(key: number, scancode: number, action: number, mods: number): void;
  send_char_mods(key: number, mods: number): void;
  send_char(key: number): void;
  send_scroll(x: number, y: number): void;
  set_env(key: string, value: string): void;
  dl_open(key: string): boolean;
  on_cursor_enabled(callback: (result: boolean) => void): void;
  on_crash_message(callback: (message: string) => void): void;
  on_log_message(callback: (message: string) => void): void;
  on_nominal_exit(callback: (message: number) => void): void;
  accessClipboard(callback: (message: string) => void): void;
}