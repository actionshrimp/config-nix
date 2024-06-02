local M = {}
M.init = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix",
    callback = function(ev)
      vim.lsp.start({
        name = "nixd",
        cmd = { "nixd" },
        root_dir = vim.fs.root(ev.buf, { "flake.nix" }),
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
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
    end,
  })
end
return M
