{ pkgs }:

let
  inherit (pkgs.lib) fakeHash;

  nu =
    name: script:
    pkgs.nuenv.mkScript {
      inherit name script;
    };
in
[
  (pkgs.writeScriptBin "random-nix-hash" ''
    nix hash convert --from base16 --hash-algo sha1 --to nix32 "$(openssl rand -hex 20)"
  '')

  (pkgs.writeScriptBin "random-sha256-hash" ''
    echo -n "$(head -c 32 /dev/urandom)" | openssl dgst -sha256 -binary | openssl base64 | awk '{print "sha256-" $1}'
  '')

  (nu "crate-hash" ''
    # Display the hash for a cargo crate
    def main [
      name: string, # Package name
      version: string, # Package version
    ] {
      nix-prefetch-url --type sha256 --unpack $"https://crates.io/api/v1/crates/($name)/($version)/download"
    }
  '')

  (nu "fake-hash" ''
    "${fakeHash}"
  '')

  (nu "git-hash" ''
    # Get the hash for the GitHub URL at https://github.com/<owner>/<repo>/archive/<rev>.tar.gz
    def main [
      owner: string, # The repo owner
      repo: string, # The repo name
      rev: string # The Git revision
    ] {
      nix-prefetch-url --type sha256 --unpack $"https://github.com/($owner)/($repo)/archive/($rev).tar.gz"
    }
  '')

  (nu "has" ''
    # Search for a specific term in the local Nixpkgs repo
    def main [
      term: string # The search term
    ] {
      do {
        cd ~/nx/nixpkgs
        git grep $term
      }
    }
  '')

  (nu "wo" ''
    # See the path of an executable
    def main [
      executable: string, # The executable to trace
    ] {
      readlink $"(which $executable | get path.0)"
    }
  '')

  (nu "dvs" ''
    # Initialize a template from Nome
    def main [
      template: string, # The template to initialize
    ] {
      nix flake init --template $"https://flakehub.com/f/the-nix-way/nome/0.1#($template)"
    }
  '')

  (pkgs.writeShellApplication {
    name = "heavy-cleanup";
    runtimeInputs = with pkgs; [
      findutils
      nh
    ];
    text = ''
      echo "> Cleaning up Nix with nh..."
      nh clean all

      if docker info > /dev/null 2>&1; then
        images="$(docker image ls --all --quiet)"
        if [[ -n "$images" ]]; then
          echo "> Deleting all Docker images..."
          # shellcheck disable=SC2086
          docker image rm --force $images
        else
          echo "> No Docker images to delete"
        fi
      else
        echo "> Docker isn't running; skipping Docker images"
      fi

      echo "> Deleting Rust target directories under $HOME..."
      find "$HOME" \
        \( -path "$HOME/Library" -o -path "$HOME/.Trash" -o -name node_modules -o -name .git \) -prune -o \
        -type d -name target -print0 -prune \
      | while IFS= read -r -d "" dir; do
          if [[ -f "$(dirname "$dir")/Cargo.toml" ]]; then
            echo "  removing $dir"
            rm -rf "$dir"
          fi
        done

      echo "> Heavy cleanup complete 🧹"
    '';
  })

  (nu "docker-cleanup" ''
    docker system prune -af
    docker volume prune -f
    docker image prune -af
  '')

  # Open up this directory in VS Code for editing
  (nu "cfg" ''
    code ${pkgs.lib.homeDirectory}/the-nix-way/nome
  '')
]
