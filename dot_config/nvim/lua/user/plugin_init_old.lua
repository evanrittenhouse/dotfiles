local M = {}

M.plugins = {
    'ggandor/lightspeed.nvim',
    config = function()
        require('lightspeed').setup({})
    end
}

return M
