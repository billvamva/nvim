local M = {}

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values

function M.custom_find_files()
  local find_command = { 'rg', '--files' }

  pickers
    .new({}, {
      prompt_title = 'Find Files',
      finder = finders.new_oneshot_job(find_command, {
        entry_maker = function(entry)
          local bufnr = vim.fn.bufadd(entry)
          vim.fn.bufload(bufnr)

          local diagnostics = vim.diagnostic.get(bufnr)
          for _, diagnostic in ipairs(diagnostics) do
            if diagnostic.severity == vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN then
              -- close the buf if it's not opened
              if not vim.api.nvim_buf_is_loaded(bufnr) then
                vim.api.nvim_buf_delete(bufnr, { force = true })
              end
              local sev_text = diagnostic.severity == vim.diagnostic.severity.ERROR and 'E' or 'W'
              return {
                value = entry,
                display = entry .. ' ' .. sev_text,
                ordinal = entry,
              }
            end
          end
        end,
      }),
      previewer = conf.file_previewer {},
    })
    :find()
end

vim.api.nvim_create_user_command('DiagnosticFiles', function()
  M.custom_find_files()
end, {})

vim.keymap.set('n', '<leader>df', ':DiagnosticFiles<CR>', { noremap = true, silent = true })
