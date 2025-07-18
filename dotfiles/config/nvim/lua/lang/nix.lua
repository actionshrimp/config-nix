local M = {}
M.init = function()
  vim.lsp.enable("nixd")
  vim.lsp.config("nixd", {
    autostart = false,
    timeout = 2000,
    settings = {
      nixd = {
        nixpkgs = {
          -- expr = "import <nixpkgs> {}",
          -- # note this only completes on a with pkgs; [ .. ] block
          -- # see https://github.com/nix-community/nixd/issues/492
          expr = 'import (builtins.getFlake ("git+file://" + toString ./.)).inputs.nixpkgs { }',
        },
        options = {
          nixos = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations."baracus-hyperv".options',
          },
          nix_darwin = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).darwinConfigurations."marco".options',
          },
          home_manager = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."marco".options',
          },
        },
      },
    },
  })
  -- vim.api.nvim_create_autocmd("FileType", {
  --   pattern = "nix",
  --   callback = function(ev)
  --     vim.lsp.start({
  --       name = "nixd",
  --       cmd = { "nixd" },
  --       root_dir = vim.fs.root(ev.buf, { "flake.nix" }),
  --       settings = {
  --         timeout = 2000,
  --         nixd = {
  --           nixpkgs = {
  --             -- expr = "import <nixpkgs> {}",
  --             -- # note this only completes on a with pkgs; [ .. ] block
  --             -- # see https://github.com/nix-community/nixd/issues/492
  --             expr = 'import (builtins.getFlake ("git+file://" + toString ./.)).inputs.nixpkgs { }',
  --           },
  --           options = {
  --             nixos = {
  --               expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations."baracus-hyperv".options',
  --             },
  --             nix_darwin = {
  --               expr = '(builtins.getFlake ("git+file://" + toString ./.)).darwinConfigurations."marco".options',
  --             },
  --             home_manager = {
  --               expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."marco".options',
  --             },
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- })
end
return M
