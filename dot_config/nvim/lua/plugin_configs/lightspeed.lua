local keymap = require('utils').keymap
local opts = require('utils').keymap_opts

require('lightspeed').setup{}
keymap('n', 's', '<Plug>Lightspeed_omni_s', opts)
