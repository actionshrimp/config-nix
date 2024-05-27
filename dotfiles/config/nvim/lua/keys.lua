local function init()
  vim.api.nvim_create_user_command('W', ':w', {})
  vim.api.nvim_create_user_command('Wq', ':wq', {})
  vim.api.nvim_create_user_command('Wqa', ':wqa', {})

  -- vim.api.nvim_set_keymap('n', '<LEADER>fed', ":e $MYVIMRC<CR>", { noremap = true, silent = true });
  -- vim.api.nvim_create_user_command('EditVimrc', ':e $MYVIMRC', {})
  vim.keymap.set('n', '<LEADER>fed', ":e $MYVIMRC<CR>", { desc = "Edit init.lua" });
  vim.keymap.set('n', '<LEADER>feh', ":e ~/config-nix/home/default.nix<CR>", {});
  vim.keymap.set('n', '<LEADER>fec', ":e ~/config-nix/flake.nix<CR>", {});
  vim.keymap.set('n', '<LEADER>fek', ":e ~/config-nix/dotfiles/config/nvim/lua/keys.lua<CR>", {});
  vim.keymap.set('n', '<LEADER>fyy', function ()
    local f = vim.fn.expand('%:p')
    vim.fn.setreg("+", f)
    print(f)
  end, {});

  vim.keymap.set('n', '<LEADER>bd', "<CMD>bd<CR>");

  -- commenting
  vim.keymap.set('n', '<LEADER>cl', "gcc", { remap = true });
  vim.keymap.set('v', '<LEADER>cl', "gc", { remap = true });

  -- system clipboard
  vim.keymap.set('v', '<LEADER>xy', '"+y', { remap = true })
  vim.keymap.set('n', '<LEADER>xp', '"+p', { remap = true })

  -- :help CTRL-W
  vim.keymap.set('n', '<LEADER>w<S-l>', "<C-w><S-l>", {});
  vim.keymap.set('n', '<LEADER>w<S-h>', "<C-w><S-h>", {});
  vim.keymap.set('n', '<LEADER>wm', "<C-w>o", {});

  vim.keymap.set('n', '<LEADER>tw', function() vim.cmd('set list!') end, {});

  vim.keymap.set('n', '<LEADER>mrr', vim.lsp.buf.rename)
  vim.keymap.set('n', '<LEADER>mgg', vim.lsp.buf.definition)
  vim.keymap.set('n', '<LEADER>mgt', vim.lsp.buf.type_definition)
  vim.keymap.set('n', '<LEADER>mgb', "<C-o>", {})
  vim.keymap.set('n', '<LEADER>maa', vim.lsp.buf.code_action)

end

return { init = init }
