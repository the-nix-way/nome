# Deletes the target directories of Rust projects under $HOME. Pass --dry-run to only list them.

dry_run=false
if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run=true
fi

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

success() { printf '\n%s %s\n' "$green${bold}✓$reset" "$bold$1$reset"; }
failure() { printf '%s %s\n' "$red${bold}✗$reset" "$1" >&2; }
row() { printf '  %s%7s%s  %s\n' "$blue" "$1" "$reset" "$2"; }

human_size() {
  awk -v kb="$1" 'BEGIN {
    if (kb >= 1048576) printf "%.1fG", kb / 1048576
    else if (kb >= 1024) printf "%.0fM", kb / 1024
    else printf "%dK", kb
  }'
}

plural() {
  if (($1 == 1)); then
    printf '1 directory'
  else
    printf '%d directories' "$1"
  fi
}

title="$purple${bold}clean-rust-targets$reset $muted$(date '+%Y-%m-%d %H:%M')$reset"
if [[ "$dry_run" == true ]]; then
  title+=" $muted(dry run)$reset"
fi
printf '%s\n\n' "$title"

# Deleting a target directory mid-build breaks the build, so leave it for the next run
if /usr/bin/pgrep -qx 'cargo|rustc'; then
  printf '%s\n' "${muted}Skipping: cargo or rustc is running$reset"
  exit 0
fi

count=0
total_kb=0
failed=0

# The media and document folders are pruned because scanning them from a background job triggers
# macOS permission prompts, and files there can be iCloud placeholders that can't be read
while IFS= read -r -d "" tag; do
  # Cargo writes this tag, so it tells a build directory apart from a directory that's just named target
  if ! grep -qs "created by cargo" "$tag"; then
    continue
  fi

  dir=$(dirname "$tag")
  kb=$(du -sk "$dir" 2>/dev/null | awk '{print $1}' || true)
  kb=${kb:-0}

  if [[ "$dry_run" == false ]] && ! rm -rf "$dir" 2>/dev/null; then
    failure "Couldn't delete ~${dir#"$HOME"}"
    failed=$((failed + 1))
    continue
  fi

  row "$(human_size "$kb")" "~${dir#"$HOME"}"
  count=$((count + 1))
  total_kb=$((total_kb + kb))
done < <(
  find "$HOME" \
    \( \
    -path "$HOME/Desktop" -o \
    -path "$HOME/Documents" -o \
    -path "$HOME/Downloads" -o \
    -path "$HOME/Library" -o \
    -path "$HOME/Movies" -o \
    -path "$HOME/Music" -o \
    -path "$HOME/Pictures" -o \
    -name .cargo -o \
    -name .git -o \
    -name .rustup -o \
    -name .Trash -o \
    -name node_modules \
    \) -prune -o \
    -type f -path "*/target/CACHEDIR.TAG" -print0 2>/dev/null
)

if ((count == 0 && failed == 0)); then
  printf '%s\n' "${muted}Nothing to clean$reset"
elif ((count > 0)); then
  if [[ "$dry_run" == true ]]; then
    success "Would free $(human_size "$total_kb") from $(plural "$count")"
  else
    success "Freed $(human_size "$total_kb") from $(plural "$count")"
  fi
fi

if ((failed > 0)); then
  exit 1
fi
