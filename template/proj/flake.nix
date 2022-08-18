{
  description = "Local dev environment";

  inputs = {
    nome.url = "github:the-nix-way/nome";
  };

  outputs = { self, nome, ... }:
    nome.lib.mkEnv {
      toolchains = with nome.lib.toolchains; elixir ++ go ++ node ++ protobuf ++ rust;
      extras = with nome.pkgs; [ jq ];
      shellHook = ''
        echo "Welcome to this Nix-provided project env!"
      '';
    };
}
