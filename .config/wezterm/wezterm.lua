local wezterm = require('wezterm')

return {
  color_scheme = 'tokyonight_night',
  default_cursor_style = 'SteadyUnderline',
  enable_tab_bar = false,
  font = wezterm.font('CaskaydiaCove Nerd Font'), -- Corrected font assignment
  font_size = 11.0,
  window_close_confirmation = 'NeverPrompt',
  colors = {
    cursor_bg = '#e0af68',
    cursor_fg = '#1a1b26',
    cursor_border = '#e0af68',
  },
  window_padding = {
    top = 10,
    right = 15,
    bottom = 10,
    left = 15,
  },
}
