local cmd = vim.cmd
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	cmd('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

cmd [[packadd packer.nvim]]

--setup packer
require('packer').startup(function(use)
	use "wbthomason/packer.nvim"
    
    use {
        'phaazon/hop.nvim',
        branch = 'v1', -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
        end
    }
    if not vim.g.vscode then
        -- UI --
        use 'nvim-lualine/lualine.nvim'
        use 'nvim-tree/nvim-tree.lua'
        use 'nvim-tree/nvim-web-devicons'
        use 'kdheepak/tabline.nvim'
        use 'tomasr/molokai'
        use 'junegunn/vim-easy-align'
        use 'sainnhe/edge'
        use 'sharkdp/fd'
        use 'BurntSushi/ripgrep'
        use {
            'nvim-telescope/telescope.nvim',
            requires = { {'nvim-lua/plenary.nvim'} }
        }
        use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

        -- Project/Sessions/Workspaces
        use 'natecraddock/workspaces.nvim'
        
        -- tree
        use 'nvim-treesitter/nvim-treesitter'
        use 'yamatsum/nvim-cursorline'
        use {
            'glepnir/dashboard-nvim',
            event = 'VimEnter',
            config = function()
                require('dashboard').setup {
                    -- config
                    hide = {statusline, tabline},
                    theme = 'hyper',
                    config = {
                        project = {
                            enable = true, 
                            limit = 8, 
                            icon = '', 
                            label = '', 
                            action = function()
                                print('echo on project action')
                                return require("workspaces").list()
                            end,
                        },
                        path = vim.fn.stdpath("data") .. "/workspaces",
                    },
                }
            end,
            requires = {'nvim-tree/nvim-web-devicons', "natecraddock/workspaces.nvim'"}
        }
        use 'nvim-telescope/telescope-packer.nvim'
        use 'lukas-reineke/indent-blankline.nvim'
        use 'akinsho/toggleterm.nvim'
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
        use 'windwp/nvim-autopairs'
        -- LSP manager
        use 'williamboman/mason.nvim'
        use 'williamboman/mason-lspconfig.nvim'
        -- Neovim LSP Attacher
        use 'neovim/nvim-lspconfig'
        use 'simrat39/rust-tools.nvim'
        -- Completion framework
        use 'hrsh7th/nvim-cmp'

        use 'onsails/lspkind-nvim'

        -- LSP completion source:
        use 'hrsh7th/cmp-nvim-lsp'

        -- Useful completion sources:
        use 'hrsh7th/cmp-vsnip'
        use 'hrsh7th/vim-vsnip'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'

        use 'nvim-lua/popup.nvim'

        -- themes
        use 'shaunsingh/nord.nvim'
    end
end)

