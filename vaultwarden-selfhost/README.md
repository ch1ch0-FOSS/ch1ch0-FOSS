# Vaultwarden Self-Hosted Setup

Self-hosted password manager compatible with Bitwarden clients.

## Requirements

- Docker + Docker Compose
- 1GB RAM minimum
- 5GB disk space
- Network access (port 8000 for HTTP)

## Quick Start

1. Clone or download this repository
2. Edit `.env` file (set domain, admin token)
3. Run: `docker-compose up -d`
4. Access: http://localhost:8000
5. Create account (if invitations enabled)

## Configuration

### Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `VAULTWARDEN_PORT` | 8000 | HTTP port |
| `VAULTWARDEN_DOMAIN` | localhost | Domain (for clients) |
| `ADMIN_TOKEN` | changeme | Admin panel token |
| `INVITATIONS_ALLOWED` | true | Allow new signups |

## Clients

Compatible with:
- Official Bitwarden apps (web, mobile, desktop)
- Firefox/Chrome extensions
- CLI tool

Point clients to: `http://your-domain:8000`

## Health Check

./scripts/health_check.sh

## Support

Check `docs/TROUBLESHOOTING.md`
