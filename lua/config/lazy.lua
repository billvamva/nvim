local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.g.tokyonight_colors = { border = "orange" }

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin")

-- OR setup with some options
require("go").setup()

require("Comment").setup()

require("config.keymaps")()

local lspconfig = require("lspconfig")

lspconfig.clangd.setup({
  cmd = {
    "clangd",
    "--fallback-style=webkit",
  },
})

-- Function to choose LSP
local function choose_yaml_lsp()
  local options = { "YAML (General)" }
  if lspconfig.azure_pipelines_ls then
    table.insert(options, 1, "Azure DevOps")
  end

  vim.ui.select(options, { prompt = "Choose YAML LSP:" }, function(choice)
    local on_attach = function(client, bufnr)
      -- Disable formatting from LSP
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    if choice == "Azure DevOps" then
      lspconfig.azure_pipelines_ls.setup({
        on_attach = on_attach,
      })
    else
      lspconfig.yamlls.setup({
        on_attach = on_attach,
        settings = {
          yaml = {
            format = {
              enable = false, -- Disable built-in formatting
            },
            schemas = {
              ["https://raw.githubusercontent.com/Azure/azure-pipelines-vscode/master/service-schema.json"] = {
                "/azure-pipeline*.y*l",
                "/*.azure*",
                "Azure-Pipelines/**/*.y*l",
                "/.azure-pipelines/*.y*l",
              },
              ["https://raw.githubusercontent.com/kubernetes/kubernetes/master/api/openapi-spec/swagger.json"] = {
                "/*-k8s.yaml",
                "/*-k8s.yml",
                "/kubernetes/*.yaml",
                "/kubernetes/*.yml",
              },
            },
            schemaStore = {
              enable = true,
              url = "https://www.schemastore.org/api/json/catalog.json",
            },
          },
        },
      })
    end
  end)
end

-- Autocommand to trigger LSP choice for YAML files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    -- Only prompt if no LSP is attached yet
    if #vim.lsp.get_active_clients({ bufnr = 0 }) == 0 then
      choose_yaml_lsp()
    end
  end,
})

-- Optional: Command to manually trigger LSP choice
vim.api.nvim_create_user_command("ChooseYamlLsp", choose_yaml_lsp, {})

-- Optional: Command to manually format YAML files
vim.api.nvim_create_user_command("FormatYAML", function()
  vim.lsp.buf.format({ async = true })
end, {})
