# IBKR Trading Infrastructure Setup

## Phase 1: Foundation ✅
- Podman rootless configured
- User namespaces enabled
- ib_insync library installed
- Git repository initialized

## Phase 2: Paper Trading Account
1. Navigate to: https://www.interactivebrokers.com/portal
2. Create paper trading account (separate from live)
3. Paper account pre-funded with $1,000,000 simulated capital
4. Use paper account credentials for development

## Phase 3: Connection Testing
```
python3 ~/trading-infra/scripts/test_connection.py
```

Requires TWS or IB Gateway running on:
- Paper: localhost:7497
- Live: localhost:7496

## Phase 4: Deployment Pipeline
- [ ] Paper account verified
- [ ] Connection test passing
- [ ] First trade executed
- [ ] Production hardening
- [ ] Portfolio documentation

## Security Notes

- trading user: financial operations only
- sysadmin: infrastructure management
- No root access for trading user
- All configs in ~/.config/ib/
- All scripts in ~/trading-infra/

## Next Steps

1. Create paper trading account
2. Document trading strategy
3. Develop trade execution scripts
4. Integrate with existing infrastructure
5. Deploy to portfolio site
