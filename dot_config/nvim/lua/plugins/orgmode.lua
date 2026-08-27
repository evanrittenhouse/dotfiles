local M = {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  config = function()
    local journal_datetree = {
      tree_type = "custom",
      tree = {
        {
          format = "<%Y-%m-%d>",
          pattern = "^<(%d%d%d%d)%-(%d%d)%-(%d%d)>$",
          order = { 1, 2, 3 },
        },
      },
    }

    require("orgmode").setup({
      org_agenda_files = "~/orgfiles/**/*",
      org_default_notes_file = "~/orgfiles/refile.org",
      org_todo_keywords = {
        "TODO(t)",
        "IN-PROGRESS(p)",
        "REVIEW(r)",
        "BLOCKED(b)",
        "|",
        "DONE(d)",
        "CANCELLED(c)",
      },
      org_capture_templates = {
        t = {
          description = "Task",
          template = "* TODO %?\n  %U",
          target = "~/orgfiles/refile.org",
        },
        i = {
          description = "Idea",
          template = "* %? :idea:\n  %U",
          target = "~/orgfiles/refile.org",
        },
        s = {
          description = "Standup",
          template = "* Standup\n%?",
          target = "~/orgfiles/journal.org",
          datetree = journal_datetree,
        },
        n = {
          description = "Work note",
          template = "* %^{Title}\n  %U\n\n  %?",
          target = "~/orgfiles/journal.org",
          datetree = journal_datetree,
        },
      },
    })

    vim.lsp.enable("org")
  end
}

return M
