local function plugins()
	return { {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' }
	} }
end


local function init()
	vim.keymap.set('n', '<LEADER>pf', ":Telescope find_files<CR>", {});
end

return { plugins = plugins, init = init }
