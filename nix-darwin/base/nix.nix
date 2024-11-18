{ username }:

{
  buildMachines = [
    #{
    #hostName = "eu.nixbuild.net";
    #  system = "x86_64-linux";
    #  maxJobs = 100;
    #  supportedFeatures = [ "benchmark" "big-parallel" ];
    #}
  ];
  checkConfig = true;
  distributedBuilds = true;
  extraOptions = "";
  settings = {
    build-users-group = "nixbld";
    cores = 10;
    extra-sandbox-paths = [ ];
    max-jobs = "auto";
    require-sigs = true;
    sandbox = false;
    sandbox-fallback = false;
  };
}
