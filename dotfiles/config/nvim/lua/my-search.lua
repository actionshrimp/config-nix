local M = {}

M.init = function()
  local s = require("snacks")
  require("which-key").add({
    {
      {
        mode = "n",
        -- project
        {
          "<leader>pp",
          s.picker.projects,
          desc = "Find project",
        },
        {
          "<leader>pf",
          s.picker.files,
          desc = "Find project",
        },

        -- buffer
        { "<leader>bb", s.picker.buffers, desc = "Buffers" },
        { "<leader>fr", s.picker.recent, desc = "Recent files" },
        { "<leader>rl", s.picker.resume, desc = "Resume search" },
        { "<leader>ry", s.picker.yanky, desc = "Clipboard" },

        -- search
        {
          "<LEADER>/",
          s.picker.grep,
          desc = "Search",
        },
        {
          "<LEADER>*",
          function()
            s.picker.grep_word({ live = true })
          end,
          desc = "Search word under cursor",
        },
        { "<LEADER>sc", ":noh<CR>", desc = "Clear search" },
        {
          "R",
          function()
            local w = vim.fn.expand("<cword>")
            return ":%S/" .. w .. "/"
          end,
          desc = "Replace in current file",
          expr = true,
        },
        {
          "<leader>R",
          function()
            local w = vim.fn.expand("<cword>")
            return ":'<,'>S/" .. w .. "/"
          end,
          -- select first, then deselect to get your cursor to the right word you want to replace
          desc = "Replace in previous visual region",
          expr = true,
        },
      },
      {
        mode = { "v" },
        {

          {
            "R",
            function()
              local w = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
              return ":<C-w>%S/" .. w[1] .. "/"
            end,
            desc = "Replace in current file",
            expr = true,
          },
          {
            "<leader>R",
            function()
              local w = vim.fn.expand("<cword>")
              return ":S/" .. w .. "/"
            end,
            desc = "Replace in current visual region",
            expr = true,
          },
        },
      },
    },
  })

  -- /g flag for :%s on by default
  vim.cmd.set("gdefault")
  vim.cmd.set("ignorecase")
  vim.cmd.set("smartcase")
end

return M
