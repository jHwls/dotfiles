#!/bin/bash
set -e
{{ if eq .chezmoi.os "darwin" }}
# elvish + nushell come from the Brewfile; put brew on PATH so `which` finds them.
eval "$(/opt/homebrew/bin/brew shellenv)"
{{ end }}
ELVISH=$(which elvish 2>/dev/null || echo "$HOME/.local/bin/elvish")
NU=$(which nu 2>/dev/null || echo "$HOME/.local/bin/nu")

# Register both in /etc/shells (required by chsh)
for SHELL_BIN in "$ELVISH" "$NU"; do
  if ! grep -qxF "$SHELL_BIN" /etc/shells; then
    echo "$SHELL_BIN" | sudo tee -a /etc/shells
  fi
done

# Set nushell as the default login shell
chsh -s "$NU"
echo "Default shell set to nushell: $NU"
echo "Elvish also available at: $ELVISH"
