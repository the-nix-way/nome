{ pkgs }:

let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

  # Helper function to cut down on boilerplate
  extension = { publisher, name, version, sha256 }:
    buildVscodeMarketplaceExtension {
      mktplcRef = { inherit name publisher sha256 version; };
    };
in
{
  enable = true;
  package = pkgs.vscode;
  extensions = with pkgs.vscode-extensions; [
    # Provided by Nixpkgs
    bbenoist.nix
    bierner.markdown-mermaid
    dbaeumer.vscode-eslint
    dhall.dhall-lang
    donjayamanne.githistory
    eamodio.gitlens
    elmtooling.elm-ls-vscode
    esbenp.prettier-vscode
    formulahendry.auto-close-tag
    kamikillerto.vscode-colorize
    lucperkins.vrl-vscode
    ms-azuretools.vscode-docker
    octref.vetur
    redhat.vscode-yaml
    rust-lang.rust-analyzer
    silvenon.mdx
    tamasfe.even-better-toml
    yzhang.markdown-all-in-one

    # Not in Nixpkgs
    (extension {
      publisher = "dzhavat";
      name = "bracket-pair-toggler";
      version = "0.0.2";
      sha256 = "sha256-2u+bdXU9nU1C8X3hpi7FfI2en4mlgWRPIVzcZrgGzPo=";
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
      publisher = "tilt-dev";
      name = "Tiltfile";
      version = "0.0.3";
      sha256 = "sha256-KQ+jmVwHH/9iqmS6mYGxZMMmVisI2FqMMCDUi9AJCcY=";
    })
    (extension {
      publisher = "jallen7usa";
      name = "vscode-cue-fmt";
      version = "0.1.1";
      sha256 = "sha256-juOcZgSfhM1BnyVQPleP86rbuRt0peGIr2aDh7WmNQk=";
    })
    (extension {
      publisher = "nickgo";
      name = "cuelang";
      version = "0.0.1";
      sha256 = "sha256-dAMV1SQUSuq2nze5us6/x1DGYvxzFz3021++ffQoafI=";
    })
    (extension {
      publisher = "PenumbraTheme";
      name = "penumbra";
      version = "0.3.0";
      sha256 = "sha256-2XbPG1o1u/P49m3V9X+KkMJgw3g8IaT0YigiKFgoM/0=";
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
      publisher = "RobbOwen";
      name = "synthwave-vscode";
      version = "0.1.11";
      sha256 = "sha256-nHs9qJCKiG12sw4Hj7St86AcQJsKKx+l9mlRNSrFWOQ=";
    })
    (extension {
      publisher = "whizkydee";
      name = "material-palenight-theme";
      version = "2.0.2";
      sha256 = "sha256-//EpXe+kKloqbMIZ8kstUKdYB490tQBBilB3Z9FfBNI=";
    })
    (extension {
      publisher = "amatiasq";
      name = "sort-imports";
      version = "6.3.1";
      sha256 = "sha256-w02bnJH3wfZsTMwDbrlc6UdVhh+equqnF9cnkOhQciU=";
    })
    (extension {
      publisher = "PKief";
      name = "material-icon-theme";
      version = "4.19.0";
      sha256 = "sha256-RBXs7S0iyuutUn11hFqc0VyTs4NFDFLBRvY0u8id86s=";
    })
    (extension {
      publisher = "EditorConfig";
      name = "EditorConfig";
      version = "0.16.4";
      sha256 = "sha256-j+P2oprpH0rzqI0VKt0JbZG19EDE7e7+kAb3MGGCRDk=";
    })
    (extension {
      publisher = "sdras";
      name = "night-owl";
      version = "2.0.1";
      sha256 = "sha256-AqfcVV9GYZ+GLgusXfij9z4WzrU9cCHp3sdZb0i6HzE=";
    })
    (extension {
      publisher = "ms-vscode";
      name = "vscode-typescript-next";
      version = "4.8.20220805";
      sha256 = "sha256-Nz1uAJ2gQXDDvmu1rnyzW5U1fQFbJDpcxNfujHNEsUI=";
    })
    (extension {
      publisher = "bradlc";
      name = "vscode-tailwindcss";
      version = "0.8.6";
      sha256 = "sha256-v15KuD3eYFCsrworCJ1SZAMkyZKztAwWKmfwmbirleI=";
    })
  ];

  userSettings =
    builtins.fromJSON (builtins.readFile ./config/vscode-settings.json);
}
