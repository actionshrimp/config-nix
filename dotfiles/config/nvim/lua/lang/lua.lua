-- Create an event handler for the FileType autocommand
vim.api.nvim_create_autocmd('FileType', {
  -- This handler will fire when the buffer's 'filetype' is "python"
  pattern = 'lua',
  callback = function(ev)
    vim.lsp.start({
      name = 'lua-language-server',
      cmd = {'lua-language-server'},
      -- Set the "root directory" to the parent directory of the file in the
      -- current buffer (`ev.buf`) that contains either a "setup.py" or a
      -- "pyproject.toml" file. Files that share a root directory will reuse
      -- the connection to the same LSP server.
      root_dir = vim.fs.root(ev.buf, {'.luarc.json'}),
    })
  end,
})
