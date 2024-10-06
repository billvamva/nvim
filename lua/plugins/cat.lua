return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = false,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = function(colors)
        local util = require("catppuccin.utils.colors")
        return {
          -- Vertical window separators
          WinSeparator = {
            fg = util.darken(colors.blue, 0.7),
            bg = util.darken(colors.surface0, 0.3),
            bold = true,
          },
          -- Horizontal window separators
          HorizontalSeparator = {
            fg = util.darken(colors.green, 0.7),
            bg = util.darken(colors.surface0, 0.3),
            bold = true,
          },
          -- Inactive windows
          NormalNC = { bg = util.darken(colors.base, 0.1) },
        }
      end,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    },
  },
}
