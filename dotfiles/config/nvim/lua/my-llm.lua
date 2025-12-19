local M = {}
M.plugins = function()
  return {
    {
      {
        "folke/sidekick.nvim",
        lazy = false,
        dependencies = {
          "zbirenbaum/copilot.vim",
          "copilotlsp-nvim/copilot-lsp",
        },
        config = function(args)
          vim.lsp.enable("copilot")
          vim.lsp.config("copilot", {})
          require("sidekick").setup(args.opts)
        end,
        opts = {
          -- add any options here
          cli = {
            mux = {
              backend = "zellij",
              enabled = true,
              create = "split",
            },
            win = {
              keys = {
                buffers = { "<c-]>", "buffers", mode = "nt", desc = "open buffer picker" },
                files = { "<c-f>", "files", mode = "nt", desc = "open file picker" },
                hide_n = { "q", "hide", mode = "n", desc = "hide the terminal window" },
                prompt = { "<c-p>", "prompt", mode = "t", desc = "insert prompt or context" },
                stopinsert = { "<c-q>", "stopinsert", mode = "t", desc = "enter normal mode" },
                hide_ctrl_dot = nil,
                -- Navigate windows in terminal mode. Only active when:
                -- * layout is not "float"
                -- * there is another window in the direction
                -- With the default layout of "right", only `<c-h>` will be mapped
                nav_left = { "<c-h>", "nav_left", expr = true, desc = "navigate to the left window" },
                nav_down = { "<c-j>", "nav_down", expr = true, desc = "navigate to the below window" },
                nav_up = { "<c-k>", "nav_up", expr = true, desc = "navigate to the above window" },
                nav_right = { "<c-l>", "nav_right", expr = true, desc = "navigate to the right window" },
              },
            },
          },
        },
        keys = {
          {
            "<tab>",
            function()
              -- if there is a next edit, jump to it, otherwise apply it if any
              if not require("sidekick").nes_jump_or_apply() then
                return "<Tab>" -- fallback to normal tab
              end
            end,
            expr = true,
            desc = "Goto/Apply Next Edit Suggestions ",
            mode = { "n" },
          },
          {
            "<S-tab>",
            function()
              -- clear the next edit suggestions
              require("sidekick.nes").clear()
            end,
            expr = true,
            desc = "Clear Next Edit Suggestions",
            mode = { "n" },
          },
          --   {
          --     "<c-.>",
          --     function()
          --       require("sidekick.cli").toggle()
          --     end,
          --     desc = "Sidekick Toggle",
          --     mode = { "n", "t", "i", "x" },
          --   },
          --   {
          --     "<leader>aa",
          --     function()
          --       require("sidekick.cli").toggle()
          --     end,
          --     desc = "Sidekick Toggle CLI",
          --   },
          --   {
          --     "<leader>at",
          --     function()
          --       require("sidekick.cli").send({ msg = "{this}" })
          --     end,
          --     mode = { "x", "n" },
          --     desc = "Send This",
          --   },
          --   {
          --     "<leader>af",
          --     function()
          --       require("sidekick.cli").send({ msg = "{file}" })
          --     end,
          --     desc = "Send File",
          --   },
          --   {
          --     "<leader>ap",
          --     function()
          --       require("sidekick.cli").prompt()
          --     end,
          --     mode = { "n", "x" },
          --     desc = "Sidekick Select Prompt",
          --   },
        },
      },
    },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false, -- set this if you want to always pull the latest change
      mode = "legacy",
      opts = {
        -- provider = "openai",
        -- auto_suggestions_provider = "openai",
        -- openai = {
        --   endpoint = "https://api.openai.com/v1",
        --   model = "gpt-4o",
        --   timeout = 30000, -- Timeout in milliseconds
        --   temperature = 0,
        --   max_tokens = 4096,
        --   ["local"] = false,
        -- },
        -- provider = "litellm_claude_sonnet",
        providers = {
          claude = {
            endpoint = "https://api.anthropic.com",
            model = "claude-sonnet-4-20250514",
            -- timeout = 30000, -- Timeout in milliseconds
            extra_request_body = {
              -- temperature = 0.75,
              -- max_tokens = 20480,
            },
          },
        },

        behaviour = {
          auto_suggestions = false,
          enable_cursor_planning_mode = false,
        },

        mappings = {
          -- NOTE: The following will be safely set by avante.nvim
          ask = "<leader>aaa",
          edit = "<leader>aae",
          refresh = "<leader>aar",
          focus = "<leader>aaf",
          toggle = {
            default = "<leader>aat",
            debug = "<leader>aad",
            hint = "<leader>aah",
            suggestion = "<leader>aas",
            repomap = "<leader>aaR",
          },
        },
      },
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          "MeanderingProgrammer/render-markdown.nvim",
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },
  }
end
return M
