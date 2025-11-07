return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      require("mini.files").setup({
        windows = { preview = true },
      })
      local minifiles_toggle = function(...)
        if not MiniFiles.close() then MiniFiles.open(...) end
      end
      vim.keymap.set('n', '<leader>F', minifiles_toggle, { desc = "Toggle mini.files buffer" })

      require("mini.ai").setup()
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
