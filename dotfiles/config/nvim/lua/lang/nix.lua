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
end
return M
