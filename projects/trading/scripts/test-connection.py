#!/usr/bin/env python3
"""
Test IBKR ib_insync connectivity
Requires TWS or IB Gateway running on localhost:7497 (paper) or 7496 (live)
"""

from ib_insync import IB
import sys

def test_paper_trading():
    """Test connection to paper trading account"""
    ib = IB()
    try:
        print("Attempting connection to paper trading account...")
        ib.connect("127.0.0.1", 7497, clientId=1)
        
        print("✅ Connected to IBKR paper trading")
        accounts = ib.managedAccounts()
        print(f"Accounts: {accounts}")
        
        ib.disconnect()
        return True
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        return False

if __name__ == "__main__":
    if test_paper_trading():
        sys.exit(0)
    else:
        print("\nNote: TWS or IB Gateway must be running on localhost:7497")
        sys.exit(1)
