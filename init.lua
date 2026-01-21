-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    {'ojroques/nvim-hardline'},
    {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate'
},
{'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
{ "tiagovla/scope.nvim", config = true },
{
  "olimorris/onedarkpro.nvim",
  priority = 1000, -- Ensure it loads first
},
{ 'projekt0n/github-nvim-theme', name = 'github-theme' },
{ 'stevearc/oil.nvim', name = 'oil' },
{ 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim'}},
{
  "willothy/flatten.nvim",
  config = true,
  -- or pass configuration with
  -- opts = {  }
  -- Ensure that it runs first to minimize delay when opening file from terminal
  lazy = false,
  priority = 1001,
},
{
    'chomosuke/term-edit.nvim',
    event = 'TermOpen',
    version = '1.*',
},
{ "nvim-tree/nvim-web-devicons", opts = {} }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
require('hardline').setup {
  bufferline = false,  -- disable bufferline
  bufferline_settings = {
    exclude_terminal = false,  -- don't show terminal buffers in bufferline
    show_index = false,        -- show buffer indexes (not the actual buffer numbers) in bufferline
  },
  theme = 'default',   -- change theme
  sections = {         -- define sections
    {class = 'mode', item = require('hardline.parts.mode').get_item},
    {class = 'high', item = require('hardline.parts.git').get_item, hide = 100},
    {class = 'med', item = require('hardline.parts.filename').get_item},
    '%<',
    {class = 'med', item = '%='},
    {class = 'low', item = require('hardline.parts.wordcount').get_item, hide = 100},
    {class = 'error', item = require('hardline.parts.lsp').get_error},
    {class = 'warning', item = require('hardline.parts.lsp').get_warning},
    {class = 'warning', item = require('hardline.parts.whitespace').get_item},
    {class = 'high', item = require('hardline.parts.filetype').get_item, hide = 60},
    {class = 'mode', item = require('hardline.parts.line').get_item},
  },
}
vim.opt.termguicolors = true
require("bufferline").setup{ 
	options ={
		numbers = "buffer_id"}
}
require("scope").setup({})
require("oil").setup({
cleanup_delay_ms = 1000,
buf_options = {
	buflisted = false,
	bufhidden = "hide"
}})
require("telescope").load_extension("scope")
local builtin = require('telescope.builtin')
local map = vim.keymap.set
local set = vim.opt
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
require 'term-edit'.setup {
    -- Mandatory option:
    -- Set this to a lua pattern that would match the end of your prompt.
    -- Or a table of multiple lua patterns where at least one would match the
    -- end of your prompt at any given time.
    -- For most bash/zsh user this is '%$ '.
    -- For most powershell/fish user this is '> '.
    -- For most windows cmd user this is '>'.
    prompt_end = '%$ ',
    -- How to write lua patterns: https://www.lua.org/pil/20.2.html
}
vim.cmd("set number")
vim.cmd("colorscheme github_dark")
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], {noremap=true})
vim.api.nvim_set_option("clipboard", "unnamed")
vim.opt.termguicolors = true
vim.cmd("filetype plugin indent on")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")
vim.cmd("set autoindent")
set.hlsearch = false
vim.keymap.set('', '<leader>gd', function()
	vim.cmd 'cd ..'
end, { desc = 'Navigate down one directory from current one' })
vim.keymap.set('n', '<C-f>', ':e %:h<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<C-n>', '<cmd>bnext<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>cb', function()
	vim.cmd('cd ' .. vim.fn.expand '%:p:h')
end, {desc = 'Set working directory to path of buffer'})

