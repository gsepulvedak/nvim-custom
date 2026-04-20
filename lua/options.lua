-- Line numbers and relative numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Make new windows open below or to the right
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Don't wrap lines so the cursor doesn't skip text when scrolling
vim.opt.wrap = false

-- Enable mouse mode (in case you want to resize a window!)
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Set TAB behaviour
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Make the clipboard reachable for "everybody"
vim.opt.clipboard = "unnamedplus"

-- Keep cursor at the middle of the screen when scrolling
vim.opt.scrolloff = 999

-- Enable "square" visual mode
vim.opt.virtualedit = "block"

-- Split window below when searching-replacing terms
vim.opt.inccommand = "split"

-- Enable ignore case in ':' commands
vim.opt.ignorecase = true

-- Enable term colors (however it didn't make a change)
vim.opt.termguicolors = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Set diagnostics to show as virtual text on current line (>= 0.11)
vim.diagnostic.config({
  virtual_text = { current_line = true },
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set default expr as fold method for R scripts foldng mainly
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.RCommentFold(v:lnum)"
