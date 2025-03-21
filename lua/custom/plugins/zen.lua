return {
  'folke/zen-mode.nvim',
  opts = {
    window = {
      width = 0.7, -- width will be 85% of the editor width
    },
  },
  keys = {
    { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Toggle Zen Mode' },
  },
  config = function(_, opts)
    require('zen-mode').setup(opts)
  end,
}
