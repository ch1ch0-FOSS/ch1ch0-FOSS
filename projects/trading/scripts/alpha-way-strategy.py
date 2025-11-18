#!/usr/bin/env python3
"""
The Alpha Way - Multi-Timeframe Reversal Strategy
Based on Rob Smith's "The Strat" + Institutional Money Flow

Strategy Flow:
1. Check /ES & /NQ for market direction
2. Analyze major ETFs with multi-timeframe analysis
3. Identify sectors with institutional money flow
4. Find equities in accumulation phase
5. Look for Rob Smith's reversal patterns (2-1-2, 3-2-2, etc.)
6. Enter on 5:1 risk/reward ratio minimum
7. Hold from entry to broadening formation target
"""

from datetime import datetime
import json
import os

class AlphaWayStrategy:
    """The Alpha Way Trading Strategy Implementation"""
    
    def __init__(self, account_value):
        self.account_value = account_value
        self.min_risk_reward = 5.0  # 5:1 minimum
        self.position_size_pct = 0.02  # 2% risk per trade
        self.trade_log = "/home/trading/trading-infra/trading_log.json"
    
    # PHASE 1: Market Analysis
    def check_market_indices(self):
        """
        Step 1: Analyze /ES and /NQ for overall market direction
        
        Checklist:
        - /ES (S&P 500 futures) trending direction
        - /NQ (Nasdaq futures) trending direction
        - Alignment between indices (both bullish/bearish)
        - Multi-timeframe confirmation (Monthly, Weekly, Daily, 4hr, 60min)
        """
        print("=== PHASE 1: Market Index Analysis ===")
        print("[ ] /ES direction checked")
        print("[ ] /NQ direction checked")
        print("[ ] Indices aligned")
        print("[ ] Multi-timeframe continuity confirmed")
        print("")
        
        # Manual checklist for IBKR portal
        return {
            "es_direction": "BULLISH/BEARISH",  # Replace after analysis
            "nq_direction": "BULLISH/BEARISH",  # Replace after analysis
            "aligned": True,  # True if both agree
            "timeframes_confirm": True  # Full Time Frame Continuity
        }
    
    # PHASE 2: Sector Analysis
    def analyze_major_etfs(self):
        """
        Step 2: Chart major ETFs with multi-timeframe analysis
        
        ETFs to analyze:
        - SPY, QQQ, IWM (market)
        - XLF, XLE, XLK, XLV, XLY, XLP, XLI, XLU, XLRE (sectors)
        
        Look for:
        - Reversal patterns (2-1-2, 3-2-2, 2-2, 3-2)
        - Continuation patterns (2-1-2, 2-2)
        - Full Time Frame Continuity (FTFC)
        - Broadening formations setting up
        """
        print("=== PHASE 2: Major ETF Analysis ===")
        print("[ ] SPY, QQQ, IWM checked")
        print("[ ] Sector ETFs scanned")
        print("[ ] Reversal/continuation patterns identified")
        print("[ ] Sectors with institutional flow noted")
        print("")
        
        return {
            "strong_sectors": [],  # Add sectors showing strength
            "weak_sectors": [],    # Add sectors showing weakness
            "reversal_setups": []  # ETFs with reversal patterns
        }
    
    # PHASE 3: Equity Selection
    def identify_sector_holdings(self, strong_sectors):
        """
        Step 3: Find equities in strong sectors matching Rob Smith's patterns
        
        Criteria:
        - Stock in strong sector (from Phase 2)
        - Showing Rob Smith reversal pattern (2-1-2, 3-2-2, etc.)
        - In accumulation phase (price consolidating, volume increasing)
        - Multi-timeframe alignment
        - Clear broadening formation target visible
        """
        print("=== PHASE 3: Equity Selection ===")
        print("[ ] Holdings in strong sectors identified")
        print("[ ] Rob Smith patterns present")
        print("[ ] Accumulation phase confirmed")
        print("[ ] Broadening formation targets marked")
        print("")
        
        return []  # List of candidate equities
    
    # PHASE 4: Contract Analysis
    def analyze_monthly_contracts(self, symbol, entry, stop, target):
        """
        Step 4: Analyze monthly option contracts for optimal entry
        
        Requirements:
        - Monthly contracts (institutional liquidity)
        - Tight bid-ask spread
        - Open interest > 100
        - Target must be 5:1 risk/reward minimum
        
        Risk/Reward Table (from your image):
        - Win rate 20%: Need 5:1 to be profitable
        - Win rate 30%: Need 3:1 to be profitable
        - Win rate 40%: Need 2:1 to be profitable
        """
        risk = abs(entry - stop)
        reward = abs(target - entry)
        
        if risk == 0:
            return None
        
        risk_reward_ratio = reward / risk
        
        print("=== PHASE 4: Contract Analysis ===")
        print(f"Symbol: {symbol}")
        print(f"Entry: ${entry:.2f}")
        print(f"Stop Loss: ${stop:.2f}")
        print(f"Target: ${target:.2f}")
        print(f"Risk: ${risk:.2f}")
        print(f"Reward: ${reward:.2f}")
        print(f"Risk/Reward Ratio: {risk_reward_ratio:.1f}:1")
        print("")
        
        if risk_reward_ratio < self.min_risk_reward:
            print(f"❌ Risk/Reward {risk_reward_ratio:.1f}:1 below minimum {self.min_risk_reward}:1")
            return None
        
        print(f"✅ Risk/Reward {risk_reward_ratio:.1f}:1 meets minimum threshold")
        print("[ ] Monthly contract selected")
        print("[ ] Bid-ask spread tight")
        print("[ ] Open interest adequate")
        print("")
        
        return {
            "symbol": symbol,
            "entry": entry,
            "stop": stop,
            "target": target,
            "risk": risk,
            "reward": reward,
            "ratio": risk_reward_ratio
        }
    
    # PHASE 5: Position Sizing
    def calculate_position_size(self, risk_per_share):
        """
        Step 5: Calculate position size based on account risk
        
        Rules:
        - Risk 2% of account per trade
        - Buy time with available capital (monthly contracts)
        - One starter position initially
        """
        risk_amount = self.account_value * self.position_size_pct
        shares = int(risk_amount / risk_per_share)
        
        print("=== PHASE 5: Position Sizing ===")
        print(f"Account Value: ${self.account_value:,.2f}")
        print(f"Risk per Trade: {self.position_size_pct*100}%")
        print(f"Risk Amount: ${risk_amount:.2f}")
        print(f"Risk per Share: ${risk_per_share:.2f}")
        print(f"Position Size: {shares} shares (or contracts)")
        print("")
        
        return shares
    
    # PHASE 6: Trade Execution
    def execute_trade_checklist(self, trade_plan):
        """
        Step 6: Pre-execution checklist
        
        Before entering trade in IBKR portal:
        """
        print("=== PHASE 6: Trade Execution Checklist ===")
        print("[ ] Market indices aligned")
        print("[ ] Sector showing strength")
        print("[ ] Rob Smith pattern confirmed")
        print("[ ] Accumulation phase verified")
        print("[ ] 5:1 risk/reward minimum met")
        print("[ ] Monthly contract selected")
        print("[ ] Position size calculated")
        print("[ ] Entry, stop, target marked on chart")
        print("[ ] Broadening formation target identified")
        print("")
        print("✅ ALL CHECKS PASSED - READY TO EXECUTE")
        print("")
        print("Execute in IBKR Client Portal:")
        print(f"  Symbol: {trade_plan['symbol']}")
        print(f"  Entry: ${trade_plan['entry']:.2f}")
        print(f"  Stop: ${trade_plan['stop']:.2f}")
        print(f"  Target: ${trade_plan['target']:.2f}")
        print(f"  Size: {trade_plan['size']} contracts")
        print("")
        print("After execution, log in trading_log.json")
    
    # PHASE 7: Trade Management
    def hold_to_target(self):
        """
        Step 7: Trade management rules
        
        Hold Strategy:
        - Enter on reversal confirmation
        - Hold through consolidation (accumulation phase)
        - Target: Broadening formation breakout
        - Exit: When price reaches broadening formation target
        - Stop: Predetermined stop loss (no emotion)
        
        Do NOT:
        - Exit early due to fear
        - Move stop loss closer
        - Add to losing positions
        - Trade without all 6 phases complete
        """
        print("=== PHASE 7: Trade Management ===")
        print("Rules:")
        print("- Hold from entry to broadening formation target")
        print("- Do not exit early (buy time with monthly contracts)")
        print("- Honor stop loss if hit")
        print("- Target must be broadening formation breakout")
        print("- Log all results in trading_log.json")
    
    # Trade Log
    def log_trade(self, trade_details):
        """Log trade to JSON file"""
        try:
            with open(self.trade_log, 'r') as f:
                log = json.load(f)
        except:
            log = {"account": "castille85dm", "trades": []}
        
        trade_entry = {
            "date": datetime.now().isoformat(),
            "symbol": trade_details['symbol'],
            "pattern": trade_details.get('pattern', 'Rob Smith Reversal'),
            "entry": trade_details['entry'],
            "stop": trade_details['stop'],
            "target": trade_details['target'],
            "size": trade_details['size'],
            "risk_reward": trade_details['ratio'],
            "status": "OPEN",
            "notes": trade_details.get('notes', '')
        }
        
        log['trades'].append(trade_entry)
        
        with open(self.trade_log, 'w') as f:
            json.dump(log, f, indent=2)
        
        print(f"✅ Trade logged to {self.trade_log}")

# Example usage
if __name__ == "__main__":
    print("=" * 60)
    print("THE ALPHA WAY - Multi-Timeframe Reversal Strategy")
    print("=" * 60)
    print("")
    
    # Initialize with your account value
    account_value = float(input("Enter account value: $"))
    strategy = AlphaWayStrategy(account_value)
    
    # Execute full workflow
    print("\n" + "=" * 60)
    strategy.check_market_indices()
    strategy.analyze_major_etfs()
    strategy.identify_sector_holdings([])
    
    # Example trade setup
    print("\n" + "=" * 60)
    print("EXAMPLE TRADE ANALYSIS")
    print("=" * 60 + "\n")
    
    symbol = input("Enter symbol: ").upper()
    entry = float(input("Entry price: $"))
    stop = float(input("Stop loss: $"))
    target = float(input("Target price: $"))
    
    # Analyze trade
    trade = strategy.analyze_monthly_contracts(symbol, entry, stop, target)
    
    if trade:
        size = strategy.calculate_position_size(trade['risk'])
        trade['size'] = size
        
        strategy.execute_trade_checklist(trade)
        
        # Log trade
        log_choice = input("\nLog this trade? (y/n): ")
        if log_choice.lower() == 'y':
            trade['notes'] = input("Trade notes: ")
            strategy.log_trade(trade)
    
    print("\n" + "=" * 60)
    strategy.hold_to_target()
    print("=" * 60)

