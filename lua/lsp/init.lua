local nvim_lsp = require 'lspconfig'
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  print("Log: LSP[" .. client.name .."] attached.")

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader><leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader><leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<leader><leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

nvim_lsp.dartls.setup {
    on_attach = on_attach,
}

local rust_opt = {
    tools = {
        autoSetHints = true,
        hover_with_action = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        }
    }
}
require 'rust-tools'.setup(rust_opt)
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
local cmp = require 'cmp'
-- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = ''} })
-- local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
-- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "rust"
-- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "dart"
-- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "lua"
-- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "toml"
-- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "c"
-- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "c++"
-- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "javascript"

local compare = require('cmp.config.compare')
local lspkind = require('lspkind')
cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    mapping = {
        -- ['<Tab>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
        ['<Tab>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        -- { name = 'path' },
        { name = 'buffer' }
    }),
    formatting = {
        format = lspkind.cmp_format {
            with_text = false,
            maxwidth = 50,
            before = function (entry, vim_item)
                vim_item.word = ''
                vim_item.menu = ''
                return vim_item
            end
        }
    },
    -- sorting = {
    --     priority_weight = 2,
    --     comparators = {
    --         -- compare.offset,
    --         -- compare.exact,
    --         -- compare.score,
    --         -- compare.kind,
    --         -- compare.recently_used,
    --         -- compare.sort_text,
    --         compare.length
    --     }
    -- }
}

-- Dart/Flutter
require "flutter-tools".setup {
    decorations = {
        statusline = {
            app_version = false,
            device = false,
        }
    },
    debugger = {
        enabled = false,
    },
}

