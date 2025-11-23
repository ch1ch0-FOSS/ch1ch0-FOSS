#!/bin/bash
set -euo pipefail

# Configuration
PRIVATE_REPO="/mnt/data/git/srv-m1m"
PUBLIC_REPO="/mnt/data/git/user-FOSS"
TEMP_CLONE="/tmp/srv-m1m-sanitized-$$"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# Validate prerequisites
[[ -d "$PRIVATE_REPO/.git" ]] || log_error "Private repo not found: $PRIVATE_REPO"
[[ -d "$PUBLIC_REPO/.git" ]] || log_error "Public repo not found: $PUBLIC_REPO"

log_info "Creating temporary sanitized clone..."
git clone --depth=1 file://"$PRIVATE_REPO" "$TEMP_CLONE"
cd "$TEMP_CLONE"

# Remove sensitive directories entirely
log_info "Removing sensitive directories..."
rm -rf secrets/ .env* keys/ certs/ backups/
find . -type d -name "secrets" -o -name "private" -o -name "credentials" | xargs rm -rf 2>/dev/null || true

# Remove sensitive file types
log_info "Removing sensitive file types..."
find . -type f -name "*.key" -delete
find . -type f -name "*.pem" -delete
find . -type f -name "*.p12" -delete
find . -type f -name "*.pfx" -delete
find . -type f -name "*_rsa" -delete
find . -type f -name "*_dsa" -delete
find . -type f -name "*_ecdsa" -delete
find . -type f -name "*_ed25519" -delete
find . -type f -name "*.env" -delete
find . -type f -name "*.env.local" -delete
find . -type f -name ".env.*" -delete

# Path sanitization in all text files
log_info "Sanitizing paths and hostnames..."
find . -type f -name "*.md" -not -path "./.git/*" -exec sed -i \
  -e 's|/home/user|/home/user|g' \
  -e 's|user@system|user@system|g' \
  -e 's|srv-m1m\.local|system.local|g' \
  -e 's|user|user|g' \
  -e 's|localhost:3000/user|localhost:3000/user|g' \
  {} +

find . -type f -name "*.sh" -not -path "./.git/*" -exec sed -i \
  -e 's|/home/user|/home/user|g' \
  -e 's|user@system|user@system|g' \
  -e 's|srv-m1m\.local|system.local|g' \
  -e 's|user|user|g' \
  {} +

find . -type f -name "*.yml" -o -name "*.yaml" -not -path "./.git/*" | xargs sed -i \
  -e 's|/home/user|/home/user|g' \
  -e 's|user@system|user@system|g' 2>/dev/null || true

find . -type f -name "*.conf" -o -name "*.json" -o -name "*.txt" -not -path "./.git/*" | xargs sed -i \
  -e 's|/home/user|/home/user|g' \
  -e 's|user|user|g' 2>/dev/null || true

# Remove node_modules if present
[[ -d node_modules ]] && rm -rf node_modules

log_info "Copying sanitized content to public repo..."
rsync -av --delete \
  --exclude='.git' \
  --exclude='.gitignore' \
  "$TEMP_CLONE/" "$PUBLIC_REPO/"

# Cleanup
rm -rf "$TEMP_CLONE"

log_info "Sanitization complete!"
log_info "Next steps:"
log_info "  cd $PUBLIC_REPO"
log_info "  git status"
log_info "  git add -A"
log_info "  git commit -m 'sync: sanitized update from srv-m1m'"
log_info "  git push github main"
