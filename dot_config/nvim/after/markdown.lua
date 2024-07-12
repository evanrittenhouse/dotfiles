local set_vim_option = require "utils".set_vim_option

-- Conceals text. In Markdown, this folds URLs so that only their display text is used
set_vim_option('conceallevel', 2)
set_vim_option('textwidth', 120)
