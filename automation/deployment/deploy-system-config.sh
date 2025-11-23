#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO_PATH="/mnt/data/git/srv-m1m"
LOG_FILE="/var/log/deploy_system_config_$(date +%Y%m%d_%H%M%S).log"

log_info()    { echo "[INFO]    $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_success() { echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_error()   { echo "[ERROR]   $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }

check_root() {
    [[ $EUID -ne 0 ]] && { log_error "Must run as root"; exit 1; }
}

log_info "Deploying system configuration from $REPO_PATH"
check_root

cd "$REPO_PATH" || { log_error "Repo not found at $REPO_PATH"; exit 1; }

BEFORE_COMMIT=$(git rev-parse HEAD)
log_info "Current commit: $BEFORE_COMMIT"

git pull origin master || { log_error "Git pull failed"; exit 1; }

AFTER_COMMIT=$(git rev-parse HEAD)
log_info "Updated to commit: $AFTER_COMMIT"

if [ "$BEFORE_COMMIT" = "$AFTER_COMMIT" ]; then
    log_info "No updates. System config already current."
    exit 0
fi

log_info "Deploying updated configurations..."

# Example: Copy automation scripts to /usr/local/bin or /opt
# Adjust paths based on actual repo structure
# cp -r automation/scripts/* /usr/local/bin/

# Example: Deploy systemd units if changed
# cp automation/systemd/*.service /etc/systemd/system/
# systemctl daemon-reload

log_success "System config deployed successfully"
log_info "Previous: $BEFORE_COMMIT"
log_info "Current:  $AFTER_COMMIT"

