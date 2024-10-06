return {
  -- Go development plugin
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua", -- optional package for GUI support
      "neovim/nvim-lspconfig", -- LSP configuration plugin
      "nvim-treesitter/nvim-treesitter", -- Treesitter for enhanced syntax highlighting
      "hrsh7th/nvim-cmp", -- Autocompletion plugin
      "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
      "saadparwaiz1/cmp_luasnip", -- Snippet source for nvim-cmp
      "L3MON4D3/LuaSnip", -- Snippet plugin
    },
    config = function()
      require("go").setup()
      -- Configure nvim-cmp
      -- Setup LSP for Go
      require("lspconfig").gopls.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = function(client, bufnr)
          local buf_set_keymap = vim.api.nvim_buf_set_keymap
          local buf_set_option = vim.api.nvim_buf_set_option
          buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

          -- Mappings.
          local opts = { noremap = true, silent = true }

          -- See `:help vim.lsp.*` for documentation on any of the below functions
          buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
          buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
          buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
          buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
          buf_set_keymap(bufnr, "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
          buf_set_keymap(bufnr, "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
          buf_set_keymap(
            bufnr,
            "n",
            "<space>wl",
            "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
            opts
          )
          buf_set_keymap(bufnr, "n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
          buf_set_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
          buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
          buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
          buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
          buf_set_keymap(bufnr, "n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
          buf_set_keymap(bufnr, "n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        end,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              nilness = true,
            },
            staticcheck = true,
          },
        },
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
