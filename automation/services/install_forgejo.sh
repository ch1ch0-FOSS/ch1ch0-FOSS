#!/usr/bin/env bash
#===============================================================================
#  Forgejo Installation Script - Git Service Configuration
#===============================================================================
#  Author        : user
#  Date          : 2025-11-02
#  Environment   : Fedora Asahi Remix 42 ARM64 (Apple Silicon)
#  Target System : user@asahi-m1m (192.168.1.64)
#-------------------------------------------------------------------------------
#  Purpose       : Install Forgejo binary service with systemd management
#  Service User  : git
#  Binary Port   : 3000 (HTTP)
#  SSH Port      : 2222 (SSH git service)
#  Data Dir      : /var/lib/forgejo/data (owned by git:git)
#  Config        : /etc/forgejo/app.ini
#  Notes         : Idempotent, backs up existing configs, handles permissions
#===============================================================================
set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES (Live System Configuration)
#===============================================================================
APP_NAME="forgejo"
APP_VERSION="8.5.2"  # Latest stable as of Nov 2025
PKG_MANAGER="dnf"
SERVICE_USER="git"
SERVICE_GROUP="git"
INSTALL_DIR="/opt/forgejo"
CONFIG_DIR="/etc/forgejo"
DATA_DIR="/var/lib/forgejo/data"
BIN_PATH="/opt/forgejo/forgejo"
DOWNLOAD_URL="https://dl.forgejo.org/forgejo/8.5.2/forgejo-8.5.2-linux-arm64"
SYSTEMD_SERVICE="forgejo.service"
HTTP_PORT="3000"
SSH_PORT="2222"
BACKUP_DIR="/var/backups/forgejo"
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

#===============================================================================
# SECTION 3: CONFIRMATION BEFORE RUNNING
#===============================================================================
echo
echo "=================================="
echo "  Forgejo Installation Configuration"
echo "=================================="
echo "  Application Name  : $APP_NAME"
echo "  Version           : $APP_VERSION"
echo "  Service User      : $SERVICE_USER:$SERVICE_GROUP"
echo "  Install Directory : $INSTALL_DIR"
echo "  Config Directory  : $CONFIG_DIR"
echo "  Data Directory    : $DATA_DIR"
echo "  Binary Path       : $BIN_PATH"
echo "  HTTP Port         : $HTTP_PORT"
echo "  SSH Port          : $SSH_PORT"
echo "  Systemd Service   : /etc/systemd/system/$SYSTEMD_SERVICE"
echo "  System IP         : $SYSTEM_IP"
echo "  Hostname          : $HOSTNAME"
echo

read -rp "Proceed with Forgejo installation? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  log_warn "Installation aborted."
  exit 1
fi

#===============================================================================
# SECTION 4: PRE-FLIGHT CHECKS
#===============================================================================
log_info "Running pre-flight checks..."

check_root

if systemctl is-active --quiet "$SYSTEMD_SERVICE" 2>/dev/null; then
  log_warn "Forgejo service is currently running. Will create backup before upgrade."
  mkdir -p "$BACKUP_DIR"
  cp -rv "$CONFIG_DIR"/* "$BACKUP_DIR/config-$(date +%s)/" 2>/dev/null || true
  cp -rv "$DATA_DIR" "$BACKUP_DIR/data-$(date +%s)/" 2>/dev/null || true
  systemctl stop "$SYSTEMD_SERVICE"
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

mkdir -p "$INSTALL_DIR" "$CONFIG_DIR" "$DATA_DIR" "$BACKUP_DIR"
chown -R "$SERVICE_USER:$SERVICE_GROUP" "$DATA_DIR" "$CONFIG_DIR"
chmod 750 "$DATA_DIR" "$CONFIG_DIR"

log_success "Directories prepared and permissions set"

#===============================================================================
# SECTION 6: DOWNLOAD AND INSTALL BINARY
#===============================================================================
log_info "Downloading Forgejo binary version $APP_VERSION..."

if [ ! -f "$BIN_PATH" ] || [ ! -x "$BIN_PATH" ]; then
  mkdir -p "$INSTALL_DIR"
  cd "$INSTALL_DIR" || exit 1
  
  if ! wget -q "$DOWNLOAD_URL" -O forgejo-temp; then
    log_error "Failed to download Forgejo binary from $DOWNLOAD_URL"
    exit 1
  fi
  
  mv forgejo-temp "$BIN_PATH"
  chmod +x "$BIN_PATH"
  log_success "Binary installed at $BIN_PATH"
else
  log_warn "Binary already exists at $BIN_PATH, skipping download"
fi

#===============================================================================
# SECTION 7: GENERATE/BACKUP CONFIG
#===============================================================================
log_info "Configuring Forgejo application settings..."

if [ -f "$CONFIG_DIR/app.ini" ]; then
  cp "$CONFIG_DIR/app.ini" "$CONFIG_DIR/app.ini.backup.$(date +%s)"
  log_info "Backed up existing app.ini"
fi

# Create primary app.ini configuration
cat > "$CONFIG_DIR/app.ini" <<'EOF'
APP_NAME = Forgejo Git Service
RUN_USER = git
RUN_MODE = prod

[server]
HTTP_ADDR = 0.0.0.0
HTTP_PORT = 3000
PROTOCOL = http
ROOT_URL = http://asahi-m1m.local:3000/
SSH_DOMAIN = asahi-m1m.local
SSH_PORT = 2222
OFFLINE_MODE = false
ENABLE_GZIP = true
ENABLE_PPROF = false
STATIC_URL_PREFIX = /

[database]
DB_TYPE = sqlite3
PATH = /var/lib/forgejo/data/forgejo.db
LOG_SQL = false
SQLITE_JOURNAL_MODE = wal

[repository]
ROOT = /var/lib/forgejo/data/repositories
ENABLE_PUSH_CREATE_USER = false
ENABLE_PUSH_CREATE_ORG = false
DEFAULT_BRANCH = main
DISABLE_MIGRATIONS = false
ENABLE_LOCAL_COPY_WIKI = true

[repository.upload]
ENABLED = true
TEMP_PATH = /var/lib/forgejo/data/tmp/upload
ALLOWED_TYPES = 
MAX_FILE_SIZE = 4294967296

[repository.signing]
SIGNING_KEY = 
SIGNING_NAME = 
SIGNING_EMAIL = 

[ui]
THEMES = gitea,arc-green
DEFAULT_THEME = arc-green
EXPLORE_PAGING_NUM = 20
ISSUE_PAGING_NUM = 20
REPO_PAGING_NUM = 20
MEMBERS_PAGING_NUM = 20

[markdown]
ENABLE_HARD_LINE_BREAK = false

[session]
PROVIDER = file
PROVIDER_CONFIG = /var/lib/forgejo/data/sessions
COOKIE_SECURE = false
COOKIE_NAME = i_like_forgejo
GC_INTERVAL_TIME = 86400

[cache]
ADAPTER = memory
INTERVAL = 60

[picture]
DISABLE_GRAVATAR = true
ENABLE_FEDERATED_AVATAR = false

[openid]
ENABLE_OPENID_SIGNIN = false
ENABLE_OPENID_SIGNUP = false

[security]
INSTALL_LOCK = true
REVERSE_PROXY_LIMIT = 1
REVERSE_PROXY_TRUSTED_PROXIES = 127.0.0.1/8,::1/128
INTERNAL_TOKEN_URI = 

[service]
DISABLE_REGISTRATION = false
REQUIRE_SIGNIN_VIEW = false
ENABLE_CAPTCHA = false
DEFAULT_KEEP_EMAIL_PRIVATE = false
ALLOW_ONLY_INTERNAL_REGISTRATION = false
ALLOW_ONLY_EXTERNAL_REGISTRATION = false
SKIP_LOCAL_TWO_FACTOR = false
ENABLE_USER_HEATMAP = true
PUBLIC_ONLY = false
ENABLE_TIMETRACKING = true
DEFAULT_ENABLE_TIMETRACKING = true
ENABLE_DEPENDENCIES = true

[webhook]
QUEUE_LENGTH = 1000
DELIVER_TIMEOUT = 15
ALLOWED_HOST_LIST = 

[mailer]
ENABLED = false
PROTOCOL = smtp
SMTP_ADDR = localhost
SMTP_PORT = 25
FROM = noreply@asahi-m1m.local
USER = 
PASSWD = 

[log]
MODE = console
LEVEL = info
ROUTER = console
ROOT_PATH = /var/lib/forgejo/data/log

[log.console]
LEVEL = debug
STDERR = false
FLAGS = stdlogs,colorized
EOF

chown "$SERVICE_USER:$SERVICE_GROUP" "$CONFIG_DIR/app.ini"
chmod 640 "$CONFIG_DIR/app.ini"
log_success "Configuration file deployed"

#===============================================================================
# SECTION 8: CREATE SYSTEMD SERVICE UNIT
#===============================================================================
log_info "Creating systemd service unit..."

cat > "/etc/systemd/system/$SYSTEMD_SERVICE" <<'EOF'
[Unit]
Description=Forgejo Git Service
Documentation=man:forgejo(1)
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target
ConditionPathExists=/opt/forgejo/forgejo

[Service]
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/forgejo
ExecStart=/opt/forgejo/forgejo web -c /etc/forgejo/app.ini
Restart=always
RestartSec=10
StandardOutput=append:/var/lib/forgejo/data/log/forgejo.log
StandardError=append:/var/lib/forgejo/data/log/forgejo.err

# Resource limits
LimitNOFILE=infinity
LimitNPROC=infinity

# Security hardening
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/forgejo

# Restart policy
StartLimitBurst=5
StartLimitIntervalSec=60

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
log_success "Systemd service unit created"

#===============================================================================
# SECTION 9: ENABLE AND START SERVICE
#===============================================================================
log_info "Enabling and starting Forgejo service..."

systemctl enable "$SYSTEMD_SERVICE"
systemctl start "$SYSTEMD_SERVICE"

sleep 2

if systemctl is-active --quiet "$SYSTEMD_SERVICE"; then
  log_success "Forgejo service is running"
else
  log_error "Failed to start Forgejo service"
  systemctl status "$SYSTEMD_SERVICE" --no-pager
  exit 1
fi

#===============================================================================
# SECTION 10: SSH KEY SETUP FOR GIT SERVICE
#===============================================================================
log_info "Setting up SSH keys for git user..."

GIT_HOME="$DATA_DIR"
SSH_DIR="$GIT_HOME/.ssh"

if [ ! -d "$SSH_DIR" ]; then
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
  chown "$SERVICE_USER:$SERVICE_GROUP" "$SSH_DIR"
  log_info "SSH directory created for git user"
fi

if [ ! -f "$SSH_DIR/authorized_keys" ]; then
  touch "$SSH_DIR/authorized_keys"
  chmod 600 "$SSH_DIR/authorized_keys"
  chown "$SERVICE_USER:$SERVICE_GROUP" "$SSH_DIR/authorized_keys"
  log_info "Authorized keys file initialized"
fi

#===============================================================================
# SECTION 11: VERIFICATION
#===============================================================================
log_info "Verifying Forgejo installation..."

sleep 3

# Check service status
if systemctl is-active --quiet "$SYSTEMD_SERVICE"; then
  log_success "✓ Forgejo service is running"
else
  log_error "✗ Forgejo service is NOT running"
  systemctl status "$SYSTEMD_SERVICE" --no-pager
  exit 1
fi

# Check binary version
if [ -x "$BIN_PATH" ]; then
  BINARY_VERSION=$("$BIN_PATH" --version 2>/dev/null || echo "unknown")
  log_success "✓ Binary version: $BINARY_VERSION"
else
  log_error "✗ Binary not executable at $BIN_PATH"
  exit 1
fi

# Check HTTP endpoint
if curl -s -m 5 "http://127.0.0.1:$HTTP_PORT/" >/dev/null 2>&1; then
  log_success "✓ HTTP service responding on port $HTTP_PORT"
else
  log_warn "⚠ HTTP service not responding on port $HTTP_PORT (may still be initializing)"
fi

# Check SSH port listening
if netstat -tuln 2>/dev/null | grep -q ":$SSH_PORT\s"; then
  log_success "✓ SSH service listening on port $SSH_PORT"
else
  log_warn "⚠ SSH port $SSH_PORT not yet listening"
fi

# Check data directory
if [ -d "$DATA_DIR" ] && [ -w "$DATA_DIR" ]; then
  log_success "✓ Data directory accessible: $DATA_DIR"
else
  log_error "✗ Data directory issue: $DATA_DIR"
fi

#===============================================================================
# SECTION 12: DISPLAY SUMMARY AND NEXT STEPS
#===============================================================================
echo
echo "===================================="
echo "  Forgejo Installation Complete"
echo "===================================="
echo
log_success "Forgejo has been successfully installed and configured."
echo
echo "📋 Service Information:"
echo "  Status        : $(systemctl is-active $SYSTEMD_SERVICE)"
echo "  HTTP URL      : http://$HOSTNAME:$HTTP_PORT"
echo "  SSH Clone     : ssh://git@$HOSTNAME:$SSH_PORT/[username]/[repo].git"
echo "  Config File   : $CONFIG_DIR/app.ini"
echo "  Data Dir      : $DATA_DIR"
echo "  Service User  : $SERVICE_USER"
echo
echo "📝 Useful Commands:"
echo "  View logs     : tail -f $DATA_DIR/log/forgejo.log"
echo "  Status check  : systemctl status $SYSTEMD_SERVICE"
echo "  Restart       : sudo systemctl restart $SYSTEMD_SERVICE"
echo "  Edit config   : sudo nano $CONFIG_DIR/app.ini"
echo "  Test SSH      : ssh -p $SSH_PORT git@$HOSTNAME info"
echo
echo "🔗 Next Steps:"
echo "  1. Access web interface: http://$HOSTNAME:$HTTP_PORT"
echo "  2. Complete initial setup (admin user, organization)"
echo "  3. Configure email notifications (mailer section in app.ini)"
echo "  4. Set up reverse proxy (Traefik) for SSL/TLS termination"
echo "  5. Configure Git hooks for CI/CD integration"
echo
echo "⚠️  Troubleshooting:"
echo "  - Check service logs: journalctl -u $SYSTEMD_SERVICE -n 50"
echo "  - Verify database: file $DATA_DIR/forgejo.db"
echo "  - Reset admin password: $BIN_PATH admin user change-password admin <newpass>"
echo
