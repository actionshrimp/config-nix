local function plugins()
	return { {
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})
		end
	} }
end


local function init()
	vim.keymap.set('n', '<LEADER>pf', ":FzfLua files<CR>", {});
end

return { plugins = plugins, init = init }
