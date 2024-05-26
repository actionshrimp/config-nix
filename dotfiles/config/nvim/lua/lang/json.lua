local function init()
	vim.api.nvim_create_autocmd('FileType', {
		pattern = 'json',
		callback = function(ev)
			vim.lsp.start({
				name = 'vscode-json-languageserver',
				cmd = { 'vscode-json-languageserver', "--stdio" },
			})
		end,
	})
end

return { init = init }
