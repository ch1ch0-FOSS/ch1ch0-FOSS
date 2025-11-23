# ADR-004: Localhost-Only Service Binding

**Status**: Accepted  
**Date**: 2025-11-21  
**Deciders**: user  
**Last Validated**: 2025-11-23

## Context

Self-hosted services (Forgejo, Vaultwarden, Syncthing, Ollama) require network accessibility but must minimize attack surface. Options considered:

1. **Public binding** (0.0.0.0): Direct external access, simple but high risk
2. **Firewall-based filtering**: Public binding + firewall rules, complex management
3. **Localhost-only binding**: Services bound to 127.0.0.1, access via SSH tunnel or reverse proxy

Security requirements:
- Reduce attack surface (principle of least exposure)
- Enable remote access without direct exposure
- Support authentication mechanisms only (no defense-in-depth via network isolation alone)
- Facilitate service isolation and user-based access control

## Decision

All self-hosted services bind exclusively to localhost (127.0.0.1 or ::1). External access requires SSH tunnel or reverse proxy (future implementation).

### Implementation Details

**Service Configuration**

| Service      | Port  | Binding         | Protocol | User        | Access Method        |
|--------------|-------|-----------------|----------|-------------|----------------------|
| Forgejo      | 3000  | `:::3000` (IPv6)| HTTP     | user      | Direct (LAN), SSH    |
| Vaultwarden  | 8000  | 127.0.0.1:8000  | HTTPS    | vaultwarden | SSH tunnel           |
| Syncthing    | 8384  | 127.0.0.1:8384  | HTTPS    | user      | SSH tunnel           |
| Syncthing    | 22000 | `:::22000`      | TCP      | user      | Discovery protocol   |
| Ollama       | 11434 | 127.0.0.1:11434 | HTTP     | ollama      | SSH tunnel           |

**Note**: Forgejo currently binds to `:::3000` (all IPv6 interfaces). Migration to localhost-only binding planned.

**Process Ownership**

ollama 1110 /usr/local/bin/ollama serve
user 1327 /mnt/data/srv/forgejo/forgejo-bin web
user 1328 /usr/bin/syncthing serve
user 1339 /usr/bin/syncthing serve (child process)
postgres 409709 postgres: forgejo forgejo ::1(49162) idle


All services run under dedicated or user-scoped systemd units. No root privileges required for service operation.

## Consequences

### Positive

- **Reduced attack surface**: Services not exposed to external networks
- **Defense in depth**: Network isolation + application authentication
- **Audit simplicity**: Only SSH access logs need monitoring for external access
- **Flexible access control**: SSH key-based authentication enforces user identity
- **Future-proof**: Can add reverse proxy (nginx/caddy) without service reconfiguration

### Negative

- **Access complexity**: Users must establish SSH tunnel or VPN
- **Port forwarding overhead**: Additional SSH connection for each service access
- **User education**: Team members need SSH tunnel setup instructions
- **Forgejo exception**: Currently bound to `:::3000`, requires migration

### Validation Evidence

**Port Binding Verification** (2025-11-23)

LISTEN 0 4096 127.0.0.1:11434 0.0.0.0:* (Ollama)
LISTEN 0 4096 127.0.0.1:8384 0.0.0.0:* (Syncthing)
LISTEN 0 4096 *:3000 : (Forgejo - IPv6)

**External Access Test** (2025-11-23)

ssh -L 3000:localhost:3000 user@192.168.1.64
curl -I http://localhost:3000

HTTP/1.1 200 OK
Result: PASS - Services accessible via tunnel

**Service Status** (2025-11-23)

forgejo.service loaded active running
syncthing.service loaded active running
vaultwarden.service loaded activating auto-restart (transient failure)
ollama.service (system service, not --user)


## Security Analysis

### Current State

| Service      | Binding Status | External Exposure | Risk Level | Remediation Required |
|--------------|----------------|-------------------|------------|----------------------|
| Ollama       | localhost-only | None              | Low        | None                 |
| Syncthing    | localhost-only | None (UI)         | Low        | None                 |
| Syncthing    | :::22000       | Discovery proto   | Low        | Expected behavior    |
| Forgejo      | `:::3000`      | LAN-accessible    | Medium     | **YES - bind to localhost** |
| Vaultwarden  | localhost-only | None              | Low        | Fix service restart  |

### Attack Scenarios Mitigated

1. **Direct exploitation**: Services not reachable from external networks
2. **Port scanning**: Localhost-bound services invisible to network scanners
3. **Credential stuffing**: SSH key authentication required before service access
4. **Service vulnerabilities**: Exploit requires prior SSH access (raises attacker cost)

### Residual Risks

1. **Forgejo exposure**: Currently accessible on LAN (192.168.1.64:3000)
2. **SSH compromise**: If SSH key stolen, attacker gains service access
3. **Local privilege escalation**: User-scoped services share user permissions

## Access Procedures

### SSH Tunnel (Standard Method)

Single service
ssh -L 3000:localhost:3000 user@192.168.1.64

Multiple services
ssh -L 3000:localhost:3000
-L 8000:localhost:8000
-L 8384:localhost:8384
-L 11434:localhost:11434
user@192.168.1.64

Access services
curl http://localhost:3000 # Forgejo
curl http://localhost:8000 # Vaultwarden
curl http://localhost:8384 # Syncthing
curl http://localhost:11434 # Ollama

### Future: Reverse Proxy (Planned)

Internet → nginx/caddy (443) → localhost services
↓
TLS termination
Authentication
Rate limiting


## Remediation Tasks

**High Priority**
1. Migrate Forgejo from `:::3000` to `127.0.0.1:3000`
   - Edit `/mnt/data/srv/forgejo/app.ini`
   - Set `HTTP_ADDR = 127.0.0.1`
   - Restart: `systemctl --user restart forgejo`

2. Investigate Vaultwarden service failure
   - Check logs: `journalctl --user -u vaultwarden -n 50`
   - Verify data path: `/mnt/data/srv/vaultwarden/`
   - Restart: `systemctl --user restart vaultwarden`

**Medium Priority**
3. Document SSH tunnel procedures for team access
4. Implement reverse proxy with TLS (nginx/caddy)
5. Add fail2ban for SSH brute-force protection

## Related Decisions

- ADR-001: External SSD Strategy (service data isolation)
- ADR-003: Git-Backed Configuration (service config management)

## References

- Service configs: `/mnt/data/srv/{forgejo,vaultwarden,syncthing,ollama}/`
- Systemd units: `~/.config/systemd/user/{forgejo,vaultwarden,syncthing}.service`
- SSH config: `/etc/ssh/sshd_config`


