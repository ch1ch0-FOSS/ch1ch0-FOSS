# System Verification & Health Checks

## Quick Status Check (30 seconds)
```bash
# All critical services
sudo systemctl status forgejo ollama syncthing vaultwarden mariadb

# Network ports
ss -tulnp | grep LISTEN

# Disk usage
df -h

Service-Specific Checks

[Per-service verification commands]

---

