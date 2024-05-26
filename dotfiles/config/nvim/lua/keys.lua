local function init()
	vim.api.nvim_create_user_command('W', ':w', {})
	vim.api.nvim_create_user_command('Wq', ':wq', {})
	vim.api.nvim_create_user_command('Wqa', ':wqa', {})

	-- vim.api.nvim_set_keymap('n', '<LEADER>fed', ":e $MYVIMRC<CR>", { noremap = true, silent = true });
	-- vim.api.nvim_create_user_command('EditVimrc', ':e $MYVIMRC', {})
	vim.keymap.set('n', '<LEADER>fed', ":e $MYVIMRC<CR>", { desc = "Edit init.lua" });
	vim.keymap.set('n', '<LEADER>feh', ":e ~/config-nix/home/default.nix<CR>", {});
	vim.keymap.set('n', '<LEADER>fec', ":e ~/config-nix/flake.nix<CR>", {});
	vim.keymap.set('n', '<LEADER>gs', ":Neogit<CR>", {});
	vim.keymap.set('n', '<LEADER>pt', ":Neotree<CR>", {});
	vim.keymap.set('n', '<LEADER>sc', ":noh<CR>", {});
	vim.keymap.set({'n', 'v'}, '<LEADER>cl', "gcc", { remap = true });

	-- :help CTRL-W
	vim.keymap.set('n', '<LEADER>w<S-l>', "<C-w><S-l>", {});
	vim.keymap.set('n', '<LEADER>w<S-h>', "<C-w><S-h>", {});
	vim.keymap.set('n', '<LEADER>wm', "<C-w>o", {});
end

return { init = init }
