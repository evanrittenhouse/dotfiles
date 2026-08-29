local org_query

local function make_reverse_highlight(name)
  local reverse_name = name .. "Reverse"

  if vim.fn.synIDattr(reverse_name, "fg") ~= "" then
    return reverse_name
  end

  local highlight = vim.fn.synIDtrans(vim.fn.hlID(name))
  local gui_bg = vim.fn.synIDattr(highlight, "bg", "gui")
  local cterm_bg = vim.fn.synIDattr(highlight, "bg", "cterm")

  if gui_bg == "" then
    gui_bg = "None"
  end
  if cterm_bg == "" then
    cterm_bg = "None"
  end

  vim.cmd(string.format("highlight %s guifg=%s ctermfg=%s", reverse_name, gui_bg, cterm_bg))
  return reverse_name
end

local function parse_org(ctx)
  if not org_query then
    org_query = vim.treesitter.query.parse(
      "org",
      [[
        (headline (stars) @headline)
        (
          (expr) @dash
          (#match? @dash "^-----+$")
        )
        (block
          name: (expr) @_name
          (#match? @_name "(SRC|src)")
        ) @codeblock
        (paragraph . (expr) @quote
          (#eq? @quote ">")
        )
        (listitem
          bullet: (bullet) @number
          (#match? @number "^[0-9]+[.)]$")
        )
        (listitem
          bullet: (bullet) @checkbox_bullet
          checkbox: (checkbox) @checkbox
        )
      ]]
    )
  end

  local marks = {}
  local dash_highlight = "Dash"
  local dash_string = "-"
  local quote_highlight = "Quote"
  local quote_string = "┃"
  local codeblock_highlight = "CodeBlock"
  local bullets = { "◉", "○", "✸", "✿" }
  local headline_highlights = { "Headline" }
  local fat_headlines = false
  local fat_headline_upper_string = "▃"
  local fat_headline_lower_string = "🬂"
  local last_fat_headline = -1

  local bullet_highlights = {
    "@org.headline.level1",
    "@org.headline.level2",
    "@org.headline.level3",
    "@org.headline.level4",
    "@org.headline.level5",
    "@org.headline.level6",
    "@org.headline.level7",
    "@org.headline.level8",
  }

  local width = vim.api.nvim_win_get_width(0)
  local win_view = vim.fn.winsaveview()
  local left_offset = win_view.leftcol

  for id, node in org_query:iter_captures(ctx.root, ctx.buf) do
    local capture = org_query.captures[id]
    local start_row, start_column, end_row = node:range()

    if capture == "headline" then
      local text = vim.treesitter.get_node_text(node, ctx.buf)
      local level = #vim.trim(text)
      local hl_group = headline_highlights[math.min(level, #headline_highlights)]
      local bullet_hl_group = bullet_highlights[math.min(level, #bullet_highlights)]
      local virt_text = {}

      if #bullets > 0 then
        local bullet = bullets[((level - 1) % #bullets) + 1]
        virt_text[1] = {
          string.rep(" ", level - vim.fn.strwidth(bullet)) .. bullet,
          { hl_group, bullet_hl_group },
        }
      end

      table.insert(marks, {
        start_row = start_row,
        start_col = 0,
        opts = {
          end_col = 0,
          end_row = start_row + 1,
          hl_group = hl_group,
          virt_text = virt_text,
          virt_text_pos = "overlay",
          hl_eol = true,
        },
      })

      if fat_headlines then
        local reverse_hl_group = make_reverse_highlight(hl_group)
        local padding_above = { { fat_headline_upper_string:rep(width), reverse_hl_group } }

        if start_row > 0 then
          local line_above = vim.api.nvim_buf_get_lines(ctx.buf, start_row - 1, start_row, false)[1]

          if line_above == "" and start_row - 1 ~= last_fat_headline then
            table.insert(marks, {
              start_row = start_row - 1,
              start_col = 0,
              opts = {
                virt_text = padding_above,
                virt_text_pos = "overlay",
                virt_text_win_col = 0,
                hl_mode = "combine",
              },
            })
          else
            table.insert(marks, {
              start_row = start_row,
              start_col = 0,
              opts = {
                virt_lines_above = true,
                virt_lines = { padding_above },
              },
            })
          end
        end

        local padding_below = { { fat_headline_lower_string:rep(width), reverse_hl_group } }
        local line_below = vim.api.nvim_buf_get_lines(ctx.buf, start_row + 1, start_row + 2, false)[1]

        if line_below == "" then
          table.insert(marks, {
            start_row = start_row + 1,
            start_col = 0,
            opts = {
              virt_text = padding_below,
              virt_text_pos = "overlay",
              virt_text_win_col = 0,
              hl_mode = "combine",
            },
          })
          last_fat_headline = start_row + 1
        else
          table.insert(marks, {
            start_row = start_row,
            start_col = 0,
            opts = {
              virt_lines = { padding_below },
            },
          })
        end
      end
    elseif capture == "dash" then
      table.insert(marks, {
        start_row = start_row,
        start_col = 0,
        opts = {
          virt_text = { { dash_string:rep(width), dash_highlight } },
          virt_text_pos = "overlay",
          hl_mode = "combine",
        },
      })
    elseif capture == "codeblock" then
      table.insert(marks, {
        start_row = start_row,
        start_col = 0,
        opts = {
          end_col = 0,
          end_row = end_row,
          hl_group = codeblock_highlight,
          hl_eol = true,
        },
      })

      local start_line = vim.api.nvim_buf_get_lines(ctx.buf, start_row, start_row + 1, false)[1]
      local _, padding = start_line:find("^ +")
      local codeblock_padding = math.max((padding or 0) - left_offset, 0)

      if codeblock_padding > 0 then
        for row = start_row, end_row - 1 do
          table.insert(marks, {
            start_row = row,
            start_col = 0,
            opts = {
              virt_text = { { string.rep(" ", codeblock_padding), "Normal" } },
              virt_text_win_col = 0,
              priority = 1,
            },
          })
        end
      end
    elseif capture == "quote" then
      table.insert(marks, {
        start_row = start_row,
        start_col = start_column,
        opts = {
          virt_text = { { quote_string, quote_highlight } },
          virt_text_pos = "overlay",
          hl_mode = "combine",
        },
      })
    elseif capture == "number" then
      local text = vim.treesitter.get_node_text(node, ctx.buf)

      table.insert(marks, {
        start_row = start_row,
        start_col = start_column,
        opts = {
          end_row = start_row,
          end_col = start_column + #text,
          virt_text = { { text, "RenderMarkdownBullet" } },
          virt_text_pos = "overlay",
        },
      })
    elseif capture == "checkbox_bullet" then
      table.insert(marks, {
        start_row = start_row,
        start_col = start_column,
        opts = {
          end_row = start_row,
          end_col = start_column + 1,
          conceal = "",
        },
      })
    elseif capture == "checkbox" then
      local state = vim.treesitter.get_node_text(node, ctx.buf)
      local icon = "󰄱  "
      local highlight = "RenderMarkdownUnchecked"

      if state:match("%[[Xx]%]") then
        icon = "󰱒  "
        highlight = "RenderMarkdownChecked"
      elseif state == "[-]" then
        icon = "󰥔  "
        highlight = "RenderMarkdownTodo"
      end

      table.insert(marks, {
        start_row = start_row,
        start_col = start_column,
        opts = {
          end_row = start_row,
          end_col = start_column + 3,
          virt_text = { { icon, highlight } },
          virt_text_pos = "overlay",
        },
      })
    end
  end

  return marks
end

local M = {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
    'nvim-orgmode/orgmode',
  },
  opts = {
    file_types = { 'markdown', 'org' },
    custom_handlers = {
      org = {
        parse = parse_org,
      },
    },
  },
}

return M
