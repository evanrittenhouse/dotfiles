local set_vim_option  = require "utils".set_vim_option

-- Conceals text. In Markdown, this folds URLs so that only their display text is used
set_vim_option('conceallevel', 2)

-- See https://stackoverflow.com/a/50415982 for more on these
set_vim_option('textwidth', 0)
set_vim_option('number')
set_vim_option('wrapmargin', 0)
set_vim_option('wrap')
set_vim_option('linebreak')
set_vim_option('columns', 120)
