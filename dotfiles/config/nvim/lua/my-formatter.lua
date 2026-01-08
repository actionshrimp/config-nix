local M = {}
M.plugins = function()
  return {
    {
      "stevearc/conform.nvim",
      config = function()
        vim.keymap.set("n", "<LEADER>m=b", vim.lsp.buf.format)

        local util = require("conform.util")
        ---@type conform.FileFormatterConfig
        local biome = {
          meta = {
            url = "https://biomejs.dev/reference/cli/#biome-format",
            description = "A toolchain for web projects, aimed to provide functionalities to maintain them. This config runs formatting *only* using in-place file editing (not stdin) to avoid emoji issues. See `biome-check` or `biome-organize-imports` for other options.",
          },
          command = util.from_node_modules("biome"),
          stdin = false,
          args = function(self, ctx)
            if self:cwd(ctx) then
              return { "format", "--write", "$FILENAME" }
            end
            -- only when biome.json{,c} don't exist
            return {
              "format",
              "--write",
              "--indent-style",
              vim.bo[ctx.buf].expandtab and "space" or "tab",
              "--indent-width",
              ctx.shiftwidth,
              "$FILENAME",
            }
          end,
          cwd = util.root_file({
            "biome.json",
            "biome.jsonc",
          }),
        }

        local biome_organize_imports = {
          meta = {
            url = "https://github.com/biomejs/biome",
            description = "A toolchain for web projects, aimed to provide functionalities to maintain them. This config runs import sorting *only* using in-place file editing (not stdin) to avoid emoji issues. See `biome` or `biome-check` for other options.",
          },
          command = util.from_node_modules("biome"),
          stdin = false,
          args = {
            "check",
            "--write",
            "--formatter-enabled=false",
            "--linter-enabled=false",
            "--assist-enabled=true",
            "$FILENAME",
          },
          cwd = util.root_file({
            "biome.json",
            "biome.jsonc",
          }),
        }

        require("conform").setup({
          async = true,
          format_on_save = function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500 }
          end,
          default_format_opts = {
            lsp_format = "fallback",
          },

          formatters = {
            ocamlformat_iml = {
              command = "ocamlformat",
              args = { "--impl", "--enable-outside-detected-project", "--name", "$FILENAME", "-" },
            },
            biome = vim.tbl_extend("force", biome, { require_cwd = true }),
            ["biome-organize-imports"] = vim.tbl_extend("force", biome_organize_imports, { require_cwd = true }),
            prettier = {
              require_cwd = true,
            },
            swiftformat = {
              meta = {
                url = "https://github.com/nicklockwood/SwiftFormat",
                description = "SwiftFormat relative bin setup",
              },
              command = "./binary/swiftformat",
              stdin = true,
              args = { "--stdinpath", "$FILENAME" },
              range_args = function(self, ctx)
                local startOffset = ctx.range.start[1]
                local endOffset = ctx.range["end"][1]

                return {
                  "--linerange",
                  startOffset .. "," .. endOffset,
                  "--stdinpath",
                  "$FILENAME",
                }
              end,
              cwd = require("conform.util").root_file({ "devenv.lock" }),
            },
          },

          -- :lua print(vim.bo.filetype)
          formatters_by_ft = {
            javascript = { "biome", "biome-organize-imports", "prettier" },
            json = { "biome", "biome-organize-imports", "prettier" },
            typescriptreact = { "biome", "biome-organize-imports", "prettier" },
            typescript = { "biome", "biome-organize-imports", "prettier" },
            lua = { "stylua" },
            terraform = { "terraform_fmt" },
            nix = { "nixfmt" },
            ocaml = { "ocamlformat" },
            iml = { "ocamlformat_iml" },
            swift = { "swiftformat", lsp_format = "never" },
          },
        })

        vim.api.nvim_create_user_command("FormatDisable", function(args)
          if args.bang then
            -- FormatDisable! will disable formatting just for this buffer
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
        end, {
          desc = "Disable autoformat-on-save",
          bang = true,
        })
        vim.api.nvim_create_user_command("FormatEnable", function()
          vim.b.disable_autoformat = false
          vim.g.disable_autoformat = false
        end, {
          desc = "Re-enable autoformat-on-save",
        })
      end,
    },
  }
end
return M
