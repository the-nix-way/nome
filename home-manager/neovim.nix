{ pkgs }:

{
  enable = true;
  # Sets alias vim=nvim
  vimAlias = true;

  extraConfig = builtins.readFile ./config/.vimrc;

  # Neovim plugins
  plugins = with pkgs.vimPlugins; [
    ctrlp-vim
    gruvbox
    nerdtree
    tabular
    tokyonight-nvim
    vim-cpp-enhanced-highlight
    vim-nix
    {
      # Tree-sitter parsers and queries; highlighting is enabled per filetype
      plugin = nvim-treesitter.withPlugins (p: [ p.meson ]);
      type = "lua";
      config = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "meson" },
          callback = function() vim.treesitter.start() end,
        })
      '';
    }
  ];
}
