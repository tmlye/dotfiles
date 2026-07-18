require('nvim-treesitter').install {
  'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript',
  'vimdoc', 'vim', 'bash', 'query', 'hcl', 'markdown', 'markdown_inline',
}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-treesitter', { clear = true }),
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require('nvim-treesitter-textobjects').setup {
  select = { lookahead = true },
  move = { set_jumps = true },
}

local select = require 'nvim-treesitter-textobjects.select'
local move = require 'nvim-treesitter-textobjects.move'
local swap = require 'nvim-treesitter-textobjects.swap'

local function sel(capture)
  return function() select.select_textobject(capture, 'textobjects') end
end

vim.keymap.set({ 'x', 'o' }, 'aa', sel '@parameter.outer')
vim.keymap.set({ 'x', 'o' }, 'ia', sel '@parameter.inner')
vim.keymap.set({ 'x', 'o' }, 'af', sel '@function.outer')
vim.keymap.set({ 'x', 'o' }, 'if', sel '@function.inner')
vim.keymap.set({ 'x', 'o' }, 'ac', sel '@class.outer')
vim.keymap.set({ 'x', 'o' }, 'ic', sel '@class.inner')

local function mv(fn, capture)
  return function() move[fn](capture, 'textobjects') end
end

vim.keymap.set({ 'n', 'x', 'o' }, ']m', mv('goto_next_start', '@function.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, ']]', mv('goto_next_start', '@class.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, ']M', mv('goto_next_end', '@function.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, '][', mv('goto_next_end', '@class.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, '[m', mv('goto_previous_start', '@function.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, '[[', mv('goto_previous_start', '@class.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, '[M', mv('goto_previous_end', '@function.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, '[]', mv('goto_previous_end', '@class.outer'))

vim.keymap.set('n', '<leader>a', function() swap.swap_next '@parameter.inner' end)
vim.keymap.set('n', '<leader>A', function() swap.swap_previous '@parameter.inner' end)
