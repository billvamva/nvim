return {
  "nvim-pack/nvim-spectre",
  build = false,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  -- stylua: ignore
  keys = {
    { "<leader>sr",
            function()
require('spectre').open({
  is_insert_mode = true,
  -- the directory where the search tool will be started in
  cwd = "~/.config/nvim",
  search_text="test",
  replace_text="test",
  -- the pattern of files to consider for searching
  path="lua/**/*.lua",
  -- the directories or files to search in
  search_paths = {"lua/", "plugin/"},
  is_close = false, -- close an exists instance of spectre and open new
})
 end, desc = "Replace in files (Spectre)" },
  },
}

--
