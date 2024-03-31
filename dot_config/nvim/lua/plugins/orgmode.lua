-- overall tutorial: https://github.com/nvim-orgmode/orgmode/wiki/Getting-Started
-- docs: https://github.com/nvim-orgmode/orgmode/blob/master/DOCS.md
-- default keymaps: https://github.com/nvim-orgmode/orgmode/blob/master/lua/orgmode/config/defaults.lua
-- all actions: https://github.com/nvim-orgmode/orgmode/blob/master/lua/orgmode/config/mappings/init.lua

-- TODO: migrate to brain/org?
local ORG_DIR = "~/orgfiles/"
local DEFAULT_FILE = ORG_DIR .. "/refile.org"

local M = {
  "nvim-orgmode/orgmode",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", lazy = true },
  },
  -- ft = "Org",
  event = "VeryLazy",
  opts = {
    org_agenda_files = ORG_DIR .. "**/*.org",
    org_default_notes_file = DEFAULT_FILE,
    org_todo_keywords = {
      "IDEA(i)",
      "INCOMING(c)",
      "IN PROGRESS(p)",
      "BLOCKED(b)",
      "IN REVIEW(r)",
      "|", -- separates "unfinished" from "finished" states,
      "DONE(d)"
    },
    org_capture_templates = {
      t = {
        description = "TODO",
        template = "* TODO %?\n %u",
        target = DEFAULT_FILE
      },
      n = {
        description = "Note",
        template = "* %?\n%t\n\n**URL: [[url][desc]]\n\n **  ",
        target = DEFAULT_FILE
      }
    }
  },
}

return M
