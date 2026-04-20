-- Creates a Telescope picker to navigate R scripts using folding sections
-- Sort of aerial plugin although based on my custom R folding sections rather than
-- on LSP
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

local function get_sections()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local items = {}

  for lnum, line in ipairs(lines) do
    local level, title = line:match("^%s*(##?)%s*([A-Z].*)$")
    if level and title then
      table.insert(items, {
        lnum = lnum,
        level = #level, -- 1 for #, 2 for ##
        text = title,
        line = line,
      })
    end
  end

  return items
end

function M.pick_sections(opts)
  opts = opts or {}

  local items = get_sections()

  pickers.new(opts, {
    prompt_title = "R Sections",
    finder = finders.new_table({
      results = items,
      entry_maker = function(entry)
        local indent = entry.level == 2 and "  " or ""
        return {
          value = entry,
          ordinal = entry.line,
          display = string.format("%4d  %s%s", entry.lnum, indent, entry.text),
          lnum = entry.lnum,
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      local function jump_to_selection()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if not selection then
          return
        end

        vim.api.nvim_win_set_cursor(0, { selection.value.lnum, 0 })
        vim.cmd("normal! zz")
      end

      actions.select_default:replace(jump_to_selection)

      map("i", "<C-v>", function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          vim.cmd("vsplit")
          vim.api.nvim_win_set_cursor(0, { selection.value.lnum, 0 })
          vim.cmd("normal! zz")
        end
      end)

      map("i", "<C-s>", function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          vim.cmd("split")
          vim.api.nvim_win_set_cursor(0, { selection.value.lnum, 0 })
          vim.cmd("normal! zz")
        end
      end)

      return true
    end,
  }):find()
end

return M
