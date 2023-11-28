{ pkgs }:

let
  font = "CascadiaCode";
  terminalFont = "Iosevka";
  colorTheme = "GitHub Dark Mode";
  iconTheme = "material-icon-theme";

  ext = publisher: name: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = { inherit name publisher sha256 version; };
  };
in
{
  enable = true;

  enableExtensionUpdateCheck = true;

  extensions = with pkgs.vscode-extensions; [
    bbenoist.nix
    editorconfig.editorconfig
    esbenp.prettier-vscode
    github.vscode-github-actions
    golang.go
    rust-lang.rust-analyzer
    tamasfe.even-better-toml

    # Extensions not in Nixpkgs
    (ext "b4dM4n" "nixpkgs-fmt" "0.0.1" "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=")
    (ext "GitHub" "github-vscode-theme" "6.3.4" "sha256-JbI0B7jxt/2pNg/hMjAE5pBBa3LbUdi+GF0iEZUDUDM=")
    (ext "markusylisiurunen" "githubdarkmode" "0.1.6" "sha256-Xzh8g5bEi4kPul1nJyROcN0CeDnXuNxQEYt6HgMepvM=")
    (ext "ms-vscode" "vscode-typescript-next" "5.4.20231127" "sha256-UVuYggzeWyQTmQxXdM4sT78FUOtYGKD4SzREntotU5g=")
    (ext "PKief" "material-icon-theme" "4.32.0" "sha256-6I9/nWv449PgO1tHJbLy/wxzG6BQF6X550l3Qx0IWpw=")
    (ext "whizkydee" "material-palenight-theme" "2.0.3" "sha256-qz2pz9JlnO2OV3eJnRqzbcic1lzpl0ViygwhNjZOWpI=")
  ];

  globalSnippets = { };

  keybindings = [ ];

  mutableExtensionsDir = false;

  userSettings = {
    "[nix]" = {
      "editor.defaultFormatter" = "B4dM4n.nixpkgs-fmt";
      "editor.formatOnSave" = true;
    };
    "[rust]" = {
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
    };
    "[toml]" = {
      "editor.defaultFormatter" = "tamasfe.even-better-toml";
    };
    "search.exclude" = {
      "**/.direnv" = true;
      "**/.git" = true;
      "**/node_modules" = true;
      "*.lock" = true;
      "dist" = true;
      "tmp" = true;
    };
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "terminal.integrated.fontFamily" = terminalFont;
    "workbench.colorTheme" = colorTheme;
    "workbench.iconTheme" = iconTheme;
  };
}
