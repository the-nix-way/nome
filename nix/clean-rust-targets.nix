{ writeShellApplication }:

writeShellApplication {
  name = "clean-rust-targets";
  text = builtins.readFile ./clean-rust-targets.sh;
}
