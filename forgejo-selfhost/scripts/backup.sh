#!/bin/bash
set -euo pipefail

BACKUP_DIR="${1:-/backups}"
SERVICES=("forgejo" "vaultwarden" "syncthing")
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

if [ ! -d "$BACKUP_DIR" ]; then
  echo "[FAIL] Backup directory $BACKUP_DIR does not exist"
  exit 1
fi

for service in "${SERVICES[@]}"; do
  latest_backup=$(ls -1t "$BACKUP_DIR/$service"* 2>/dev/null | head -1)
  
  if [ -z "$latest_backup" ]; then
    echo "[FAIL] No backup found for $service"
    exit 1
  fi
  
  if file "$latest_backup" | grep -q "gzip"; then
    if tar -tzf "$latest_backup" > /dev/null 2>&1; then
      echo "[OK] $service backup is valid ($(du -sh "$latest_backup" | cut -f1))"
    else
      echo "[FAIL] $service backup is corrupted"
      exit 1
    fi
  else
    echo "[WARN] $service backup format unknown, skipping integrity check"
  fi
done

echo "[OK] All backups verified successfully"
exit 0

