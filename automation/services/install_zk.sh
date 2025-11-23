#!/usr/bin/env bash

#===============================================================================
# zk Installation Script - Zettelkasten CLI Tool
#===============================================================================
# Author       : user
# Date         : 2025-11-22
# Environment  : Fedora Asahi Remix 42 ARM64 (Apple Silicon)
# Target System: srv-m1m
#-------------------------------------------------------------------------------
# Purpose      : Install zk (Zettelkasten note management CLI)
# Binary Path  : /usr/local/bin/zk
# Config Dir   : ~/.config/zk/ (symlinked to toolkit)
# Notebook Dir : /mnt/data/git/user-GNOSIS
# Database     : SQLite (embedded, stored in notebook .zk/ directory)
# Notes        : CLI-only tool, no systemd service required
#===============================================================================

set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES
#===============================================================================

APP_NAME="zk"
ZK_VERSION="0.14.1"
INSTALL_DIR="/usr/local/bin"
BINARY_PATH="$INSTALL_DIR/zk"
CONFIG_DIR="$HOME/.config/zk"
TOOLKIT_ZK_DIR="/mnt/data/git/srv-m1m/toolkit/editors/zk"
NOTEBOOK_DIR="/mnt/data/git/user-GNOSIS"
DOWNLOAD_URL="https://github.com/zk-org/zk/releases/download/v${ZK_VERSION}/zk-${ZK_VERSION}-linux-arm64.tar.gz"
TEMP_DIR="/tmp/zk-install"
LOG_FILE="/var/log/zk_install_$(date +%Y%m%d_%H%M%S).log"

#===============================================================================
# SECTION 2: UTILITY FUNCTIONS
#===============================================================================

log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"
}

log_warn() {
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"
}

log_success() {
    echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (binary installation to /usr/local/bin)"
        exit 1
    fi
}

cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        log_info "Cleaned up temporary directory"
    fi
}

trap cleanup EXIT

#===============================================================================
# SECTION 3: PRE-FLIGHT CHECKS
#===============================================================================

log_info "Running pre-flight checks..."
check_root

# Check if zk is already installed
if [ -f "$BINARY_PATH" ]; then
    INSTALLED_VERSION=$($BINARY_PATH --version 2>/dev/null | awk '{print $2}' || echo "unknown")
    log_warn "zk already installed at $BINARY_PATH (version: $INSTALLED_VERSION)"
    
    if [ "$INSTALLED_VERSION" = "$ZK_VERSION" ]; then
        log_info "Requested version $ZK_VERSION already installed"
        read -rp "Reinstall anyway? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            log_warn "Installation aborted"
            exit 0
        fi
    else
        log_info "Upgrading from $INSTALLED_VERSION to $ZK_VERSION"
    fi
fi

# Check required tools
for cmd in curl tar; do
    if ! command -v $cmd >/dev/null 2>&1; then
        log_error "Required command not found: $cmd"
        exit 1
    fi
done

#===============================================================================
# SECTION 4: DOWNLOAD AND EXTRACT BINARY
#===============================================================================

log_info "Downloading zk v$ZK_VERSION for ARM64..."

mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

curl -L -o "zk.tar.gz" "$DOWNLOAD_URL" 2>&1 | tee -a "$LOG_FILE"

if [ ! -f "zk.tar.gz" ]; then
    log_error "Failed to download zk binary"
    exit 1
fi

log_info "Extracting binary..."
tar -xzf "zk.tar.gz"

if [ ! -f "zk" ]; then
    log_error "Binary not found after extraction"
    exit 1
fi

log_success "Downloaded and extracted zk binary"

#===============================================================================
# SECTION 5: INSTALL BINARY
#===============================================================================

log_info "Installing zk binary to $BINARY_PATH..."

# Backup existing binary if present
if [ -f "$BINARY_PATH" ]; then
    cp "$BINARY_PATH" "${BINARY_PATH}.backup-$(date +%Y%m%d-%H%M%S)"
    log_info "Backed up existing binary"
fi

# Install new binary
install -m 755 zk "$BINARY_PATH"

if [ ! -f "$BINARY_PATH" ]; then
    log_error "Failed to install binary to $BINARY_PATH"
    exit 1
fi

log_success "Binary installed at $BINARY_PATH"

#===============================================================================
# SECTION 6: CONFIGURE ZK (USER-LEVEL)
#===============================================================================

log_info "Configuring zk for user: $SUDO_USER"

# Determine actual user (script run with sudo)
ACTUAL_USER="${SUDO_USER:-$USER}"
ACTUAL_HOME=$(getent passwd "$ACTUAL_USER" | cut -d: -f6)
ACTUAL_CONFIG_DIR="$ACTUAL_HOME/.config/zk"

log_info "User home directory: $ACTUAL_HOME"
log_info "Config directory: $ACTUAL_CONFIG_DIR"

# Create config directory if missing
sudo -u "$ACTUAL_USER" mkdir -p "$ACTUAL_CONFIG_DIR"

# Symlink config and templates from toolkit (if toolkit exists)
if [ -d "$TOOLKIT_ZK_DIR" ]; then
    log_info "Linking configuration from toolkit..."
    
    # Remove existing config/templates if they're not symlinks
    if [ -f "$ACTUAL_CONFIG_DIR/config.toml" ] && [ ! -L "$ACTUAL_CONFIG_DIR/config.toml" ]; then
        mv "$ACTUAL_CONFIG_DIR/config.toml" "$ACTUAL_CONFIG_DIR/config.toml.backup-$(date +%Y%m%d-%H%M%S)"
        log_warn "Backed up existing config.toml"
    fi
    
    if [ -d "$ACTUAL_CONFIG_DIR/templates" ] && [ ! -L "$ACTUAL_CONFIG_DIR/templates" ]; then
        mv "$ACTUAL_CONFIG_DIR/templates" "$ACTUAL_CONFIG_DIR/templates.backup-$(date +%Y%m%d-%H%M%S)"
        log_warn "Backed up existing templates directory"
    fi
    
    # Create symlinks
    sudo -u "$ACTUAL_USER" ln -sf "$TOOLKIT_ZK_DIR/config.toml" "$ACTUAL_CONFIG_DIR/config.toml"
    sudo -u "$ACTUAL_USER" ln -sf "$TOOLKIT_ZK_DIR/templates" "$ACTUAL_CONFIG_DIR/templates"
    
    log_success "Configuration symlinked from toolkit"
else
    log_warn "Toolkit directory not found at $TOOLKIT_ZK_DIR"
    log_info "Skipping configuration symlink (manual setup required)"
fi

# Verify notebook directory exists
if [ ! -d "$NOTEBOOK_DIR" ]; then
    log_warn "Notebook directory not found: $NOTEBOOK_DIR"
    log_info "Create it with: git clone <notebook-repo> $NOTEBOOK_DIR"
else
    log_success "Notebook directory exists: $NOTEBOOK_DIR"
fi

#===============================================================================
# SECTION 7: VERIFICATION
#===============================================================================

log_info "Running verification checks..."

# Verify binary is executable
if ! "$BINARY_PATH" --version >/dev/null 2>&1; then
    log_error "Binary installed but not executable or corrupted"
    exit 1
fi

INSTALLED_VERSION=$("$BINARY_PATH" --version | awk '{print $2}')
log_success "zk version $INSTALLED_VERSION installed successfully"

# Verify config symlinks
if [ -L "$ACTUAL_CONFIG_DIR/config.toml" ]; then
    log_success "Config symlink verified: $(readlink "$ACTUAL_CONFIG_DIR/config.toml")"
else
    log_warn "Config file not symlinked (manual configuration may be needed)"
fi

if [ -L "$ACTUAL_CONFIG_DIR/templates" ]; then
    log_success "Templates symlink verified: $(readlink "$ACTUAL_CONFIG_DIR/templates")"
else
    log_warn "Templates directory not symlinked"
fi

#===============================================================================
# SECTION 8: INSTALLATION SUMMARY
#===============================================================================

echo
echo "====================================="
echo " zk Installation Complete"
echo "====================================="
echo
log_success "zk v$ZK_VERSION successfully installed"
echo
echo "📋 Installation Information:"
echo "  Binary Path     : $BINARY_PATH"
echo "  Version         : $INSTALLED_VERSION"
echo "  Config Dir      : $ACTUAL_CONFIG_DIR"
echo "  Toolkit Source  : $TOOLKIT_ZK_DIR"
echo "  Notebook Dir    : $NOTEBOOK_DIR"
echo
echo "🔗 Configuration:"
if [ -L "$ACTUAL_CONFIG_DIR/config.toml" ]; then
    echo "  config.toml     : ✓ symlinked to toolkit"
else
    echo "  config.toml     : ⚠ not configured"
fi
if [ -L "$ACTUAL_CONFIG_DIR/templates" ]; then
    echo "  templates       : ✓ symlinked to toolkit"
else
    echo "  templates       : ⚠ not configured"
fi
echo
echo "📝 Useful Commands:"
echo "  Check version   : zk --version"
echo "  List notes      : zk list"
echo "  Create note     : zk new"
echo "  Edit recent     : zk edit --sort created- --interactive"
echo "  View config     : zk config"
echo "  Show aliases    : grep '^\[alias\]' -A 50 ~/.config/zk/config.toml"
echo
echo "🗄️  Database:"
echo "  Type            : SQLite (embedded)"
echo "  Location        : $NOTEBOOK_DIR/.zk/"
echo "  No service required (CLI tool only)"
echo
echo "⚠️  Setup Notes:"
if [ ! -d "$NOTEBOOK_DIR" ]; then
    echo "  - Notebook directory not found"
    echo "  - Clone your notebook: git clone <repo> $NOTEBOOK_DIR"
fi
if [ ! -d "$TOOLKIT_ZK_DIR" ]; then
    echo "  - Toolkit directory not found"
    echo "  - Manual configuration required at $ACTUAL_CONFIG_DIR"
fi
echo
echo "🔗 Next Steps:"
echo "  1. Verify notebook exists: ls -la $NOTEBOOK_DIR"
echo "  2. Initialize zk database: cd $NOTEBOOK_DIR && zk index"
echo "  3. Test note creation: zk new --title 'Test Note'"
echo "  4. Review configuration: zk config"
echo
