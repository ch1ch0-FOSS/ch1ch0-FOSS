Service Dependency Map
━━━━━━━━━━━━━━━━━━━━━

┌─────────────┐
│   Forgejo   │  Port 3000
│ (Git Server)│
└──────┬──────┘
       │ uses
       ▼
┌─────────────────┐
│ /mnt/data/git/  │  (Repository storage)
└─────────────────┘

┌──────────────┐
│ Vaultwarden  │  Port 8000
│(Password Mgr)│
└──────┬───────┘
       │ uses
       ▼
┌──────────────────────┐
│ /mnt/data/srv/       │  (Encrypted vault)
│    vaultwarden/      │
└──────────────────────┘

┌─────────────┐
│ Syncthing   │  Port 8384
│(File Sync)  │
└──────┬──────┘
       │ uses
       ▼
┌──────────────────────┐
│ /mnt/data/srv/       │  (Sync metadata)
│    syncthing/        │
└──────────────────────┘

┌─────────────┐
│   Ollama    │  Port 11434
│(LLM Server) │
└──────┬──────┘
       │ uses
       ▼
┌──────────────────────┐
│ /mnt/data/srv/       │  (Model storage)
│    ollama/           │
└──────────────────────┘

All services:
- Run as systemd --user units
- Bound to localhost only
- Require external SSD mount
- Zero dependencies on OS partition

