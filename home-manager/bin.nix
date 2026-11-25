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

  # Build a package across all active DSP distributions and supported systems.
  # Extra args are passed to nix build, e.g. `dsp-all p11-kit --rebuild`.
  (pkgs.writeShellApplication {
    name = "dsp-all";
    text = ''
      if [ $# -lt 1 ]; then
        echo "usage: dsp-all <package> [nix build args...]" >&2
        exit 1
      fi
      pkg="$1"
      shift

      for dist in 25.11 26.05 rolling; do
        for sys in x86_64-linux aarch64-linux aarch64-darwin; do
          echo "=== secure-packages-$dist / $sys ==="
          nix build -L --no-link --print-out-paths "$@" \
            "https://flakehub.com/f/DeterminateSystems/secure-packages-$dist/*#legacyPackages.$sys.$pkg" \
            || echo "FAILED: $dist $sys"
        done
      done
    '';
  })

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

  (nu "heavy-cleanup" ''
    # Reclaim disk space from dev tooling: Nix, Docker, language caches, and build output in idle projects.
    # Everything removed is a cache or build output that gets re-downloaded or rebuilt on next use.
    def main [
      --days: int = 30, # Only clean projects idle for at least this many days (0 cleans every project)
    ] {
      let before = (free-bytes)

      print "> Cleaning up Nix with nh..."
      ${pkgs.nh}/bin/nh clean all

      docker-cleanup
      rust-cleanup
      js-cleanup
      misc-cleanup
      project-cleanup $days

      let freed = ((free-bytes) - $before)
      print $"> Heavy cleanup complete, freed ($freed | into filesize) 🧹"
    }

    def docker-cleanup [] {
      if not (docker-running) {
        print "> Docker isn't running; skipping Docker"
        return
      }

      let images = (docker image ls --all --quiet | lines)
      if ($images | is-empty) {
        print "> No Docker images to delete"
      } else {
        print "> Deleting all Docker images..."
        docker image rm --force ...$images
      }

      print "> Pruning the Docker build cache..."
      docker builder prune --all --force
    }

    # Unpacked crate sources and git checkouts; Cargo re-extracts them from its .crate cache
    def rust-cleanup [] {
      if ($env.HOME | path join ".cargo" | path exists) {
        print "> Cleaning the Cargo registry and git caches..."
        ${pkgs.cargo-cache}/bin/cargo-cache --autoclean
      }
    }

    def js-cleanup [] {
      print "> Deleting the npm cache and npx packages..."
      [".npm/_cacache" ".npm/_npx"] | home-paths | remove-all

      # pnpm keeps one store per store version and never deletes the old ones
      if (installed pnpm) {
        let current = (do { cd $env.HOME; ^pnpm store path } | str trim | path expand)
        print "> Deleting old pnpm stores..."
        ["Library/pnpm/store" ".local/share/pnpm/store"]
        | home-paths
        | where {|root| $root | path exists }
        | each {|root| ls $root | where type == dir | get name }
        | flatten
        | where {|store| ($store | path expand) != $current }
        | remove-all

        print "> Pruning the pnpm store..."
        do { cd $env.HOME; ^pnpm store prune }
      }

      print "> Deleting the Yarn and Bun caches..."
      ["Library/Caches/Yarn" ".yarn/berry/cache" ".bun/install/cache"] | home-paths | remove-all

      # Keep only the newest download of each browser
      let puppeteer = ($env.HOME | path join ".cache/puppeteer")
      if ($puppeteer | path exists) {
        print "> Deleting old Puppeteer browsers..."
        ls $puppeteer
        | where type == dir
        | each {|browser| ls $browser.name | where type == dir | sort-by modified | drop 1 | get name }
        | flatten
        | remove-all
      }
    }

    def misc-cleanup [] {
      if (installed uv) {
        print "> Pruning the uv cache..."
        ^uv cache prune
      }

      if (installed go) {
        print "> Cleaning the Go build cache..."
        ^go clean -cache
      }
    }

    # Rust target/, node_modules, and .next directories in projects idle for at least $days days
    def project-cleanup [days: int] {
      print $"> Deleting build output in projects idle for ($days)+ days under ($env.HOME)..."
      let home = $env.HOME
      let cutoff = ((date now) - ($days * 1day))

      (^${pkgs.findutils}/bin/find $home
        "(" -path $"($home)/.*" -o -path $"($home)/Library" -o -path $"($home)/Applications" -o -name .git -o -name .direnv ")" -prune
        -o -type d "(" -name target -o -name node_modules -o -name .next ")" -print -prune)
      | complete # find exits non-zero on unreadable directories; keep what it found
      | get stdout
      | lines
      | where {|dir|
          let project = ($dir | path dirname)
          let manifest = if (($dir | path basename) == "target") { "Cargo.toml" } else { "package.json" }
          ($project | path join $manifest | path exists) and ((last-active $project) < $cutoff)
        }
      | remove-all
    }

    # When a project was last worked on: its latest commit or Git index update, else the directory's mtime
    def last-active [dir: path]: nothing -> datetime {
      let root = (do { ^git -C $dir rev-parse --show-toplevel } | complete)
      if $root.exit_code != 0 {
        return (ls --directory $dir | get modified.0)
      }

      let root = ($root.stdout | str trim)
      let commit = (do { ^git -C $root log -1 --format=%cI } | complete | get stdout | str trim)
      let index = ($root | path join ".git/index")
      [
        (if ($commit | is-empty) { null } else { $commit | into datetime })
        (if ($index | path exists) { ls $index | get modified.0 } else { null })
        (ls --directory $root | get modified.0)
      ]
      | compact
      | sort
      | last
    }

    # Expand paths relative to the home directory
    def home-paths []: list<string> -> list<string> {
      each {|p| $env.HOME | path join $p }
    }

    def remove-all []: list<string> -> nothing {
      where {|p| $p | path exists }
      | each {|p|
          print $"  removing ($p)"
          rm --recursive --force $p
        }
      | ignore
    }

    def installed [name: string]: nothing -> bool {
      which $name | is-not-empty
    }

    # Available bytes on the volume that holds the home directory
    def free-bytes []: nothing -> int {
      (^df -k $env.HOME | lines | last | split row --regex '\s+' | get 3 | into int) * 1024
    }

    # Is the Docker daemon up and reachable?
    def docker-running []: nothing -> bool {
      (installed docker) and ((docker info | complete | get exit_code) == 0)
    }
  '')

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
