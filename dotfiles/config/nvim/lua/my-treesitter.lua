local M = {}

-- Parsers we want available. The `main` branch has no `ensure_installed`
-- option; `install()` is asynchronous and a no-op for parsers already present.
local ensure_installed = {
  "eex",
  "elixir",
  "gleam",
  "go",
  "gotmpl",
  "hcl", -- terraform
  "heex",
  "helm",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline", -- fenced code blocks, used by render-markdown.nvim
  "ocaml",
  "regex",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

-- Filetypes to leave alone: orgmode manages its own parser, highlighting and
-- indentation.
local ignore_filetypes = { org = true }

local function on_filetype(ev)
  if ignore_filetypes[vim.bo[ev.buf].filetype] then
    return
  end

  -- Fails when no parser is installed for this filetype, which is fine.
  if not pcall(vim.treesitter.start, ev.buf) then
    return
  end

  vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

-- Incremental selection, which the `main` branch no longer provides.
-- `selections[bufnr]` is the stack of nodes we have grown through, so that
-- decrementing can walk back down it.
local selections = {}

local function select_node(node)
  local srow, scol, erow, ecol = node:range()
  if ecol == 0 then
    erow = erow - 1
    ecol = #vim.api.nvim_buf_get_lines(0, erow, erow + 1, true)[1]
  end

  vim.cmd("normal! \27")
  vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, 0) })
end

local function init_selection()
  -- get_node() only looks at trees that have already been parsed.
  local ok, parser = pcall(vim.treesitter.get_parser)
  if not ok or not parser then
    return
  end
  parser:parse(true)

  local node = vim.treesitter.get_node()
  if not node then
    return
  end
  selections[vim.api.nvim_get_current_buf()] = { node }
  select_node(node)
end

local function node_incremental()
  local buf = vim.api.nvim_get_current_buf()
  local stack = selections[buf]
  if not stack or #stack == 0 then
    return init_selection()
  end

  local node = stack[#stack]
  -- Skip ancestors that cover exactly the same range, so each press visibly
  -- grows the selection.
  local parent = node:parent()
  while parent and vim.deep_equal({ parent:range() }, { node:range() }) do
    parent = parent:parent()
  end
  if not parent then
    return select_node(node)
  end

  table.insert(stack, parent)
  select_node(parent)
end

local function node_decremental()
  local buf = vim.api.nvim_get_current_buf()
  local stack = selections[buf]
  if not stack or #stack < 2 then
    return
  end

  table.remove(stack)
  select_node(stack[#stack])
end

M.plugins = function()
  return {
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      -- The `main` branch does not support lazy-loading.
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter").install(ensure_installed)

        -- Highlighting and indentation are opt-in per buffer on `main`.
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("my-treesitter", { clear = true }),
          callback = on_filetype,
        })

        vim.keymap.set("n", "<cr>", init_selection, { desc = "Treesitter: init selection" })
        vim.keymap.set("x", "L", node_incremental, { desc = "Treesitter: grow selection" })
        vim.keymap.set("x", "H", node_decremental, { desc = "Treesitter: shrink selection" })
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      opts = {
        select = {
          -- Jump forward to the textobject, similar to targets.vim.
          lookahead = true,
        },
      },
      -- Keymaps use e.g.
      --   require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      --   require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
      --   require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
    },
    {
      "Wansmer/treesj",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("treesj").setup({
          use_default_keymaps = false,
          max_join_length = 2048,
        })

        vim.keymap.set("n", "<LEADER>tj", function()
          require("treesj").toggle()
        end, { desc = "Treesitter Join (toggle)" })
      end,
    },
  }
end
M.init = function() end
return M
