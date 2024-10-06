-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local fn = vim.fn

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General Settings
local general = augroup("General", { clear = true })

autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  group = general,
  desc = "Disable New Line Comment",
})

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.api.nvim_create_autocmd("User", {
  group = augroup("resession"),
  pattern = "SessionLoadPost",
  callback = function()
    vim.cmd("nohlsearch")
    vim.cmd("diffupdate")
    vim.cmd("normal! <c-l>")
  end,
})

-- Auto clear search highlight
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = augroup("auto_clear_highlight"),
  pattern = "*",
  callback = function()
    vim.cmd("nohlsearch")
  end,
})

-- Clear search highlight after a short delay
vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = augroup("auto_clear_highlight_delay"),
  pattern = "*",
  callback = function()
    vim.fn.timer_start(3000, function()
      vim.cmd("nohlsearch")
    end)
  end,
})
