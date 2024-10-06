-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
return function()
  local builtin = require("telescope.builtin")
  -- First, set up the global Telescope configuration

  local function find_files_with_hidden()
    builtin.find_files({
      hidden = true,
      respect_gitignore = false,
      file_ignore_patterns = { ".git/" },
    })
  end

  -- Function to open file in a vertical split
  local function find_files_vsplit()
    builtin.find_files({
      hidden = true,
      respect_gitignore = false,
      file_ignore_patterns = { ".git/" },
      attach_mappings = function(prompt_bufnr, map)
        map("i", "<CR>", function()
          local selection = require("telescope.actions.state").get_selected_entry()
          require("telescope.actions").close(prompt_bufnr)
          vim.cmd("vsplit " .. selection.value)
        end)
        return true
      end,
    })
  end

  -- Function to open file in a horizontal split
  local function find_files_split()
    builtin.find_files({
      hidden = true,
      respect_gitignore = false,
      file_ignore_patterns = { ".git/" },
      attach_mappings = function(prompt_bufnr, map)
        map("i", "<CR>", function()
          local selection = require("telescope.actions.state").get_selected_entry()
          require("telescope.actions").close(prompt_bufnr)
          vim.cmd("split " .. selection.value)
        end)
        return true
      end,
    })
  end

  -- Existing mappings
  vim.keymap.set("n", "<C-p>", find_files_with_hidden, { desc = "Search files (including hidden)" })
  vim.keymap.set("n", "<leader><leader>", find_files_with_hidden, { desc = "Search files (including hidden)" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find term in files" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Search in buffer" })
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Get help" })

  -- New mappings for split opens
  vim.keymap.set("n", "<leader>fv", find_files_vsplit, { desc = "Search files and open in vertical split" })
  vim.keymap.set("n", "<leader>fs", find_files_split, { desc = "Search files and open in horizontal split" })

  vim.api.nvim_set_keymap("n", "<leader>rw", "<cmd>lua ResizeLeftWindowBigger()<cr>", { noremap = true, silent = true })

  function ResizeLeftWindowBigger()
    local width = vim.api.nvim_get_option("columns")
    local target_width = math.floor(width * 0.75) -- 75% of total width
    vim.cmd(target_width .. "wincmd |")
  end

  local neotest = require("plugins.neotest")
  vim.keymap.set("n", "<leader>tn", function()
    neotest.run.run()
  end, { desc = "Run nearest test" })
  vim.keymap.set("n", "<leader>tf", function()
    neotest.run.run(vim.fn.expand("%"))
  end, { desc = "Run tests in file" })
  vim.keymap.set("n", "<leader>tl", function()
    neotest.run.run_last()
  end, { desc = "Run last test" })
  vim.keymap.set("n", "<leader>ts", function()
    neotest.summary.toggle()
  end, { desc = "Toggle test summary" })

  local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
      opts = opts or {}
      opts.silent = opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, opts)
    end
  end

  -- Buffer navigation
  map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
  map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })

  -- Map <leader>ts to horizontal split
  vim.api.nvim_set_keymap("n", "<leader>ws", ":split<CR>", { noremap = true, silent = true })

  -- Map <leader>tv to vertical split
  vim.api.nvim_set_keymap("n", "<leader>wv", ":vsplit<CR>", { noremap = true, silent = true })

  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

  -- Add any other custom keymaps here
end
