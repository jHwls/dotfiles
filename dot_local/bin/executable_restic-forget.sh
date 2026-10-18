#!/bin/sh
# restic forget/prune; launchd runs it Sundays at 10:00. Secrets come from
# 1Password via op:// refs in the env file — a locked 1Password fails the run,
# and the notification is the signal to check ~/Library/Logs/restic/forget.log.
set -eu

# Notifications are best-effort; never fail the prune because of one.
notify_ok() {
  osascript -e "display notification \"$1\" with title \"restic prune\"" >/dev/null 2>&1 || :
}
notify_err() {
  osascript -e "display notification \"$1\" with title \"restic prune\" sound name \"Basso\"" >/dev/null 2>&1 || :
}

# Full output is reprinted to stdout, which launchd sends to the log file.
if ! out=$(
  . "$HOME/.config/restic/r2.env"
  exec restic forget --keep-daily 7 --keep-weekly 5 --keep-monthly 12 --prune 2>&1
); then
  printf '%s\n' "$out"
  notify_err "prune failed — see ~/Library/Logs/restic/forget.log"
  exit 1
fi
printf '%s\n' "$out"
notify_ok "prune complete"
