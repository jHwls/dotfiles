#!/bin/sh
# restic backup of repos and ~/backups to r2; launchd runs it daily at 09:30.
# Secrets come from 1Password via op:// refs in the env file — if 1Password is
# locked at run time, op times out and the backup fails; the notification is
# the signal to check ~/Library/Logs/restic/backup.log.
set -eu

LOG="$HOME/Library/Logs/restic/backup.log"

# Notifications are best-effort; never fail the backup because of one.
notify_ok() {
  osascript -e "display notification \"$1\" with title \"restic backup\"" >/dev/null 2>&1 || :
}
notify_err() {
  osascript -e "display notification \"$1\" with title \"restic backup\" sound name \"Basso\"" >/dev/null 2>&1 || :
}

do_backup() {
  . "$HOME/.config/restic/r2.env"
  restic backup \
    /Users/jhwls/repos \
    /Users/jhwls/backups \
    --exclude '**/node_modules' \
    --exclude '**/.turbo' \
    --exclude '**/.pnpm-store' \
    --exclude '**/.cache' \
    --exclude '**/assets/vendor' \
    --exclude '**/.next' \
    --exclude '**/target' \
    --exclude '**/dist' \
    --exclude '**/.venv' \
    --exclude '**/deps' \
    --exclude '**/_build'
}

# Full output is reprinted to stdout, which launchd sends to the log file.
if ! out=$(do_backup 2>&1); then
  printf '%s\n' "$out"
  notify_err "backup failed — see ~/Library/Logs/restic/backup.log"
  exit 1
fi
printf '%s\n' "$out"

snapshot=$(printf '%s\n' "$out" | tail -n 1 | awk '{print $2}')
case $snapshot in
  [0-9a-f]*) notify_ok "backup complete — snapshot $snapshot" ;;
  *) notify_ok "backup complete" ;;
esac
