# The Alpha Way Trading Strategy

Multi-Timeframe Reversal Strategy based on Rob Smith's "The Strat" + Institutional Money Flow Analysis

## Core Philosophy

"Broadening formations exist everywhere, where's the next 2?" - @RobInTheBlack

## 7-Phase Trading Process

### Phase 1: Market Index Analysis
- Chart /ES and /NQ with multi-timeframe analysis
- Confirm direction alignment
- Verify Full Time Frame Continuity (FTFC)

### Phase 2: Sector ETF Analysis
- Scan major ETFs (SPY, QQQ, IWM, sector ETFs)
- Identify institutional money flow
- Look for reversal setups (2-1-2, 3-2-2, 2-2, 3-2)

### Phase 3: Equity Selection
- Find holdings in strong sectors
- Match Rob Smith reversal patterns
- Confirm accumulation phase
- Identify broadening formation targets

### Phase 4: Contract Analysis
- Monthly contracts (institutional liquidity)
- Minimum 5:1 risk/reward ratio
- Tight bid-ask spread
- Adequate open interest

### Phase 5: Position Sizing
- Risk 2% per trade
- Calculate shares based on stop loss distance
- One starter position

### Phase 6: Trade Execution
- Complete all 6 phases first
- Mark entry, stop, target on chart
- Execute in IBKR Client Portal
- Log trade immediately

### Phase 7: Trade Management
- Hold from entry to broadening formation target
- Buy time with monthly contracts
- Honor stop loss
- Do not exit early

## Rob Smith's "The Strat" Patterns

### Reversal Patterns
- **2-1-2 Bearish Reversal**: Inside bar followed by down bar (reversal down)
- **2-1-2 Bullish Reversal**: Inside bar followed by up bar (reversal up)
- **3-2-2 Bearish Reversal**: Outside bar, inside bar, down bar
- **3-2-2 Bullish Reversal**: Outside bar, inside bar, up bar
- **2-2 Reversal**: Two inside bars then breakout

### Continuation Patterns
- **2-1-2 Continuation**: Inside bar continues trend
- **2-2 Continuation**: Inside bars in direction of trend

## Risk/Reward Requirements

| Win Rate | Min R:R | Status |
|----------|---------|--------|
| 20% | 5:1 | Profitable |
| 30% | 3:1 | Profitable |
| 40% | 2:1 | Profitable |

**Strategy requires 5:1 minimum (accounts for 20% win rate)**

## Accumulation Phase

Price consolidates after downtrend:
- Volume increases during consolidation
- Support level holds
- Institutional buying accumulates shares
- Breakout follows accumulation

## Multi-Timeframe Analysis

Priority order:
1. Monthly (highest probability)
2. Weekly
3. Daily
4. 4-hour
5. 60-minute

**Trade only when Full Time Frame Continuity exists**

## Trade Checklist

Before every trade:
- [ ] /ES and /NQ aligned
- [ ] Sector showing strength
- [ ] Rob Smith pattern present
- [ ] Accumulation phase confirmed
- [ ] 5:1 risk/reward minimum
- [ ] Monthly contract selected
- [ ] Position sized correctly
- [ ] Broadening formation target marked

## Tools

- TradingView for charting
- IBKR Client Portal for execution
- `alpha_way_strategy.py` for analysis
- `trading_log.json` for record keeping

## Execution

python3 ~/trading-infra/scripts/alpha_way_strategy.py


