#!/usr/bin/env bash
set -uo pipefail

fail=0

ok()   { printf "  ✅ %s\n" "$1"; }
bad()  { printf "  ❌ %s\n" "$1"; fail=1; }

echo "🔍 Checking symlinks..."
for f in \
  "$HOME/.zshrc" \
  "$HOME/.gitconfig" \
  "$HOME/.config/ghostty/config" \
  "$HOME/.config/starship/starship.toml" \
  "$HOME/.config/bat/config" \
  "$HOME/.config/karabiner/karabiner.json"
do
  if [ -L "$f" ]; then
    ok "$f -> $(readlink "$f")"
  elif [ -e "$f" ]; then
    bad "$f exists but is NOT a symlink (stow did not manage it)"
  else
    bad "$f is missing"
  fi
done

echo "🔍 Checking tools..."
for t in git gh fzf rg bat eza fd starship atuin zoxide direnv delta jq stow just; do
  if command -v "$t" >/dev/null 2>&1; then
    ok "$t"
  else
    bad "$t not found"
  fi
done

echo "🔍 Checking config validity..."

# Ghostty parses its own config and reports errors.
GHOSTTY=/Applications/Ghostty.app/Contents/MacOS/ghostty
if [ -x "$GHOSTTY" ]; then
  if out=$("$GHOSTTY" +validate-config --config-file="$HOME/.config/ghostty/config" 2>&1) && [ -z "$out" ]; then
    ok "ghostty config"
  else
    bad "ghostty config: $out"
  fi
else
  bad "ghostty not installed"
fi

# bat exits non-zero on an unknown option in its config file.
if bat --version >/dev/null 2>&1 && echo x | bat -p --language=txt >/dev/null 2>&1; then
  ok "bat config"
else
  bad "bat config rejected by bat (run: echo x | bat -p)"
fi

# print-config parses the TOML and warns on unknown/invalid keys on stderr.
# (Do NOT use `starship config` here — that opens $EDITOR.)
if command -v starship >/dev/null 2>&1; then
  if out=$(starship print-config 2>&1 >/dev/null) && [ -z "$out" ]; then
    ok "starship config"
  else
    bad "starship config: ${out:-unreadable}"
  fi
fi

# A Nerd Font is required for eza --icons and the starship glyphs.
if ls ~/Library/Fonts /Library/Fonts 2>/dev/null | grep -qi "nerdfont\|nerd font"; then
  ok "Nerd Font installed"
else
  bad "no Nerd Font found (icons will render as tofu)"
fi

echo "🔍 Checking zsh startup..."
# Run under a pty: several tools (fzf) emit harmless 'can't change option: zle'
# warnings when stderr/stdin is not a terminal, which is not a real failure.
# A pty echoes the EOF marker ("^D") and backspaces; those are terminal
# artifacts, not shell output. Strip them before deciding.
out=$(script -q /dev/null zsh -i -c 'exit' 2>&1 \
      | sed 's/\^D//g' \
      | tr -d '\r\b\a' \
      | grep -v '^[[:space:]]*$' || true)
if [ -n "$out" ]; then
  bad "zsh startup produced output:"$'\n'"$out"
else
  ok "zsh starts cleanly"
fi

if [ "$fail" -eq 0 ]; then
  echo "✅ All checks passed"
else
  echo "❌ Some checks failed"
  exit 1
fi
