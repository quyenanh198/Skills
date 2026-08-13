---
name: spy-entry-analysis
description: Builds a multi-timeframe technical analysis of $SPY (S&P 500 ETF) by comparing the 15-minute, 1-hour, 4-hour, and daily charts to identify whether current conditions look like a good entry point, and explains the reasoning, risks, and alternative scenarios. Use this skill whenever the user asks about SPY entry points, whether it's a good time to buy SPY, SPY chart analysis, pre-market SPY setup, or multi-timeframe technical analysis for SPY — even if they just say "check SPY" or "how does SPY look today." Also trigger for near-identical requests about other single tickers if the user asks for the same kind of multi-timeframe entry analysis.
---

# SPY Multi-Timeframe Entry Analysis

## Purpose

Produce a technical-analysis write-up that helps the user evaluate whether current
conditions on $SPY look favorable for an entry, by comparing four timeframes
(15m, 1h, 4h, 1d) across trend, key levels, and momentum. This skill produces
**informational technical analysis**, not a trade recommendation — the framing
and disclaimers below are required, not optional.

## Language

Write the final output in Vietnamese, regardless of what language the user's
request was in. Keep ticker symbols, indicator names (RSI, MACD, EMA/SMA), and
numeric price levels in their standard form — translate the surrounding
prose, headers, and explanations into Vietnamese. Section headers (Snapshot,
Per-timeframe breakdown, etc.) should also be translated into Vietnamese.

## Source discipline: data over opinions

This skill analyzes price/volume data and computed indicator values — it does
**not** relay other people's trading opinions, calls, or commentary. Concretely:

- Use sources for raw facts: price, OHLC/range, volume, computed indicator
  values (RSI, MACD, moving averages, OBV, MFI, CMF, VWAP), and support/
  resistance levels derived from price structure.
- Do NOT cite or summarize individual traders'/analysts' subjective takes,
  predictions, "my outlook," forum posts, or trade write-ups (e.g. TradingView
  "ideas," Stocktwits posts, blog commentary like "I'm bearish because...").
  If a source is presenting an opinion rather than a data point, skip it even
  if the number inside it looks useful — find the same data point from an
  aggregator/data source instead.
- Aggregated technical-rating scores (e.g. "64% Buy") are borderline — these
  are computed from indicators, not a person's opinion, so they're fine to use
  as one data point, but don't lean on them as the main narrative driver.
- The analysis and verdict should read as Claude's own synthesis of the data,
  not a roundup of what various commentators think.

## Important framing requirement

This skill touches financial decision-making. Every output MUST:
- Present findings as factual/technical observations ("price is above the 50-EMA
  on the 4h, RSI is at 58") rather than confident directives ("you should buy now").
- Give a "verdict" section that describes what the *setup* looks like (e.g.
  "conditions lean constructive for a short-term entry" / "mixed signals, no
  clean setup") rather than a bare command to buy or not buy.
- Include risks and at least one alternative/bearish scenario, not just the
  bull case.
- End with a brief note that this is technical-analysis synthesis for the
  user's own research, not financial advice, and that the user should confirm
  live prices/levels themselves before acting (search results and charts can
  lag real-time price).
- Never state a hard price target or position size. Levels discussed should be
  framed as reference points (support/resistance/moving averages found in
  sources), not instructions.

## Workflow

### 1. Gather current data via web search

Run separate, specific searches — don't try to cover all timeframes in one query.
Favor data/indicator pages (Barchart, Investing.com technicals, StockAnalysis,
AltIndex, TipRanks technicals, ChartMill, exchange/broker quote pages) over
news or commentary sites:
- `SPY price today` — current price/level, OHLC, volume, today's move
- `SPY technical analysis indicators` — RSI, MACD, moving averages (multiple
  timeframes if the source offers a timeframe selector — many data sites let
  you pull 15m/1h/4h/1d/1w indicator readings from one page)
- `SPY volume today` / `SPY OBV` / `SPY money flow index` / `SPY Chaikin money
  flow` — money-flow / volume-flow specific data
- `SPY support resistance levels` — price-structure levels, not narrative
- `SPY news today` — only for macro catalysts (Fed, CPI, jobs, earnings) that
  could override the technical picture that day; not for opinions

Use web_fetch on any promising data page rather than relying on search
snippets alone.

**Known limitation — JS-rendered pages return empty tables.** TradingView's
technicals page (tradingview.com/symbols/.../technicals/) and similar
JavaScript-heavy dashboards load their indicator values via client-side API
calls after the page renders. A direct web_fetch on these pages will show the
indicator table with dashes ("—") instead of numbers — the data isn't
missing, it's just not present in the static HTML. Don't present a "—" table
as if it were a data point, and don't guess numbers to fill it in.

When a fetched page comes back empty like this, fall back to a source that
renders indicator values as static HTML per timeframe, for example:
- Investing.com's technical-analysis page (e.g.
  investing.com/etfs/spdr-s-p-500-technical) — its summary table is rendered
  server-side across horizons (hourly, 5-hour, daily, weekly, monthly) and
  appears directly in fetched/search text.
- Barchart, TipRanks, AltIndex, ChartMill, Intellectia technicals pages — these
  generally render current RSI/MACD/moving-average values as static text too
  (already used in step 1 above for daily figures; check whether they expose
  a timeframe/period selector for shorter horizons as well).

If, after trying at least one static fallback, numeric data for a given
timeframe still isn't available, say so plainly in the output rather than
filling the gap with inference — see "if a timeframe has no data" in step 4.

If the user has pasted their own chart data/levels instead of asking you to
search, use that data directly and skip redundant searches — but still search
for same-day macro catalysts.

### 2. Synthesize per timeframe

For each of 15m / 1h / 4h / 1d, note:
- **Trend**: up/down/sideways, and relative to key moving averages (e.g. 20/50 EMA)
  if available in sources
- **Key levels**: nearest support and resistance from price structure
- **Momentum**: RSI/MACD reading if available (overbought >70, oversold <30 as
  reference, not a rule)
- **Money flow / volume**: is volume confirming the move (rising volume on
  advances, fading volume on pullbacks) or diverging from it (price rising on
  falling volume, etc.)? Use OBV, MFI, CMF, or raw volume trend — whichever is
  available. Volume/money-flow confirmation is weighted as heavily as trend
  and momentum, not as an afterthought.

### 3. Compare timeframes to find the entry

The goal is to find where a good entry point exists, not to require every
timeframe to agree before calling anything "good":
- Look at each timeframe's setup independently first — a clean, well-confirmed
  setup on one timeframe (e.g. 1h pulling into a well-defended support with
  rising money flow) is a valid finding even if the daily or 15m don't show
  the same clarity.
- Then note where timeframes reinforce or conflict with each other — this
  context matters (e.g. "good short-term 1h entry, but daily trend is still
  down, so this favors a scalp over a swing") — but a lack of full alignment
  does not by itself disqualify an entry. State plainly which timeframe(s)
  the entry case is strongest on and why.
- Is price near a key level (support for a long entry, resistance for caution)?
- Is momentum and money flow confirming the trend or diverging from it (e.g.
  price making highs while RSI or volume/OBV weakens)?
- Is there a macro catalyst today (Fed meeting, CPI print, jobs report, earnings)
  that could invalidate the technical picture regardless of chart setup?

### 4. Write the output

Structure (full write-up, per user preference):

1. **Snapshot** — current price, today's context, any major catalyst
2. **Per-timeframe breakdown** — 15m, 1h, 4h, 1d: trend / key levels / momentum
   / money flow (volume, OBV/MFI/CMF)
3. **Timeframe comparison** — where the entry case is strongest and why, and
   where timeframes reinforce or conflict — without requiring full agreement
4. **Verdict** — how the setup looks (constructive / mixed / weak) and on
   which timeframe(s), framed as an observation the user can weigh, not a
   directive
5. **Risks / what would invalidate this** — at least one concrete scenario
   where the setup fails
6. **Alternative scenario** — the bear/wait case, briefly
7. **Closing note** — not financial advice; confirm live levels before acting

Keep citations to sources per the standard citation rules — paraphrase, don't
quote chart commentary verbatim. Per the source-discipline section above,
cite data points, not people's opinions.

**If a timeframe has no data:** after trying TradingView and at least one
static fallback (see step 1), if numeric indicator data for a timeframe is
still unavailable, say so explicitly in that timeframe's section (e.g. "no
reliable numeric data found for the 15m timeframe today") rather than
omitting the gap silently or inferring numbers from adjacent timeframes.

## Notes on scheduling

This skill runs when invoked in a conversation; it does not run automatically
before market open. If the user wants a recurring daily check, mention that
this requires a scheduling-capable surface (e.g. Claude Code with a cron
trigger) rather than promising it will run on its own here.
