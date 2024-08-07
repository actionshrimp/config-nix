local M = {}
M.plugins = function()
  return {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    {
      "hrsh7th/nvim-cmp",
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
          }),
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
          }),
        })
      end,
    },
  }
end
return M
