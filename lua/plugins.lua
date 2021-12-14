-- Install packer
local cmd = vim.cmd
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	cmd('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

cmd [[packadd packer.nvim]]

--setup packer
require('packer').startup(function()
	use "wbthomason/packer.nvim"
	use 'nvim-lualine/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons'
    -- use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
    use 'kdheepak/tabline.nvim'
	use 'tomasr/molokai'
    use {
        'phaazon/hop.nvim',
        branch = 'v1', -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    }
    use 'junegunn/vim-easy-align'
    use 'sainnhe/edge'
    use 'sharkdp/fd'
    use 'BurntSushi/ripgrep'
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use 'nvim-treesitter/nvim-treesitter'
    use 'Shatur/neovim-session-manager'
    use 'yamatsum/nvim-cursorline'
    use 'glepnir/dashboard-nvim'
    use 'nvim-telescope/telescope-packer.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'numToStr/Comment.nvim'
    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }
end)

