local function init()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function(ev)
      vim.lsp.start({
        name = 'lua-language-server',
        cmd = { 'lua-language-server' },
        root_dir = vim.fs.root(ev.buf, { '.luarc.json' }),
      })
    end,
  })
end

return { init = init }
