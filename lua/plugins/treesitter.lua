return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
  },
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          "bash",
          "c",
          "html",
          "julia",
          "lua",
          "luadoc",
          "markdown",
          "markdown_inline",
          "python",
          "r",
          "rnoweb",
          "regex",
          "vim",
          "vimdoc",
          "yaml",
        },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { "ruby" },
          -- Enable injections for markdown fenced code blocks
          injections = {
            enable = true,
          },
        },
        indent = {
          enable = true,
          disable = { "ruby" },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Leader>is",
            node_incremental = "<C-I>",
            node_decremental = "<C-D>",
            scope_incremental = "<C-S>",
          },
        },
        textobjects = { -- this requires nvim-treesitter-textobjects module
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj
            keymaps = {
              ["oa"] = { query = "@assignment.outer", desc = "Select [a]round [o]perator" },
              ["oi"] = { query = "@assignment.inner", desc = "Select [i]nside [o]perator" },
              ["ol"] = { query = "@assignment.lhs", desc = "Select [o]perator [l]hs" },
              ["or"] = { query = "@assignment.rhs", desc = "Select [o]perator [r]hs" },
              ["af"] = "@call.outer",
              ["if"] = "@call.inner",
              ["al"] = { query = "@loop.outer", desc = "Select [a]round [l]oop" },
              ["il"] = { query = "@loop.inner", desc = "Select [i]nside [l]oop" },
              ["ab"] = { query = "@statement.outer", desc = "Select [a]round [b]races" },
              ["ib"] = { query = "@statement.inner", desc = "Select [i]nside [b]races" },
              ["po"] = { query = "@parameter.outer", desc = "Select [p]arameters" },
              ["pi"] = { query = "@parameter.inner", desc = "Select [p]arameters" },
              ["ac"] = { query = "@comment.block", desc = "Select [a]round [c]omments" },
              ["se"] = { query = "@select_expression", desc = "Select [e]xpression" },
              ["re"] = { query = "@sql_relation", desc = "Select sql [re]lation" },
              ["be"] = { query = "@sql_binary_expression", desc = "Select sql [b]inary [e]xpression" },
            },
          },
          swap = {
            enable = false,
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]f"] = { query = "@call.outer", desc = "Next function call start" },
              ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
              ["]c"] = { query = "@comment.block", desc = "Next class start" },
              ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
              ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
              ["]]"] = { query = "@assignment.outer", desc = "Next code chunk" },
            },
            goto_next_end = {
              ["]F"] = { query = "@call.outer", desc = "Next function call end" },
              ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
              ["]C"] = { query = "@comment.block", desc = "Next class end" },
              ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
              ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
            },
            goto_previous_start = {
              ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
              ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
              ["[c"] = { query = "@comment.block", desc = "Prev class start" },
              ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
              ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
              ["[["] = { query = "@assignment.outer", desc = "Prev code chunk" },
            },
            goto_previous_end = {
              ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
              ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
              ["[C"] = { query = "@comment.blokck", desc = "Prev class end" },
              ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
              ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
            },
          },
        },
    })
      -- Associate quarto/rmarkdown filetypes with markdown parser
      vim.treesitter.language.register("markdown", { "rmarkdown", "quarto" })
      -- Make textobj moves repeatable on the usual vim keys:
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
