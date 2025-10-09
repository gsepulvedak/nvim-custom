return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod',                     lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },   -- Optional
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    
    local function set_save_location()
      local cwd = vim.fn.getcwd()
      local rproj_files = vim.fn.globpath(cwd, "*.R", false, true)

      if #rproj_files > 0 then
        vim.g.db_ui_save_location = "./sql"
      else
        vim.g.db_ui_save_location = "~/.local/share/db_ui"
      end
    end

    set_save_location()

  end,
}
