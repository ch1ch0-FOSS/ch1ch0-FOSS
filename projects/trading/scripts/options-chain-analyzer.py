#!/usr/bin/env python3
"""
Options Chain Analyzer for Bullish Call Plays
Finds directional call options with 5:1 profit potential

Strategy:
- Bullish directional call spreads or naked calls
- Monthly contracts (institutional liquidity)
- Identify strike prices with 5:1 reward/risk
- Calculate breakeven and max profit
"""

import json
from datetime import datetime

class OptionsAnalyzer:
    def __init__(self, symbol, current_price, support, resistance):
        self.symbol = symbol
        self.current_price = current_price
        self.support = support
        self.resistance = resistance
        self.min_ratio = 5.0
        self.candidates = []
    
    def print_header(self):
        print("=" * 70)
        print(f"OPTIONS CHAIN ANALYZER: {self.symbol}")
        print("=" * 70)
        print(f"Current Price: ${self.current_price:.2f}")
        print(f"Support: ${self.support:.2f}")
        print(f"Resistance: ${self.resistance:.2f}")
        print(f"Min Risk/Reward: {self.min_ratio}:1")
        print("=" * 70)
        print("")
    
    def get_monthly_call_chains(self):
        """
        Guide user to input monthly call chain data from IBKR
        
        Monthly contracts are preferred because:
        - Institutional liquidity (wide bid-ask spreads)
        - Time decay works slower (better for holding)
        - Less whipsawed by daily noise
        """
        print("STEP 1: MONTHLY CALL CHAINS")
        print("-" * 70)
        print("")
        print("In IBKR Client Portal:")
        print("1. Search for: {symbol} 100 (e.g., VALE 100)")
        print("2. Select next MONTHLY expiration (avoid weeklies)")
        print("3. View CALL options chain")
        print("4. Note strike prices and bid/ask prices")
        print("")
        print("Input call chain data (enter 'done' to finish):")
        print("Format: Strike,Bid,Ask,Volume,OpenInterest")
        print("")
        
        calls = []
        while True:
            entry = input("Enter call option: ").strip()
            if entry.lower() == 'done':
                break
            
            try:
                parts = entry.split(',')
                call = {
                    'strike': float(parts[0]),
                    'bid': float(parts[1]),
                    'ask': float(parts[2]),
                    'volume': int(parts[3]) if len(parts) > 3 else 0,
                    'oi': int(parts[4]) if len(parts) > 4 else 0,
                }
                calls.append(call)
                print(f"  ✅ Added: Strike ${call['strike']:.2f}, Bid ${call['bid']:.2f}, Ask ${call['ask']:.2f}")
            except:
                print("  ❌ Invalid format. Use: Strike,Bid,Ask,Volume,OI")
        
        return calls
    
    def analyze_bullish_calls(self, calls):
        """
        Analyze each call for 5:1 risk/reward potential
        
        Bullish Call Strategy:
        - Buy call at strike below/near resistance
        - Entry cost: Ask price
        - Max profit: Resistance - Strike - Entry cost
        - Max loss: Entry cost (premium paid)
        - Risk/Reward: Max Profit / Max Loss
        """
        print("")
        print("STEP 2: BULLISH CALL ANALYSIS")
        print("-" * 70)
        print("")
        
        valid_plays = []
        
        for call in calls:
            strike = call['strike']
            bid = call['bid']
            ask = call['ask']
            volume = call['volume']
            oi = call['oi']
            
            # Skip if insufficient liquidity
            if oi < 10:
                continue
            
            # Entry cost: we pay the ask
            entry_cost = ask
            
            # For bullish call: max profit = resistance - strike - entry_cost
            max_profit = self.resistance - strike - entry_cost
            
            # Max loss = what we paid (entry_cost)
            max_loss = entry_cost
            
            # Risk/Reward ratio
            if max_loss > 0:
                ratio = max_profit / max_loss
            else:
                ratio = 0
            
            # Breakeven = strike + entry_cost
            breakeven = strike + entry_cost
            
            # Profit target (5:1 ratio)
            profit_at_5to1 = entry_cost * self.min_ratio
            
            print(f"Strike ${strike:.2f}:")
            print(f"  Entry (Ask): ${ask:.2f}")
            print(f"  Max Loss: ${max_loss:.2f}")
            print(f"  Max Profit (at ${self.resistance:.2f}): ${max_profit:.2f}")
            print(f"  Breakeven: ${breakeven:.2f}")
            print(f"  Risk/Reward: {ratio:.2f}:1")
            print(f"  Liquidity: {volume} vol, {oi} OI")
            
            if ratio >= self.min_ratio:
                print(f"  ✅ MEETS 5:1 CRITERIA")
                valid_plays.append({
                    'strike': strike,
                    'entry_cost': entry_cost,
                    'max_profit': max_profit,
                    'max_loss': max_loss,
                    'ratio': ratio,
                    'breakeven': breakeven,
                    'volume': volume,
                    'oi': oi
                })
            else:
                print(f"  ⚠️  Ratio {ratio:.2f}:1 below {self.min_ratio}:1 minimum")
            
            print("")
        
        return valid_plays
    
    def validate_setup(self, call_play):
        """
        Pre-execution checklist for selected call
        """
        print("STEP 3: PRE-EXECUTION CHECKLIST")
        print("-" * 70)
        print("")
        print("Before executing this call trade:")
        print("")
        print(f"[ ] Symbol: {self.symbol}")
        print(f"[ ] Strike: ${call_play['strike']:.2f}")
        print(f"[ ] Entry: ${call_play['entry_cost']:.2f} (ask price)")
        print(f"[ ] Max Profit: ${call_play['max_profit']:.2f} (at ${self.resistance:.2f})")
        print(f"[ ] Max Loss: ${call_play['max_loss']:.2f} (premium paid)")
        print(f"[ ] Risk/Reward: {call_play['ratio']:.2f}:1")
        print(f"[ ] Breakeven: ${call_play['breakeven']:.2f}")
        print(f"[ ] Expiration: MONTHLY (not weekly)")
        print(f"[ ] Liquidity: {call_play['volume']} volume, {call_play['oi']} open interest")
        print("")
        print("Questions to confirm:")
        print("[ ] Rob Smith reversal pattern confirmed on chart")
        print("[ ] Accumulation phase visible")
        print("[ ] Full Time Frame Continuity verified")
        print("[ ] Strike price aligns with technical levels")
        print("[ ] Volume adequate (min 10 OI, preferably 100+)")
        print("[ ] Bid-ask spread tight (< 5% of premium)")
        print("")
    
    def log_options_trade(self, symbol, call_play, expiration):
        """Log options trade to JSON"""
        trade_log = "/home/trading/trading-infra/trading_log.json"
        
        try:
            with open(trade_log, 'r') as f:
                log = json.load(f)
        except:
            log = {"account": "castille85dm", "trades": []}
        
        trade_entry = {
            "date": datetime.now().isoformat(),
            "type": "CALL_OPTION",
            "symbol": symbol,
            "strike": call_play['strike'],
            "expiration": expiration,
            "entry": call_play['entry_cost'],
            "max_profit": call_play['max_profit'],
            "max_loss": call_play['max_loss'],
            "risk_reward": call_play['ratio'],
            "breakeven": call_play['breakeven'],
            "status": "PENDING",
            "notes": "Bullish directional call play"
        }
        
        log['trades'].append(trade_entry)
        
        with open(trade_log, 'w') as f:
            json.dump(log, f, indent=2)
        
        print(f"✅ Options trade logged to {trade_log}")

if __name__ == "__main__":
    print("=" * 70)
    print("BULLISH CALL OPTIONS ANALYZER")
    print("=" * 70)
    print("")
    
    # Get setup details
    symbol = input("Symbol: ").upper()
    current = float(input("Current price: $"))
    support = float(input("Support level: $"))
    resistance = float(input("Resistance/Target: $"))
    expiration = input("Expiration month (e.g., DEC, JAN): ").upper()
    
    # Initialize analyzer
    analyzer = OptionsAnalyzer(symbol, current, support, resistance)
    analyzer.print_header()
    
    # Get monthly call chains from user
    calls = analyzer.get_monthly_call_chains()
    
    if not calls:
        print("No calls entered. Exiting.")
        exit(1)
    
    # Analyze calls
    valid_plays = analyzer.analyze_bullish_calls(calls)
    
    if valid_plays:
        print("")
        print("=" * 70)
        print(f"FOUND {len(valid_plays)} CALL OPTIONS WITH 5:1 POTENTIAL")
        print("=" * 70)
        print("")
        
        # Select best play
        print("Select call to analyze further (1-{}): ".format(len(valid_plays)), end="")
        selection = int(input()) - 1
        
        if 0 <= selection < len(valid_plays):
            selected = valid_plays[selection]
            analyzer.validate_setup(selected)
            
            # Log if confirmed
            if input("\nLog this trade? (y/n): ").lower() == 'y':
                analyzer.log_options_trade(symbol, selected, expiration)
    else:
        print("")
        print("❌ No calls found with 5:1 risk/reward")
        print("Try lower strikes (closer to support) for better ratios")

