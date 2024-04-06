-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- See `:help vim.keymap.set()`

-- Keep cursor in place when combining lines with J
vim.keymap.set("n", "J", "mzJ`z")
-- Keep cursor in center when searching and paging
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste over text without copying it to default register
vim.keymap.set("x", "p", [["_dP]])
-- Delete text without copying it to default register
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Prevent moving cursor with space
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Allow sudo filesaving
vim.keymap.set('c', 'w!!', ':w ! sudo tee % > /dev/null')

-- Split Window Navigation
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('i', '<c-j>', '<c-o><c-j>')
vim.keymap.set('i', '<c-k>', '<c-o><c-k>')
vim.keymap.set('i', '<c-h>', '<c-o><c-h>')
vim.keymap.set('i', '<c-l>', '<c-o><c-l>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Manual highlight clearing
vim.keymap.set('n', '<c-g>', ':noh<CR>')

-- Remove trailing whitespace
vim.keymap.set('n', '<leader>s', ':%s/\\s\\+$//e<CR>:noh<CR>', { silent = true })

-- Quicker saving
vim.keymap.set('n', '<Leader>w', ':w<CR>')

-- Open a terminal in the current buffer's file's directory
vim.keymap.set('n', '<leader>t', ':lcd %:h<CR>:vertical terminal <CR>', { silent = true})

-- Copy to wayland clipboard
vim.keymap.set('v', '<leader>y', ":'<,'>w !wl-copy<CR><CR>", { silent = true })
