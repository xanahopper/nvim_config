local cmd = vim.cmd

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

local indent = 4
local cmd = vim.cmd

local g = vim.g
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
opt('o', 'guifont', 'JetBrainsMono Nerd Font Mono:h13')

g.neovide_remember_window_size = 1
g.neovide_input_use_logo = 1
g.neovide_cursor_vfx_mode = 'sonicboom'

g.dashboard_default_executive = 'Telescope'

g.dashboard_custom_section = {
    a = {description = {"  Find File                 SPC f f"}, command = "Telescope find_files"},
    b = {description = {"  Recents                   SPC f h"}, command = "Telescope oldfiles"},
    c = {description = {"縷 Find Word                 SPC f g"}, command = "Telescope live_grep"},
    e = {description = {"  Sessions                  SPC f s"}, command = "Telescope sessions"},
    f = {description = {"  Load Last Session         SPC l s"}, command = "LoadLastSession!"},
    g = {description = {"  Update Plugins            SPC p u"}, command = "PackerUpdate"},
    h = {description = {"  Settings                  SPC e v"}, command = "edit $MYVIMRC"},
    i = {description = {"  Exit                      SPC q  "}, command = "exit"}
}
local utils = require('telescope.utils')
local set_var = vim.api.nvim_set_var

local git_root, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, vim.loop.cwd())

local function get_dashboard_git_status()
  local git_cmd = {'git', 'status', '-s', '--', '.'}
  local output = utils.get_os_command_output(git_cmd)
  set_var('dashboard_custom_footer', {'Git status', '', unpack(output)})
end

if ret ~= 0 then
  local is_worktree = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, vim.loop.cwd())
  if is_worktree[1] == "true" then
    get_dashboard_git_status()
  else
    set_var('dashboard_custom_footer', {'Not in a git directory'})
  end
else
    get_dashboard_git_status()
end
g.dashboard_custom_header = require 'const'.custom_dashboard_header
g.edge_style = 'edge'

cmd [[
  autocmd filetype netrw setl bufhidden=wipe
  " remove dashboard number autocmd
  au FileType dashboard,dashpreview,nvimtree,telescopeprompt set showtabline=0 | set nornu nonu | autocmd BufLeave <buffer> set showtabline=2 | autocmd BufEnter <buffer> set showtabline=0 nornu nonu
  fun! NumberToggle()
    if (&ft == 'dashboard')
        au! FocusLost *
        au! FocusGained *
        :set norelativenumber nonumber
    else
        au FocusLost <buffer> :set norelativenumber number
        au FocusGained <buffer> :set relativenumber
    endif
  endfunction

  au FileType * set rnu nonu | call NumberToggle()
  au InsertEnter * :set norelativenumber number
  au InsertLeave * :set relativenumber
  au FocusLost * :lua require 'utils'.try_save_session()
]]

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

local function current_session()
    local session_utils = require 'session_manager.utils'
    local session_file = vim.v.this_session
    if session_utils == nil or session_file == nil then
        return ''
    else
        local session_name = session_utils.session_filename_to_dir(session_file)
        return session_name or ''
    end
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
      },
      {
        'diagnostics',
        source = { 'nvim' },
        sections = { 'warn' },
        diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
      },
      { 'filename', file_status = false, path = 1 },
      { modified, color = { bg = colors.red } },
      {
        '%w',
        cond = function()
          return vim.wo.previewwindow
        end,
      },
      {
        '%r',
        cond = function()
          return vim.bo.readonly
        end,
      },
      {
        '%q',
        cond = function()
          return vim.bo.buftype == 'quickfix'
        end,
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { current_session, search_result, 'filetype' },
    lualine_z = { '%l:%c', '%p%%/%L' },
  },
  inactive_sections = {
    lualine_c = { '%f %y %m' },
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
  set sessionoptions+=tabpages,globals
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
require 'session_manager'.setup {
    sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),
    path_replacer = '__',
    colon_replacer = '++',
    autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
    autosave_last_session = true,
    autosave_ignore_not_normal = true,
    autosave_only_in_session = false
}
telescope.load_extension('sessions')
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
