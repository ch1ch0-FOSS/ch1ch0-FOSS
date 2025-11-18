#!/usr/bin/env python3
"""
IBKR Web API client for Linux-native trading
Uses IBKR's REST API endpoints
No TWS/Windows required
"""

import requests
import json
import os
from dotenv import load_dotenv

# Load credentials
load_dotenv(os.path.expanduser('~/.config/ib/credentials.env'))

USERNAME = os.getenv('IBKR_USERNAME')
PASSWORD = os.getenv('IBKR_PASSWORD')

# IBKR Web API endpoint (public, no local service needed)
IBKR_GATEWAY_URL = "https://api.ibkr.com"

class IBKRWebClient:
    def __init__(self):
        self.session = requests.Session()
        self.base_url = IBKR_GATEWAY_URL
        self.authenticated = False
    
    def authenticate(self):
        """Authenticate with IBKR web API"""
        print("Authenticating with IBKR Web API...")
        try:
            # IBKR Web API authentication
            auth_url = f"{self.base_url}/v1/api/iserver/auth/login"
            payload = {
                "username": USERNAME,
                "password": PASSWORD
            }
            response = self.session.post(auth_url, json=payload, verify=False)
            
            if response.status_code == 200:
                print("✅ Authentication successful")
                self.authenticated = True
                return True
            else:
                print(f"❌ Authentication failed: {response.status_code}")
                print(f"Response: {response.text}")
                return False
                
        except Exception as e:
            print(f"❌ Authentication error: {e}")
            return False
    
    def get_accounts(self):
        """Get list of accounts"""
        if not self.authenticated:
            return None
        
        try:
            url = f"{self.base_url}/v1/api/iserver/accounts"
            response = self.session.get(url, verify=False)
            if response.status_code == 200:
                return response.json()
            return None
        except Exception as e:
            print(f"Error fetching accounts: {e}")
            return None
    
    def get_portfolio(self):
        """Get portfolio details"""
        if not self.authenticated:
            return None
        
        try:
            url = f"{self.base_url}/v1/api/portfolio/accounts"
            response = self.session.get(url, verify=False)
            if response.status_code == 200:
                return response.json()
            return None
        except Exception as e:
            print(f"Error fetching portfolio: {e}")
            return None

if __name__ == "__main__":
    client = IBKRWebClient()
    
    if client.authenticate():
        print("\n=== Account Information ===")
        accounts = client.get_accounts()
        if accounts:
            print(f"Accounts: {json.dumps(accounts, indent=2)}")
        
        print("\n=== Portfolio ===")
        portfolio = client.get_portfolio()
        if portfolio:
            print(f"Portfolio: {json.dumps(portfolio, indent=2)}")
    else:
        print("Failed to authenticate")

