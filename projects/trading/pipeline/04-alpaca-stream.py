#!/usr/bin/env python3
"""
Alpaca Real-Time Data Stream
Pulls 1-minute bars, order flow data, calculates volume profiles
"""

import os
import logging
from datetime import datetime, timedelta
from alpaca_trade_api import REST
import pandas as pd
import duckdb
from dotenv import load_dotenv

load_dotenv(os.path.expanduser('~/.env_trading'))
DB_PATH = os.getenv('DB_PATH')

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class AlpacaDataStream:
    def __init__(self):
        self.api = REST(
            base_url='https://paper-api.alpaca.markets',
            key_id='PK3ETWQI96B99AL75V5G',
            secret_key='3jcHwAeFwm9FSXwy67sQXWVgyrY0cb6a72ei7Ivr'
        )
        self.conn = duckdb.connect(DB_PATH)
        self.tickers = ['SPY', 'QQQ', 'IWM', 'AAPL', 'MSFT', 'NVDA']
        
    def create_alpaca_tables(self):
        """Create tables for Alpaca data"""
        self.conn.execute("""
            CREATE TABLE IF NOT EXISTS alpaca_bars (
                ticker VARCHAR,
                timestamp TIMESTAMP,
                open DOUBLE,
                high DOUBLE,
                low DOUBLE,
                close DOUBLE,
                volume BIGINT
            )
        """)
        logger.info("Tables created")
    
    def get_latest_bars(self):
        """Fetch latest 1-minute bars"""
        for ticker in self.tickers:
            try:
                bars = self.api.get_bars(
                    ticker,
                    '1Min',
                    limit=1
                )
                
                if bars is not None and len(bars) > 0:
                    bar = bars[0]
                    self.conn.execute("""
                        INSERT INTO alpaca_bars VALUES (?, ?, ?, ?, ?, ?, ?)
                    """, (
                        ticker,
                        pd.Timestamp(bar.t).to_pydatetime(),
                        bar.o,
                        bar.h,
                        bar.l,
                        bar.c,
                        int(bar.v)
                    ))
                    logger.info(f"{ticker}: close={bar.c} volume={bar.v}")
            except Exception as e:
                logger.error(f"Error fetching {ticker}: {e}")
        
        self.conn.commit()
    
    def calculate_volume_profile(self, ticker, minutes=5):
        """Calculate volume profile for recent bars"""
        query = f"""
            SELECT 
                close,
                SUM(volume) as vol_at_level
            FROM alpaca_bars
            WHERE ticker = '{ticker}'
            AND timestamp > CURRENT_TIMESTAMP - INTERVAL 5 MINUTE
            GROUP BY close
            ORDER BY vol_at_level DESC
        """
        result = self.conn.execute(query).fetchall()
        return result
    
    def run(self):
        """Main loop"""
        self.create_alpaca_tables()
        logger.info("Alpaca stream initialized. Fetching latest bars...")
        
        import time
        while True:
            try:
                self.get_latest_bars()
                
                # Calculate volume profile for SPY
                profile = self.calculate_volume_profile('SPY')
                if profile:
                    logger.info(f"SPY volume profile (top 3): {profile[:3]}")
                
                time.sleep(5)
                
            except KeyboardInterrupt:
                logger.info("Shutdown")
                break
            except Exception as e:
                logger.error(f"Error: {e}")


if __name__ == '__main__':
    stream = AlpacaDataStream()
    stream.run()

