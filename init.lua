-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load nvim options
require("options")

-- Load keymaps
require("keymaps")

-- Load lsp servers. To add more servers, edit ./lua/lsp.lua
require("lsp")

-- Install or load lazy.lua
require("config.lazy")

-- Configure database connections for dadbod-ui
require("db-connections")

-- Configure custom R-folds according to expression
require("r_folds")
