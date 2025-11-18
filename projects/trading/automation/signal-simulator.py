import duckdb
import json
import random
import os
from datetime import datetime

class SignalSimulator:
    def __init__(self, db_path):
        self.conn = duckdb.connect(db_path)
    
    def simulate_trade(self, ticker, signal_confidence, entry_reason, qty=1):
        """Simulate a trade based on last bar price with random outcome."""
        try:
            last_bar = self.conn.execute("""
                SELECT close FROM alpaca_bars 
                WHERE ticker = ? 
                ORDER BY timestamp DESC LIMIT 1
            """, (ticker,)).fetchone()
            
            if not last_bar:
                print(f"  ✗ No data for {ticker}")
                return None
            
            entry_price = float(last_bar[0])
            
            # Simulate exit: 60% win bias
            outcome = random.random()
            if outcome < 0.6:  # Win
                exit_price = entry_price * (1 + random.uniform(0.001, 0.01))
            else:  # Loss
                exit_price = entry_price * (1 - random.uniform(0.001, 0.01))
            
            pnl = (exit_price - entry_price) * qty
            
            # Log to paper_trades
            self.conn.execute("""
                INSERT INTO paper_trades 
                (ticker, entry_price, entry_time, entry_reason, order_id, qty, exit_price, exit_time, pnl, win_loss)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                ticker,
                entry_price,
                datetime.now(),
                entry_reason,
                f"SIM-{int(datetime.now().timestamp() * 1000)}",
                qty,
                exit_price,
                datetime.now(),
                pnl,
                pnl > 0
            ))
            
            self.conn.commit()
            
            return {
                'ticker': ticker,
                'entry_price': round(entry_price, 2),
                'exit_price': round(exit_price, 2),
                'qty': qty,
                'pnl': round(pnl, 2),
                'win': pnl > 0
            }
        
        except Exception as e:
            print(f"  ✗ Error simulating {ticker}: {str(e)}")
            return None

if __name__ == '__main__':
    db_path = os.path.expanduser('~/trading-infra/storage/trading.duckdb')
    simulator = SignalSimulator(db_path)
    
    print("\n=== SIMULATING 5 PAPER TRADES ===\n")
    
    tickers = ['SPY', 'QQQ', 'IWM', 'AAPL', 'MSFT']
    for i, ticker in enumerate(tickers, 1):
        result = simulator.simulate_trade(ticker, 8.0, f'Test signal confluence {i}', qty=1)
        if result:
            status = "✓ WIN" if result['win'] else "✗ LOSS"
            print(f"{i}. {ticker}: ${result['entry_price']} → ${result['exit_price']} | P&L: ${result['pnl']} {status}")
    
    print("\n✓ All simulated trades logged to database\n")
