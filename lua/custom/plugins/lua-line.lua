return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = function()
    local function get_file_name(buf_nr)
      local file = vim.fn.bufname(buf_nr)
      local buftype = vim.fn.getbufvar(buf_nr, '&buftype')
      local filetype = vim.fn.getbufvar(buf_nr, '&filetype')
      if buftype == 'help' then
        return 'help:' .. vim.fn.fnamemodify(file, ':t:r')
      elseif buftype == 'quickfix' then
        return 'quickfix'
      elseif filetype == 'TelescopePrompt' then
        return 'Telescope'
      elseif file == '' then
        return '[No Name]'
      else
        return vim.fn.fnamemodify(file, ':t')
      end
    end
    local function get_prev_buffer(current_buf)
      local buffers = vim.fn.getbufinfo { buflisted = 1 }
      for i, buf in ipairs(buffers) do
        if buf.bufnr == current_buf and i > 1 then
          return get_file_name(buffers[i - 1].bufnr)
        end
      end
      return ''
    end

    -- Soft blue color palette
    local colors = {
      bg = '#4682B4', -- Steel Blue (base color)
      fg = '#FFFFFF', -- White (for text)
      light_bg = '#2c3e50', -- Lighter Steel Blue (for active window)
      dark_bg = '#b2babb', -- Darker Steel Blue (for inactive window)
      highlight = '#7CB9E8', -- Light Sky Blue (for highlights)
    }

    local function lsp_diagnostics()
      local bufnr = vim.api.nvim_get_current_buf()
      local counts = {
        errors = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }),
        warnings = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }),
      }
      return string.format('E: %d W: %d', #counts.errors, #counts.warnings)
    end

    return {
      options = {
        theme = {
          normal = {
            a = { fg = colors.fg, bg = colors.bg },
            b = { fg = colors.fg, bg = colors.bg },
            c = { fg = colors.fg, bg = colors.bg },
          },
          inactive = {
            a = { fg = colors.fg, bg = colors.dark_bg },
            b = { fg = colors.fg, bg = colors.dark_bg },
            c = { fg = colors.fg, bg = colors.dark_bg },
          },
        },
        globalstatus = false,
        disabled_filetypes = { statusline = { 'dashboard', 'alpha' } },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {
            function()
              return get_prev_buffer(vim.fn.bufnr '%')
            end,
            color = { fg = colors.fg, bg = colors.highlight },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            file_status = true,
            path = 1,
            color = { fg = colors.fg, bg = colors.light_bg },
            padding = { left = 1, right = 1 },
            fmt = function(str)
              local modified = vim.bo.modified and ' [+]' or ''
              return str .. modified
            end,
          },
        },
        lualine_x = {
          {
            lsp_diagnostics,
          },
        },
        lualine_y = {
          { 'progress', color = { fg = colors.fg, bg = colors.bg }, padding = { left = 1, right = 0 } },
          { 'location', color = { fg = colors.fg, bg = colors.bg }, padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          {
            function()
              return os.date '%R'
            end,
            color = { fg = colors.fg, bg = colors.highlight },
            padding = { left = 1, right = 1 },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            file_status = true,
            path = 1,
            color = { fg = colors.fg, bg = colors.dark_bg },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { 'lazy' },
    }
  end,
}
