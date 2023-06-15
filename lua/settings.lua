local cmd = vim.cmd

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

local indent = 4
local cmd = vim.cmd

local g = vim.g
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

g.mapleader = ' '
opt('o', 'helplang', 'cn')
opt('o', 'swapfile', false)
opt('o', 'backup', false)
opt('o', 'number', true)
opt('o', 'relativenumber', true)
opt('o', 'autoread', true)
opt('o', 'wildignore', '*.swap,*.bak,*.pyc,*.class,.svn')
opt('o', 'whichwrap', 'b,s,<,>,h,l,[,]')
opt('o', 'cursorcolumn', true)
opt('o', 'cursorline', true)
opt('o', 'visualbell', false)
opt('o', 'errorbells', false)
opt('o', 'tm', 500)
opt('o', 'scrolloff', 5)
opt('o', 'ignorecase', true)
opt('o', 'smartcase', true)
opt('o', 'foldenable', false)
opt('o', 'foldmethod', 'indent')
opt('o', 'foldlevel', 99)
opt('o', 'smartindent', true)
opt('o', 'autoindent', true)
opt('o', 'tabstop', 4)
opt('o', 'shiftwidth', 4)
opt('o', 'softtabstop', 4)
opt('o', 'smarttab', true)
opt('o', 'expandtab', true)
opt('o', 'hidden', true)
opt('o', 'wildmode', 'list:longest')
opt('o', 'ttyfast', true)
opt('o', 'title', true)
opt('o', 'encoding', 'utf-8')
opt('o', 'background', 'dark')
opt('o', 'guifont', 'JetBrainsMono Nerd Font Mono:h12')

g.neovide_remember_window_size = 1
g.neovide_input_use_logo = 1
g.neovide_cursor_vfx_mode = 'sonicboom'

g.dashboard_default_executive = 'Telescope'

local utils = require('telescope.utils')
local set_var = vim.api.nvim_set_var

g.edge_style = 'edge'

local colors = {
  red = '#ca1243',
  grey = '#a0a1a7',
  black = '#383a42',
  white = '#f3f3f3',
  light_green = '#83a598',
  orange = '#fe8019',
  green = '#8ec07c',
}

local theme = {
  normal = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.black, bg = colors.white },
    z = { fg = colors.white, bg = colors.black },
  },
  insert = { a = { fg = colors.black, bg = colors.light_green } },
  visual = { a = { fg = colors.black, bg = colors.orange } },
  replace = { a = { fg = colors.black, bg = colors.green } }
}

local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
  self.status = ''
  self.applied_separator = ''
  self:apply_highlights(default_highlight)
  self:apply_section_separators()
  return self.status
end

-- put proper separators and gaps between components in sections
local function process_sections(sections)
  for name, section in pairs(sections) do
    local left = name:sub(9, 10) < 'x'
    for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
      table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
    end
    for id, comp in ipairs(section) do
      if type(comp) ~= 'table' then
        comp = { comp }
        section[id] = comp
      end
      comp.separator = left and { right = '' } or { left = '' }
    end
  end
  return sections
end

local function search_result()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local last_search = vim.fn.getreg '/'
  if not last_search or last_search == '' then
    return ''
  end
  local searchcount = vim.fn.searchcount { maxcount = 9999 }
  return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

local function modified()
  if vim.bo.modified then
    return '+'
  elseif vim.bo.modifiable == false or vim.bo.readonly == true then
    return '-'
  end
  return ''
end

-- local function current_session()
--     local session_utils = require 'session_manager.utils'
--     local session_file = vim.v.this_session
--     if session_utils == nil or session_file == nil then
--         return ''
--     else
--         local session_name = session_utils.session_filename_to_dir(session_file)
--         return session_name or ''
--     end
-- end
local function current_lang()
    local file_type = vim.bo.filetype

end

require('lualine').setup {
  options = {
    theme = 'nord',
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = process_sections {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      {
        'diff',
        source = {'nvim'},
        diff_color = {
            add = { fg = colors.green },
            modified = { fg = colors.orange },
            removed = { fg = colors.red }
        }
      },
      {
        'diagnostics',
        source = { 'nvim' },
        sections = { 'error' },
        diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
        symbols = {error = ' '},
      },
      {
        'diagnostics',
        source = { 'nvim' },
        sections = { 'warn' },
        diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
        symbols = {error = ''}
      },
      { 'filename', file_status = false, path = 1 },
      { modified, color = { bg = colors.red } },
      {
        '%w',
        type='stl',
        cond = function()
          return vim.wo.previewwindow
        end,
      },
      {
        '%r',
        type='stl',
        cond = function()
          return vim.bo.readonly
        end,
      },
      {
        '%q',
        type='stl',
        cond = function()
          return vim.bo.buftype == 'quickfix'
        end,
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {{ search_result, 'filetype', type='stl'}},
    lualine_z = {{ '%l:%c', '%p%%/%L', type='stl'}},
  },
  inactive_sections = {
    lualine_c = {{ '%f %y %m', type='stl'}},
    lualine_x = {},
  },
}

require 'tabline'.setup {
    tabline_show_devicons = true,
    tabline_showbufnr = true,
    tabline_show_filename_only = true,
}
require 'hop'.setup()
cmd [[
  set guioptions-=e
  " set sessionoptions+=tabpages,globals
]]

cmd [[colorscheme molokai]]

local Path = require('plenary.path')
local telescope = require 'telescope'
telescope.setup {
    extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                           -- the default case_mode is "smart_case"
        }
    }
}
telescope.load_extension("workspaces")
telescope.load_extension('packer')
telescope.load_extension('fzf')

require 'Comment'.setup()
require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = true,
    filetype_exclude = {'help','dashboard','dashpreview','NvimTree','vista','sagahover', 'TelescopePrompt' }
}
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})
g.AutoPairsShortcutToggle = "<M-a>p"
g.AutoPairsMutilineClose = 0
require("todo-comments").setup {
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  -- highlight = {
  --   before = "", -- "fg" or "bg" or empty
  --   keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
  --   after = "fg", -- "fg" or "bg" or empty
  --   pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
  --   comments_only = true, -- uses treesitter to match keywords in comments only
  --   max_line_len = 400, -- ignore lines longer than this
  --   exclude = {}, -- list of file types to exclude highlighting
  -- },
  -- FIXME
  -- list of named colors where we try to extract the guifg from the
  -- list of hilight groups or use the hex color if hl not found as a fallback
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
-- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
}

-- Mason Setup // A LSP manager
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
require("mason-lspconfig").setup()

local rt = require("rust-tools")

rt.setup({
})

local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = '󰌵'})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Treesitter Plugin Setup 
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true }, 
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- nvim-tree setup
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end
require('nvim-tree').setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    on_attach = my_on_attach,
})

require('workspaces').setup({
    hooks = {
        open = { "NvimTreeOpen", "Telescope find_files" }
    }
})

