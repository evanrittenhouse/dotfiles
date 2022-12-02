local keymap = require('utils').keymap
local opts = require('utils').keymap_opts

require('trouble').setup()
keymap('n', '<Leader>tt', ':TroubleToggle document_diagnostics<CR>', opts)
