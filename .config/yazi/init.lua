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

-- Increase filename max length
require("yaziline"):setup({
  filename_max_length = 48, -- truncate when filename > 48
  filename_truncate_length = 12, -- leave 12 chars on both sides
  filename_truncate_separator = "..." -- the separator of the truncated filename
})
