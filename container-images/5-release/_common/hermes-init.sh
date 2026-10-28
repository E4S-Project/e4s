#!/bin/bash
# Idempotent HERMES_HOME seeding, run by hermes-wrapper.sh once per image version.
# Modeled on upstream's container stage2 hook.
set -eu
: "${HERMES_HOME:?run via the hermes wrapper}"
SRC=/opt/hermes
PY=/opt/hermes/.venv/bin/python

umask 077
mkdir -p "$HERMES_HOME"/{backups,cron,sessions,logs/gateways,hooks,memories,skills,skins,plans,workspace,home,pairing,platforms/pairing}

seed() { [ -f "$HERMES_HOME/$1" ] || { [ -f "$SRC/$2" ] && cp "$SRC/$2" "$HERMES_HOME/$1"; } || true; }
seed .env .env.example
[ -f "$HERMES_HOME/.env" ] && chmod 600 "$HERMES_HOME/.env"
seed config.yaml cli-config.yaml.example
seed SOUL.md docker/SOUL.md

# SQLite WAL is unsafe on network filesystems. Upstream only auto-detects virtiofs/9p, so
# anything that isn't a known local fs (NFS, Lustre, GPFS, ...) gets rollback-journal mode
# before the first database open.
if [ ! -f "$HERMES_HOME/.journal-mode-checked" ]; then
  case "$(stat -f -c %T "$HERMES_HOME" 2>/dev/null || echo unknown)" in
    ext*|xfs|btrfs|tmpfs|overlay*|zfs) ;;
    *) /opt/hermes/.venv/bin/hermes config set database.journal_mode delete || true ;;
  esac
  touch "$HERMES_HOME/.journal-mode-checked"
fi

"$PY" "$SRC/tools/skills_sync.py" || echo "[hermes-init] skills sync failed (continuing)" >&2
[ -f "$HERMES_HOME/config.yaml" ] && { "$PY" "$SRC/scripts/docker_config_migrate.py" || true; }
cp /etc/hermes/e4s-ref "$HERMES_HOME/.e4s-init-done"
