local M = {}

M.plugins = function()
  return {
    {
      "mfussenegger/nvim-dap",
      config = function()
        local dap = require("dap")
        local suffix = "/bin/js-debug"
        local whichpath = vim.trim(vim.system({ "which", "js-debug" }, { text = true }):wait().stdout)
        local realpath = vim.trim(vim.system({ "realpath", whichpath }, { text = true }):wait().stdout)
        local debugger_path = string.sub(realpath, 0, -(#suffix + 1))

        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              debugger_path .. "/lib/node_modules/js-debug/dist/src/dapDebugServer.js",
              "${port}",
            },
          },
        }

        for _, language in ipairs({ "typescript", "javascript" }) do
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Debug Mocha Tests",
              -- trace = true, -- include debugger info
              runtimeExecutable = "node",
              runtimeArgs = {
                "./node_modules/vitest/dist/cli.js",
              },
              rootPath = "${workspaceFolder}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
            },
          }
        end
      end,
    },
  }
end
return M
