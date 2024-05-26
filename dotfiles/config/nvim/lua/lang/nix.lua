local function init()
	vim.api.nvim_create_autocmd('FileType', {
		pattern = 'nix',
		callback = function(ev)
			vim.lsp.start({
				name = 'nixd',
				cmd = { 'nixd' },
				root_dir = vim.fs.root(ev.buf, { 'flake.nix' }),
			})
		end,
	})
end

return { init = init }
