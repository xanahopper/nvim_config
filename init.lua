-- vim.env.PATH = '/Users/xana/.bytebm/bin:/usr/local/bin:/Users/xana/.pyenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/puppetlabs/bin:/usr/local/munki:/Library/Apple/usr/bin:/Users/xana/.cargo/bin:/Users/xana/Env/Flutterw/bin:/Users/xana/Env/flutter/bin:/Users/xana/Dev/Android/SDK/platform-tools:/Users/xana/Env/depot_tools'
require 'plugins'
require 'settings'
require 'mapping'
require 'lsp'

local term_program = vim.env.TERM_PROGRAM
if term_program ~= nil and string.sub(term_program, 1, 5) == 'iTerm' then
	vim.cmd('au VimLeave * set guicursor=a:ver25-blinkon1')
end


