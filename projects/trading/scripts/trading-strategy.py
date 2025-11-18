#!/usr/bin/env python3
"""
Trading Strategy Module
Document your trading logic here
Execute manually or automate later
"""

class TradingStrategy:
    """Define your trading strategy"""
    
    def __init__(self, account_value):
        self.account_value = account_value
        self.risk_per_trade = 0.02  # Risk 2% per trade
        self.positions = []
    
    def calculate_position_size(self, entry, stop_loss):
        """Calculate position size based on risk"""
        risk_amount = self.account_value * self.risk_per_trade
        price_risk = abs(entry - stop_loss)
        
        if price_risk > 0:
            shares = int(risk_amount / price_risk)
            return shares
        return 0
    
    def identify_buy_signals(self, market_data):
        """
        Define your buy signals here
        market_data: dict with current market prices
        """
        signals = []
        
        # Example: Buy if price breaks above 50-day MA
        # signals.append({
        #     'symbol': 'AAPL',
        #     'entry': 150.00,
        #     'stop_loss': 145.00,
        #     'target': 160.00
        # })
        
        return signals
    
    def identify_sell_signals(self, open_positions):
        """Define your sell signals here"""
        exits = []
        
        # Example: Sell when stop loss hit or target reached
        # for pos in open_positions:
        #     if current_price <= pos['stop_loss']:
        #         exits.append(pos)
        
        return exits
    
    def execute_trade(self, signal):
        """
        Manual execution checklist
        Before executing:
        1. Verify market conditions
        2. Check account balance
        3. Review stop loss logic
        4. Execute trade in portal
        5. Document in trading log
        """
        print(f"Trade Signal: {signal}")
        print("Execute in IBKR portal manually")
        print("Document result in trading_log.json")

# Example usage
if __name__ == "__main__":
    strategy = TradingStrategy(account_value=10000)
    
    # Your market data would go here
    market_data = {}
    
    print("=== Trading Strategy Ready ===")
    print("Modify identify_buy_signals() with your strategy")
    print("Then manually execute signals via IBKR portal")

