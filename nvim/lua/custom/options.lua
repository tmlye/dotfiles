-- See `:help vim.o`

-- Do not highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
vim.o.undodir = vim.fn.expand('$HOME/.nvim_undo')

-- Turn off swap files
vim.o.swapfile = false

-- Scrolling
vim.o.scrolloff = 10
vim.o.sidescrolloff = 10
vim.o.sidescroll = 5

-- Wrapping
vim.o.wrap = true
vim.o.showbreak = "↪"

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
