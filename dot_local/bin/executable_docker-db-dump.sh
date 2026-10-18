#!/bin/sh
# Dump docker-managed database state into ~/backups, which restic backs up.
# Volumes live inside the OrbStack VM disk — a file-level copy of that image
# is torn while containers run, so logical dumps are the backup mechanism.
# If a job fires while OrbStack is stopped it fails; the next calendar run
# picks up. Run manually after starting OrbStack if the log shows a miss.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
set -eu
set -o pipefail

OUT="$HOME/backups"
mkdir -p "$OUT"

log() { printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"; }
log_error() { log "ERROR: $*" >&2; }

# Notifications are best-effort; never fail the dump because of one.
notify() {
  osascript -e "display notification \"$1\" with title \"docker-db-dump\"" >/dev/null 2>&1 || :
}
notify_err() {
  osascript -e "display notification \"$1\" with title \"docker-db-dump\" sound name \"Basso\"" >/dev/null 2>&1 || :
}

SIZES=

# Dump to a tmp file and verify before swapping in — a failed dump must never
# clobber the last good one.
dump_db() {
  file="$1"
  container="$2"
  db="$3"
  shift 3
  log "dumping $container/$db -> $file"
  tmp="$OUT/$file.tmp"
  if ! docker exec "$container" pg_dump -U postgres "$@" "$db" | gzip > "$tmp"; then
    log_error "pg_dump of $db from $container failed — previous $file kept"
    rm -f "$tmp"
    return 1
  fi
  if ! gzip -t "$tmp"; then
    log_error "$file failed gzip integrity check — previous $file kept"
    rm -f "$tmp"
    return 1
  fi
  mv "$tmp" "$OUT/$file"
  log "done: $file ($(du -h "$OUT/$file" | cut -f1))"
  SIZES="$SIZES ${file%.sql.gz} $(du -h "$OUT/$file" | cut -f1)"
}

if ! docker info >/dev/null 2>&1; then
  log_error "docker daemon unreachable — is OrbStack running?"
  notify_err "docker daemon unreachable — is OrbStack running?"
  exit 1
fi

# Per-db pg_dump rather than pg_dumpall: a fresh volume recreates roles and
# databases via dev/postgres/init-dbs.sh, so only table data needs backing up.
# Bifrost's db holds the gateway config (providers, keys, governance, MCP
# clients); its usage-log tables are excluded by data only — schema is kept,
# so a restore leaves a working bifrost. pg_dump silently ignores patterns
# that match nothing, so a table added or renamed by a bifrost upgrade would
# quietly start being dumped again; the done: sizes show it.
status=0
dump_db hub-dev-pg.sql.gz hub-postgres-1 hub_dev || status=1
dump_db bifrost-config-pg.sql.gz hub-postgres-1 bifrost \
  --exclude-table-data=logs \
  --exclude-table-data=mcp_tool_logs \
  --exclude-table-data=agent_logs \
  --exclude-table-data='warp_*' || status=1

if [ "$status" -eq 0 ]; then
  log "all dumps complete"
  notify "all dumps complete —$SIZES"
else
  log_error "finished with errors"
  notify_err "dump failed — see ~/Library/Logs/backup/docker-dbdump.log"
fi
exit "$status"
