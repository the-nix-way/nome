# Run the env.sh script (if it exists). That script is meant to contain secrets, tokens, and
# other things you don't want to put in your Nix config. This is quite "impure" but a
# reasonable workaround.
if [ -e ~/.env.sh ]; then
  . ~/.env.sh
fi

if [ -n "${REX_BIN_DIR:-}" ]; then
  export PATH="$REX_BIN_DIR:$PATH"
fi

bindkey '\e[3~' delete-char
