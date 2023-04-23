{ pkgs }:

let
  font = "CascadiaCode";
  terminalFont = "Iosevka";
  colorTheme = "GitHub Dark Dimmed";
  iconTheme = "material-icon-theme";
in
{
  enable = true;

  extensions = with pkgs.vscode-extensions; [
    bbenoist.nix
    justusadam.language-haskell
  ];

  userSettings = {
    "[mdx]" = {
      "editor.formatOnSave" = false;
    };
    "[nix]" = {
      "editor.defaultFormatter" = "b4dM4n.nixpkgs-fmt";
    };
    "[rust]" = {
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
    };
    "[terraform]" = {
      "editor.defaultFormatter" = "hashicorp.terraform";
      "editor.formatOnSave" = false;
      "editor.codeActionsOnSave" = {
        "source.formatAll.terraform" = true;
      };
    };
    "[terraform-vars]" = {
      "editor.defaultFormatter" = "hashicorp.terraform";
      "editor.formatOnSave" = false;
      "editor.codeActionsOnSave" = {
        "source.formatAll.terraform" = true;
      };
    };
    "[toml]" = {
      "editor.defaultFormatter" = "bungcip.better-toml";
    };
    "[txt]" = {
      "editor.formatOnSave" = false;
    };
    "[vue]" = {
      "editor.wordWrapColumn" = 100;
      "editor.wordWrap" = "wordWrapColumn";
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "debug.javascript.unmapMissingSources" = true;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.detectIndentation" = false;
    "editor.fontFamily" = font;
    "editor.fontLigatures" = true;
    "editor.formatOnPaste" = false;
    "editor.formatOnSave" = true;
    "editor.insertSpaces" = true;
    "editor.rulers" = [ 80 100 ];
    "editor.tabSize" = 2;
    "emmet.showExpandedAbbreviation" = "never";
    "emmet.showSuggestionsAsSnippets" = false;
    "eslint.options" = {
      "extensions" = [
        ".js"
        ".jsx"
        ".md"
        ".mdx"
        ".ts"
        ".tsx"
        ".vue"
      ];
    };
    "eslint.validate" = [
      "markdown"
      "mdx"
      "javascript"
      "javascriptreact"
      "typescript"
      "typescriptreact"
      "vue"
    ];
    "search.exclude" = {
      "**/.direnv" = true;
      "**/.git" = true;
      "**/node_modules" = true;
      "*.lock" = true;
      "dist" = true;
      "tmp" = true;
    };
    "terminal.integrated.fontFamily" = terminalFont;
    "workbench.colorTheme" = colorTheme;
    "workbench.iconTheme" = iconTheme;
  };
  userTasks = { };
}

