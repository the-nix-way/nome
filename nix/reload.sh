# Tokyo Night, to match the rest of the setup
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  reset=$'\e[0m'
  bold=$'\e[1m'
  blue=$'\e[38;2;122;162;247m'
  green=$'\e[38;2;158;206;106m'
  muted=$'\e[38;2;86;95;137m'
  purple=$'\e[38;2;187;154;247m'
  red=$'\e[38;2;247;118;142m'
else
  reset="" bold="" blue="" green="" muted="" purple="" red=""
fi

step() { printf '\n%s %s\n' "$blue${bold}▸$reset" "$bold$1$reset"; }
note() { printf '  %s\n' "$muted$1$reset"; }
success() { printf '\n%s %s\n' "$green${bold}✓$reset" "$bold$1$reset"; }
failure() { printf '\n%s %s\n' "$red${bold}✗$reset" "$bold$1$reset" >&2; }

elapsed() {
  local minutes=$((SECONDS / 60)) seconds=$((SECONDS % 60))
  if ((minutes > 0)); then
    printf '%dm %ds' "$minutes" "$seconds"
  else
    printf '%ds' "$seconds"
  fi
}

# Only move aside real files; symlinks into /etc/static are already managed by nix-darwin
move_aside() {
  if [[ -f "$1" && ! -L "$1" ]]; then
    note "Moving $1 to $1.before-nix-darwin"
    sudo mv "$1" "$1.before-nix-darwin"
  fi
}

printf '%s %s\n' "$purple${bold}nome$reset" "$muted$DARWIN_CONFIG$reset"

move_aside /etc/nix/nix.custom.conf
move_aside /etc/nix/flake-registry.json
move_aside /etc/zshenv

# Resolve this now, since the switch repoints the symlink
previous=$(readlink -f /run/current-system || true)

step "Rebuilding and switching"
if sudo "$DARWIN_REBUILD" switch --flake ".#$DARWIN_CONFIG"; then
  if [[ -e "$previous" ]]; then
    step "What changed"
    nvd diff "$previous" /run/current-system || note "Couldn't compare with the previous generation"
  fi

  success "macOS config applied in $(elapsed)"
  note "Restarting zsh"
  exec zsh -l
else
  failure "darwin-rebuild switch failed after $(elapsed)"
  exit 1
fi
