local M = {}
M.plugins = function()
  return {
    {
      "David-Kunz/gen.nvim",
      config = function(opts)
        require("gen").setup({
          display_mode = "split", -- The display mode. Can be "float" or "split".
          -- model = "mistral", -- The default model to use.
          model = "codellama", -- The default model to use.
          --   show_prompt = true,     -- Shows the Prompt submitted to Ollama.
          --   show_model = true,      -- Displays which model you are using at the beginning of your chat session.
        })
        vim.keymap.set("v", "<LEADER>agg", ":'<,'>Gen<CR>")
        vim.keymap.set("n", "<LEADER>agc", ":Gen Chat<CR>")
      end,
    },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false, -- set this if you want to always pull the latest change
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
        provider = "claude", -- Recommend using Claude
        auto_suggestions_provider = "claude", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
        providers = {
          claude = {
            endpoint = "https://api.anthropic.com",
            model = "claude-3-5-sonnet-20241022",
          },
          fastapply = {
            __inherited_from = "openai",
            api_key_name = "",
            endpoint = "http://localhost:11434/v1",
            model = "hf.co/Kortix/FastApply-7B-v1.0_GGUF:Q4_K_M",
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
  }
end
return M
