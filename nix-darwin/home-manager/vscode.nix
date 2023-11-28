{ pkgs }:

let
  font = "CascadiaCode";
  terminalFont = "Iosevka";
  colorTheme = "GitHub Dark Dimmed";
  iconTheme = "material-icon-theme";

  ext = publisher: name: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = { inherit name publisher sha256 version; };
  };
in
{
  enable = true;

  extensions = with pkgs.vscode-extensions; [
    bbenoist.nix
    bungcip.better-toml
    esbenp.prettier-vscode
    rust-lang.rust-analyzer

    # Extensions not in Nixpkgs
    (ext "b4dM4n" "nixpkgs-fmt" "0.0.1" "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=")
    (ext "GitHub" "github-vscode-theme" "6.3.4" "sha256-JbI0B7jxt/2pNg/hMjAE5pBBa3LbUdi+GF0iEZUDUDM=")
    (ext "PKief" "material-icon-theme" "4.32.0" "sha256-6I9/nWv449PgO1tHJbLy/wxzG6BQF6X550l3Qx0IWpw=")
  ];

  userSettings = {
    "[nix]" = {
      "editor.defaultFormatter" = "b4dM4n.nixpkgs-fmt";
      "editor.formatOnSave" = true;
    };
    "[rust]" = {
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
    };
    "[toml]" = {
      "editor.defaultFormatter" = "bungcip.better-toml";
    };
    "search.exclude" = {
      "**/.direnv" = true;
      "**/.git" = true;
      "**/node_modules" = true;
      "*.lock" = true;
      "dist" = true;
      "tmp" = true;
    };
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "terminal.integrated.fontFamily" = terminalFont;
    "workbench.colorTheme" = colorTheme;
    "workbench.iconTheme" = iconTheme;
  };
}
