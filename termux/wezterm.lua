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
    foreground = 'white',
  },
  scrollback_lines = 1000000,
  color_scheme = "Windows High Contrast (base16)",
  enable_wayland = true,
  term = "xterm-256color",
}
