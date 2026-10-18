# dotfiles

chezmoi-managed macOS dotfiles. The source dir is this repo at
`~/repos/dotfiles`; `CHEATSHEET.md` has the day-to-day chezmoi commands.

## Setup

Clone the repo to `~/repos/dotfiles`, then:

    chezmoi init    # regenerate ~/.config/chezmoi/chezmoi.toml from .chezmoi.toml.tmpl
    chezmoi apply

## Backups

Three launchd user agents run the nightly backup chain. Each posts macOS
notifications and logs under `~/Library/Logs`:

| When | Script | launchd label |
| --- | --- | --- |
| daily 09:00 | `~/.local/bin/docker-db-dump.sh` | `com.threespeed.docker-dbdump` |
| daily 09:30 | `~/.local/bin/restic-run.sh` | `com.threespeed.restic.backup` |
| Sundays 10:00 | `~/.local/bin/restic-forget.sh` | `com.threespeed.restic.forget` |

- `docker-db-dump.sh` — logical `pg_dump` of the docker-managed databases
  into `~/backups` (a file-level copy of the OrbStack disk image is torn
  while containers run, so logical dumps are the backup mechanism).
- `restic-run.sh` — restic backup of `~/repos` and `~/backups` to
  Cloudflare R2.
- `restic-forget.sh` — restic forget/prune, with the retention flags as
  written in the script.

The plists live in `private_Library/LaunchAgents/` and apply to
`~/Library/LaunchAgents/`. The
`dot_chezmoiscripts/run_onchange_after_30-reload-launchd-agents.sh.tmpl`
script embeds each plist's checksum, so chezmoi re-runs it — a
`launchctl bootout` + `bootstrap` of all three labels — whenever a plist
changes.

### ~/.config/restic/r2.env (created by hand)

`r2.env` is created by hand and is not managed by chezmoi (it is listed in
`.chezmoiignore`). It exports the restic repository and credentials that
`restic-run.sh` and `restic-forget.sh` source at run time; secrets are
1Password `op://` references, resolved by the 1Password CLI when the backup
runs. Nothing under `.config/restic/` is committed to this repo.
