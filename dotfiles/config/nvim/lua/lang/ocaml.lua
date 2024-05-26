local function init()
	-- :lua print(vim.bo.filetype)
	vim.api.nvim_create_autocmd('FileType', {
		pattern = 'ocaml',
		callback = function(ev)
			vim.lsp.start({
				name = 'ocaml-lsp-server',
				cmd = { 'ocamllsp' },
				root_dir = vim.fs.root(ev.buf, { 'dune-project' }),
			})
		end,
	})
end

return { init = init }
