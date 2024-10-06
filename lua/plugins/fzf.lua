return {
  "ibhagwan/fzf-lua",
  requires = { "nvim-tree/nvim-web-devicons" }, -- optional for icons
  config = function()
    require("fzf-lua").setup({
      winopts = {
        height = 0.85, -- window height
        width = 0.80, -- window width
        row = 0.30, -- window row position (0=top, 1=bottom)
        col = 0.50, -- window col position (0=left, 1=right)
      },
      keymap = {
        fzf = {
          ["ctrl-u"] = "unix-line-discard",
          ["ctrl-f"] = "half-page-down",
          ["ctrl-b"] = "half-page-up",
          ["ctrl-a"] = "beginning-of-line",
          ["ctrl-e"] = "end-of-line",
          ["alt-a"] = "toggle-all",
          ["f3"] = "toggle-preview-wrap",
          ["f4"] = "toggle-preview",
          ["shift-down"] = "preview-page-down",
          ["shift-up"] = "preview-page-up",
        },
      },
    })
  end,
}
