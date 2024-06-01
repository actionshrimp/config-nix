local M = {}
M.plugins = function()
  return {
    {
      "David-Kunz/gen.nvim",
      config = function(opts)
        require('gen').setup({
          display_mode = "split", -- The display mode. Can be "float" or "split".
          model = "llama3",       -- The default model to use.
          --   show_prompt = true,     -- Shows the Prompt submitted to Ollama.
          --   show_model = true,      -- Displays which model you are using at the beginning of your chat session.
        })
        vim.keymap.set('v', "<LEADER>agg", ":'<,'>Gen<CR>");
        vim.keymap.set('n', "<LEADER>agc", ":Gen Chat<CR>");
      end
    },
  }
end
return M
