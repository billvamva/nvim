-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- init.lua or ~/.config/nvim/lua/user/init.lua

-- Enable auto-indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true

-- Set the shift width (number of spaces to use for each step of (auto)indent)
vim.opt.shiftwidth = 4

-- Set the number of spaces that a <Tab> in the file counts for
vim.opt.tabstop = 4

-- Insert spaces instead of tabs
vim.opt.expandtab = true

-- Custom function to move horizontal split to the right
function MoveSplitToRight()
  -- Move the current window to a new tab
  vim.cmd("tab split")
  -- Convert the window in the new tab to a vertical split
  vim.cmd("vsplit")
  -- Move the window content back to the original tab
  vim.cmd("tabclose")
  -- Move the window to the rightmost position
  vim.cmd("wincmd L")
end

-- Create a command to call the function
vim.api.nvim_create_user_command("MoveToRight", MoveSplitToRight, {})

-- Keybinding to move the current split to the right
vim.api.nvim_set_keymap("n", "<Leader>mr", ":MoveToRight<CR>", { noremap = true, silent = true })

vim.opt.wrap = true

-- Configure diagnostics floating window
vim.diagnostic.config({
  virtual_text = {
    prefix = ">", -- Custom text or symbol for diagnostics
    spacing = 4,
  },
  signs = true, -- Enable signs
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    source = true, -- Show diagnostic source
    border = "rounded",
    focusable = false,
  },
})

-- Function to show diagnostics in a floating window
function Show_line_diagnostics()
  local opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = "rounded",
    source = "always", -- Show source in diagnostics
    prefix = " ",
  }
  vim.diagnostic.open_float(nil, opts)
end

-- Key mapping to show diagnostics in floating window
vim.api.nvim_set_keymap(
  "n",
  "<leader>d", -- Change this to your preferred keybinding
  "<cmd>lua Show_line_diagnostics()<CR>",
  { noremap = true, silent = true }
)

-- Scrollbar configuration
require("scrollbar").setup()

-- LSP integration with scrollbar
require("scrollbar.handlers.diagnostic").setup()

vim.cmd([[
  au BufNewFile,BufRead *.tf set filetype=terraform
  au BufNewFile,BufRead *.tfvars set filetype=terraform
]])

local toggleterm = require("toggleterm")

toggleterm.setup({
  size = 20,
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
local Terminal = require("toggleterm.terminal").Terminal

-- Function to create or toggle a terminal
function Toggle_terminal()
  local term = Terminal:new({
    direction = "horizontal",
    on_open = function(term)
      vim.cmd("startinsert!")
      set_terminal_keymaps()
    end,
    on_close = function(term)
      vim.cmd("startinsert!")
    end,
  })
  term:toggle()
end

-- Keymap to toggle the terminal
vim.api.nvim_set_keymap(
  "n",
  "<leader>T",
  "<cmd>lua Toggle_terminal()<CR>",
  { desc = "Terminal", noremap = true, silent = true }
)

-- In your Neovim configuration (e.g., init.lua or a separate file)
vim.opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

-- Ensure the WinSeparator highlight is applied to horizontal separators
vim.cmd([[
  augroup CustomSeparators
    autocmd!
    autocmd VimEnter,ColorScheme * highlight! link StatusLine WinSeparator
    autocmd VimEnter,ColorScheme * highlight! link StatusLineNC WinSeparator
  augroup END
]])
