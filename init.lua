if vim.g.vscode then
    require 'plugins'
    require 'mapping_vscode'
else
    require 'plugins'
    require 'settings'
    require 'mapping'
    require 'lsp'

    local term_program = vim.env.TERM_PROGRAM
    if term_program ~= nil and string.sub(term_program, 1, 5) == 'iTerm' then
        vim.cmd('au VimLeave * set guicursor=a:ver25-blinkon1')
    end
end

