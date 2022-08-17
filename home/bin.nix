{ writeScriptBin }:

[
  (writeScriptBin
    "proj"
    ''
      nix flake init --template github:the-nix-way/nome
    '')
]
