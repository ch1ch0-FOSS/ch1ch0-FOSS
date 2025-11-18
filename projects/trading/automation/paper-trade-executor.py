# ~/trading-infra/automation/paper-trade-executor.py

import logging
import os
import json
from datetime import datetime
from typing import Optional, Dict, Any
import duckdb
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import MarketOrderRequest
from alpaca.trading.enums import OrderSide, TimeInForce
from uuid import UUID

# Configuration
API_KEY = os.getenv('APCA_API_KEY_ID')
API_SECRET = os.getenv('APCA_API_SECRET_KEY')
DB_PATH = os.path.expanduser('~/trading-infra/storage/trading.duckdb')
LOG_FILE = os.path.expanduser('~/trading-infra/logs/executor.log')

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class JSONEncoder(json.JSONEncoder):
    """Custom JSON encoder to handle UUID and datetime objects."""
    def default(self, obj):
        if isinstance(obj, UUID):
            return str(obj)
        if isinstance(obj, datetime):
            return obj.isoformat()
        return super().default(obj)

class PaperTradeExecutor:
    def __init__(self):
        self.trading_client = TradingClient(
            api_key=API_KEY,
            secret_key=API_SECRET,
            paper=True
        )
        self.conn = duckdb.connect(DB_PATH)
        self._ensure_tables_exist()
        logger.info("PaperTradeExecutor initialized successfully")

    def _ensure_tables_exist(self):
        """Create paper_trades and trade_signals tables if they don't exist."""
        # Create sequences first
        self.conn.execute("CREATE SEQUENCE IF NOT EXISTS seq_trades START 1")
        self.conn.execute("CREATE SEQUENCE IF NOT EXISTS seq_signals START 1")
        
        # Create tables
        self.conn.execute("""
            CREATE TABLE IF NOT EXISTS paper_trades (
                id INTEGER PRIMARY KEY DEFAULT nextval('seq_trades'),
                ticker VARCHAR,
                entry_price DOUBLE,
                entry_time TIMESTAMP,
                entry_reason VARCHAR,
                order_id VARCHAR,
                qty INTEGER,
                exit_price DOUBLE,
                exit_time TIMESTAMP,
                pnl DOUBLE,
                win_loss BOOLEAN,
                created_at TIMESTAMP DEFAULT now()
            )
        """)
        
        self.conn.execute("""
            CREATE TABLE IF NOT EXISTS trade_signals (
                id INTEGER PRIMARY KEY DEFAULT nextval('seq_signals'),
                ticker VARCHAR,
                signal_type VARCHAR,
                confidence DOUBLE,
                pattern VARCHAR,
                multi_tf_confluence BOOLEAN,
                volume_anomaly BOOLEAN,
                signal_time TIMESTAMP,
                created_at TIMESTAMP DEFAULT now()
            )
        """)
        
        self.conn.commit()
        logger.info("Database tables verified/created")

    def execute_trade(
        self,
        ticker: str,
        qty: int,
        side: str,
        entry_reason: str,
        signal_confidence: float = None
    ) -> Optional[Dict[str, Any]]:
        """Execute a market order on paper account."""
        try:
            order_data = MarketOrderRequest(
                symbol=ticker,
                qty=qty,
                side=OrderSide.BUY if side.lower() == 'buy' else OrderSide.SELL,
                time_in_force=TimeInForce.DAY
            )
            
            order = self.trading_client.submit_order(order_data=order_data)
            entry_time = datetime.now()
            
            logger.info(f"Order submitted: {ticker} {qty} {side} @ Order ID: {order.id}")
            
            # Log trade signal
            self.conn.execute("""
                INSERT INTO trade_signals 
                (ticker, signal_type, confidence, pattern, signal_time)
                VALUES (?, ?, ?, ?, ?)
            """, (ticker, side.upper(), signal_confidence, entry_reason, entry_time))
            
            # Log initial trade entry
            self.conn.execute("""
                INSERT INTO paper_trades 
                (ticker, entry_price, entry_time, entry_reason, order_id, qty)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (
                ticker,
                float(order.filled_avg_price) if order.filled_avg_price else 0,
                entry_time,
                entry_reason,
                str(order.id),
                qty
            ))
            self.conn.commit()
            
            logger.info(f"Trade logged: {ticker} {qty} {side} @ {order.filled_avg_price}")
            
            return {
                'order_id': str(order.id),
                'ticker': ticker,
                'qty': qty,
                'side': side,
                'entry_price': float(order.filled_avg_price) if order.filled_avg_price else 0,
                'entry_time': entry_time.isoformat(),
                'status': str(order.status)
            }
        
        except Exception as e:
            logger.error(f"Error executing trade for {ticker}: {str(e)}")
            return None

    def close_trade(
        self,
        order_id: str,
        ticker: str,
        qty: int,
        exit_reason: str = "Manual close"
    ) -> Optional[Dict[str, Any]]:
        """Close an open trade by submitting opposing market order."""
        try:
            result = self.conn.execute("""
                SELECT entry_price, entry_time FROM paper_trades 
                WHERE order_id = ? LIMIT 1
            """, (order_id,)).fetchall()
            
            if not result:
                logger.error(f"Trade with order_id {order_id} not found")
                return None
            
            entry_price, entry_time = result[0]
            
            close_order_data = MarketOrderRequest(
                symbol=ticker,
                qty=qty,
                side=OrderSide.SELL,
                time_in_force=TimeInForce.DAY
            )
            
            close_order = self.trading_client.submit_order(order_data=close_order_data)
            exit_time = datetime.now()
            exit_price = float(close_order.filled_avg_price) if close_order.filled_avg_price else 0
            pnl = (exit_price - entry_price) * qty
            
            logger.info(f"Trade closed: {ticker} PnL: {pnl}")
            
            self.conn.execute("""
                UPDATE paper_trades 
                SET exit_price = ?, exit_time = ?, pnl = ?, win_loss = ?
                WHERE order_id = ?
            """, (exit_price, exit_time, pnl, pnl > 0, order_id))
            self.conn.commit()
            
            return {
                'order_id': str(close_order.id),
                'ticker': ticker,
                'exit_price': exit_price,
                'exit_time': exit_time.isoformat(),
                'pnl': pnl,
                'win': pnl > 0
            }
        
        except Exception as e:
            logger.error(f"Error closing trade {order_id}: {str(e)}")
            return None

    def get_open_trades(self) -> list:
        """Fetch all open trades (exit_price IS NULL)."""
        return self.conn.execute("""
            SELECT id, ticker, entry_price, entry_time, entry_reason, qty, order_id
            FROM paper_trades
            WHERE exit_price IS NULL
            ORDER BY entry_time DESC
        """).fetchall()

    def get_daily_stats(self) -> Dict[str, Any]:
        """Generate daily trade statistics."""
        today = datetime.now().date()
        stats = self.conn.execute(f"""
            SELECT 
                COUNT(*) as total_trades,
                SUM(CASE WHEN win_loss THEN 1 ELSE 0 END) as wins,
                AVG(pnl) as avg_pnl,
                SUM(pnl) as total_pnl,
                MAX(pnl) as best_trade,
                MIN(pnl) as worst_trade
            FROM paper_trades
            WHERE DATE(entry_time) = '{today}'
        """).fetchone()
        
        if not stats or stats[0] is None:
            return {
                'date': today.isoformat(),
                'total_trades': 0,
                'wins': 0,
                'avg_pnl': 0,
                'total_pnl': 0,
                'best_trade': 0,
                'worst_trade': 0
            }
        
        return {
            'date': today.isoformat(),
            'total_trades': stats[0],
            'wins': stats[1] or 0,
            'avg_pnl': round(float(stats[2] or 0), 2),
            'total_pnl': round(float(stats[3] or 0), 2),
            'best_trade': round(float(stats[4] or 0), 2),
            'worst_trade': round(float(stats[5] or 0), 2)
        }

if __name__ == '__main__':
    executor = PaperTradeExecutor()
    
    # Display account info
    account = executor.trading_client.get_account()
    print(f"\n{'='*60}")
    print(f"Account ID: {account.id}")
    print(f"Buying Power: ${account.buying_power}")
    print(f"Portfolio Value: ${account.portfolio_value}")
    print(f"Cash: ${account.cash}")
    print(f"{'='*60}\n")
    
    # Example: Execute a paper trade
    print("Example: Executing test trade (SPY 1 share)...")
    result = executor.execute_trade(
        ticker='SPY',
        qty=1,
        side='buy',
        entry_reason='Test execution - BF detection + Multi-TF confluence (9/10)',
        signal_confidence=9.0
    )
    
    if result:
        print(f"\nTrade executed:\n{json.dumps(result, indent=2, cls=JSONEncoder)}")
        print(f"\nOpen trades:\n{executor.get_open_trades()}")
        print(f"\nDaily stats:\n{json.dumps(executor.get_daily_stats(), indent=2, cls=JSONEncoder)}")
    else:
        print("Trade execution failed")
