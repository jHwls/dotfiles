# macOS packages — installed via `brew bundle` (20-brew-bundle script).
# mise is prompt-gated, so the bundle script adds it separately.

# bun ships in its own tap, not homebrew/core
tap "oven-sh/bun"

# OVHcloud CLI ships in OVH's tap
tap "ovh/tap"

# Shells
brew "nushell"
brew "elvish"

# Multi-shell completion engine (git etc.)
brew "carapace"

# CLI tools
brew "fswatch"
brew "gh"
brew "git"
brew "git-delta"
brew "graphviz"
brew "harlequin"
brew "mkcert"
brew "pandoc"
brew "ripgrep"
brew "starship"
brew "telnet"
brew "zoxide"

# Infra / ops
brew "awscli"
brew "opentofu"
brew "restic"
cask "gcloud-cli"

# Misc
brew "exercism"
brew "woff2"
brew "wxwidgets" # erlang (via mise) links it for the wx GUI

# JS runtime
brew "oven-sh/bun/bun"

# Apps
# docker/docker-compose come from OrbStack's shims; brew docker intentionally unrecorded.
cask "ghostty"
cask "linear"
cask "ngrok"
cask "orbstack"
cask "postico"
cask "discord"
cask "firefox@developer-edition"
cask "fork"
cask "slack"
cask "session-manager-plugin" # AWS SSM sessions for awscli
cask "ovh/tap/ovhcloud-cli"

# Fonts
cask "font-iosevka"
cask "font-iosevka-term-nerd-font"
cask "font-iosevka-term-slab-nerd-font"

# 1Password — app provides the SSH agent + op-ssh-sign; `op` is the CLI.
cask "1password"
cask "1password-cli"
