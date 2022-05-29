local alpha = require'alpha'
local startify = require'alpha.themes.startify'
local if_nil = vim.F.if_nil

startify.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}

local curr_cwd = vim.fn.getcwd()
startify.section.top_buttons.val = {
    startify.button( "e", "  New file" , ":ene <BAR> startinsert <CR>"),
    startify.button( "e", "  > New file" , ":ene <BAR> startinsert <CR>"),
    startify.button( "f", "  > Find file in current directory", ":cd " .. curr_cwd .. " | Telescope git_files<CR>"),
    startify.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
    startify.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
}

-- disable MRU
startify.section.mru.val = { { type = "padding", val = 0 } }

-- disable MRU cwd
-- startify.section.mru_cwd.val = { { type = "padding", val = 0 } }

-- startify.section.mru_cwd.val = {
--     { type = "padding", val = 1 },
--     { 
--         type = "group",
--         val = function()
--             return { mru(0, vim.fn.getcwd()) }
--         end,
--         opts = { shrink_margin = false }
--     }
-- }

-- disable nvim_web_devicons
startify.nvim_web_devicons.enabled = true
-- startify.nvim_web_devicons.highlight = false
-- startify.nvim_web_devicons.highlight = 'Keyword'

startify.section.footer = {
    { type = "text", val = "footer" },
}

-- ignore filetypes in MRU
-- startify.mru_opts.ignore = function(path, ext)
--     return
--             (string.find(path, "COMMIT_EDITMSG"))
--         or  (vim.tbl_contains(default_mru_ignore, ext))
-- end

alpha.setup(startify.opts)
   
