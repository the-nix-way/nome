{
  description = "Local dev environment";

  inputs = {
    nome.url = "github:the-nix-way/nome";
  };

  outputs = { self, nome, ... }:
    nome.lib.dev.mkEnv {
      toolchains = with nome.lib.dev.toolchains; elixir ++ go ++ node ++ protobuf ++ rust;
      extras = with nome.pkgs; [ jq ];
      shellHook = ''
        echo "Welcome to this Nix-provided project env!"
      '';
    };
}
