-- Bootstrap lazy.nvim if it doesn't exist
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  print("Cloning lazy.nvim...")
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local clone_command = {
    "git",
    "clone",
    "--filter=blob:none", -- Only fetch necessary files
    "--branch=stable",     -- Use the stable branch
    lazyrepo,
    lazypath,
  }

  local out, err = vim.fn.system(clone_command)
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nError details: ", "ErrorMsg" },
      { err or "", "WarningMsg" },
      { "\nPress any key to exit...", "None" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  else
    print("lazy.nvim cloned successfully!")
  end
end

-- Add lazy.nvim to the runtime path
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with your plugins
require("lazy").setup({
  spec = {
    -- Import your plugins from a separate file
    { import = "plugins" },
  },
})
