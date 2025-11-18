#!/usr/bin/env python3
"""Detect volume anomalies"""

import duckdb
import os
from dotenv import load_dotenv
from datetime import datetime, timedelta
import logging

logging.basicConfig(level=logging.INFO)

load_dotenv(os.path.expanduser('~/.env_trading'))
DB_PATH = os.getenv('DB_PATH')

def detect_anomalies():
    """Detect volume anomalies and insert into volume_anomalies table"""
    conn = duckdb.connect(DB_PATH)
    
    # Get tickers to analyze
    tickers = conn.execute("SELECT DISTINCT ticker FROM holdings_ohlcv").fetchall()
    
    for (ticker,) in tickers:
        # Calculate 20-day average volume
        result = conn.execute(f"""
            SELECT 
                AVG(volume) as avg_vol,
                volume as current_vol,
                volume / NULLIF(AVG(volume) OVER (ORDER BY timestamp ROWS BETWEEN 20 PRECEDING AND 1 PRECEDING), 0) as ratio
            FROM holdings_ohlcv
            WHERE ticker = '{ticker}'
              AND timeframe = '1d'
            ORDER BY timestamp DESC
            LIMIT 1
        """).fetchall()
        
        if result and result[0][2] > 1.5:  # 50% above average
            avg_vol, current_vol, ratio = result[0]
            
            signal_strength = 'weak' if ratio < 2 else 'moderate' if ratio < 3 else 'strong'
            
            conn.execute("""
                INSERT OR REPLACE INTO volume_anomalies
                VALUES (?, ?, ?, ?, ?, 'stock', ?)
            """, [
                ticker,
                datetime.now(),
                int(avg_vol),
                int(current_vol),
                float(ratio),
                signal_strength
            ])
    
    conn.commit()
    conn.close()
    logging.info("Volume anomalies detected")

if __name__ == '__main__':
    detect_anomalies()
