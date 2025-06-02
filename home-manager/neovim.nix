{ pkgs }:

{
  enable = true;
  # Sets alias vim=nvim
  vimAlias = true;

  extraConfig = (builtins.readFile ./config/.vimrc);

  # Neovim plugins
  plugins = with pkgs.vimPlugins; [
    catppuccin-nvim
    ctrlp
    editorconfig-vim
    gruvbox
    nerdtree
    tabular
    vim-cpp-enhanced-highlight
    vim-elixir
    vim-nix
  ];
}
