local M = {}
M.plugins = function()
  return {
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
        provider = "litellm",
        auto_suggestions_provider = "litellm", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
        providers = {
          claude = {
            endpoint = "https://api.anthropic.com",
            model = "claude-3-7-sonnet-latest",
          },
          fastapply = {
            __inherited_from = "openai",
            api_key_name = "",
            endpoint = "http://localhost:11434/v1",
            model = "hf.co/Kortix/FastApply-7B-v1.0_GGUF:Q4_K_M",
          },
          litellm = {
            __inherited_from = "openai",
            endpoint = "https://litellm.ml.goodnotesbeta.com",
            model_name = "claude-3-7-sonnet-latest",
            api_key_name = "ANTHROPIC_AUTH_TOKEN",
          },
        },
        cursor_applying_provider = "fastapply",
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
    {
      "greggh/claude-code.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim", -- Required for git operations
      },
      -- keys = { { "<leader>ac", group = "Claude Code" }, { "<leader>acc", desc = "Toggle" } },
      config = function()
        require("claude-code").setup({})
      end,
    },
  }
end
return M
