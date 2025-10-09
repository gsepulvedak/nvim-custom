vim.lsp.enable({
  -- In the v0.11 builtin LSP API, name the servers here to enable them
  "air",
  "lua_ls",
  "r_language_server",
})
-- This will trigger vim.lsp.config("*") for configs in lsp/*.lua
