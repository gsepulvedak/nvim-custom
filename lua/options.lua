-- Line numbers and relative numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Make new windows open below or to the right
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Don't wrap lines so the cursor doesn't skip text when scrolling
vim.opt.wrap = false

-- Set TAB behaviour
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

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

