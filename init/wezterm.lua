local wezterm = require 'wezterm'
return {
  font = wezterm.font_with_fallback {
    'UbuntuMono',
  },
  font_size = 27,
  line_height = 1.22,
  cell_width = 1.0,
  window_background_opacity = 0.9,
  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 600,
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  enable_scroll_bar = true,
  keys = {
    {
      key = 'F11',
      action = wezterm.action.ToggleFullScreen,
    },
  },
  colors = {
    -- 文本颜色
    foreground = 'white',
    -- 背景颜色
    background = 'black',
    -- 光标颜色
    cursor_bg = 'white',
    -- 光标颜色（闪烁间）
    cursor_fg = 'black'
  },
  -- 不隐藏鼠标
  hide_mouse_cursor_when_typing = false,
  scrollback_lines = 1000000,
  color_scheme = "Windows High Contrast (base16)",
  enable_wayland = true,
  term = "xterm-256color",
}
