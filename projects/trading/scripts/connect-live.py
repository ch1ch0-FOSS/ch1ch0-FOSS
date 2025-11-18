#!/usr/bin/env python3
"""
Connect to IBKR live account and retrieve account details
Credentials loaded from ~/.config/ib/credentials.env
"""

import os
from ib_insync import IB
from dotenv import load_dotenv

# Load credentials from file
load_dotenv(os.path.expanduser('~/.config/ib/credentials.env'))

username = os.getenv('IBKR_USERNAME')
password = os.getenv('IBKR_PASSWORD')
account_type = os.getenv('IBKR_ACCOUNT_TYPE', 'live')
port = int(os.getenv('IBKR_PORT', '7496'))

if not username or not password:
    print("❌ Credentials not configured")
    print("Edit: ~/.config/ib/credentials.env")
    exit(1)

print(f"=== IBKR Live Account Connection ===")
print(f"Account type: {account_type}")
print(f"Connecting to localhost:{port}")
print("")

ib = IB()
try:
    ib.connect('127.0.0.1', port, clientId=1)
    print("✅ Connected to IBKR live account")
    
    # Query account details (read-only, no trades)
    accounts = ib.managedAccounts()
    print(f"Accounts: {accounts}")
    
    # Get portfolio
    portfolio = ib.portfolio()
    print(f"Portfolio: {portfolio}")
    
    # Get account summary
    summary = ib.accountSummary()
    print(f"Account Summary: {summary}")
    
    ib.disconnect()
    print("✅ Disconnected successfully")
    
except Exception as e:
    print(f"❌ Connection failed: {e}")
    print("")
    print("Note: TWS or IB Gateway must be running on localhost:7496")
    exit(1)

