return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      local function project_root(start_dir)
        local markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" }
        local found = vim.fs.find(markers, { path = start_dir, upward = true, limit = 1 })
        if #found == 0 then
          return start_dir
        end
        return vim.fs.dirname(found[1])
      end

      local function resolve_python()
        local env_python = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
        if env_python then
          local candidate = vim.fs.joinpath(env_python, "bin", "python")
          if vim.uv.fs_stat(candidate) then
            return candidate
          end
        end

        local bufname = vim.api.nvim_buf_get_name(0)
        local start_dir = bufname ~= "" and vim.fs.dirname(bufname) or vim.uv.cwd()
        local root = project_root(start_dir)
        local env_names = { ".venv", "venv", "env", ".env" }

        for _, env_name in ipairs(env_names) do
          local env_dir = vim.fs.find(env_name, { path = root, upward = true, limit = 1, type = "directory" })[1]
          if env_dir then
            local python = vim.fs.joinpath(env_dir, "bin", "python")
            if vim.uv.fs_stat(python) then
              return python
            end
          end
        end

        return "python3"
      end

      require("nvim-dap-virtual-text").setup({
        commented = true,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
      })

      dapui.setup({
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "▸",
        },
      })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      dap.adapters.python = function(callback, config)
        local cwd = config.cwd
        if type(cwd) ~= "string" or cwd == "" or cwd:match("^%$%{") then
          cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
        end
        local root = project_root(cwd ~= "" and cwd or vim.uv.cwd())
        local env_python = resolve_python()

        callback({
          type = "executable",
          command = env_python,
          args = { "-m", "debugpy.adapter" },
          options = {
            source_filetype = "python",
            cwd = root,
          },
        })
      end

      dap.configurations.python = {
        {
          name = "Launch current file",
          type = "python",
          request = "launch",
          program = "${file}",
          cwd = "${fileDirname}",
          pythonPath = resolve_python,
          justMyCode = false,
          console = "integratedTerminal",
        },
      }

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: conditional breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: continue/start" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: step into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: step over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: step out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: open REPL" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: toggle UI" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: run last" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug: terminate" })
      vim.keymap.set({ "n", "v" }, "<leader>de", function()
        dapui.eval()
      end, { desc = "Debug: eval expression" })
      vim.keymap.set({ "n", "v" }, "<leader>dh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "Debug: hover value" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(args)
          vim.keymap.set("v", "<localleader>ds", function()
            require("dap-python").debug_selection()
          end, { buffer = args.buf, desc = "Debug selected Python" })
          vim.keymap.set("n", "<localleader>dm", function()
            require("dap-python").test_method()
          end, { buffer = args.buf, desc = "Debug nearest test method" })
          vim.keymap.set("n", "<localleader>dC", function()
            require("dap-python").test_class()
          end, { buffer = args.buf, desc = "Debug nearest test class" })
        end,
      })
    end,
  },
}
