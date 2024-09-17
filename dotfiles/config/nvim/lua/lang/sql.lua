local M = {}
M.plugins = function()
  return {
    {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-ui",
      {
        "kristijanhusak/vim-dadbod-completion",
        config = function()
          vim.g["db_ui_execute_on_save"] = 0
          vim.g["db_ui_use_nerd_fonts"] = 1
          require("cmp").setup.filetype({ "sql" }, {
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
            },
          })
        end,
      },
    },
  }
end
M.init = function()
  vim.keymap.set("n", "<LEADER>ass", ":DBUIToggle<CR>", { desc = "DBUI" })
end
return M
