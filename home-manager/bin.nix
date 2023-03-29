{ pkgs }:

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

  prefix = ''
    set -o errexit
    set -o nounset
    set -o pipefail
    if [[ "''${TRACE-0}" == "1" ]]; then
      set -o xtrace
    fi
  '';

  script = name: content: writeScriptBin name ''
    ${prefix}
    ${content}
  '';
in
[
  (script "cache" ''
    ${checkForArg1 "no cache specified"}
    nix flake archive --json \
      | ${pkgs.jq}/bin/jq -r '.path,(.inputs|to_entries[].value.path)' \
      | ${pkgs.cachix}/bin/cachix push $1
  '')

  (script "cache-env" ''
    ${checkForArg1 "no cache specified"}
    nix develop --profile nuenv-ci-profile
    cachix push $1 nuenv-ci-profile
  '')

  (script "docker-clean" ''
    docker system prune -a --volumes
  '')

  (script "build-push" ''
    ${checkForArg1 "no build attribute specified"}

    nix-build '<nixpkgs>' -A $1 | cachix push lucperkins-dev && rm result
  '')
  (script "crate-hash" ''
    ${checkForArg1 "no package name provided"}
    ${checkForArg2 "no package version provided"}

    nix-prefetch-url --type sha256 --unpack https://crates.io/api/v1/crates/$1/$2/download
  '')
  (script "fakeHash" ''
    echo "${fakeHash}" | pbcopy
  '')
  (script "hasher" ''
    ${checkForArg1 "no string provided"}
    nix-hash --type sha256 --flat --base32 <(echo $1) | cut -c 1-32
  '')
  (script "git-hash" ''
    ${checkForArg1 "no owner specified"}
    ${checkForArg2 "no repo specified"}
    ${checkForArg3 "no revision specified"}

    nix-prefetch-url --type sha256 --unpack https://github.com/$1/$2/archive/$3.tar.gz
  '')
  (script "has" ''
    ${checkForArg1 "no search term specified"}

    (cd ~/nx/nixpkgs && git grep $1)
  '')
  (script "proj" ''
    nix flake init --template github:the-nix-way/nome
  '')
  (script "wo" ''
    ${checkForArg1 "no executable specified"}

    readlink $(which $1)
  '')
  (script "xr" ''
    ${checkForArg1 "no executable specified"}

    nix run nixpkgs#$1 -- $2
  '')
  (script "xs" ''
    ${checkForArg1 "no attribute specified"}

    nix-env --query --available --attr-path $1
  '')
  (script "xsp" ''
    ${checkForArg1 "no attribute specified"}

    nix-env --file '<nixpkgs>' --query --available --attr-path -A $1
  '')

  (script "x-run-force" ''
    nix run --tarball-ttl 0 ''${@}
  '')

  (script "px" ''
    ${checkForArg1 "no system specified"}

    nix eval nixpkgs#pkgsCross.$1.stdenv.hostPlatform.config
  '')

  (script "dvt" ''
    ${checkForArg1 "no template specified"}

    nix flake init --template github:the-nix-way/dev-templates#$1
  '')

  (script "cleanup" ''
    docker system prune -af
    docker volume prune -f
    docker image prune -af
  '')

  (script "dvs" ''
    ${checkForArg1 "no template specified"}

    nix flake init --template github:the-nix-way/nome#$1
  '')

  # Open up this directory in VS Code for editing
  (script "cfg" ''
    code ${pkgs.homeDirectory}/the-nix-way/nome
  '')

  (script "linux-builder" ''
    nix run nixpkgs/release-22.11#darwin.builder
  '')

  # Borrowed from here: https://discourse.nixos.org/t/nixpkgs-support-for-linux-builders-running-on-macos/24313/2
  (
    let
      dataDir = "/var/lib/nixos-builder";
      linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ]
        pkgs.stdenv.hostPlatform.system;
      outerPkgs = pkgs;
      port = 31022;
      linuxBuilder = (import "${pkgs.nixpkgs-unstable.path}/nixos" {
        system = linuxSystem;
        configuration = ({ modulesPath, lib, ... }: {
          imports = [ "${modulesPath}/profiles/macos-builder.nix" ];
          virtualisation.host.pkgs = outerPkgs;
          virtualisation.forwardPorts = lib.mkForce [{
            from = "host";
            host.address = "127.0.0.1";
            host.port = port;
            guest.port = 22;
          }];
        });
      }).config.system.build.macos-builder-installer;
    in
    (script "linux-builder-daemon" ''
      sudo launchctl kickstart -k system/org.nixos.nix-daemon
    '')
  )
]
