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
    esbenp.prettier-vscode
    github.vscode-github-actions
    github.github-vscode-theme
    golang.go
    hashicorp.hcl
    hashicorp.terraform
    jeff-hykin.better-nix-syntax
    lucperkins.vrl-vscode
    matthewpi.caddyfile-support
    mkhl.direnv
    nefrob.vscode-just-syntax
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
    (ext "oven" "bun-vscode" "0.0.12" "sha256-8+Fqabbwup6Jzm5m8GlWbxTqumqXtWAw5s3VaDht9Us=")
    (ext "enkia" "tokyo-night" "1.0.6" "sha256-VWdUAU6SC7/dNDIOJmSGuIeffbwmcfeGhuSDmUE7Dig=")
    (ext "gleam" "gleam" "2.10.0" "sha256-Xlgtfo0d6gjYsfggNYHjUjsFB1y6/KPJeM3ZgEEBxXk=")
    (ext "Guyutongxue" "lalrpop-syntax-highlight" "0.0.5" "sha256-VJBvR9pM0NPYi/RUoVQcL1tt2PZCKohwX8Dd1nz0UGY=")
    (ext "JakeBecker" "elixir-ls" "0.17.10" "sha256-4/B70DyNlImz60PSTSL5CKihlOJen/tR1/dXGc3s1ZY=")
    (ext "markusylisiurunen" "githubdarkmode" "0.1.6" "sha256-Xzh8g5bEi4kPul1nJyROcN0CeDnXuNxQEYt6HgMepvM=")
    (ext "ms-vscode" "vscode-typescript-next" "5.4.20231127" "sha256-UVuYggzeWyQTmQxXdM4sT78FUOtYGKD4SzREntotU5g=")
    (ext "PKief" "material-icon-theme" "4.32.0" "sha256-6I9/nWv449PgO1tHJbLy/wxzG6BQF6X550l3Qx0IWpw=")
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
