local function plugins()
	return { }
end

local function init()
	vim.diagnostic.config({ virtual_text = false })
	vim.keymap.set('n', '<LEADER>m=b', vim.lsp.buf.format);
	vim.keymap.set('n', '<LEADER>el', ":Telescope diagnostics<CR>", {});
end

return { plugins = plugins, init = init }
