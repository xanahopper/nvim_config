local M = {}

M.try_save_session = function()
    local session_file = vim.v.this_session
    if (session_file ~= nil) then
        vim.cmd [[:SaveSession]]
    end
end

M.try_complete_confirm = function()
    local remap = vim.api.nvim_set_keymap
    local npairs = require 'nvim-autopairs'

    if vim.fn.pumvisble() ~= 0 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            require 'complete'
    else
        return 
    end
end

return M
