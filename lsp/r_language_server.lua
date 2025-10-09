---@brief
---
--- [languageserver](https://github.com/REditorSupport/languageserver) is an
--- implementation of the Microsoft's Language Server Protocol for the R
--- language.
---
--- It is released on CRAN and can be easily installed by
---
--- ```r
--- install.packages("languageserver")
--- ```
return {
  cmd = { 'R', '--no-echo', '-e', 'languageserver::run()' },
  filetypes = { "r", "quarto", "rmarkdown" },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, '.git') or vim.uv.os_homedir())
  end,
  settings = {
    r = {
      lsp = {
        rich_documentation = false,
        lintr_cache_directory = ".lintr_cache",
        -- Enable lintr for embedded R code in quarto/rmarkdown
        lintr_on_save = true,
      },
      server_capabilities = {
        documentFormattingProvider = false,
        documentRangeFormattingProvider = false,
      }
    },
  },
}
