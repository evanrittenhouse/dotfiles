vim.g.startify_lists = {
  { type = 'dir', header = { '   Latest in '..vim.fn.getcwd()..':' } },
  { type = 'sessions', header = { '   Sessions' } },
  { type = 'bookmarks', header = { '   Bookmarks' } },
  { type = 'commands', header = { '   Commands' } }
}
