{ pkgs }:

let
  font = "JetBrains Mono";
  terminalFont = "JetBrains Mono";
  iconTheme = "material-icon-theme";

  ext = publisher: name: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = { inherit name publisher sha256 version; };
  };
in
{
  enable = true;

  enableExtensionUpdateCheck = true;

  extensions = (with pkgs.vscode-extensions; [
    astro-build.astro-vscode
    b4dm4n.vscode-nixpkgs-fmt
    bbenoist.nix
    bradlc.vscode-tailwindcss
    denoland.vscode-deno
    editorconfig.editorconfig
    elixir-lsp.vscode-elixir-ls
    enkia.tokyo-night
    esbenp.prettier-vscode
    github.vscode-github-actions
    github.github-vscode-theme
    gleam.gleam
    golang.go
    hashicorp.hcl
    hashicorp.terraform
    jeff-hykin.better-nix-syntax
    lucperkins.vrl-vscode
    matthewpi.caddyfile-support
    mesonbuild.mesonbuild
    mkhl.direnv
    nefrob.vscode-just-syntax
    pkief.material-icon-theme
    prisma.prisma
    phoenixframework.phoenix
    rust-lang.rust-analyzer
    tamasfe.even-better-toml
    teabyii.ayu
    thenuprojectcontributors.vscode-nushell-lang
    unifiedjs.vscode-mdx
    vue.volar
  ]) ++ [
    # Extensions not in Nixpkgs
    (ext "andrejunges" "Handlebars" "0.4.1" "sha256-Rwhr9X3sjDm6u/KRYE2ucCJSlZwsgUJbH/fdq2WZ034=")
    (ext "antfu" "theme-vitesse" "0.8.3" "sha256-KkpJgJBcnMeQ1G97QS/E6GY4/p9ebZRaA5pUXPd9JB0=")
    (ext "bufbuild" "vscode-buf" "0.7.0" "sha256-B5/Gc+f3xaYpMTXFcQ9LJiAb9LBJX2aR+gh22up3Wi4=")
    (ext "oven" "bun-vscode" "0.0.26" "sha256-klMkKAorWJj2o015FWbQQfpmYe4JM0UOM+WVh+YPtI4=")
    (ext "Guyutongxue" "lalrpop-syntax-highlight" "0.0.5" "sha256-VJBvR9pM0NPYi/RUoVQcL1tt2PZCKohwX8Dd1nz0UGY=")
    (ext "markusylisiurunen" "githubdarkmode" "0.1.6" "sha256-Xzh8g5bEi4kPul1nJyROcN0CeDnXuNxQEYt6HgMepvM=")
    (ext "ms-vscode" "vscode-typescript-next" "5.4.20231127" "sha256-UVuYggzeWyQTmQxXdM4sT78FUOtYGKD4SzREntotU5g=")
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
      "editor.formatOnSave" = true;
    };
    "[toml]" = {
      "editor.defaultFormatter" = "tamasfe.even-better-toml";
      "editor.formatOnSave" = true;
    };
    "editor.wordWrap" = "wordWrapColumn";
    "editor.wordWrapColumn" = 120;
    "search.exclude" = {
      "**/.direnv" = true;
      "**/.git" = true;
      "**/node_modules" = true;
      "*.lock" = true;
      "dist" = true;
      "tmp" = true;
    };
    # "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "rust-analyzer.server.path" = "rust-analyzer";
    "terminal.integrated.fontFamily" = terminalFont;
    "window.autoDetectColorScheme" = true;
    "workbench.preferredLightColorTheme" = "Vitesse Light";
    "workbench.preferredDarkColorTheme" = "Vitesse Dark";
  };
}
