local function map(mode, lhs, rhs, opts)
	local options = {noremap = true}
	if opts then options = vim.tbl_extend('force', options, opts) end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local g = vim.g
g.mapleader = ' '

map('i', 'jk', '<esc>')
map('i', 'kj', '<esc>')
map('n', ';', ':')
map('n', 'H', '^')
map('n', 'L', '$')
map('n', '<F1>', '<Esc>"')

map('n', '<leader>w', '<cmd>w<CR>')
map('n', '<leader>q', '<cmd>q<CR>')

map('n', '[b', '<cmd>bp<CR>')
map('n', ']b', '<cmd>bn<CR>')
map('n', '<leader>bd', '<cmd>bd<CR>')

map('n', '<leader>ev', '<cmd>e $MYVIMRC<CR>')

map('n', '<leader><leader>j', '<cmd>HopWordAC<CR>')
map('n', '<leader><leader>k', '<cmd>HopWordBC<CR>')
map('n', '<leader>ll', '<cmd>HopLine<CR>')

