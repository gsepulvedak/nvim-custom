vim.lsp.enable({
  -- In the v0.11 builtin LSP API, name the servers here to enable them
  "air",
  "lua_ls",
  "r_language_server",
  "pylsp",

  -- Enable folding capacity for ufo plugin
  opts = {
    capabilities = {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
  },
})
-- This will trigger vim.lsp.config("*") for configs in lsp/*.lua
