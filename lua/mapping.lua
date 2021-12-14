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
map('n', 'U', '<C-r>')
map('n', '<F1>', '<Esc>"')

map('n', '<leader>w', '<cmd>w<CR>')
map('n', '<leader>q', '<cmd>q<CR>')
map('n', '<leader>p', '"+p')
-- select all
map('n', '<leader>sa', 'ggVG')

map('n', '<leader>bp', '<cmd>bp<CR>')
map('n', '<leader>bn', '<cmd>bn<CR>')
map('n', '<leader>bd', '<cmd>bd<CR>')

map('n', '<leader>ev', '<cmd>e $MYVIMRC<CR>')

-- Hop
map('n', '<leader><leader>j', '<cmd>HopWordAC<CR>')
map('n', '<leader><leader>k', '<cmd>HopWordBC<CR>')
map('n', '<leader><leader>l', '<cmd>HopLine<CR>')

-- Telescope
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
map('n', '<leader>fh', '<cmd>Telescope oldfiles<cr>')
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
map('n', '<leader>fm', '<cmd>Telescope marks<cr>')
map('n', '<leader>fs', '<cmd>Telescope sessions save_current=true<cr>')
map('n', '<leader>ft', '<cmd>Telescope help_tags<cr>')

map('n', '<leader>ls', '<cmd>LoadLastSession<cr>')
map('n', '<leader>lS', '<cmd>LoadLastSession!<cr>')
map('n', '<leader>ss', '<cmd>SaveSession<cr>')

map('n', '<leader>rl', '<cmd>luafile %<cr>')
map('n', '<leader>pu', '<cmd>PackerUpdate<cr>')
map('n', '<leader>da', '<cmd>Dashboard<cr>')

