# Ch1ch0 FOSS Infrastructure

Self-hosted, open-source tools. You own your data.

## Tier 1: DIY Self-Hosted

Pick the tools you need. Deploy on your hardware with docker-compose.

### Available Now

**Forgejo** - Git version control  
Repository: [forgejo-selfhost](./forgejo-selfhost)  
Supports: Single user or small teams  
Deployment: ~2 minutes with docker-compose  

**Syncthing** - File synchronization  
Repository: [syncthing-setup](./syncthing-setup)  
Supports: Multi-device file sync  
Deployment: ~2 minutes with docker-compose  

## Quick Start

1. Pick a tool
2. `git clone <repo>`
3. `docker-compose up -d`
4. Access web UI (see README in each repo)
5. Done

## Support

Each repo has:
- README.md - Quick start
- docs/INSTALLATION.md - Detailed setup
- docs/TROUBLESHOOTING.md - Common issues
- docs/BACKUP_RESTORE.md - Data persistence

## Philosophy

One tool. One job. Compose together.  
Own your infrastructure. No vendor lock-in.

## Tier 2: Managed Deployment (Coming Soon)

Not ready to self-host? We deploy and manage for you.  
Contact: [ch1ch0.me](https://ch1ch0.me)

## License

Open Source. Deploy freely.
