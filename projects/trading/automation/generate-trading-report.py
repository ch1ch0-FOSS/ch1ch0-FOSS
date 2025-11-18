#!/usr/bin/env python3
"""
Master Trading Report Generator
Automated signal generation combining:
- Volume anomaly detection
- Multi-timeframe confluence (W, D, 4H, 1H)
- Broadening formation detection (Rob Smith 3-bar method)
- Holdings drill-down
- Plutus LLM recommendations

Output: Markdown report with naked calls/puts + DCA targets
"""

import os
import sys
import duckdb
import yfinance as yf
import pandas as pd
import subprocess
from datetime import datetime
from pathlib import Path
from dotenv import load_dotenv

# Load environment
load_dotenv(os.path.expanduser('~/.env_trading'))
DB_PATH = os.getenv('DB_PATH')
OLLAMA_MODEL = os.getenv('OLLAMA_MODEL', '0xroyce/plutus')

# Project paths
PROJECT_ROOT = Path.home() / 'trading-infra'
HOLDINGS_CSV = PROJECT_ROOT / 'data' / 'etf-holdings.csv'
REPORT_DIR = PROJECT_ROOT / 'execution' / 'reports' / 'daily'


class TradingReportGenerator:
    def __init__(self):
        self.conn = duckdb.connect(DB_PATH)
        self.holdings_df = pd.read_csv(HOLDINGS_CSV)
        self.report_lines = []
        self.options_plays = []
        self.dca_targets = []
        
    def log(self, msg):
        """Print and store in report"""
        print(f"[{datetime.now().strftime('%H:%M:%S')}] {msg}")
        
    def get_volume_anomalies(self):
        """Fetch today's volume anomalies from database"""
        query = """
            SELECT 
                ticker,
                signal_strength,
                volume_ratio,
                anomaly_type
            FROM volume_anomalies
            WHERE DATE(timestamp) = CURRENT_DATE
              AND signal_strength IN ('strong', 'moderate')
            ORDER BY volume_ratio DESC
        """
        return self.conn.execute(query).fetch_df()
    
    def get_etf_holdings(self, etf):
        """Get top holdings for an ETF"""
        holdings = self.holdings_df[self.holdings_df['etf'] == etf]
        return holdings.sort_values('weight', ascending=False).head(10)
    
    def check_timeframe_confluence(self, ticker):
        """Check if W, D, 4H, 1H all align bullish/bearish"""
        try:
            timeframes = {
                '1wk': '3mo',
                '1d': '2mo',
                '4h': '30d',
                '1h': '7d'
            }
            
            trends = []
            
            for interval, period in timeframes.items():
                data = yf.download(ticker, period=period, interval=interval, progress=False)
                if len(data) < 20:
                    continue
                    
                # Simple EMA trend
                ema20 = data['Close'].ewm(span=20).mean()
                current_price = data['Close'].iloc[-1]
                current_ema = ema20.iloc[-1]
                
                trend = 'bullish' if current_price > current_ema else 'bearish'
                trends.append(trend)
            
            if len(trends) < 3:
                return 'insufficient_data', 'unknown'
            
            # All align?
            if all(t == 'bullish' for t in trends):
                return 'bullish', 'strong'
            elif all(t == 'bearish' for t in trends):
                return 'bearish', 'strong'
            elif trends.count('bullish') >= 3:
                return 'bullish', 'moderate'
            elif trends.count('bearish') >= 3:
                return 'bearish', 'moderate'
            else:
                return 'mixed', 'weak'
                
        except Exception as e:
            self.log(f"Confluence error for {ticker}: {e}")
            return 'error', 'unknown'
    
    def detect_broadening_formation(self, ticker, timeframe='1d'):
        """Detect Rob Smith 3-bar/outside bar broadening formation"""
        try:
            period_map = {'1wk': '1y', '1d': '6mo', '4h': '60d'}
            period = period_map.get(timeframe, '6mo')
            
            data = yf.download(ticker, period=period, interval=timeframe, progress=False)
            
            if len(data) < 10:
                return None
            
            formations = []
            
            for i in range(2, len(data)):
                current = data.iloc[i]
                prev = data.iloc[i-1]
                
                # Outside bar: current engulfs previous
                is_outside = (current['High'] > prev['High'] and 
                              current['Low'] < prev['Low'])
                
                if is_outside:
                    # Calculate expansion magnitude
                    expansion = ((current['High'] - current['Low']) / 
                                (prev['High'] - prev['Low'])) - 1
                    
                    formations.append({
                        'date': current.name.strftime('%Y-%m-%d'),
                        'upper_boundary': float(current['High']),
                        'lower_boundary': float(current['Low']),
                        'expansion_pct': float(expansion * 100),
                        'timeframe': timeframe
                    })
            
            # Return most recent formation
            return formations[-1] if formations else None
            
        except Exception as e:
            self.log(f"BF detection error for {ticker}: {e}")
            return None
    
    def generate_entry_signal(self, ticker, current_price, bf_daily, bf_weekly, confluence):
        """Combine all factors to generate entry signal"""
        
        trend, strength = confluence
        
        # Need at least moderate confluence
        if strength == 'weak' or trend == 'mixed':
            return None
        
        # Check BF boundaries
        signal = None
        
        if bf_daily:
            lower = bf_daily['lower_boundary']
            upper = bf_daily['upper_boundary']
            
            # Price at lower boundary + bullish confluence = CALL
            if current_price <= lower * 1.03 and trend == 'bullish':
                signal = {
                    'ticker': ticker,
                    'action': 'BUY_CALL',
                    'type': 'options',
                    'current_price': current_price,
                    'entry_zone': f"${lower:.2f} - ${lower*1.03:.2f}",
                    'reason': f"Price at lower BF boundary (${lower:.2f})",
                    'bf_timeframe': 'Daily',
                    'confluence': f"{trend.title()} ({strength})",
                    'confidence': 8 if bf_weekly else 7
                }
            
            # Price at upper boundary + bearish confluence = PUT
            elif current_price >= upper * 0.97 and trend == 'bearish':
                signal = {
                    'ticker': ticker,
                    'action': 'BUY_PUT',
                    'type': 'options',
                    'current_price': current_price,
                    'entry_zone': f"${upper*0.97:.2f} - ${upper:.2f}",
                    'reason': f"Price at upper BF boundary (${upper:.2f})",
                    'bf_timeframe': 'Daily',
                    'confluence': f"{trend.title()} ({strength})",
                    'confidence': 8 if bf_weekly else 7
                }
            
            # Weekly BF detected = boost confidence
            if signal and bf_weekly:
                signal['confidence'] = 9
                signal['reason'] += f" + Weekly BF confirmation"
        
        # If no signal but strong confluence, add to DCA list
        if not signal and strength == 'strong':
            return {
                'ticker': ticker,
                'type': 'dca',
                'current_price': current_price,
                'confluence': f"{trend.title()} (strong)",
                'reason': 'Long-term accumulation zone'
            }
        
        return signal
    
    def analyze_holding(self, ticker):
        """Full analysis pipeline for a single holding"""
        try:
            # Get current price
            data = yf.Ticker(ticker).history(period='1d')
            if data.empty:
                return None
            
            current_price = float(data['Close'].iloc[-1])
            
            # Multi-timeframe confluence
            confluence = self.check_timeframe_confluence(ticker)
            
            # Broadening formations
            bf_daily = self.detect_broadening_formation(ticker, '1d')
            bf_weekly = self.detect_broadening_formation(ticker, '1wk')
            
            # Generate signal
            signal = self.generate_entry_signal(
                ticker, current_price, bf_daily, bf_weekly, confluence
            )
            
            return signal
            
        except Exception as e:
            self.log(f"Analysis error for {ticker}: {e}")
            return None
    
    def query_plutus(self, signals):
        """Get Plutus LLM analysis for options plays"""
        if not signals:
            return "No high-confidence signals to analyze."
        
        # Build prompt
        signal_text = "\n".join([
            f"{i+1}. {s['ticker']} - {s['action'].replace('_', ' ')} at ${s['current_price']:.2f}\n"
            f"   Reason: {s['reason']}\n"
            f"   Confluence: {s['confluence']}\n"
            f"   Confidence: {s['confidence']}/10"
            for i, s in enumerate(signals[:5])  # Top 5
        ])
        
        prompt = f"""Generate trading signals for these setups. Keep responses concise.

TODAY'S HIGH-CONFIDENCE PLAYS:

{signal_text}

For EACH ticker:
1. Validate the setup (support/resistance, volume, momentum)
2. Recommend specific strike price (ATM or 2-5% OTM)
3. Suggest expiration (prefer 0-7 DTE for momentum plays)
4. Target profit (aim for 5:1 minimum)
5. Risk management (stop loss level)

Format as brief bullet points per ticker."""
        
        try:
            result = subprocess.run(
                ['ollama', 'run', OLLAMA_MODEL],
                input=prompt.encode(),
                capture_output=True,
                timeout=180
            )
            return result.stdout.decode('utf-8', errors='ignore')
        except Exception as e:
            return f"Plutus error: {str(e)}"
    
    def generate_markdown_report(self):
        """Build complete markdown report"""
        now = datetime.now()
        report = []
        
        # Header
        report.append(f"# Trading Signal Report")
        report.append(f"**Generated:** {now.strftime('%Y-%m-%d %H:%M:%S PST')}\n")
        report.append(f"**Snapshot:** {now.strftime('%H:%M')} PST\n")
        report.append("---\n")
        
        # Options plays section
        if self.options_plays:
            report.append("## 🎯 HIGH-CONVICTION OPTIONS PLAYS\n")
            
            for i, play in enumerate(self.options_plays, 1):
                report.append(f"### {i}. {play['ticker']} - {play['action'].replace('_', ' ')}\n")
                report.append(f"- **Current Price:** ${play['current_price']:.2f}")
                report.append(f"- **Entry Zone:** {play['entry_zone']}")
                report.append(f"- **Setup:** {play['reason']}")
                report.append(f"- **Timeframe Confluence:** {play['confluence']}")
                report.append(f"- **BF Detection:** {play['bf_timeframe']} outside bar")
                report.append(f"- **Confidence:** {play['confidence']}/10\n")
            
            # Plutus analysis
            report.append("## Plutus LLM Analysis\n")
            report.append(self.plutus_analysis)
            report.append("\n")
        else:
            report.append("## ⚠️ No High-Conviction Options Plays Today\n")
            report.append("No setups meeting criteria (BF boundary + timeframe confluence).\n")
        
        # DCA targets section
        if self.dca_targets:
            report.append("---\n")
            report.append("## 📊 DCA SHARE ACCUMULATION TARGETS\n")
            report.append("*Long-term position building in strong trends*\n")
            
            for i, target in enumerate(self.dca_targets, 1):
                report.append(f"### {i}. {target['ticker']}\n")
                report.append(f"- **Current Price:** ${target['current_price']:.2f}")
                report.append(f"- **Trend:** {target['confluence']}")
                report.append(f"- **Strategy:** {target['reason']}")
                report.append(f"- **Suggested Allocation:** $200-500/month\n")
        
        # Execution workflow
        report.append("---\n")
        report.append("## ✅ EXECUTION WORKFLOW\n")
        report.append("1. Open TradingView → Verify chart setups")
        report.append("2. Confirm BF boundaries on daily + weekly")
        report.append("3. Check 15m chart for precise entry timing")
        report.append("4. Execute on Webull (options) or broker (shares)")
        report.append("5. Log trade in `execution/trade-log.md`")
        report.append("6. Set alerts at BF boundaries\n")
        
        return "\n".join(report)
    
    def save_report(self, content):
        """Save report to daily directory"""
        now = datetime.now()
        
        # Create directory structure
        report_date_dir = REPORT_DIR / now.strftime('%Y-%m-%d')
        report_date_dir.mkdir(parents=True, exist_ok=True)
        
        # Filename: 0700-snapshot.md
        filename = f"{now.strftime('%H%M')}-snapshot.md"
        filepath = report_date_dir / filename
        
        with open(filepath, 'w') as f:
            f.write(content)
        
        self.log(f"✓ Report saved: {filepath}")
        return filepath
    
    def git_commit(self, filepath):
        """Commit report to git"""
        try:
            subprocess.run(['git', 'add', str(filepath)], cwd=PROJECT_ROOT, check=True)
            commit_msg = f"report: {datetime.now().strftime('%Y-%m-%d %H:%M')} snapshot"
            subprocess.run(['git', 'commit', '-m', commit_msg], cwd=PROJECT_ROOT, check=True)
            self.log("✓ Report committed to git")
        except subprocess.CalledProcessError as e:
            self.log(f"⚠️  Git commit failed: {e}")
    
    def run(self):
        """Main execution pipeline"""
        self.log("="*70)
        self.log("TRADING SIGNAL REPORT GENERATOR")
        self.log("="*70)
        
        # Step 1: Get volume anomalies
        self.log("\n1. Fetching volume anomalies...")
        anomalies = self.get_volume_anomalies()
        
        if anomalies.empty:
            self.log("⚠️  No anomalies detected today")
            # Generate minimal report
            report = self.generate_markdown_report()
            filepath = self.save_report(report)
            self.git_commit(filepath)
            return
        
        self.log(f"✓ Found {len(anomalies)} ETF anomalies")
        
        # Step 2: Analyze holdings for each ETF
        self.log("\n2. Analyzing holdings...")
        
        for idx, row in anomalies.iterrows():
            etf = row['ticker']
            self.log(f"\n   Scanning {etf} holdings...")
            
            holdings = self.get_etf_holdings(etf)
            
            for hidx, holding in holdings.iterrows():
                ticker = holding['ticker']
                self.log(f"     • {ticker}...")
                
                signal = self.analyze_holding(ticker)
                
                if signal:
                    if signal['type'] == 'options' and signal['confidence'] >= 7:
                        self.options_plays.append(signal)
                        self.log(f"       ✓ Options signal: {signal['action']} (confidence {signal['confidence']})")
                    elif signal['type'] == 'dca':
                        self.dca_targets.append(signal)
                        self.log(f"       ✓ DCA target added")
        
        # Step 3: Sort by confidence
        self.options_plays = sorted(self.options_plays, key=lambda x: x['confidence'], reverse=True)
        
        self.log(f"\n✓ Analysis complete:")
        self.log(f"  - Options plays: {len(self.options_plays)}")
        self.log(f"  - DCA targets: {len(self.dca_targets)}")
        
        # Step 4: Plutus analysis
        if self.options_plays:
            self.log("\n3. Querying Plutus LLM...")
            self.plutus_analysis = self.query_plutus(self.options_plays)
            self.log("✓ Plutus analysis complete")
        else:
            self.plutus_analysis = "No options plays to analyze."
        
        # Step 5: Generate report
        self.log("\n4. Generating markdown report...")
        report = self.generate_markdown_report()
        
        # Step 6: Save and commit
        filepath = self.save_report(report)
        self.git_commit(filepath)
        
        self.log("\n" + "="*70)
        self.log(f"✓ REPORT COMPLETE: {filepath}")
        self.log("="*70)
        
        # Close database
        self.conn.close()


if __name__ == '__main__':
    try:
        generator = TradingReportGenerator()
        generator.run()
    except Exception as e:
        print(f"FATAL ERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
