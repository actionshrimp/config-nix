local M = {}
M.plugins = function()
  return {
    -- { "hrsh7th/cmp-nvim-lsp" },
    -- { "hrsh7th/cmp-buffer" },
    -- {
    --   "hrsh7th/nvim-cmp",
    --   config = function()
    --     local cmp = require("cmp")
    --     cmp.setup({
    --       sources = cmp.config.sources({
    --         { name = "nvim_lsp" },
    --         { name = "buffer" },
    --       }),
    --       mapping = cmp.mapping.preset.insert({
    --         ["<C-Space>"] = cmp.mapping.complete(),
    --       }),
    --     })
    --   end,
    -- },
    {
      "saghen/blink.compat",
      -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
      version = "*",
      -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
      lazy = true,
      -- make sure to set opts so that lazy.nvim calls blink.compat's setup
      opts = {},
    },

    {
      "saghen/blink.cmp",
      -- optional: provides snippets for the snippet source
      dependencies = "rafamadriz/friendly-snippets",

      -- use a release tag to download pre-built binaries
      version = "*",
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- See the full "keymap" documentation for information on defining your own keymap.
        keymap = { preset = "default" },
        completion = {
          menu = {
            -- auto_show = function(ctx)
            --   return ctx.mode ~= "cmdline"
            -- end,
          },
        },

        appearance = {
          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
          -- Useful for when your theme doesn't support blink.cmp
          -- Will be removed in a future release
          use_nvim_cmp_as_default = true,
          -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = "mono",
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
            "avante_commands",
            "avante_mentions",
            "avante_files",
          },
          providers = {
            avante_commands = {
              name = "avante_commands",
              module = "blink.compat.source",
              score_offset = 90, -- show at a higher priority than lsp
              opts = {},
            },
            avante_files = {
              name = "avante_files",
              module = "blink.compat.source",
              score_offset = 100, -- show at a higher priority than lsp
              opts = {},
            },
            avante_mentions = {
              name = "avante_mentions",
              module = "blink.compat.source",
              score_offset = 1000, -- show at a higher priority than lsp
              opts = {},
            },
          },
        },
      },
      opts_extend = { "sources.default" },
    },
  }
end
return M
