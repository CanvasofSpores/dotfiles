-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

opts = {
  adapters = {
    ["neotest-python"] = {
      -- Here you can specify the settings for the adapter, i.e.
      runner = "pytest",
      -- python = ".venv/bin/python",
    },
  },
}
