{ username }:

{
  buildMachines = [
    {
      hostName = "eu.nixbuild.net";
      system = "x86_64-linux";
      maxJobs = 100;
      supportedFeatures = [ "benchmark" "big-parallel" ];
    }
  ];
  checkConfig = true;
  distributedBuilds = true;
  extraOptions = "";
  registry = { };
  settings = {
    auto-optimise-store = true;
    bash-prompt-prefix = "(nix:$name)\\040";
    build-users-group = "nixbld";
    cores = 10;
    experimental-features = [ "nix-command" "flakes" ];
    extra-experimental-features = [ "repl-flake" ];
    extra-sandbox-paths = [ ];
    extra-trusted-public-keys = "cache.flakehub.com-1:t6986ugxCA+d/ZF9IeMzJkyqi5mDhvFIx7KA/ipulzE= cache.flakehub.com-2:ntBGiaKSmygJOw2j1hFS7KDlUHQWmZALvSJ9PxMJJYU=";
    extra-trusted-substituters = "https://cache.flakehub.com/";
    extra-nix-path = "nixpkgs=flake:nixpkgs";
    max-jobs = "auto";
    netrc-file = "/Users/${username}/.local/share/flakehub/netrc";
    require-sigs = true;
    sandbox = false;
    sandbox-fallback = false;
  };
}
