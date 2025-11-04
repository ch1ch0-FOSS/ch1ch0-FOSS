# Syncthing Setup

Peer-to-peer file synchronization across devices.

## Requirements

- Docker + Docker Compose
- 500MB RAM minimum
- 5GB disk space (+ sync folder size)
- Network access (ports 8384, 22000)

## Quick Start

1. Clone or download this repository
2. Run: `docker-compose up -d`
3. Access: http://localhost:8384
4. Configure folders + peer devices
5. Add on second device, accept share

## Configuration

Access web GUI at: `http://localhost:8384`

### Port Forwarding (if behind NAT)

Forward to host:
- TCP 22000 (sync protocol)
- UDP 22000 (sync protocol)
- UDP 21027 (discovery)

## Devices

Add device:
1. Generate device ID on first device
2. Add device ID on second device
3. Share folder
4. Second device accepts share
5. Sync begins

## Health Check

./scripts/health_check.sh

## Support

Check `docs/TROUBLESHOOTING.md`


