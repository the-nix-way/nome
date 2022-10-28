{ homeDirectory
, pkgs
}:

let
  inherit (pkgs) writeScriptBin;
  inherit (pkgs.lib) fakeHash;

  checkForArg = pos: msg: ''
    if [ -z "$''${pos}" ]; then
      echo "${msg}"
      exit 1
    fi
  '';

  checkForArg1 = msg: checkForArg 1 msg;
  checkForArg2 = msg: checkForArg 2 msg;
  checkForArg3 = msg: checkForArg 3 msg;
in
[
  (writeScriptBin "build-push" ''
    ${checkForArg1 "no build attribute specified"}

    nix-build '<nixpkgs>' -A $1 | cachix push lucperkins-dev && rm result
  '')
  (writeScriptBin "crate-hash" ''
    ${checkForArg1 "no package name provided"}
    ${checkForArg2 "no package version provided"}

    nix-prefetch-url --type sha256 --unpackttps://crates.io/api/v1/crates/$1/$2/download
  '')
  (writeScriptBin "fakeHash" ''
    echo "${fakeHash}" | pbcopy
  '')
  (writeScriptBin "hasher" ''
    nix-hash --type sha256 --flat --base32 <(echo $1) | cut -c 1-32
  '')
  (writeScriptBin "git-hash" ''
    ${checkForArg1 "no owner specified"}
    ${checkForArg2 "no repo specified"}
    ${checkForArg3 "no revision specified"}

    nix-prefetch-url --type sha256 --unpack https://github.com/$1/$2/archive/$3.tar.gz
  '')
  (writeScriptBin "has" ''
    ${checkForArg1 "no search term specified"}

    (cd ~/nx/nixpkgs && git grep $1)
  '')
  (writeScriptBin "proj" ''
    nix flake init --template github:the-nix-way/nome
  '')
  (writeScriptBin "wo" ''
    ${checkForArg1 "no executable specified"}

    readlink $(which $1)
  '')
  (writeScriptBin "xr" ''
    ${checkForArg1 "no executable specified"}

    nix run nixpkgs#$1 -- $2
  '')
  (writeScriptBin "xs" ''
    ${checkForArg1 "no attribute specified"}

    nix-env --query --available --attr-path $1
  '')
  (writeScriptBin "xsp" ''
    ${checkForArg1 "no attribute specified"}

    nix-env --file '<nixpkgs>' --query --available --attr-path -A $1
  '')

  (writeScriptBin "px" ''
    ${checkForArg1 "no system specified"}

    nix eval nixpkgs#pkgsCross.$1.stdenv.hostPlatform.config
  '')

  (writeScriptBin "dvt" ''
    ${checkForArg1 "no template specified"}

    nix flake init --template github:the-nix-way/dev-templates#$1
  '')

  (writeScriptBin "cleanup" ''
    docker system prune -af
    docker volume prune -f
    docker image prune -af
  '')

  (writeScriptBin "dvs" ''
    ${checkForArg1 "no template specified"}

    nix flake init --template github:the-nix-way/nome#$1
  '')

  (writeScriptBin "cfg" ''
    code ${homeDirectory}/the-nix-way/nome
  '')
]
