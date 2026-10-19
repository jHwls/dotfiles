#!/bin/sh
# Spin up a throwaway Linux container and run the README's remote bootstrap
# (installer -> chezmoi init --apply) against the current working tree, then
# assert the expected remote result: shells + CLI config + networking tools,
# no backup chain, second apply a no-op.
#
# Usage: test/linux-bootstrap.sh [--image IMG] [--platform P] [--keep]
# Defaults: debian:bookworm-slim, linux/amd64.
#
# Requires docker. The repo is mounted read-only as the container's chezmoi
# source dir, so the test always exercises exactly what is in this checkout,
# including uncommitted changes.
set -eu

IMAGE=debian:bookworm-slim
PLATFORM=linux/amd64
KEEP=0

usage() {
  sed -n '2,10p' "$0"
}

while [ $# -gt 0 ]; do
  case $1 in
    --image) IMAGE=$2; shift 2 ;;
    --platform) PLATFORM=$2; shift 2 ;;
    --keep) KEEP=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'unknown arg: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

command -v docker >/dev/null 2>&1 || { echo "docker CLI not found" >&2; exit 1; }

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
NAME=dotfiles-bootstrap-test-$$

if [ "$KEEP" -eq 0 ]; then
  trap 'docker rm -f "$NAME" >/dev/null 2>&1 || :' EXIT
fi

printf '== container %s (%s, %s)\n' "$NAME" "$IMAGE" "$PLATFORM"
docker rm -f "$NAME" >/dev/null 2>&1 || :
docker run -d --platform "$PLATFORM" --name "$NAME" \
  -v "$ROOT":/root/.local/share/chezmoi:ro \
  "$IMAGE" sleep 3600 >/dev/null

rc=0
docker exec -i "$NAME" sh -s <<'EOF' || rc=$?
set -u
fail=0
ok() { printf 'PASS %s\n' "$*"; }
no() { printf 'FAIL %s\n' "$*"; fail=1; }

. /etc/os-release
printf '== distro: %s %s (%s)\n' "${ID:-?}" "${VERSION_ID:-?}" "$(uname -m)"

FAMILY=unknown
case "${ID:-} ${ID_LIKE:-}" in
  *debian*|*ubuntu*) FAMILY=deb ;;
  *fedora*|*rhel*|*centos*) FAMILY=rpm ;;
  *arch*) FAMILY=arch ;;
  *alpine*) FAMILY=apk ;;
  *suse*) FAMILY=suse ;;
esac
echo "family: $FAMILY"

printf '== prereqs (curl + CA bundle)\n'
case "$FAMILY" in
  deb)  apt-get update -qq && apt-get install -y -qq --no-install-recommends ca-certificates curl bash ;;
  rpm)  dnf install -y curl ca-certificates bash || yum install -y curl ca-certificates bash ;;
  arch) pacman -Sy --noconfirm --needed curl ca-certificates bash ;;
  apk)  apk add --no-cache curl ca-certificates bash ;;
  suse) zypper --non-interactive install curl ca-certificates bash ;;
  *)    echo "unsupported distro family: $FAMILY" >&2; exit 1 ;;
esac && ok "prereqs installed" || no "prereqs install"

printf '== install chezmoi\n'
if curl -fsLS get.chezmoi.io -o /tmp/czm-install.sh && sh /tmp/czm-install.sh -b /usr/local/bin; then
  ok "chezmoi installed"
else
  no "chezmoi install"
fi
/usr/local/bin/chezmoi --version

printf '== bootstrap (chezmoi init --apply, non-interactive remote defaults)\n'
if /usr/local/bin/chezmoi init --apply; then
  ok "bootstrap apply"
else
  no "bootstrap apply"
fi

printf '== assertions\n'
for f in .zshrc .gitconfig .psqlrc .vimrc .config/nushell/config.nu .config/zsh/aliases.zsh .config/starship.toml; do
  if [ -e "$HOME/$f" ]; then ok "applied $f"; else no "applied $f"; fi
done

for f in .local/bin/docker-db-dump.sh .local/bin/restic-run.sh .local/bin/restic-forget.sh Library/LaunchAgents; do
  if [ ! -e "$HOME/$f" ]; then ok "absent on remote: $f"; else no "should be absent on remote: $f"; fi
done

for c in curl wget git dig nslookup ping nc traceroute mtr ss; do
  if command -v "$c" >/dev/null 2>&1; then ok "tool $c"; else no "tool $c"; fi
done

printf '== second apply (must be a no-op)\n'
if /usr/local/bin/chezmoi apply; then ok "second apply"; else no "second apply"; fi
if [ -z "$(/usr/local/bin/chezmoi status)" ]; then ok "status clean"; else no "status not clean"; fi

exit "$fail"
EOF

if [ "$rc" -eq 0 ]; then
  printf '\nBOOTSTRAP TEST: PASS\n'
else
  printf '\nBOOTSTRAP TEST: FAIL\n'
fi
if [ "$KEEP" -eq 1 ]; then
  printf 'container kept: docker exec -it %s sh   (docker rm -f %s when done)\n' "$NAME" "$NAME"
fi
exit "$rc"
