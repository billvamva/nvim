--telescope.lua
return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.5',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-live-grep-args.nvim' },
  config = function()
    local telescope = require 'telescope'
    telescope.setup {
      defaults = {
        border = {
          prompt = { 1, 1, 1, 1 },
          results = { 1, 1, 1, 1 },
          preview = { 1, 1, 1, 1 },
        },
      },
      borderchars = {},
      layout_strategy = 'horizontal',
      layout_config = {
        width = function(_, cols, _)
          if cols > 200 then
            return 170
          else
            return math.floor(cols * 0.87)
          end
        end,
        preview_cutoff = 120,
      },
    }
  end,
}
