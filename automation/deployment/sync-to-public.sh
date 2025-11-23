#!/bin/bash
set -e

PRIVATE_REPO="/mnt/data/git/system"
PUBLIC_REPO="/mnt/data/git/user-FOSS/infrastructure"

echo "=== Syncing Private → Public Infrastructure ==="

# Sync infrastructure services
rsync -av --delete \
  --exclude='.git' \
  --exclude='secrets/' \
  --exclude='*.key' \
  --exclude='*.pem' \
  "$PRIVATE_REPO/infrastructure/" "$PUBLIC_REPO/"

# Sync tooling
rsync -av --delete \
  --exclude='.git' \
  "$PRIVATE_REPO/tooling/" "/mnt/data/git/user-FOSS/tooling/"

# Sync documentation (non-operational)
rsync -av --delete \
  "$PRIVATE_REPO/documentation/guides/" "/mnt/data/git/user-FOSS/docs/guides/"

cd "$PUBLIC_REPO"

# Sanitize paths in markdown files
find . -type f -name "*.md" -not -path "./.git/*" \
  -exec sed -i 's|/home/user|/home/user|g' {} +

find . -type f -name "*.md" -not -path "./.git/*" \
  -exec sed -i 's|user@system|user@system|g' {} +

# Sanitize shell scripts
find . -type f -name "*.sh" -not -path "./.git/*" \
  -exec sed -i 's|/home/user|/home/user|g' {} +

echo "=== Sanitization complete ==="
echo "Review changes with: cd $PUBLIC_REPO && git diff"
echo "Commit and push with:"
echo "  git add ."
echo "  git commit -m 'docs: sync sanitized infrastructure from private repo'"
echo "  git push github main"
