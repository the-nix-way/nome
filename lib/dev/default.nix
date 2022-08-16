{ pkgs }:

{
  tools = {
    go = with pkgs; [ go gotools ];

    node = with pkgs; [ nodejs yarn ] ++ (with pkgs.nodePackages; [ pnpm ]);

    protobuf = with pkgs; [ buf protobuf ];
  };
}
