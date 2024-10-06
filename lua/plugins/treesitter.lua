-- treesitter.lua
local M = {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { "go", "javascript", "bash", "c", "cpp" },
    highlight = { enable = true },
    indent = { enable = true },
  },
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,
}

return { M }
