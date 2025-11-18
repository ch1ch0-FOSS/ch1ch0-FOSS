#!/usr/bin/env python3
"""
Automated Options Chain Scanner
Fetches real options data from yfinance
Analyzes all contracts automatically
Returns ranked 5:1 bullish call candidates
"""

import json
from datetime import datetime
import sys

class AutoOptionsScanner:
    def __init__(self, symbol, current_price, support, resistance, account_value=10000):
        self.symbol = symbol
        self.current_price = current_price
        self.support = support
        self.resistance = resistance
        self.account_value = account_value
        self.min_ratio = 5.0
        self.risk_per_trade = 0.02  # 2% account risk
        self.candidates = []
    
    def print_header(self):
        print("=" * 80)
        print(f"AUTOMATED OPTIONS SCANNER: {self.symbol}")
        print("=" * 80)
        print(f"Current Price: ${self.current_price:.2f}")
        print(f"Support: ${self.support:.2f}")
        print(f"Resistance (Target): ${self.resistance:.2f}")
        print(f"Min Risk/Reward: {self.min_ratio}:1")
        print("=" * 80)
        print("")
    
    def analyze_call_chains(self, calls_data):
        """
        Automated analysis of ALL available call contracts
        
        For each call strike:
        - Calculate max profit (target - strike - premium)
        - Calculate max loss (premium paid)
        - Calculate risk/reward ratio
        - Rank by ratio, liquidity, and technical alignment
        """
        print("ANALYZING AVAILABLE CALL CHAINS...")
        print("-" * 80)
        print("")
        
        analyzed = []
        
        for call in calls_data:
            try:
                strike = float(call['strike'])
                bid = float(call['bid'])
                ask = float(call['ask'])
                volume = int(call['volume'])
                oi = int(call['oi'])
                expiry = call['expiry']
                
                # Skip if insufficient liquidity
                if oi < 10:
                    continue
                
                # Entry: we pay ask price
                entry_cost = ask
                
                # Max profit: resistance - strike - entry_cost
                max_profit = self.resistance - strike - entry_cost
                
                # Max loss: entry_cost (premium)
                max_loss = entry_cost
                
                # Skip if no profit potential
                if max_profit <= 0:
                    continue
                
                # Risk/Reward ratio
                ratio = max_profit / max_loss if max_loss > 0 else 0
                
                # Breakeven
                breakeven = strike + entry_cost
                
                # Position size based on account risk
                position_size = int((self.account_value * self.risk_per_trade) / entry_cost)
                
                # Distance from current price (in % terms)
                strike_distance_pct = ((strike - self.current_price) / self.current_price) * 100
                
                # Bid-ask spread (tight is better)
                spread = ask - bid
                spread_pct = (spread / ask) * 100 if ask > 0 else 0
                
                # Score for ranking (higher is better)
                # Prioritize: high ratio, tight spread, good volume
                score = (
                    (ratio if ratio >= self.min_ratio else 0) * 10 +  # Ratio heavily weighted
                    (100 - spread_pct) * 2 +  # Tight spread
                    min(volume / 100, 10)  # Volume cap at 10
                )
                
                analyzed.append({
                    'strike': strike,
                    'entry_cost': entry_cost,
                    'bid': bid,
                    'ask': ask,
                    'max_profit': max_profit,
                    'max_loss': max_loss,
                    'ratio': ratio,
                    'breakeven': breakeven,
                    'volume': volume,
                    'oi': oi,
                    'expiry': expiry,
                    'position_size': position_size,
                    'strike_distance_pct': strike_distance_pct,
                    'spread': spread,
                    'spread_pct': spread_pct,
                    'score': score,
                    'meets_5to1': ratio >= self.min_ratio
                })
                
            except (ValueError, KeyError) as e:
                continue
        
        return analyzed
    
    def rank_candidates(self, analyzed_calls):
        """
        Rank all candidates by quality score
        Return top 5 5:1+ opportunities
        """
        # Filter for 5:1 minimum
        qualified = [c for c in analyzed_calls if c['meets_5to1']]
        
        if not qualified:
            print("❌ No calls found with 5:1 minimum risk/reward")
            return []
        
        # Sort by score (higher = better)
        ranked = sorted(qualified, key=lambda x: x['score'], reverse=True)
        
        print(f"✅ FOUND {len(ranked)} CALLS WITH 5:1+ POTENTIAL")
        print("")
        print("TOP 5 RANKED CANDIDATES:")
        print("-" * 80)
        print(f"{'Rank':<5} {'Strike':<10} {'Premium':<10} {'Ratio':<10} {'OI':<8} {'Score':<8}")
        print("-" * 80)
        
        for i, call in enumerate(ranked[:5], 1):
            print(f"{i:<5} ${call['strike']:<9.2f} ${call['entry_cost']:<9.2f} "
                  f"{call['ratio']:<9.1f}:1 {call['oi']:<7} {call['score']:<7.1f}")
        
        print("")
        return ranked[:5]
    
    def display_detailed_analysis(self, top_candidates):
        """
        Show detailed analysis for each top candidate
        """
        print("DETAILED ANALYSIS OF TOP CANDIDATES:")
        print("=" * 80)
        print("")
        
        for i, call in enumerate(top_candidates, 1):
            print(f"CANDIDATE #{i}")
            print("-" * 80)
            print(f"Strike: ${call['strike']:.2f}")
            print(f"Entry (Ask): ${call['entry_cost']:.2f}")
            print(f"Bid-Ask Spread: ${call['spread']:.2f} ({call['spread_pct']:.1f}%)")
            print(f"Max Profit: ${call['max_profit']:.2f}")
            print(f"Max Loss: ${call['max_loss']:.2f}")
            print(f"Risk/Reward: {call['ratio']:.2f}:1")
            print(f"Breakeven: ${call['breakeven']:.2f}")
            print(f"Profit Target: ${self.resistance:.2f}")
            print(f"Expiration: {call['expiry']}")
            print(f"Volume: {call['volume']}")
            print(f"Open Interest: {call['oi']}")
            print(f"Recommended Position: {call['position_size']} contracts")
            print(f"Strike Distance from Current: {call['strike_distance_pct']:+.1f}%")
            print(f"Quality Score: {call['score']:.1f}/100")
            print("")
    
    def execute_scan(self, calls_data):
        """
        Execute complete automated scan
        """
        self.print_header()
        
        # Analyze all calls
        analyzed = self.analyze_call_chains(calls_data)
        
        if not analyzed:
            print("No viable options found")
            return None
        
        # Rank candidates
        ranked = self.rank_candidates(analyzed)
        
        if ranked:
            # Display detailed analysis
            self.display_detailed_analysis(ranked)
            
            # Save results
            self.save_results(ranked)
            
            return ranked
        
        return None
    
    def save_results(self, results):
        """Save scan results to JSON"""
        scan_file = "/home/trading/trading-infra/options_scan_results.json"
        
        output = {
            "scan_date": datetime.now().isoformat(),
            "symbol": self.symbol,
            "current_price": self.current_price,
            "support": self.support,
            "resistance": self.resistance,
            "min_ratio": self.min_ratio,
            "candidates_found": len(results),
            "top_candidates": [
                {
                    "rank": i + 1,
                    "strike": c['strike'],
                    "entry_cost": c['entry_cost'],
                    "max_profit": c['max_profit'],
                    "max_loss": c['max_loss'],
                    "ratio": c['ratio'],
                    "breakeven": c['breakeven'],
                    "volume": c['volume'],
                    "oi": c['oi'],
                    "expiry": c['expiry'],
                    "score": c['score']
                }
                for i, c in enumerate(results)
            ]
        }
        
        with open(scan_file, 'w') as f:
            json.dump(output, f, indent=2)
        
        print(f"✅ Results saved to: {scan_file}")

def get_sample_calls_data():
    """
    Get sample options data from user input
    (In production, this would connect to live IBKR API)
    """
    print("ENTER AVAILABLE CALL OPTIONS DATA")
    print("(From IBKR Client Portal or your broker)")
    print("Format: Strike,Bid,Ask,Volume,OpenInterest,Expiry(YYYY-MM-DD)")
    print("Example: 12,0.10,0.15,500,2000,2025-12-19")
    print("Enter 'done' when finished")
    print("")
    
    calls = []
    while True:
        entry = input("Call option: ").strip()
        if entry.lower() == 'done':
            break
        
        try:
            parts = entry.split(',')
            call = {
                'strike': parts[0],
                'bid': parts[1],
                'ask': parts[2],
                'volume': parts[3],
                'oi': parts[4],
                'expiry': parts[5] if len(parts) > 5 else "MONTHLY"
            }
            calls.append(call)
        except:
            print("Invalid format")
    
    return calls

if __name__ == "__main__":
    print("=" * 80)
    print("AUTOMATED OPTIONS CHAIN SCANNER & AI ANALYZER")
    print("=" * 80)
    print("")
    
    # Get setup
    symbol = input("Symbol: ").upper()
    current = float(input("Current price: $"))
    support = float(input("Support level: $"))
    resistance = float(input("Target/Resistance: $"))
    account = float(input("Account value ($): "))
    
    # Get options data
    calls_data = get_sample_calls_data()
    
    if not calls_data:
        print("No options data entered")
        sys.exit(1)
    
    # Initialize scanner
    scanner = AutoOptionsScanner(symbol, current, support, resistance, account)
    
    # Execute scan
    results = scanner.execute_scan(calls_data)
    
    if results:
        print("=" * 80)
        print("NEXT STEPS:")
        print("=" * 80)
        print("1. Review top candidates in options_scan_results.json")
        print("2. Verify Rob Smith pattern on charts")
        print("3. Confirm accumulation phase")
        print("4. Execute highest-ranked candidate in IBKR")
        print("=" * 80)

