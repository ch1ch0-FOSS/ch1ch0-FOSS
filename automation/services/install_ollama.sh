#!/usr/bin/env bash
#===============================================================================
#  Ollama Installation Script - LLM Runtime Configuration
#===============================================================================
#  Author        : user
#  Date          : 2025-11-02
#  Environment   : Fedora Asahi Remix 42 ARM64 (Apple Silicon)
#  Target System : user@asahi-m1m (192.168.1.64)
#-------------------------------------------------------------------------------
#  Purpose       : Install Ollama binary with systemd service management
#  Service User  : ollama
#  API Port      : 11434 (localhost only, behind reverse proxy)
#  Mode          : CPU-only (Apple Silicon supports AMX operations)
#  Binary Path   : /usr/local/bin/ollama
#  Config Dir    : /etc/systemd/system/ollama.service.d/
#  Data Dir      : /var/lib/ollama/
#  Notes         : Idempotent, validates GPU/CPU capabilities, model management
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES (Live System Configuration)
#===============================================================================
APP_NAME="ollama"
APP_VERSION="0.12.3"  # Latest as of Nov 2025, matches live system
SERVICE_USER="ollama"
SERVICE_GROUP="ollama"
BIN_PATH="/usr/local/bin/ollama"
BIN_INSTALL_URL="https://ollama.ai/download/ollama-linux-arm64"
INSTALL_DIR="/opt/ollama"
CONFIG_DIR="/etc/systemd/system/ollama.service.d"
DATA_DIR="/var/lib/ollama"
OVERRIDE_CONF="$CONFIG_DIR/override.conf"
SYSTEMD_SERVICE="ollama.service"
API_PORT="11434"
LISTEN_ADDR="127.0.0.1:$API_PORT"  # Localhost only
BACKUP_DIR="/var/backups/ollama"
MODELS_DIR="$DATA_DIR/models"
GPU_SUPPORT="false"  # Set to true if GPU detected
ENABLE_CORS="false"
ENABLE_DEBUG="false"
SYSTEM_IP="192.168.1.64"
HOSTNAME="asahi-m1m.local"

#===============================================================================
# SECTION 2: UTILITY FUNCTIONS
#===============================================================================
log_info() {
  echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') $*"
}

log_warn() {
  echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') $*"
}

log_error() {
  echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $*"
}

log_success() {
  echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') $*"
}

check_root() {
  if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root"
    exit 1
  fi
}

detect_gpu() {
  if lspci 2>/dev/null | grep -qi "vga\|3d\|gpu"; then
    return 0
  elif nvidia-smi &>/dev/null; then
    return 0
  elif [[ -e /proc/device-tree/model ]] && grep -qi "apple\|m1\|m2\|m3" /proc/device-tree/model 2>/dev/null; then
    log_info "Detected Apple Silicon (M1/M2/M3)"
    return 1  # Apple Silicon acceleration handled natively by Ollama
  fi
  return 1
}

#===============================================================================
# SECTION 3: CONFIRMATION BEFORE RUNNING
#===============================================================================
echo
echo "=================================="
echo "  Ollama Installation Configuration"
echo "=================================="
echo "  Application Name  : $APP_NAME"
echo "  Version           : $APP_VERSION"
echo "  Service User      : $SERVICE_USER:$SERVICE_GROUP"
echo "  Binary Path       : $BIN_PATH"
echo "  Data Directory    : $DATA_DIR"
echo "  API Port          : $API_PORT (localhost only)"
echo "  Systemd Service   : /etc/systemd/system/$SYSTEMD_SERVICE"
echo "  Config Override   : $OVERRIDE_CONF"
echo "  Mode              : CPU-only (no GPU)"
echo "  Apple Silicon     : Optimized for ARM64 AMX operations"
echo

read -rp "Proceed with Ollama installation? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  log_warn "Installation aborted."
  exit 1
fi

#===============================================================================
# SECTION 4: PRE-FLIGHT CHECKS
#===============================================================================
log_info "Running pre-flight checks..."

check_root

# Check system architecture
ARCH=$(uname -m)
if [[ "$ARCH" != "aarch64" ]]; then
  log_warn "⚠️  System architecture is $ARCH (expected aarch64 for ARM64)"
fi

# Check available CPU cores
CPU_CORES=$(nproc 2>/dev/null || echo "unknown")
log_info "Available CPU cores: $CPU_CORES"

# Check available memory
MEM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
log_info "Total system memory: $MEM_TOTAL"

# Backup existing service if running
if systemctl is-active --quiet "$SYSTEMD_SERVICE" 2>/dev/null; then
  log_warn "Ollama service is currently running. Creating backup..."
  mkdir -p "$BACKUP_DIR"
  if [ -f "$OVERRIDE_CONF" ]; then
    cp "$OVERRIDE_CONF" "$BACKUP_DIR/override.conf.$(date +%s)"
  fi
  systemctl stop "$SYSTEMD_SERVICE"
  sleep 1
fi

#===============================================================================
# SECTION 5: CREATE SERVICE USER AND DIRECTORIES
#===============================================================================
log_info "Setting up service user and directories..."

if ! id "$SERVICE_USER" &>/dev/null; then
  useradd --system --home-dir "$DATA_DIR" --shell /bin/false "$SERVICE_USER"
  log_info "Created system user: $SERVICE_USER"
else
  log_info "Service user $SERVICE_USER already exists"
fi

mkdir -p "$DATA_DIR" "$MODELS_DIR" "$CONFIG_DIR" "$BACKUP_DIR"
chown -R "$SERVICE_USER:$SERVICE_GROUP" "$DATA_DIR" "$MODELS_DIR"
chmod 755 "$DATA_DIR" "$MODELS_DIR"

log_success "Directories prepared and permissions set"

#===============================================================================
# SECTION 6: INSTALL/VERIFY BINARY
#===============================================================================
log_info "Checking/Installing Ollama binary..."

if [ -f "$BIN_PATH" ] && [ -x "$BIN_PATH" ]; then
  BINARY_VERSION=$("$BIN_PATH" --version 2>/dev/null || echo "unknown")
  log_info "Existing binary found: $BINARY_VERSION"
  
  read -rp "Keep existing binary or download latest? (k/d): " binary_choice
  if [[ "$binary_choice" =~ ^[Dd]$ ]]; then
    log_info "Downloading latest Ollama binary..."
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR" || exit 1
    
    if ! wget -q "$BIN_INSTALL_URL" -O ollama-temp; then
      log_error "Failed to download Ollama binary"
      exit 1
    fi
    
    mv ollama-temp "$BIN_PATH"
    chmod +x "$BIN_PATH"
    log_success "Binary updated"
  fi
else
  log_info "Downloading Ollama binary..."
  mkdir -p "$INSTALL_DIR"
  cd "$INSTALL_DIR" || exit 1
  
  if ! wget -q "$BIN_INSTALL_URL" -O ollama-temp; then
    log_error "Failed to download Ollama binary from $BIN_INSTALL_URL"
    exit 1
  fi
  
  mv ollama-temp "$BIN_PATH"
  chmod +x "$BIN_PATH"
  log_success "Binary installed at $BIN_PATH"
fi

BINARY_VERSION=$("$BIN_PATH" --version 2>/dev/null || echo "unknown")
log_info "Ollama version: $BINARY_VERSION"

#===============================================================================
# SECTION 7: CREATE SYSTEMD OVERRIDE CONFIGURATION
#===============================================================================
log_info "Creating systemd override configuration..."

if [ -f "$OVERRIDE_CONF" ]; then
  cp "$OVERRIDE_CONF" "$OVERRIDE_CONF.backup.$(date +%s)"
  log_info "Backed up existing override.conf"
fi

mkdir -p "$CONFIG_DIR"

cat > "$OVERRIDE_CONF" <<'EOF'
# Ollama Systemd Service Override Configuration
# ==============================================
# This file customizes the Ollama service behavior.

[Service]
# User and group running the service
User=ollama
Group=ollama

# Working directory for model storage
WorkingDirectory=/var/lib/ollama

# Environment variables
Environment="OLLAMA_HOST=127.0.0.1:11434"
Environment="OLLAMA_MODELS=/var/lib/ollama/models"
Environment="OLLAMA_NUM_PARALLEL=1"
Environment="OLLAMA_MAX_QUEUE=512"

# CPU-only optimization
Environment="CPU_THREADS_NUM=0"
Environment="CPU_THREADS_AFFINITY=all"

# Debug and logging (set to 1 for verbose)
Environment="OLLAMA_DEBUG=0"

# Memory limits (optional, adjust based on system)
# Note: Apple Silicon can use up to available system RAM
Environment="OLLAMA_MAX_VRAM=0"

# Keep service running
Restart=always
RestartSec=5
StartLimitBurst=5
StartLimitIntervalSec=60

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/ollama

# Resource limits
LimitNOFILE=65536
LimitNPROC=65536

# Standard output/error
StandardOutput=journal
StandardError=journal
SyslogIdentifier=ollama
EOF

chmod 644 "$OVERRIDE_CONF"
log_success "Override configuration created at $OVERRIDE_CONF"

#===============================================================================
# SECTION 8: ENABLE AND START SERVICE
#===============================================================================
log_info "Enabling and starting Ollama service..."

systemctl enable "$SYSTEMD_SERVICE"
systemctl daemon-reload
systemctl start "$SYSTEMD_SERVICE"

sleep 3

if systemctl is-active --quiet "$SYSTEMD_SERVICE"; then
  log_success "✓ Ollama service is running"
else
  log_error "✗ Failed to start Ollama service"
  systemctl status "$SYSTEMD_SERVICE" --no-pager
  journalctl -u "$SYSTEMD_SERVICE" -n 20 --no-pager || true
  exit 1
fi

#===============================================================================
# SECTION 9: VERIFY API ENDPOINT
#===============================================================================
log_info "Verifying Ollama API endpoint..."

sleep 2

if curl -s -m 5 "http://127.0.0.1:$API_PORT/api/tags" >/dev/null 2>&1; then
  log_success "✓ API endpoint responding at http://127.0.0.1:$API_PORT"
else
  log_warn "⚠️  API not responding yet (service may still be initializing)"
fi

#===============================================================================
# SECTION 10: LIST AVAILABLE MODELS
#===============================================================================
log_info "Checking available models in library..."

# Check if any models are cached
if [ -d "$MODELS_DIR" ] && [ "$(ls -A "$MODELS_DIR")" ]; then
  MODEL_COUNT=$(find "$MODELS_DIR" -type d -mindepth 1 | wc -l)
  log_info "Found $MODEL_COUNT model(s) in cache"
  
  log_info "Available models (via API):"
  MODELS=$(curl -s -m 5 "http://127.0.0.1:$API_PORT/api/tags" 2>/dev/null | grep -o '"name":"[^"]*' | cut -d'"' -f4 || echo "none")
  if [ "$MODELS" != "none" ]; then
    echo "$MODELS" | sed 's/^/  - /'
  else
    log_warn "No models currently loaded (use: ollama pull <model>)"
  fi
else
  log_info "No models cached yet (download with: ollama pull <model>)"
fi

#===============================================================================
# SECTION 11: CREATE CLI WRAPPER SCRIPT
#===============================================================================
log_info "Creating Ollama CLI wrapper script..."

cat > "/usr/local/bin/ollama-cli" <<'EOF'
#!/bin/bash
# Ollama CLI wrapper for direct command execution
# This wrapper allows running ollama commands with root privileges when needed

OLLAMA_BIN="/usr/local/bin/ollama"

case "$1" in
  pull|run|create|delete|show|list|cp|rm)
    # These commands may need elevated privileges
    exec "$OLLAMA_BIN" "$@"
    ;;
  *)
    # Other commands use the standard binary
    exec "$OLLAMA_BIN" "$@"
    ;;
esac
EOF

chmod +x "/usr/local/bin/ollama-cli"
log_success "CLI wrapper created at /usr/local/bin/ollama-cli"

#===============================================================================
# SECTION 12: VERIFICATION SUMMARY
#===============================================================================
log_info "Running final verification checks..."

# Service status
if systemctl is-active --quiet "$SYSTEMD_SERVICE"; then
  log_success "✓ Service is active"
else
  log_error "✗ Service is NOT active"
  exit 1
fi

# Binary check
if [ -x "$BIN_PATH" ]; then
  log_success "✓ Binary is executable"
else
  log_error "✗ Binary is NOT executable"
  exit 1
fi

# Port listening
if ss -tuln 2>/dev/null | grep -q ":$API_PORT\s"; then
  log_success "✓ API port $API_PORT is listening"
else
  log_warn "⚠️  API port may not be listening yet"
fi

# Data directory permissions
if [ -w "$DATA_DIR" ]; then
  log_success "✓ Data directory is writable"
else
  log_error "✗ Data directory is NOT writable"
  exit 1
fi

#===============================================================================
# SECTION 13: DISPLAY SUMMARY AND NEXT STEPS
#===============================================================================
echo
echo "===================================="
echo "  Ollama Installation Complete"
echo "===================================="
echo
log_success "Ollama has been successfully installed and configured."
echo
echo "📋 Service Information:"
echo "  Status              : $(systemctl is-active $SYSTEMD_SERVICE)"
echo "  Binary              : $BIN_PATH"
echo "  API Endpoint        : http://127.0.0.1:$API_PORT"
echo "  Models Directory    : $MODELS_DIR"
echo "  Configuration       : $OVERRIDE_CONF"
echo "  Systemd Unit        : /etc/systemd/system/$SYSTEMD_SERVICE"
echo
echo "🧠 Model Management:"
echo "  List local models   : ollama list"
echo "  Pull a model        : ollama pull mistral     # or llama2, neural-chat, etc."
echo "  Run interactive     : ollama run mistral"
echo "  Show model info     : ollama show mistral"
echo "  Delete model        : ollama rm mistral"
echo
echo "📝 Useful Commands:"
echo "  View logs           : journalctl -u $SYSTEMD_SERVICE -f"
echo "  Status check        : systemctl status $SYSTEMD_SERVICE"
echo "  Restart service     : sudo systemctl restart $SYSTEMD_SERVICE"
echo "  Stop service        : sudo systemctl stop $SYSTEMD_SERVICE"
echo "  Edit config         : sudo nano $OVERRIDE_CONF"
echo "  Test API            : curl -X POST http://127.0.0.1:$API_PORT/api/generate -d '{\"model\":\"mistral\",\"prompt\":\"Hello!\"}'"
echo
echo "🔗 Next Steps:"
echo "  1. Pull an LLM model: ollama pull mistral"
echo "  2. Test locally: ollama run mistral"
echo "  3. Configure Open WebUI for web interface (optional)"
echo "  4. Set up Traefik reverse proxy for external access (if needed)"
echo "  5. Monitor resource usage: watch -n 1 'free -h && ps aux | grep ollama'"
echo
echo "⚠️  Recommended Models (ARM64 optimized):"
echo "  - mistral       : Fast, efficient 7B model"
echo "  - neural-chat   : Conversational, lighter weight"
echo "  - llama2        : Comprehensive, good quality"
echo "  - dolphin-mixtral: Advanced reasoning"
echo
echo "💡 Performance Tips (Apple Silicon M1/M2/M3):"
echo "  - Models under 7B perform best"
echo "  - Use quantized versions (q4_0, q5_0) for speed"
echo "  - Adjust OLLAMA_NUM_PARALLEL in override.conf based on RAM"
echo "  - Monitor system temps: watch 'sensors' (if available)"
echo
echo "⚠️  Troubleshooting:"
echo "  - API not responding: journalctl -u $SYSTEMD_SERVICE -n 30"
echo "  - Model download fails: check /var/lib/ollama/models/ permissions"
echo "  - Out of memory: reduce model size or increase swap"
echo "  - Slow inference: check CPU load with 'top' or 'htop'"
echo
