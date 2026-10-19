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
  ];
}
