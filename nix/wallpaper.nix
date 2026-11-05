{
  height ? 3384,
  jetbrains-mono,
  rev,
  runCommand,
  themes,
  typst,
  width ? 6016,
}:

let
  inherit (themes.wallpaper) accents bg muted;
in
runCommand "nome-wallpaper-${rev}.png"
  {
    nativeBuildInputs = [ typst ];
  }
  ''
    # Typst only reads images from alongside the document
    cp ${./wallpaper.typ} wallpaper.typ
    cp ${./detsys-logo.svg} detsys-logo.svg

    typst compile \
      --font-path ${jetbrains-mono}/share/fonts \
      --ignore-system-fonts \
      --format png \
      --ppi 144 \
      --input seed=${builtins.hashString "sha256" rev} \
      --input "label=nome @ ${rev}" \
      --input width=${toString width} \
      --input height=${toString height} \
      --input "bg=${bg}" \
      --input "muted=${muted}" \
      --input "accents=${builtins.concatStringsSep "," accents}" \
      wallpaper.typ \
      $out
  ''
