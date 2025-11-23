#!/usr/bin/env bash

#===============================================================================
# PostgreSQL Installation Script - Database Service Configuration
#===============================================================================
# Author       : user
# Date         : 2025-11-22
# Environment  : Fedora Asahi Remix 42 ARM64 (Apple Silicon)
# Target System: system (192.168.1.64)
#-------------------------------------------------------------------------------
# Purpose      : Install PostgreSQL 16 database server
# Service User : postgres
# Port         : 5432 (localhost only)
# Data Dir     : /var/lib/pgsql/data
# Config       : /var/lib/pgsql/data/postgresql.conf
# Notes        : Idempotent, creates service users for applications
#===============================================================================

set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# SECTION 1: VARIABLES
#===============================================================================

APP_NAME="postgresql"
PG_VERSION="16"
SERVICE_NAME="postgresql.service"
DATA_DIR="/var/lib/pgsql/data"
CONFIG_FILE="$DATA_DIR/postgresql.conf"
HBA_FILE="$DATA_DIR/pg_hba.conf"
PORT="5432"
LISTEN_ADDR="127.0.0.1"
BACKUP_DIR="/var/backups/postgresql"
LOG_FILE="/var/log/postgresql_install_$(date +%Y%m%d_%H%M%S).log"

# Database users to create (application accounts)
FORGEJO_USER="forgejo"
FORGEJO_DB="forgejo"
VAULTWARDEN_USER="vaultwarden"
VAULTWARDEN_DB="vaultwarden"

# Credential file location
CREDENTIALS_FILE="/etc/srv/secrets/db-credentials.txt"

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
        log_error "This script must be run as root"
        exit 1
    fi
}

generate_password() {
    openssl rand -base64 24 | tr -d "=+/" | cut -c1-24
}

#===============================================================================
# SECTION 3: PRE-FLIGHT CHECKS
#===============================================================================

log_info "Running pre-flight checks..."
check_root

# Check if PostgreSQL is already installed
if rpm -qa | grep -q "^postgresql-server"; then
    INSTALLED_VERSION=$(rpm -q postgresql-server | cut -d'-' -f3)
    log_warn "PostgreSQL server already installed (version: $INSTALLED_VERSION)"
    
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        log_info "PostgreSQL service is currently running"
        read -rp "Continue with configuration update? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            log_warn "Installation aborted"
            exit 0
        fi
    fi
fi

#===============================================================================
# SECTION 4: INSTALL POSTGRESQL
#===============================================================================

log_info "Installing PostgreSQL $PG_VERSION packages..."

dnf install -y \
    postgresql \
    postgresql-server \
    postgresql-contrib \
    postgresql-private-libs \
    postgresql-private-devel 2>&1 | tee -a "$LOG_FILE"

log_success "PostgreSQL packages installed"

#===============================================================================
# SECTION 5: INITIALIZE DATABASE CLUSTER
#===============================================================================

if [ ! -f "$DATA_DIR/PG_VERSION" ]; then
    log_info "Initializing PostgreSQL database cluster..."
    sudo -u postgres /usr/bin/postgresql-setup --initdb 2>&1 | tee -a "$LOG_FILE"
    log_success "Database cluster initialized at $DATA_DIR"
else
    log_info "Database cluster already initialized"
fi

#===============================================================================
# SECTION 6: CONFIGURE POSTGRESQL
#===============================================================================

log_info "Configuring PostgreSQL server..."

# Backup original config if not already backed up
if [ -f "$CONFIG_FILE" ] && [ ! -f "$CONFIG_FILE.orig" ]; then
    cp "$CONFIG_FILE" "$CONFIG_FILE.orig"
    log_info "Backed up original postgresql.conf"
fi

# Update postgresql.conf
sudo -u postgres bash <<'PGCONF'
CONFIG_FILE="/var/lib/pgsql/data/postgresql.conf"

# Set listen address (localhost only)
sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '127.0.0.1'/" "$CONFIG_FILE"

# Set port
sed -i "s/^#port = 5432/port = 5432/" "$CONFIG_FILE"

# Increase max connections for applications
sed -i "s/^max_connections = 100/max_connections = 200/" "$CONFIG_FILE"

# Shared buffers (25% of RAM for dedicated DB server, conservative for shared system)
sed -i "s/^#shared_buffers = 128MB/shared_buffers = 256MB/" "$CONFIG_FILE"

# Effective cache size (50% of system RAM)
sed -i "s/^#effective_cache_size = 4GB/effective_cache_size = 2GB/" "$CONFIG_FILE"

# Logging configuration
sed -i "s/^#logging_collector = off/logging_collector = on/" "$CONFIG_FILE"
sed -i "s/^#log_directory = 'log'/log_directory = 'log'/" "$CONFIG_FILE"
sed -i "s/^#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'/log_filename = 'postgresql-%a.log'/" "$CONFIG_FILE"
sed -i "s/^#log_rotation_age = 1d/log_rotation_age = 1d/" "$CONFIG_FILE"
sed -i "s/^#log_line_prefix = '%m [%p] '/log_line_prefix = '%t [%p]: user=%u,db=%d,client=%h '/" "$CONFIG_FILE"

# Performance tuning
sed -i "s/^#work_mem = 4MB/work_mem = 8MB/" "$CONFIG_FILE"
sed -i "s/^#maintenance_work_mem = 64MB/maintenance_work_mem = 128MB/" "$CONFIG_FILE"
PGCONF

log_success "PostgreSQL configuration updated"

#===============================================================================
# SECTION 7: CONFIGURE AUTHENTICATION (pg_hba.conf)
#===============================================================================

log_info "Configuring client authentication..."

# Backup original pg_hba.conf if not already backed up
if [ -f "$HBA_FILE" ] && [ ! -f "$HBA_FILE.orig" ]; then
    cp "$HBA_FILE" "$HBA_FILE.orig"
    log_info "Backed up original pg_hba.conf"
fi

# Configure pg_hba.conf for local and localhost connections
sudo -u postgres bash <<'HBACONF'
HBA_FILE="/var/lib/pgsql/data/pg_hba.conf"

# Clear existing configuration
cat > "$HBA_FILE" <<'EOF'
# PostgreSQL Client Authentication Configuration
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer

# IPv4 local connections (localhost)
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             ::1/128                 scram-sha-256

# Replication connections (localhost only)
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256
EOF
HBACONF

log_success "Client authentication configured"

#===============================================================================
# SECTION 8: ENABLE AND START SERVICE
#===============================================================================

log_info "Enabling and starting PostgreSQL service..."

systemctl enable "$SERVICE_NAME"
systemctl start "$SERVICE_NAME"

sleep 3

if systemctl is-active --quiet "$SERVICE_NAME"; then
    log_success "PostgreSQL service is running"
else
    log_error "Failed to start PostgreSQL service"
    systemctl status "$SERVICE_NAME" --no-pager
    journalctl -u "$SERVICE_NAME" -n 20 --no-pager
    exit 1
fi

#===============================================================================
# SECTION 9: CREATE APPLICATION USERS AND DATABASES
#===============================================================================

log_info "Creating application users and databases..."

# Create credentials directory if missing
mkdir -p "$(dirname "$CREDENTIALS_FILE")"
chmod 700 "$(dirname "$CREDENTIALS_FILE")"

# Generate passwords if credentials file doesn't exist
if [ ! -f "$CREDENTIALS_FILE" ]; then
    FORGEJO_PASS=$(generate_password)
    VAULTWARDEN_PASS=$(generate_password)
    
    cat > "$CREDENTIALS_FILE" <<EOF
DB_USER_VW=$VAULTWARDEN_USER
DB_PASS_VW=$VAULTWARDEN_PASS
DB_USER_FORGEJO=$FORGEJO_USER
DB_PASS_FORGEJO=$FORGEJO_PASS
DB_HOST=localhost
DB_PORT=5432
EOF
    
    chmod 600 "$CREDENTIALS_FILE"
    chown root:root "$CREDENTIALS_FILE"
    log_success "Generated database credentials at $CREDENTIALS_FILE"
else
    log_info "Credentials file already exists, reading existing passwords"
    source "$CREDENTIALS_FILE"
    FORGEJO_PASS="$DB_PASS_FORGEJO"
    VAULTWARDEN_PASS="$DB_PASS_VW"
fi

# Create Forgejo user and database
sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='$FORGEJO_USER'" | grep -q 1 || \
    sudo -u postgres psql -c "CREATE USER $FORGEJO_USER WITH PASSWORD '$FORGEJO_PASS';" && \
    log_info "Created PostgreSQL user: $FORGEJO_USER"

sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='$FORGEJO_DB'" | grep -q 1 || \
    sudo -u postgres psql -c "CREATE DATABASE $FORGEJO_DB OWNER $FORGEJO_USER ENCODING 'UTF8' LC_COLLATE 'en_US.UTF-8' LC_CTYPE 'en_US.UTF-8';" && \
    log_info "Created database: $FORGEJO_DB"

# Create Vaultwarden user and database
sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='$VAULTWARDEN_USER'" | grep -q 1 || \
    sudo -u postgres psql -c "CREATE USER $VAULTWARDEN_USER WITH PASSWORD '$VAULTWARDEN_PASS';" && \
    log_info "Created PostgreSQL user: $VAULTWARDEN_USER"

sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='$VAULTWARDEN_DB'" | grep -q 1 || \
    sudo -u postgres psql -c "CREATE DATABASE $VAULTWARDEN_DB OWNER $VAULTWARDEN_USER ENCODING 'UTF8' LC_COLLATE 'en_US.UTF-8' LC_CTYPE 'en_US.UTF-8';" && \
    log_info "Created database: $VAULTWARDEN_DB"

log_success "Application users and databases configured"

#===============================================================================
# SECTION 10: VERIFICATION
#===============================================================================

log_info "Running verification checks..."

# List databases
DATABASES=$(sudo -u postgres psql -c "\l" | grep -E "forgejo|vaultwarden" | awk '{print $1}')
log_info "Configured databases: $DATABASES"

# Verify service listening on port
if ss -tuln | grep -q ":$PORT\s"; then
    log_success "PostgreSQL listening on port $PORT"
else
    log_warn "PostgreSQL may not be listening on port $PORT"
fi

#===============================================================================
# SECTION 11: INSTALLATION SUMMARY
#===============================================================================

echo
echo "====================================="
echo " PostgreSQL Installation Complete"
echo "====================================="
echo
log_success "PostgreSQL $PG_VERSION successfully installed and configured"
echo
echo "📋 Service Information:"
echo "  Status          : $(systemctl is-active $SERVICE_NAME)"
echo "  Port            : $PORT (localhost only)"
echo "  Data Directory  : $DATA_DIR"
echo "  Config File     : $CONFIG_FILE"
echo "  HBA Config      : $HBA_FILE"
echo "  Credentials     : $CREDENTIALS_FILE"
echo
echo "🗄️  Configured Databases:"
echo "  - $FORGEJO_DB (owner: $FORGEJO_USER)"
echo "  - $VAULTWARDEN_DB (owner: $VAULTWARDEN_USER)"
echo
echo "📝 Useful Commands:"
echo "  Status check    : systemctl status $SERVICE_NAME"
echo "  View logs       : journalctl -u $SERVICE_NAME -f"
echo "  Restart service : sudo systemctl restart $SERVICE_NAME"
echo "  Connect as admin: sudo -u postgres psql"
echo "  List databases  : sudo -u postgres psql -c '\l'"
echo "  List users      : sudo -u postgres psql -c '\du'"
echo
echo "⚠️  Security Notes:"
echo "  - PostgreSQL listens on localhost only (127.0.0.1)"
echo "  - Credentials stored at: $CREDENTIALS_FILE (600 permissions)"
echo "  - Authentication: scram-sha-256"
echo "  - Peer authentication for local Unix socket connections"
echo
echo "🔗 Next Steps:"
echo "  1. Configure Forgejo to use PostgreSQL database"
echo "  2. Configure Vaultwarden to use PostgreSQL database"
echo "  3. Set up regular database backups (pg_dump)"
echo "  4. Monitor database size and performance"
echo
