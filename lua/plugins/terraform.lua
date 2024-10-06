return {
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "tf" },
    config = function()
      -- Disable auto-format
      vim.g.terraform_fmt_on_save = 0
      -- Disable commenting
      vim.g.terraform_commentstring = "# %s"
    end,
  },
}
