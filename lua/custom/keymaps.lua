local builtin = require 'telescope.builtin'
-- First, set up the global Telescope configuration

local function find_files_with_hidden()
  builtin.find_files {
    hidden = true,
    respect_gitignore = false,
    file_ignore_patterns = { '.git/' },
  }
end

-- Function to open file in a vertical split
local function find_files_vsplit()
  builtin.find_files {
    hidden = true,
    respect_gitignore = false,
    file_ignore_patterns = { '.git/' },
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        vim.cmd('vsplit ' .. selection.value)
      end)
      return true
    end,
  }
end

-- Function to open file in a horizontal split
local function find_files_split()
  builtin.find_files {
    hidden = true,
    respect_gitignore = false,
    file_ignore_patterns = { '.git/' },
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        vim.cmd('split ' .. selection.value)
      end)
      return true
    end,
  }
end

-- Function to show diagnostics in a floating window
function Show_line_diagnostics()
  local opts = {
    focusable = false,
    close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
    border = 'rounded',
    source = 'always', -- Show source in diagnostics
    prefix = ' ',
  }
  vim.diagnostic.open_float(nil, opts)
end

-- Key mapping to show diagnostics in floating window
vim.api.nvim_set_keymap(
  'n',
  '<leader>d', -- Change this to your preferred keybinding
  '<cmd>lua Show_line_diagnostics()<CR>',
  { noremap = true, silent = true }
)
-- Existing mappings
vim.keymap.set('n', '<C-p>', find_files_with_hidden, { desc = 'Search files (including hidden)' })
vim.keymap.set('n', '<leader><leader>', find_files_with_hidden, { desc = 'Search files (including hidden)' })
vim.keymap.set('n', '<leader>/', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find term in files' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Search in buffer' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Get help' })

-- New mappings for split opens
vim.keymap.set('n', '<leader>fv', find_files_vsplit, { desc = 'Search files and open in vertical split' })
vim.keymap.set('n', '<leader>fs', find_files_split, { desc = 'Search files and open in horizontal split' })

vim.api.nvim_set_keymap('n', '<leader>rw', '<cmd>lua ResizeLeftWindowBigger()<cr>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ee', ':Telescope file_browser<CR>', { desc = 'Open the workspace directory' })

-- open file_browser with the path of the current buffer
vim.keymap.set('n', '<leader>ec', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = 'Open Current Buffer Directory' })

-- Alternatively, using lua API
vim.keymap.set('n', '<space>fb', function()
  require('telescope').extensions.file_browser.file_browser()
end)

local function map(mode, lhs, rhs, opts)
  local keys = require('lazy.core.handler').handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Buffer navigation
-- map('n', '<leader>bp', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<leader>bp', ':lua RecentBuffers()<CR>', { desc = 'Buffer History' })
map('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- Map <leader>ts to horizontal split
vim.api.nvim_set_keymap('n', '<leader>ws', ':split<CR>', { noremap = true, silent = true })

-- Map <leader>tv to vertical split
vim.api.nvim_set_keymap('n', '<leader>wv', ':vsplit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>df', ':DiagnosticFiles<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

local function copy_file_path_to_clipboard()
  local file_path = vim.fn.expand '%:p'
  vim.fn.setreg('+', file_path)
  print('Copied ' .. file_path .. ' to clipboard')
end

vim.api.nvim_create_user_command('CopyFilePath', copy_file_path_to_clipboard, {})

vim.api.nvim_set_keymap('n', '<leader>cf', ':CopyFilePath<CR>', { noremap = true, silent = true })
