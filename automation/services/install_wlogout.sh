#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

APP_NAME="wlogout"
INSTALL_DIR="/usr/local/bin"
BINARY_PATH="$INSTALL_DIR/wlogout"
KEYBIND='bindsym $mod+Shift+x exec wlogout'
SWAY_CONFIG="$HOME/.config/sway/config"
SRC_DIR="/tmp/wlogout-src"
LOG_FILE="/var/log/install_wlogout_$(date +%Y%m%d_%H%M%S).log"

log_info()    { echo "[INFO]    $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_success() { echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_warn()    { echo "[WARN]    $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_error()   { echo "[ERROR]   $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

log_info "Running pre-flight checks..."
check_root

for pkg in meson ninja-build gcc gtk3-devel jq; do
    rpm -q $pkg &>/dev/null || { log_error "$pkg not installed"; exit 1; }
done

# Remove any broken binary
if [ -f "$BINARY_PATH" ]; then
    sudo rm -f "$BINARY_PATH"
    log_info "Removed previous wlogout binary"
fi

# Build wlogout from source
rm -rf "$SRC_DIR"
git clone https://github.com/ArtsyMacaw/wlogout.git "$SRC_DIR"
cd "$SRC_DIR"
meson setup build
ninja -C build
sudo ninja -C build install
cd ~

[ -x "$BINARY_PATH" ] || { log_error "wlogout install failed"; exit 1; }
log_success "Installed $APP_NAME at $BINARY_PATH"

# Create config directory if missing
mkdir -p "$HOME/.config/wlogout"

# Clean any broken/duplicate keybinds:
sed -i '/wlogout launcher/,+1d' "$SWAY_CONFIG"
sed -i '/bindsym $mod\+Shift\+x.*$/d' "$SWAY_CONFIG"
sed -i '/bindsym $mod\+Shift\+e.*wlogout.*$/d' "$SWAY_CONFIG"

# Insert correct keybind
echo "$KEYBIND" >> "$SWAY_CONFIG"

# Reload sway
swaymsg reload

"$BINARY_PATH" --help >/dev/null 2>&1
[ $? -eq 0 ] && log_success "wlogout binary verified operational"

echo
echo "====================================="
echo " $APP_NAME Installation Complete"
echo "====================================="
echo "Keybinding $KEYBIND applied to $SWAY_CONFIG"
echo

