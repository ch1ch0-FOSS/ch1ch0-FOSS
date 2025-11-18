import duckdb
import os
from datetime import datetime, timedelta

class TradeJournal:
    def __init__(self, db_path):
        self.conn = duckdb.connect(db_path)
    
    def get_stats(self, period_days=1):
        """Get trading stats for last N days."""
        date_threshold = (datetime.now() - timedelta(days=period_days)).date()
        
        stats = self.conn.execute(f"""
            SELECT
                COUNT(*) as total_trades,
                SUM(CASE WHEN win_loss THEN 1 ELSE 0 END) as wins,
                AVG(pnl) as avg_pnl,
                SUM(pnl) as total_pnl,
                MAX(pnl) as best_trade,
                MIN(pnl) as worst_trade
            FROM paper_trades
            WHERE DATE(entry_time) >= '{date_threshold}'
        """).fetchone()
        
        if not stats or stats[0] is None or stats[0] == 0:
            return {
                'total_trades': 0,
                'wins': 0,
                'win_rate': 0,
                'avg_pnl': 0,
                'total_pnl': 0,
                'best_trade': 0,
                'worst_trade': 0
            }
        
        return {
            'total_trades': stats[0],
            'wins': stats[1] or 0,
            'win_rate': round((stats[1] / stats[0] * 100) if stats[0] > 0 else 0, 2),
            'avg_pnl': round(float(stats[2] or 0), 2),
            'total_pnl': round(float(stats[3] or 0), 2),
            'best_trade': round(float(stats[4] or 0), 2),
            'worst_trade': round(float(stats[5] or 0), 2)
        }
    
    def generate_report(self):
        """Generate markdown report."""
        stats = self.get_stats(1)
        
        report = f"""# Trading Journal - {datetime.now().strftime('%Y-%m-%d %H:%M')}

## Daily Statistics
- **Total Trades:** {stats['total_trades']}
- **Wins:** {stats['wins']}
- **Win Rate:** {stats['win_rate']}%
- **Total P&L:** ${stats['total_pnl']}
- **Avg P&L/Trade:** ${stats['avg_pnl']}
- **Best Trade:** ${stats['best_trade']}
- **Worst Trade:** ${stats['worst_trade']}

---
*Report generated: {datetime.now().isoformat()}*
"""
        return report

if __name__ == '__main__':
    db_path = os.path.expanduser('~/trading-infra/storage/trading.duckdb')
    journal = TradeJournal(db_path)
    report = journal.generate_report()
    print(report)
    
    # Save to file
    report_path = os.path.expanduser('~/trading-infra/reports/trade-journal-today.md')
    os.makedirs(os.path.dirname(report_path), exist_ok=True)
    with open(report_path, 'w') as f:
        f.write(report)
    print(f"✓ Report saved to {report_path}")
