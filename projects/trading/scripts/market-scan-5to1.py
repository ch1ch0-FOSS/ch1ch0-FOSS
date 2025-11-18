#!/usr/bin/env python3
"""
Market Scan for 5:1 Trading Opportunities
Automated scanning for Alpha Way strategy candidates

Scans:
1. Major indices (/ES, /NQ)
2. Sector ETFs (XLF, XLE, XLK, XLV, XLY, XLP, XLI, XLU, XLRE)
3. High-liquidity equities

Outputs candidates with:
- 5:1 risk/reward potential
- Support/resistance levels identified
- Volume analysis
- Technical setup ready for visual confirmation
"""

import json
from datetime import datetime, timedelta
import os

class MarketScanner:
    def __init__(self):
        self.scan_results = []
        self.min_ratio = 5.0
        
        # Target sectors (institutional strength)
        self.sector_etfs = {
            'XLF': 'Financial',
            'XLE': 'Energy',
            'XLK': 'Technology',
            'XLV': 'Healthcare',
            'XLY': 'Consumer Discretionary',
            'XLP': 'Consumer Staples',
            'XLI': 'Industrials',
            'XLU': 'Utilities',
            'XLRE': 'Real Estate'
        }
        
        # Major indices
        self.indices = {
            'ES': 'S&P 500',
            'NQ': 'Nasdaq'
        }
    
    def print_header(self):
        print("=" * 70)
        print("MARKET SCAN FOR 5:1 TRADING OPPORTUNITIES")
        print("=" * 70)
        print(f"Scan Time: {datetime.now().isoformat()}")
        print(f"Minimum Risk/Reward: {self.min_ratio}:1")
        print("=" * 70)
        print("")
    
    def print_scan_instructions(self):
        """Guide user through scan process"""
        print("SCAN WORKFLOW:")
        print("")
        print("1. OPEN THINKORSWIM OR TRADINGVIEW")
        print("   - Create custom watchlist")
        print("   - Add sectors listed below")
        print("")
        print("2. CHECK PHASE 1: MARKET INDICES")
        print("   Chart: /ES and /NQ with multi-timeframe analysis")
        print("   Questions:")
        print("   - [ ] /ES direction (Bullish/Bearish)")
        print("   - [ ] /NQ direction (Bullish/Bearish)")
        print("   - [ ] Aligned (both same direction)")
        print("   - [ ] Full Time Frame Continuity (monthly→60min)")
        print("")
        if input("   Continue? (y/n): ").lower() != 'y':
            return False
        
        print("3. CHECK PHASE 2: SECTOR STRENGTH")
        print("   Chart each sector ETF with multi-timeframe")
        print("   Questions:")
        print("   - [ ] Reversal patterns visible (2-1-2, 3-2-2)")
        print("   - [ ] Consolidation/accumulation forming")
        print("   - [ ] Broadening formations setting up")
        print("")
        strong_sectors = input("   Enter strong sectors (comma-separated): ").strip().upper().split(',')
        strong_sectors = [s.strip() for s in strong_sectors]
        
        print("")
        print("4. CHECK PHASE 3: EQUITY HOLDINGS")
        print("   For each strong sector, identify equities with:")
        print("   - [ ] Rob Smith reversal pattern")
        print("   - [ ] Accumulation phase")
        print("   - [ ] Broadening formation target visible")
        print("")
        equity_symbols = input("   Enter candidate symbols (comma-separated): ").strip().upper().split(',')
        equity_symbols = [s.strip() for s in equity_symbols]
        
        return strong_sectors, equity_symbols
    
    def calculate_5to1_targets(self, symbol, current_price, support, resistance):
        """Calculate potential 5:1 setups"""
        
        # Scenario 1: Bullish reversal from support
        # Entry: At support or slightly above
        # Stop: Below support
        # Target: 5x the risk above entry
        
        risk_down = current_price - support
        reward_up = current_price + (risk_down * self.min_ratio)
        
        # Scenario 2: Use resistance as target
        resistance_ratio = resistance - current_price
        if risk_down > 0:
            bullish_ratio = resistance_ratio / risk_down
        else:
            bullish_ratio = 0
        
        return {
            'symbol': symbol,
            'current': current_price,
            'support': support,
            'resistance': resistance,
            'bullish_entry': support,
            'bullish_stop': support * 0.99,  # Slightly below support
            'bullish_target_5to1': reward_up,
            'resistance_as_target': resistance,
            'resistance_ratio': bullish_ratio if bullish_ratio >= self.min_ratio else None
        }
    
    def scan_workflow(self):
        """Interactive scan workflow"""
        self.print_header()
        
        result = self.print_scan_instructions()
        if not result:
            return []
        
        strong_sectors, equity_symbols = result
        
        print("")
        print("=" * 70)
        print("PHASE 4: CONTRACT ANALYSIS")
        print("=" * 70)
        print("")
        
        candidates = []
        
        for symbol in equity_symbols:
            print(f"\nAnalyzing: {symbol}")
            print("-" * 40)
            
            try:
                current = float(input(f"  Current price: ${symbol} "))
                support = float(input(f"  Support level: $"))
                resistance = float(input(f"  Resistance/Target: $"))
                
                analysis = self.calculate_5to1_targets(symbol, current, support, resistance)
                
                print(f"\n  ✅ Analysis for {symbol}:")
                print(f"     Current: ${analysis['current']:.2f}")
                print(f"     Support: ${analysis['support']:.2f}")
                print(f"     Resistance: ${analysis['resistance']:.2f}")
                print(f"     Bullish Entry: ${analysis['bullish_entry']:.2f}")
                print(f"     Bullish Stop: ${analysis['bullish_stop']:.2f}")
                print(f"     5:1 Target: ${analysis['bullish_target_5to1']:.2f}")
                
                if analysis['resistance_ratio'] and analysis['resistance_ratio'] >= self.min_ratio:
                    print(f"     ✅ Resistance as target gives {analysis['resistance_ratio']:.1f}:1")
                    candidates.append(analysis)
                else:
                    print(f"     ⚠️  Need higher resistance for 5:1")
                
            except Exception as e:
                print(f"     Error: {e}")
        
        return candidates
    
    def save_scan_results(self, candidates):
        """Save results to file"""
        if not candidates:
            print("\nNo valid 5:1 candidates found in this scan.")
            return
        
        scan_file = "/home/trading/trading-infra/scan_results.json"
        
        scan_log = {
            "scan_date": datetime.now().isoformat(),
            "candidates": candidates,
            "total_found": len(candidates)
        }
        
        with open(scan_file, 'w') as f:
            json.dump(scan_log, f, indent=2)
        
        print(f"\n✅ Scan results saved to: {scan_file}")
        print(f"\nFound {len(candidates)} candidates meeting 5:1 criteria")
        
        return candidates

if __name__ == "__main__":
    scanner = MarketScanner()
    candidates = scanner.scan_workflow()
    scanner.save_scan_results(candidates)
    
    print("\n" + "=" * 70)
    print("NEXT STEPS:")
    print("=" * 70)
    print("1. Review candidates in scan_results.json")
    print("2. Confirm Rob Smith patterns visually on charts")
    print("3. Verify accumulation phase")
    print("4. Validate Full Time Frame Continuity")
    print("5. Run through alpha_way_strategy.py for final validation")
    print("=" * 70)

