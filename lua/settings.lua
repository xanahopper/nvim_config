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
opt('o', 'cursorcolumn', true)
opt('o', 'cursorline', true)
opt('o', 'visualbell', false)
opt('o', 'errorbells', false)
opt('o', 'tm', 500)
opt('o', 'scrolloff', 5)
opt('o', 'ignorecase', true)
opt('o', 'smartcase', true)
opt('o', 'foldenable', true)
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
opt('o', 'guifont', 'JetBrainsMono Nerd Font Mono:12h')
g.edge_style = 'edge'

cmd [[
  au FocusLost * :set norelativenumber number
  au FocusGained * :set relativenumber

  au InsertEnter * :set norelativenumber number
  au InsertLeave * :set relativenumber

  au Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|DONE\|XXX\|BUG\|HACK\)')
  au Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')
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

-- Put proper separators and gaps between components in sections
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

require('lualine').setup {
  options = {
    theme = 'powerline',
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
    lualine_y = { search_result, 'filetype' },
    lualine_z = { '%l:%c', '%p%%/%L' },
  },
  inactive_sections = {
    lualine_c = { '%f %y %m' },
    lualine_x = {},
  },
}

require 'tabline'.setup {
    tabline_show_devicons = true,
    tabline_showbufnr = false,
    tabline_show_filename_only = true,
}
require 'hop'.setup()
cmd [[
  set guioptions-=e
  set sessionoptions+=tabpages,globals
]]

cmd [[colorscheme molokai]]

-- Edge

require 'telescope'.setup()

