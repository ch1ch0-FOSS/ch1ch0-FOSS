#!/usr/bin/env python3
"""Initialize DuckDB schema for trading data"""

import duckdb
import os
from dotenv import load_dotenv

load_dotenv(os.path.expanduser('~/.env_trading'))
DB_PATH = os.getenv('DB_PATH')

conn = duckdb.connect(DB_PATH)

# Sector ETFs table
conn.execute("""
    CREATE TABLE IF NOT EXISTS sector_etfs (
        ticker VARCHAR,
        timestamp TIMESTAMP,
        open DOUBLE,
        high DOUBLE,
        low DOUBLE,
        close DOUBLE,
        volume BIGINT,
        timeframe VARCHAR,  -- '1d', '1wk', '1mo', '3mo'
        PRIMARY KEY (ticker, timestamp, timeframe)
    )
""")

# ETF Holdings table
conn.execute("""
    CREATE TABLE IF NOT EXISTS etf_holdings (
        etf_ticker VARCHAR,
        holding_ticker VARCHAR,
        weight DOUBLE,
        updated_at TIMESTAMP,
        PRIMARY KEY (etf_ticker, holding_ticker)
    )
""")

# Holdings OHLCV table
conn.execute("""
    CREATE TABLE IF NOT EXISTS holdings_ohlcv (
        ticker VARCHAR,
        timestamp TIMESTAMP,
        open DOUBLE,
        high DOUBLE,
        low DOUBLE,
        close DOUBLE,
        volume BIGINT,
        timeframe VARCHAR,  -- '1h', '1d'
        PRIMARY KEY (ticker, timestamp, timeframe)
    )
""")

# Options chains table
conn.execute("""
    CREATE TABLE IF NOT EXISTS options_chains (
        underlying_ticker VARCHAR,
        contract_symbol VARCHAR,
        timestamp TIMESTAMP,
        expiration DATE,
        strike DOUBLE,
        option_type VARCHAR,  -- 'call' or 'put'
        last_price DOUBLE,
        bid DOUBLE,
        ask DOUBLE,
        volume BIGINT,
        open_interest BIGINT,
        implied_volatility DOUBLE,
        PRIMARY KEY (contract_symbol, timestamp)
    )
""")

# Volume anomalies table
conn.execute("""
    CREATE TABLE IF NOT EXISTS volume_anomalies (
        ticker VARCHAR,
        timestamp TIMESTAMP,
        avg_volume_20d BIGINT,
        current_volume BIGINT,
        volume_ratio DOUBLE,
        anomaly_type VARCHAR,  -- 'stock' or 'options'
        signal_strength VARCHAR,  -- 'weak', 'moderate', 'strong'
        PRIMARY KEY (ticker, timestamp, anomaly_type)
    )
""")

# Trade execution log
conn.execute("""
    CREATE TABLE IF NOT EXISTS trade_executions (
        trade_id VARCHAR PRIMARY KEY,
        ticker VARCHAR,
        timestamp TIMESTAMP,
        entry_price DOUBLE,
        position_size INT,
        strategy VARCHAR,
        status VARCHAR,  -- 'open', 'closed', 'cancelled'
        exit_price DOUBLE,
        notes TEXT
    )
""")

conn.close()
print("✓ DuckDB schema initialized successfully")
