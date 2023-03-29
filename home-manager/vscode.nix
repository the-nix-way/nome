{ pkgs }:

let
  font = "CascadiaCode";
  terminalFont = "Iosevka";
  colorTheme = "GitHub Dark Dimmed";
  iconTheme = "material-icon-theme";

  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

  # Helper function for home-spun VS Code extension derivations
  extension = { publisher, name, version, sha256 }:
    buildVscodeMarketplaceExtension {
      mktplcRef = { inherit name publisher sha256 version; };
    };

  myExtensions = {
    nickel = (extension {
      publisher = "kubukoz";
      name = "nickel-syntax";
      version = "0.0.2";
      sha256 = "sha256-ffPZd717Y2OF4d9MWE6zKwcsGWS90ZJvhWkqP831tVM=";
    });

    nix = (extension {
      publisher = "bbenoist";
      name = "nix";
      version = "1.0.1";
      sha256 = "sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=";
    });

    nixpkgs-fmt = (extension {
      publisher = "B4dM4n";
      name = "nixpkgs-fmt";
      version = "0.0.1";
      sha256 = "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
    });

    nushell = (extension {
      publisher = "TheNuProjectContributors";
      name = "vscode-nushell-lang";
      version = "1.0.0";
      sha256 = "sha256-2FHAFh4ipYKegir7o59Ypb78MOzy2iu+3p3aUUgsatw=";
    });

    unison = (extension {
      publisher = "benfradet";
      name = "vscode-unison";
      version = "0.4.0";
      sha256 = "sha256-IDM9v+LWckf20xnRTj+ThAFSzVxxDVQaJkwO37UIIhs=";
    });
  };
in
{
  enable = true;
  enableExtensionUpdateCheck = true;
  enableUpdateCheck = true;
  extensions = (with myExtensions; [
    nickel
    nix
    nixpkgs-fmt
    nushell
    unison
  ]) ++ (with pkgs.vscode-extensions; [
    # Provided by Nixpkgs
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    formulahendry.auto-close-tag
    ms-azuretools.vscode-docker
    octref.vetur
    redhat.vscode-yaml
    rust-lang.rust-analyzer
    tamasfe.even-better-toml
    yzhang.markdown-all-in-one


    (extension {
      publisher = "justusadam";
      name = "language-haskell";
      version = "3.6.0";
      sha256 = "sha256-rZXRzPmu7IYmyRWANtpJp3wp0r/RwB7eGHEJa7hBvoQ=";
    })
    (extension {
      publisher = "haskell";
      name = "haskell";
      version = "2.2.2";
      sha256 = "sha256-zWdIVdz+kZg7KZQ7LeBCB4aB9wg8dUbkWfzGlM0Fq7Q=";
    })
    (extension {
      publisher = "Vue";
      name = "volar";
      version = "1.0.13";
      sha256 = "sha256-rWEV8Reevg2QcTynSiN/0ZeHLMo61qakqVhJTKAFpp4=";
    })
    (extension {
      publisher = "GitHub";
      name = "github-vscode-theme";
      version = "6.3.2";
      sha256 = "sha256-CbFZsoRiiwSWL7zJdnBcfrxuhE7E9Au2AlQjqYXW+Nc=";
    })

    (extension {
      publisher = "unifiedjs";
      name = "vscode-mdx";
      version = "1.0.3";
      sha256 = "sha256-RxMQ7S+at2pKAnyEMSU3C3sDnDBWrRF2BuxCrfE1e+I=";
    })
    (extension {
      publisher = "jq-syntax-highlighting";
      name = "jq-syntax-highlighting";
      version = "0.0.2";
      sha256 = "sha256-Bwq+aZuDmzjHw+ZnIWlL4aGz6UnqxaKm5WUko0yuIWE=";
    })
    (extension {
      publisher = "csstools";
      name = "postcss";
      version = "1.0.9";
      sha256 = "sha256-5pGDKme46uT1/35WkTGL3n8ecc7wUBkHVId9VpT7c2U=";
    })
    (extension {
      publisher = "HashiCorp";
      name = "HCL";
      version = "0.2.1";
      sha256 = "sha256-5dBLDJ7Wgv7p3DY0klqxtgo2/ckAHoMOm8G1mDOlzZc=";
    })
    (extension {
      publisher = "HashiCorp";
      name = "terraform";
      version = "2.23.0";
      sha256 = "sha256-3v2hEf/cEd7NiXfk7eJbmmdyiQJ7bWl9TuaN+y5k+e0=";
    })
    (extension {
      publisher = "Gleam";
      name = "gleam";
      version = "2.0.0";
      sha256 = "sha256-P71WDMYidD1qz4EQpVOer2npRe16glRcOA/I76jkZuM=";
    })
    (extension {
      publisher = "golang";
      name = "Go";
      version = "0.35.1";
      sha256 = "sha256-MHQrFxqSkcpQXiZQoK8e+xVgRjl3Db3n72hrQrT98lg=";
    })
    (extension {
      publisher = "ms-vscode";
      name = "makefile-tools";
      version = "0.5.0";
      sha256 = "sha256-oBYABz6qdV9g7WdHycL1LrEaYG5be3e4hlo4ILhX4KI=";
    })
    (extension {
      publisher = "BazelBuild";
      name = "vscode-bazel";
      version = "0.5.0";
      sha256 = "sha256-JJQSwU3B5C2exENdNsWEcxFSgWHnImYas4t/KLsgTj4=";
    })
    (extension {
      publisher = "bufbuild";
      name = "vscode-buf";
      version = "0.5.0";
      sha256 = "sha256-ePvmHgb6Vdpq1oHcqZcfVT4c/XYZqxJ6FGVuKAbQOCg=";
    })
    (extension {
      publisher = "brettm12345";
      name = "nixfmt-vscode";
      version = "0.0.1";
      sha256 = "sha256-8yglQDUc0CXG2EMi2/HXDJsxmXJ4YHvjNjTMnQwrgx8=";
    })
    (extension {
      publisher = "PKief";
      name = "material-icon-theme";
      version = "4.25.0";
      sha256 = "sha256-/lD3i7ZdF/XOi7RduS3HIYHFXhkoW2+PJW249gQxcyk=";
    })
    (extension {
      publisher = "EditorConfig";
      name = "EditorConfig";
      version = "0.16.4";
      sha256 = "sha256-j+P2oprpH0rzqI0VKt0JbZG19EDE7e7+kAb3MGGCRDk=";
    })
    (extension {
      publisher = "ms-vscode";
      name = "vscode-typescript-next";
      version = "5.0.202302090";
      sha256 = "sha256-LTB3lwu712Rxmi3hDGHP+l1DnQSjuy2fORf1df37d08=";
    })
    (extension {
      publisher = "bradlc";
      name = "vscode-tailwindcss";
      version = "0.8.6";
      sha256 = "sha256-v15KuD3eYFCsrworCJ1SZAMkyZKztAwWKmfwmbirleI=";
    })
  ]);

  userSettings = {
    "[mdx]" = {
      "editor.formatOnSave" = false;
    };
    "[nix]" = {
      "editor.defaultFormatter" = "B4dM4n.nixpkgs-fmt";
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
      "editor.defaultFormatter" = "tamasfe.even-better-toml";
    };
    "[txt]" = {
      "editor.formatOnSave" = false;
    };
    "[vue]" = {
      "editor.defaultFormatter" = "Vue.volar";
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
    };
    "terminal.integrated.fontFamily" = terminalFont;
    "workbench.colorTheme" = colorTheme;
    "workbench.iconTheme" = iconTheme;
  };
  userTasks = { };
}

