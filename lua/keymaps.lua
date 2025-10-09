-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`


-- Open a terminal
vim.keymap.set("n", "<leader>tr", ":70 vsplit term://bash<cr>", { desc = "Open a bash terminal to the right" })
vim.keymap.set("n", "<leader>tb", ":12 split term://bash<cr>", { desc = "Open a bash terminal below" })

-- dark/light mode toggle
local function toggle_theme()
  if vim.opt.background:get() == "dark" then
    vim.opt.background = "light"
    -- vim.cmd("colorscheme tokyonight-day")
  else
    vim.opt.background = "dark"
    -- vim.cmd("colorscheme tokyonight-moon")
  end
end

vim.keymap.set({ 'n', 't' }, "<leader>m", toggle_theme, {})

-- remap to insert pipe operator when working with R files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "r",
  callback = function()
    vim.keymap.set("i", "<C-p>", "<Esc>$a %>%", { buffer = true })
  end,
})

-- remap to remove pipe operator when working with R files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "r",
  callback = function()
    vim.keymap.set({ "i", "n" }, "<C-ñ>", "<Esc>$dF ", { buffer = true })
  end,
})
-- remap to get name of R data.frame object in script
vim.api.nvim_create_autocmd("FileType", {
  pattern = "r",
  callback = function()
    vim.keymap.set("n", "<leader>rn", function()
      local word = vim.fn.expand("<cword>")
      local cmd = "names(" .. word .. ")\n"
      require("iron.core").send(nil, { cmd })
    end, { desc = "Get data frame column names", noremap = true, silent = true })
  end,
})

-- remap to view R data.frame object
vim.api.nvim_create_autocmd("FileType", {
  pattern = "r",
  callback = function()
    vim.keymap.set("n", "<leader>rv", function()
      local word = vim.fn.expand("<cword>")
      local cmd = "View(" .. word .. ")\n"
      require("iron.core").send(nil, { cmd })
    end, { desc = "View data frame", noremap = true, silent = true })
  end,
})

-- R: map rL to ls()
vim.api.nvim_create_autocmd("FileType", {
  pattern = "r",
  callback = function()
    vim.keymap.set("n", "<leader>rL", function()
      local cmd = "ls()\n"
      require("iron.core").send(nil, { cmd })
    end, { desc = "[L]ist environment objects", noremap = true, silent = true })
  end,
})

-- R: map rr to nrow(df)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "r",
  callback = function()
    vim.keymap.set("n", "<leader>rr", function()
      local word = vim.fn.expand("<cword>")
      local cmd = "nrow(" .. word .. ")\n"
      require("iron.core").send(nil, { cmd })
    end, { desc = "Show number of [r]ows", noremap = true, silent = true })
  end,
})

-- R: map rg to glimpse(df)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "r",
  callback = function()
    vim.keymap.set("n", "<leader>rg", function()
      local word = vim.fn.expand("<cword>")
      local cmd = "dplyr::glimpse(" .. word .. ")\n"
      require("iron.core").send(nil, { cmd })
    end, { desc = "[G]limpse a dataframe", noremap = true, silent = true })
  end,
})

-- vim: ts=2 sts=2 sw=2 et
