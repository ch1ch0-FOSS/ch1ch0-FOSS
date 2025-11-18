#!/usr/bin/env python3
"""Ingest market data snapshot at specified times"""

import yfinance as yf
import duckdb
import os
from datetime import datetime, timedelta
from dotenv import load_dotenv
import logging

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(os.path.expanduser('~/trading-infra/logs/ingest.log')),
        logging.StreamHandler()
    ]
)

load_dotenv(os.path.expanduser('~/.env_trading'))
DB_PATH = os.getenv('DB_PATH')
SECTOR_ETFS = os.getenv('SECTOR_ETFS', '').split()

def ingest_sector_etfs():
    """Pull latest sector ETF data"""
    conn = duckdb.connect(DB_PATH)
    
    logging.info(f"Ingesting {len(SECTOR_ETFS)} sector ETFs...")
    
    for ticker in SECTOR_ETFS:
        try:
            # Get 2 years of daily data
            data = yf.download(ticker, period='2y', interval='1d', progress=False)
            
            if data.empty:
                logging.warning(f"No data for {ticker}")
                continue
            
            # Insert into database - convert Series to native Python types
            for idx, row in data.iterrows():
                conn.execute("""
                    INSERT OR REPLACE INTO sector_etfs
                    VALUES (?, ?, ?, ?, ?, ?, ?, '1d')
                """, [
                    ticker,
                    idx.to_pydatetime(),
                    float(row['Open']),      # Convert to native float
                    float(row['High']),      # Convert to native float
                    float(row['Low']),       # Convert to native float
                    float(row['Close']),     # Convert to native float
                    int(row['Volume'])       # Convert to native int
                ])
            
            conn.commit()
            logging.info(f"✓ {ticker}: {len(data)} candles ingested")
        except Exception as e:
            logging.error(f"✗ {ticker}: {str(e)}")
    
    conn.close()

def ingest_holdings(etf_ticker):
    """Get ETF holdings"""
    conn = duckdb.connect(DB_PATH)
    
    try:
        etf = yf.Ticker(etf_ticker)
        # Holdings info not always available via yfinance
        logging.info(f"Holdings ingestion for {etf_ticker} - manual data entry recommended")
        
    except Exception as e:
        logging.error(f"✗ Holdings {etf_ticker}: {str(e)}")
    finally:
        conn.close()

def ingest_options_chains(ticker):
    """Pull options chain for a specific ticker"""
    conn = duckdb.connect(DB_PATH)
    
    try:
        stock = yf.Ticker(ticker)
        expirations = stock.options
        
        if not expirations:
            logging.warning(f"No options for {ticker}")
            return
        
        logging.info(f"Ingesting options for {ticker} - {len(expirations)} expirations")
        
        for exp in expirations[:5]:  # Next 5 expirations
            try:
                chain = stock.option_chain(exp)
                
                # Calls
                for idx, row in chain.calls.iterrows():
                    if int(row['volume']) > 0:
                        conn.execute("""
                            INSERT OR REPLACE INTO options_chains
                            VALUES (?, ?, ?, ?, ?, 'call', ?, ?, ?, ?, ?, ?)
                        """, [
                            ticker,
                            f"{ticker}{exp.replace('-', '')}{int(row['strike']*1000)}C",
                            datetime.now(),
                            exp,
                            float(row['strike']),
                            float(row['lastPrice']) if row['lastPrice'] > 0 else 0.0,
                            float(row['bid']),
                            float(row['ask']),
                            int(row['volume']),
                            int(row['openInterest']),
                            float(row['impliedVolatility'])
                        ])
                
                # Puts
                for idx, row in chain.puts.iterrows():
                    if int(row['volume']) > 0:
                        conn.execute("""
                            INSERT OR REPLACE INTO options_chains
                            VALUES (?, ?, ?, ?, ?, 'put', ?, ?, ?, ?, ?, ?)
                        """, [
                            ticker,
                            f"{ticker}{exp.replace('-', '')}{int(row['strike']*1000)}P",
                            datetime.now(),
                            exp,
                            float(row['strike']),
                            float(row['lastPrice']) if row['lastPrice'] > 0 else 0.0,
                            float(row['bid']),
                            float(row['ask']),
                            int(row['volume']),
                            int(row['openInterest']),
                            float(row['impliedVolatility'])
                        ])
                
                conn.commit()
                logging.info(f"✓ {ticker} {exp}")
                
            except Exception as e:
                logging.error(f"✗ {ticker} {exp}: {str(e)}")
    
    except Exception as e:
        logging.error(f"✗ Options {ticker}: {str(e)}")
    finally:
        conn.close()

if __name__ == '__main__':
    ingest_sector_etfs()
    logging.info("Snapshot ingestion complete")
