-- ~/.config/nvim-custom/lua/r_folds.lua

local M = {}

local function get_header_level(line)
  -- Level 2: ## Title
  if line:match("^%s*##%s*[A-Z]") then
    return 2
  end

  -- Level 1: # Title
  -- Excludes ## because we check that first
  if line:match("^%s*#%s*[A-Z]") then
    return 1
  end

  return 0
end

local function build_fold_levels(bufnr)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_count, false)

  local levels = {}
  local current_level1 = false
  local current_level2 = false

  for i, line in ipairs(lines) do
    local header_level = get_header_level(line)

    if header_level == 1 then
      levels[i] = ">1"
      current_level1 = true
      current_level2 = false

    elseif header_level == 2 then
      if current_level1 then
        levels[i] = ">2"
        current_level2 = true
      else
        -- No parent level-1 section yet, so don't fold as level 2
        levels[i] = "0"
        current_level2 = false
      end

    else
      if current_level2 then
        levels[i] = "2"
      elseif current_level1 then
        levels[i] = "1"
      else
        levels[i] = "0"
      end
    end
  end

  vim.b[bufnr].r_comment_fold_levels = levels
  vim.b[bufnr].r_comment_fold_tick = vim.b[bufnr].changedtick
end

function _G.RCommentFoldExpr()
  local bufnr = vim.api.nvim_get_current_buf()
  local tick = vim.b[bufnr].changedtick

  if vim.b[bufnr].r_comment_fold_tick ~= tick then
    build_fold_levels(bufnr)
  end

  local levels = vim.b[bufnr].r_comment_fold_levels
  return (levels and levels[vim.v.lnum]) or "0"
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "r", "rmd", "quarto" },
  callback = function(args)
    local bufnr = args.buf

    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.RCommentFoldExpr()"
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldlevelstart = 99
    vim.opt_local.foldenable = true

    build_fold_levels(bufnr)
  end,
})

return M
