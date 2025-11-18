#!/bin/bash
set -e

echo "=== IBKR Paper Trading Setup ==="
echo ""
echo "1. Open browser: https://www.interactivebrokers.com/portal"
echo "2. Click: Account -> Paper Trading Account"
echo "3. Click: New Paper Trading Account"
echo "4. Name it: Trading Infrastructure Paper"
echo "5. Confirm credentials are created"
echo ""
echo "Paper trading account will be separate from live account"
echo "Pre-loaded with $1,000,000 simulated capital"
echo "Same market data and functionality as live account"
echo ""
echo "Next step: ib_insync connection test"
