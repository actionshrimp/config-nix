local function plugins()
	return { {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' }
	} }
end


local function init()
	vim.keymap.set('n', '<LEADER>pf', ":Telescope find_files<CR>", {});
	vim.keymap.set('n', '<LEADER>/', ":Telescope live_grep<CR>", {});
	vim.keymap.set('n', '<LEADER>*', function()
	require('telescope.builtin').live_grep {default_text=vim.fn.expand("<cword>")}
	end);
end

return { plugins = plugins, init = init }
