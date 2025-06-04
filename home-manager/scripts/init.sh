# Run the env.sh script (if it exists). That script is meant to contain secrets, tokens, and
# other things you don't want to put in your Nix config. This is quite "impure" but a
# reasonable workaround.
if [ -e ~/.env.sh ]; then
  . ~/.env.sh
fi

eval "$(ssh-agent -s)"

# Shell completion for various tools
eval "$(determinate-nixd completion zsh)"

# Go settings
eval "$(go env)"
export PATH="${GOPATH}/bin:${PATH}"

# Specific to FlakeHub dev
export ENVRC_USE_FLAKE="1"

export CARGO_NET_GIT_FETCH_WITH_CLI="true"
