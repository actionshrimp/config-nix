local M = {}
M.init = function()
  vim.api.nvim_create_user_command("W", ":w", {})
  vim.api.nvim_create_user_command("Wq", ":wq", {})
  vim.api.nvim_create_user_command("Wqa", ":wqa", {})
  vim.api.nvim_create_user_command("Qa", ":wqa", {})
  vim.api.nvim_create_user_command("E", ":e", {})

  -- vim.api.nvim_set_keymap('n', '<LEADER>fed', ":e $MYVIMRC<CR>", { noremap = true, silent = true });
  -- vim.api.nvim_create_user_command('EditVimrc', ':e $MYVIMRC', {})
  vim.keymap.set("n", "<LEADER>fed", ":e $MYVIMRC<CR>", { desc = "Edit init.lua" })
  vim.keymap.set("n", "<LEADER>feh", ":e ~/config-nix/home/default.nix<CR>", { desc = "Edit home/default.nix" })
  vim.keymap.set("n", "<LEADER>fec", ":e ~/config-nix/flake.nix<CR>", { desc = "Edit flake.nix" })
  vim.keymap.set(
    "n",
    "<LEADER>fek",
    ":e ~/config-nix/dotfiles/config/nvim/lua/keys.lua<CR>",
    { desc = "Edit keys.lua" }
  )
  vim.keymap.set("n", "<LEADER>fyy", function()
    local f = vim.fn.expand("%:p")
    vim.fn.setreg("+", f)
    print(f)
  end, { desc = "Copy current filename" })

  vim.keymap.set("n", "<LEADER>bd", "<CMD>bd<CR>")

  -- commenting
  vim.keymap.set("n", "<LEADER>cl", "gcc", { remap = true, desc = "Comment line" })
  vim.keymap.set("v", "<LEADER>cl", "gc", { remap = true, desc = "Comment selection" })

  -- system clipboard
  vim.keymap.set("v", "<LEADER>xy", '"+y', { remap = true, desc = "Clipboard yank" })
  vim.keymap.set("n", "<LEADER>xp", '"+p', { remap = true, desc = "Clipboard paste" })

  -- :help CTRL-W
  vim.keymap.set("n", "<LEADER>w<S-l>", "<C-w><S-l>", {})
  vim.keymap.set("n", "<LEADER>w<S-h>", "<C-w><S-h>", {})
  vim.keymap.set("n", "<LEADER>wm", "<C-w>o", {})

  vim.keymap.set("n", "<LEADER>tw", function()
    vim.cmd("set list!")
  end, { desc = "Toggle whitespace" })
  vim.keymap.set("n", "<LEADER>tl", function()
    vim.cmd("set wrap!")
  end, { desc = "Toggle linewrap" })

  vim.keymap.set("n", "<LEADER>mR", vim.lsp.buf.rename, { desc = "LSP Rename" })
  vim.keymap.set("n", "<LEADER>mgg", vim.lsp.buf.definition, { desc = "LSP definition" })
  vim.keymap.set("n", "<LEADER>mgt", vim.lsp.buf.type_definition, { desc = "LSP type definition" })
  vim.keymap.set("n", "<LEADER>mgb", "<C-o>", { desc = "Go back" })
  vim.keymap.set("n", "<LEADER>maa", vim.lsp.buf.code_action, { desc = "LSP Code action" })
  vim.keymap.set("n", "<LEADER>mbr", ":LspRestart<CR>", { desc = "LSP Restart" })

  vim.keymap.set("n", "<LEADER>gll", "<cmd>GitLink! browse<cr>", { desc = "Open blob URL" })
  vim.keymap.set("n", "<LEADER>glL", "<cmd>GitLink browse<cr>", { desc = "Copy blob URL" })
  vim.keymap.set("n", "<LEADER>glb", "<cmd>GitLink! blame<cr>", { desc = "Open blame URL" })
  vim.keymap.set("n", "<LEADER>glB", "<cmd>GitLink blame<cr>", { desc = "Copy blame URL" })
end
return M
