local wezterm = require('wezterm')

return {
  color_scheme = 'tokyonight_night',
  default_cursor_style = 'SteadyUnderline',
  enable_tab_bar = false,
  font = wezterm.font('CaskaydiaCove Nerd Font'),
  font_size = 11.0,
  warn_about_missing_glyphs=false,
  window_close_confirmation = 'NeverPrompt',
  window_padding = {
    top = 10,
    right = 15,
    bottom = 5,
    left = 15,
  },
}
