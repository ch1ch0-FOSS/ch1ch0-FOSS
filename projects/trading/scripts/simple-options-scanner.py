#!/usr/bin/env python3
"""
Simple Options Scanner - Guaranteed Working Version
Analyzes options chains for 5:1 opportunities
"""

def main():
    print("=" * 70)
    print("SIMPLE OPTIONS SCANNER")
    print("=" * 70)
    print("")
    
    # Get setup
    symbol = input("Symbol: ").upper()
    current = float(input("Current price: $"))
    support = float(input("Support: $"))
    resistance = float(input("Target: $"))
    
    print("")
    print(f"Analyzing {symbol}")
    print(f"Current: ${current:.2f}, Support: ${support:.2f}, Target: ${resistance:.2f}")
    print("")
    print("Enter call options (Strike,Ask) or 'done':")
    
    calls = []
    while True:
        entry = input("Call: ").strip()
        if entry.lower() == 'done':
            break
        
        try:
            strike, ask = entry.split(',')
            strike = float(strike)
            ask = float(ask)
            
            # Calculate
            max_profit = resistance - strike - ask
            max_loss = ask
            ratio = max_profit / max_loss if max_loss > 0 else 0
            
            print(f"  Strike ${strike:.2f}: Ratio {ratio:.1f}:1", end="")
            
            if ratio >= 5.0:
                print(" ✅")
                calls.append({
                    'strike': strike,
                    'ask': ask,
                    'ratio': ratio,
                    'profit': max_profit,
                    'loss': max_loss
                })
            else:
                print(" ❌")
        except:
            print("  Invalid format")
    
    print("")
    if calls:
        print(f"Found {len(calls)} calls with 5:1+")
        for c in calls:
            print(f"  Strike ${c['strike']:.2f}: ${c['ask']:.2f} premium, {c['ratio']:.1f}:1 ratio")
    else:
        print("No 5:1 calls found")

if __name__ == "__main__":
    main()

