local M = {}
M.init = function()
  vim.lsp.enable("sourcekit")
  vim.lsp.config("sourcekit", {
    cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
  })
end
return M
