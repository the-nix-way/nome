{ eachDefaultSystem, pkgs }:

{
  mkEnv = tools:
    eachDefaultSystem (system:
      let
        inherit (pkgs) mkShell;
      in
      {
        devShells = {
          default = mkShell {
            buildInputs = tools;
          };
        };
      });


  tools = {
    go = with pkgs;
      [ go gotools ];

    node = with pkgs; [ nodejs yarn ] ++ (with pkgs.nodePackages; [ pnpm ]);

    protobuf = with pkgs; [ buf protobuf ];
  };
}
