# dotfiles

> Howdy, stranger! This is Hauser. If things have gone wrong, I'm talking to myself and you don't have a wet towel around your head. Now, whatever your name is, get ready for the big surprise. You are not you, you're me.

chezmoi-managed dotfiles: everything future me needs to get set up on a new
machine. Any local or remote, macOS or Linux.

The source dir is this repo at `~/repos/dotfiles` on the main machine;
everywhere else chezmoi clones it to `~/.local/share/chezmoi`.
`CHEATSHEET.md` has the day-to-day chezmoi commands, `BACKUPS.md` covers
the backup chain.

## Setting up main

The repo is the chezmoi source dir and gets edited in place:

```sh
git clone git@github.com:jHwls/dotfiles.git ~/repos/dotfiles
chezmoi init --source ~/repos/dotfiles   # generate ~/.config/chezmoi/chezmoi.toml from .chezmoi.toml.tmpl
chezmoi apply
```

On an already-set-up main machine, plain `chezmoi init` regenerates the
config — it reads the source dir from the existing config.

## Remotes/containers

Point chezmoi at the remote git and let it install, clone, generate the
config, and apply in one step:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jHwls
```

With chezmoi already installed, that is just `chezmoi init --apply jHwls`.
The source dir then lives in `~/.local/share/chezmoi`; `chezmoi update`
pulls later changes from the remote.

On a bare Debian/Ubuntu image, `curl` and the CA bundle come first:

```sh
apt-get update && apt-get install -y ca-certificates curl
```

Remotes get the shell and CLI config plus networking tools (curl, git,
wget, dig, ping, traceroute, mtr, nc); no backup scripts and no launchd
agents — those stay on the primary (`BACKUPS.md`).

## Machine flags

Two flags live in `[data]` of `~/.config/chezmoi/chezmoi.toml`, set when
`chezmoi init` generates the config from `.chezmoi.toml.tmpl`:

| Flag | Default | Controls |
| --- | --- | --- |
| `primary` | derived: the repo is cloned at `~/repos/dotfiles` | backup chain and launchd agents (primary only — `BACKUPS.md`); remote networking-tools script (non-primary Linux only) |
| `mise` | `false` | `~/.config/mise` is managed and mise is installed (brew on macOS, mise.run otherwise) |

An interactive `chezmoi init` asks once for each, with the primary default
pre-derived from the clone. Non-interactive runs — containers, CI — take
the defaults without prompting, which is how remotes stay light. Answers
are stored, so re-running `chezmoi init` keeps them; to flip a flag, edit
`[data]` in the config and `chezmoi apply`.

## Testing

`test/linux-bootstrap.sh` checks the remote route end to end in a
throwaway Linux container (docker required): prereqs, chezmoi install,
`chezmoi init --apply` with the non-interactive remote defaults, then
asserts the result — shell and CLI config applied, backup chain absent,
all networking tools present, second apply a no-op. The current checkout
is mounted read-only as the source dir, so the test always covers
uncommitted changes.

```sh
test/linux-bootstrap.sh                        # debian:bookworm-slim, amd64
test/linux-bootstrap.sh --image ubuntu:24.04   # also --platform linux/arm64, --keep
```
