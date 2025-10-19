local wezterm = require('wezterm')
return {
  color_scheme = 'tokyonight_night',
  enable_tab_bar = false,
  enable_wayland = false,
  font = wezterm.font 'CaskaydiaCove Nerd Font',
  font_size = 11.0,
  window_close_confirmation = 'NeverPrompt',
  window_padding = {
    top = 10,
    right = 15,
    bottom = 10,
    left = 15,
  },
}
