#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO_PATH="/mnt/data/git/srv-m1m"
TOOLKIT_DIR="$REPO_PATH/toolkit"
USER_HOME="$HOME"
LOG_FILE="/var/log/deploy_toolkit_config_$(date +%Y%m%d_%H%M%S).log"

log_info()    { echo "[INFO]    $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_success() { echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_error()   { echo "[ERROR]   $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }

log_info "Deploying toolkit configuration from $TOOLKIT_DIR"

cd "$REPO_PATH" || { log_error "Repo not found at $REPO_PATH"; exit 1; }

BEFORE_COMMIT=$(git rev-parse HEAD)
log_info "Current commit: $BEFORE_COMMIT"

git pull origin master || { log_error "Git pull failed"; exit 1; }

AFTER_COMMIT=$(git rev-parse HEAD)
log_info "Updated to commit: $AFTER_COMMIT"

if [ "$BEFORE_COMMIT" = "$AFTER_COMMIT" ]; then
    log_info "No updates. Toolkit config already current."
    exit 0
fi

log_info "Deploying updated toolkit configs..."

# Ensure config directories exist
mkdir -p "$USER_HOME/.config"
mkdir -p "$USER_HOME/.local/bin"

# Editors
ln -sf "$TOOLKIT_DIR/editors/nvim" "$USER_HOME/.config/nvim"
ln -sf "$TOOLKIT_DIR/editors/zk/config.toml" "$USER_HOME/.config/zk/config.toml"
ln -sf "$TOOLKIT_DIR/editors/zk/templates" "$USER_HOME/.config/zk/templates"

# Shell
ln -sf "$TOOLKIT_DIR/shell/aliases.sh" "$USER_HOME/.config/shell/aliases.sh"
ln -sf "$TOOLKIT_DIR/shell/functions.sh" "$USER_HOME/.config/shell/functions.sh"
ln -sf "$TOOLKIT_DIR/shell/profile.sh" "$USER_HOME/.config/shell/profile.sh"
ln -sf "$TOOLKIT_DIR/shell/gitconfig" "$USER_HOME/.gitconfig"

# Terminal
ln -sf "$TOOLKIT_DIR/terminal/foot" "$USER_HOME/.config/foot"
ln -sf "$TOOLKIT_DIR/terminal/tmux" "$USER_HOME/.config/tmux"

# Terminal UI
ln -sf "$TOOLKIT_DIR/terminal-ui/fuzzel" "$USER_HOME/.config/fuzzel"
ln -sf "$TOOLKIT_DIR/terminal-ui/lazygit" "$USER_HOME/.config/lazygit"
ln -sf "$TOOLKIT_DIR/terminal-ui/vimb" "$USER_HOME/.config/vimb"

# Window Manager
ln -sf "$TOOLKIT_DIR/window-manager/config" "$USER_HOME/.config/sway/config"
ln -sf "$TOOLKIT_DIR/window-manager/colors.conf" "$USER_HOME/.config/sway/colors.conf"

# Git hooks
ln -sf "$TOOLKIT_DIR/git/hooks" "$USER_HOME/.config/git/hooks"

# Rust binaries (if any)
if [ -d "$TOOLKIT_DIR/bin/rust" ]; then
    cp -r "$TOOLKIT_DIR/bin/rust/"* "$USER_HOME/.local/bin/" 2>/dev/null || true
fi

log_success "Toolkit config deployed successfully"
log_info "Previous: $BEFORE_COMMIT"
log_info "Current:  $AFTER_COMMIT"

# Reload sway if running
if pgrep -x sway >/dev/null; then
    swaymsg reload && log_info "Reloaded sway config"
fi

