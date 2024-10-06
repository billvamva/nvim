return {
  "Rics-Dev/project-explorer.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "prichrd/netrw.nvim",
  },
  opts = {
    paths = {
      "/Users/vasilieiosvamvakas/Documents/project/s*",
      "/Users/vasilieiosvamvakas/Documents/projects/",
    }, -- Custom paths
    -- by default paths are set to ~/dev , ~/projects
  },
  config = function(_, opts)
    require("project_explorer").setup(opts)
  end,
  keys = {
    { "<leader>fp", "<cmd>ProjectExplorer<cr>", desc = "Project Explorer" },
  },
  -- Ensure the plugin is loaded correctly
  lazy = false,
}
