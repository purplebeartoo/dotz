-- Set linemode to size and modified date
function Linemode:size_and_mtime()
  local time = math.floor(self._file.cha.mtime or 0)
  if time == 0 then
    time = ""
  elseif os.date("%Y", time) == os.date("%Y") then
    time = os.date("%b %d %H:%M", time)
  else
    time = os.date("%b %d  %Y", time)
  end

  local size = self._file:size()
  return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

-- Setup yatline plugin
require("yatline"):setup({
  show_background = true,
  header_line = {
    left = {
      section_a = {
      },
      section_b = {
      },
      section_c = {
      }
    },
    right = {
      section_a = {
      },
      section_b = {
      },
      section_c = {
      }
    }
  },
  status_line = {
    left = {
      section_a = {
        {type = "string", custom = false, name = "tab_mode"},
      },
      section_b = {
        {type = "string", custom = false, name = "hovered_size"},
      },
      section_c = {
        {type = "string", custom = false, name = "hovered_name"},
      }
    },
    right = {
      section_a = {
        {type = "string", custom = false, name = "cursor_position"},
      },
      section_b = {
        {type = "string", custom = false, name = "cursor_percentage"},
      },
      section_c = {
        {type = "coloreds", custom = false, name = "permissions"},
      }
    }
  },
})

-- Setup Tokyo Night theme for yatline
local tokyo_night_theme = require("yatline-tokyo-night"):setup("night")
require("yatline"):setup({
  theme = tokyo_night_theme,
    -- section_separator = { open = "", close = "" },
    -- inverse_separator = { open = "", close = "" },
})
