local keymap = require('utils').keymap
local opts = require('utils').keymap_opts

require('trouble').setup()
keymap('n', '<Leader>td', ':TroubleToggle document_diagnostics<CR>', opts)
keymap('n', '<Leader>tw', ':TroubleToggle workspace_diagnostics<CR>', opts)
keymap('n', '<Leader>tc', ':TroubleClose<CR>', opts)
