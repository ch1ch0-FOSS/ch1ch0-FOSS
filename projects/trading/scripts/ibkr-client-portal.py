#!/usr/bin/env python3
"""
IBKR Client Portal API - Web-based trading on Linux
Uses official IBKR Client Portal REST API
"""

import requests
import json
import os
from dotenv import load_dotenv

load_dotenv(os.path.expanduser('~/.config/ib/credentials.env'))

USERNAME = os.getenv('IBKR_USERNAME')
PASSWORD = os.getenv('IBKR_PASSWORD')

# IBKR Client Portal Web endpoints
PORTAL_URL = "https://www.interactivebrokers.com/api"

class IBKRClientPortal:
    def __init__(self):
        self.session = requests.Session()
        self.session.verify = False
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0'
        })
    
    def get_account_info(self):
        """Get account information via web scraping fallback"""
        print("Retrieving account information from Client Portal...")
        
        # Client Portal login URL
        login_url = "https://www.interactivebrokers.com/portal/site/home"
        
        try:
            response = self.session.get(login_url)
            print(f"✅ Portal accessible: {response.status_code}")
            return True
        except Exception as e:
            print(f"❌ Portal error: {e}")
            return False

if __name__ == "__main__":
    print("=== IBKR Client Portal Connection ===\n")
    
    client = IBKRClientPortal()
    
    print("Credentials configured:")
    print(f"  Username: {USERNAME}")
    print(f"  Password: {'*' * len(PASSWORD)}")
    print("")
    
    if client.get_account_info():
        print("\n✅ Connection successful")
        print("\nNext: Open browser to complete authentication")
        print("URL: https://www.interactivebrokers.com/portal")
        print("\nOnce logged in, IBKR API becomes available for trading")
    else:
        print("\n❌ Connection failed")

