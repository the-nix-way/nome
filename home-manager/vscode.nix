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
    bbenoist.nix
    bradlc.vscode-tailwindcss
    denoland.vscode-deno
    editorconfig.editorconfig
    esbenp.prettier-vscode
    github.vscode-github-actions
    github.github-vscode-theme
    golang.go
    hashicorp.terraform
    lucperkins.vrl-vscode
    matthewpi.caddyfile-support
    prisma.prisma
    phoenixframework.phoenix
    rust-lang.rust-analyzer
    tamasfe.even-better-toml
    thenuprojectcontributors.vscode-nushell-lang
    unifiedjs.vscode-mdx
  ]) ++ [
    # Extensions not in Nixpkgs
    (ext "andrejunges" "Handlebars" "0.4.1" "sha256-Rwhr9X3sjDm6u/KRYE2ucCJSlZwsgUJbH/fdq2WZ034=")
    (ext "antfu" "theme-vitesse" "0.8.3" "sha256-KkpJgJBcnMeQ1G97QS/E6GY4/p9ebZRaA5pUXPd9JB0=")
    (ext "astro-build" "astro-vscode" "2.15.4" "sha256-dyv7GTscj57Uc+HgImXETKW8olGcWpL+FyAHoS36rmk=")
    (ext "bufbuild" "vscode-buf" "0.7.0" "sha256-B5/Gc+f3xaYpMTXFcQ9LJiAb9LBJX2aR+gh22up3Wi4=")
    (ext "oven" "bun-vscode" "0.0.12" "sha256-8+Fqabbwup6Jzm5m8GlWbxTqumqXtWAw5s3VaDht9Us=")
    (ext "b4dM4n" "nixpkgs-fmt" "0.0.1" "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=")
    (ext "enkia" "tokyo-night" "1.0.6" "sha256-VWdUAU6SC7/dNDIOJmSGuIeffbwmcfeGhuSDmUE7Dig=")
    (ext "gleam" "gleam" "2.10.0" "sha256-Xlgtfo0d6gjYsfggNYHjUjsFB1y6/KPJeM3ZgEEBxXk=")
    (ext "Guyutongxue" "lalrpop-syntax-highlight" "0.0.5" "sha256-VJBvR9pM0NPYi/RUoVQcL1tt2PZCKohwX8Dd1nz0UGY=")
    (ext "hashicorp" "hcl" "0.3.2" "sha256-cxF3knYY29PvT3rkRS8SGxMn9vzt56wwBXpk2PqO0mo=")
    (ext "JakeBecker" "elixir-ls" "0.17.10" "sha256-4/B70DyNlImz60PSTSL5CKihlOJen/tR1/dXGc3s1ZY=")
    (ext "jeff-hykin" "better-nix-syntax" "1.0.7" "sha256-vqfhUIjFBf9JvmxB4QFrZH4KMhxamuYjs5n9VyW/BiI=")
    (ext "markusylisiurunen" "githubdarkmode" "0.1.6" "sha256-Xzh8g5bEi4kPul1nJyROcN0CeDnXuNxQEYt6HgMepvM=")
    (ext "mkhl" "direnv" "0.17.0" "sha256-9sFcfTMeLBGw2ET1snqQ6Uk//D/vcD9AVsZfnUNrWNg=")
    (ext "ms-vscode" "vscode-typescript-next" "5.4.20231127" "sha256-UVuYggzeWyQTmQxXdM4sT78FUOtYGKD4SzREntotU5g=")
    (ext "nefrob" "vscode-just-syntax" "0.3.0" "sha256-WBoqH9TNco9lyjOJfP54DynjmYZmPUY+YrZ1rQlC518=")
    (ext "Ph0enixKM" "amber-language" "1.2.6" "sha256-Uxw6v8tc12haqgBFaTogEHEkzCYg+mzoIhCCZ6cyeX0=")
    (ext "PKief" "material-icon-theme" "4.32.0" "sha256-6I9/nWv449PgO1tHJbLy/wxzG6BQF6X550l3Qx0IWpw=")
    (ext "teabyii" "ayu" "1.0.5" "sha256-+IFqgWliKr+qjBLmQlzF44XNbN7Br5a119v9WAnZOu4=")
    (ext "vue" "volar" "2.0.11" "sha256-EyULg2yS/aqf0ipUQKFjW1WJIHECr26/JIQ+UuTPSLk=")
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
