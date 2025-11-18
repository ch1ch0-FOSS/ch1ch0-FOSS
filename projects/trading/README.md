# IBKR Trading Infrastructure

Programmatic trading setup using ib_insync on Fedora Asahi ARM64.

## Architecture

- **Runtime:** Python 3.13 + ib_insync 0.9.86
- **User:** trading (non-root, isolated)
- **Account Type:** Paper Trading (can scale to live)
- **Connection:** TWS/IB Gateway (future) or direct API

## Quick Start

Test connection (requires TWS/Gateway running):
```
python3 trading-infra/scripts/test_connection.py
```

Configure paper trading account:
```
./trading-infra/scripts/setup_paper_trading.sh
```

## Files

- scripts/setup_paper_trading.sh - Paper account setup instructions
- scripts/test_connection.py - Connection test utility
- scripts/ - Trading scripts and utilities (to be added)

## Infrastructure Philosophy

- Simple: Single user, single purpose
- Seamless: Zero system dependencies after setup
- Structured: Clear directory hierarchy
- Strategic: Audit-ready, reproducible, resilient
