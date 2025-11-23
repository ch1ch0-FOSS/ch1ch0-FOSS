Storage Architecture: srv-m1m
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/ (162.7GB, btrfs, internal SSD)
├── /boot/efi
├── /var (logs, ephemeral cache)
└── /home/user → /mnt/data/home/user (symlink)

/mnt/data (8TB, btrfs, external SSD #1)
├── srv/
│   ├── forgejo/      (Git server data)
│   ├── vaultwarden/  (Vault data)
│   ├── syncthing/    (Sync metadata)
│   └── ollama/       (LLM models)
├── git/
│   ├── srv-m1m/      (System config repo)
│   ├── user-GNOSIS/ (PKM repo)
│   └── user-FOSS/  (Portfolio repos)
├── dev/
│   ├── rust/         (Rust toolchain)
│   └── go/           (Go toolchain)
├── home/user/      (User home, symlinked from /)
└── backups/          (Service snapshots)

/mnt/fastdata (2TB, btrfs, external SSD #2)
└── (Reserved for compute-intensive processing)

