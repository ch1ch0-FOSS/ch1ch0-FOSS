# Forgejo Self-Hosted Setup

Self-host your Git repositories with Forgejo.

## Requirements

- Docker + Docker Compose
- 2GB RAM minimum
- 10GB disk space
- Network access (port 3000 for HTTP, 2222 for SSH)

## Quick Start

1. Clone or download this repository
2. Edit `.env` file (set domain, admin password)
3. Run: `docker-compose up -d`
4. Access: http://localhost:3000
5. Login: admin / (your password)

## Configuration

### Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `FORGEJO_PORT` | 3000 | HTTP port |
| `FORGEJO_SSH_PORT` | 2222 | SSH port for git operations |
| `FORGEJO_DOMAIN` | localhost | Domain name (for redirects) |
| `FORGEJO_ADMIN_PASSWORD` | changeme | Initial admin password |

### Persistent Storage

Data is stored in `./data/` directory (Docker volume).

Backup regularly:

tar -czf forgejo-backup-$(date +%s).tar.gz ./data/

## Troubleshooting

### Container won't start

docker logs forgejo

### Connection refused
- Check firewall: `sudo ufw status`
- Check port: `sudo netstat -tuln | grep 3000`

### Reset admin password

docker exec forgejo forgejo admin user change-password admin --password NEWPASS

Expected output:

[OK] Forgejo responding on port 3000


## Support

Issues? Check `/docs/TROUBLESHOOTING.md`

