local M = {}

M.try_save_session = function()
    local session_file = vim.v.this_session
    if (session_file ~= nil) then
        vim.cmd [[:SaveSession]]
    end
end

return M
