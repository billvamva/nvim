return {
  "nathom/filetype.nvim",
  config = function()
    require("filetype").setup({
      overrides = {
        extensions = {
          tf = "terraform",
          tfvars = "terraform",
          tfstate = "json",
          html = "html",
          js = "javascript",
          sh = "bash",
          c = "c",
          h = "c",
        },
        literal = {
          [".env"] = "env", -- This line sets .env files to use sh filetype
          -- You can add more literal filename matches here
        },
        complex = {
          -- This will match any file ending with .env, like .env.local, .env.production, etc.
          ["%.env.*"] = "env",
        },
      },
    })
  end,
}
