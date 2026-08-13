---
name: analyze-report
description: Builds a multi-timeframe technical analysis and change report for any publicly traded stock — current snapshot, entry-point read across 1-hour/daily/weekly charts, and what's changed since last week/quarter/year. Triggers on "Analyze-Report <ticker or company name>", "check <ticker>", "how does <ticker> look", "<ticker> entry point", or any near-identical request for a single-stock technical read.
---

# Stock Multi-Timeframe Entry & Change Report

## Purpose

Produce a technical-analysis write-up for a single stock: a real-time snapshot,
a multi-timeframe read (1h, daily, weekly) on whether current
conditions look like a reasonable entry, and a summary of what's changed since
last week, last quarter, and last year. This skill produces **informational
technical analysis**, not a trade recommendation — the framing and disclaimers
below are required, not optional.

## Invocation

Accepts a ticker or a company name, e.g. `Analyze-Report AAPL`,
`Analyze-Report Microsoft`. If a company name is given, resolve it to a
ticker first (step 0) rather than guessing.

## Configuration

The 1h timeframe uses Twelve Data instead of the primary market-data tools
(their intraday endpoints are gated on this connector's tier — see Known
limitations). It requires a free Twelve Data API key, stored as
`TWELVE_DATA_API_KEY` in a `.env` file at the plugin root — **never commit
this file** (it's covered by `.gitignore`). Run
`scripts/twelvedata_1h.sh <SYMBOL>` to fetch it; if the key is missing or the
script fails, skip the 1h timeframe, note it as unavailable in the report,
and continue with daily + weekly.

## Language

Write the final output in Vietnamese, regardless of what language the
request was in. Keep ticker symbols, indicator names (RSI, MACD, EMA/SMA),
and numeric price levels in their standard form — translate the surrounding
prose, headers, and explanations into Vietnamese.

## Data source discipline

Prefer the connected market-data tools (Alpha Vantage-backed, plus Twelve
Data for 1h — see Configuration) over web search — they return exact
computed values instead of scraped/approximate ones, and don't have the
reliability problems of pulling numbers out of JS-rendered dashboards.
Request `datatype: "json"` on every Alpha Vantage call (the tools default to
CSV, and JSON is far less error-prone to parse). Use web search/fetch only
for things the data tools don't cover: same-day macro catalysts, sector
context, or when a tool call fails.

This skill analyzes price/volume data and computed indicator values — it
does **not** relay other people's trading opinions, calls, or predictions.
`NEWS_SENTIMENT` returns aggregated sentiment computed from articles, which
is fine to use as a data point; individual traders'/analysts' subjective
takes, forum posts, or "my outlook" commentary are not.

## Workflow

### 0. Resolve the ticker

If the input isn't already an exact ticker, call `SYMBOL_SEARCH` with the
given name as `keywords`. Prefer the best match with `region: United States` and
`type: Equity` unless the user specified a different market. If multiple
plausible matches exist and it's genuinely ambiguous, ask which one instead
of guessing.

### 1. Real-time snapshot

- `GLOBAL_QUOTE` for current price, day's OHLC, volume, and change vs. prior
  close. Try `entitlement: "realtime"` first; if the response indicates
  delayed data, state that plainly in the report rather than presenting it
  as live.
- `COMPANY_OVERVIEW` for lightweight context: sector, industry, market cap.
  One call, used only to frame the report — don't turn this into a
  fundamentals writeup.
- `EARNINGS_CALENDAR` (symbol-scoped, horizon `3month`) — if an earnings
  date falls within the next ~2 weeks, flag it explicitly in the report as
  a factor that can override the technical picture regardless of chart
  setup.

### 2. Per-timeframe technical read

**Daily and weekly** (primary market-data tools):
- Price series: `TIME_SERIES_DAILY` (outputsize `compact` is enough for
  trend/level context — `_ADJUSTED` is gated on this connector) and
  `TIME_SERIES_WEEKLY_ADJUSTED`.
- `RSI` (`time_period: 14`, `series_type: close`) at `daily` and `weekly`.
- `OBV` and `MFI` (`time_period: 14`) at `daily` and `weekly`, for
  volume/money-flow confirmation.
- `MACD` is unreliable on this connector (fails at every interval on the
  current tier) — treat it as best-effort: try it, but don't block the
  report or call out its absence if it fails.

**1h** (Twelve Data — see Configuration):
- Run `scripts/twelvedata_1h.sh <SYMBOL>`, which returns `time_series`,
  `rsi`, `mfi`, and `obv` at `1h` in one call.
- If the script fails (missing key, rate limit, etc.), skip this timeframe
  entirely rather than guessing values — note it as unavailable in the
  final report.

Note per timeframe:
- **Trend**: up/down/sideways, and price relative to recent price structure
  (use SMA/EMA 20 and 50 if you also pull those — optional, don't add calls
  just for this if the price series already makes the trend clear).
- **Key levels**: nearest support/resistance from recent price structure.
- **Momentum**: RSI reading (>70 overbought / <30 oversold as reference,
  not a rule), MACD line vs. signal line.
- **Money flow**: OBV/MFI confirming the move (rising on advances) or
  diverging from it (price up, flow weakening).

### 3. Compare timeframes to find the entry

The goal is to find where a good entry point exists, not to require every
timeframe to agree:
- Evaluate each timeframe's setup independently first — a clean setup on
  one timeframe (e.g. 1h pulling into a well-defended support with
  rising money flow) is a valid finding even if daily/weekly don't show the
  same clarity.
- Then note where timeframes reinforce or conflict (e.g. "good short-term
  1h entry, but daily trend still down — favors a short hold over a
  swing"). Lack of full alignment doesn't by itself disqualify an entry;
  state plainly which timeframe(s) the case is strongest on and why.
- Is price near a key level? Is momentum/money flow confirming or
  diverging? Is there an earnings date or same-day macro catalyst that
  could override the technical picture?

### 4. What's changed since last week / quarter / year

Use `TIME_SERIES_WEEKLY_ADJUSTED` for this — `TIME_SERIES_DAILY_ADJUSTED`
with `outputsize: full` is gated on this connector (confirmed: even plain
`TIME_SERIES_DAILY` at `outputsize: full` fails), while the weekly adjusted
series returns full history and is not gated. Compare current price against
the **adjusted close** ~1 week back, ~13 weeks back (last quarter), and ~52
weeks back (last year):
- % price change over each horizon, computed from **adjusted** close only —
  a stock split between now and the anchor date will silently produce a
  wildly wrong % change (e.g. ~2x off) if raw close is used instead.
- Whether the broader trend/regime changed — compare weekly RSI/MFI at each
  anchor point against current (e.g. "RSI was in overbought territory a
  quarter ago, is neutral now") rather than re-running the full
  per-timeframe breakdown.
- Whether volume trend shifted materially (persistently higher/lower
  average volume than the prior period).
- The response for `TIME_SERIES_WEEKLY_ADJUSTED` is large enough to exceed
  inline token limits — expect a truncated preview pointing to a saved file
  or `return_full_data: true`; extract only the specific anchor-week entries
  needed rather than loading the whole series into context.
- If a horizon isn't available (e.g. a recent IPO with no 1-year history),
  say so rather than omitting it silently.

### 5. Catalysts and context

- `NEWS_SENTIMENT` (`tickers: <symbol>`) for recent company-specific news
  and aggregated sentiment — use as data, not as a source of opinions to
  relay (see Data source discipline).
- Web search only for same-day macro catalysts (Fed, CPI, jobs, sector-wide
  news) not already covered by the above.

### 6. Write the report

Structure:
1. **Snapshot** — current price, today's context, entitlement (real-time vs.
   delayed), sector/market cap, any upcoming earnings date
2. **Per-timeframe breakdown** — 1h, daily, weekly: trend / key
   levels / momentum / money flow
3. **Timeframe comparison** — where the entry case is strongest and why,
   and where timeframes reinforce or conflict
4. **Verdict** — how the setup looks (constructive / mixed / weak) and on
   which timeframe(s), framed as an observation to weigh, not a directive
5. **What's changed** — vs. last week / last quarter / last year
6. **Risks / what would invalidate this** — at least one concrete scenario
   where the setup fails, including earnings/catalyst risk if applicable
7. **Alternative scenario** — the bear/wait case, briefly
8. **Closing note** — not financial advice; confirm live prices/levels
   before acting (delayed data can lag real-time)

## Framing requirements (non-negotiable)

This skill touches financial decision-making. Every output MUST:
- Present findings as factual/technical observations ("price is above the
  50-day average, RSI is at 58") rather than confident directives ("you
  should buy now").
- Give a verdict that describes what the *setup* looks like, not a command
  to buy or not buy.
- Include risks and at least one alternative/bearish scenario, not just the
  bull case.
- Never state a hard price target or position size — levels discussed are
  reference points (support/resistance/moving averages), not instructions.
- Close with a note that this is technical-analysis synthesis for the
  user's own research, not financial advice, and that the user should
  confirm live prices/levels themselves before acting.

## Known limitations

- No native 4-hour bar exists in either connected data source — 1h, daily,
  and weekly are used instead of a synthetic/resampled 4h candle, so
  indicator values stay exact rather than approximated.
- Genuinely real-time data isn't available on any free-tier source checked
  (Alpha Vantage, Finnhub, Twelve Data, Polygon/Massive) — every one of them
  delays US equity quotes by 15 minutes to several hours on their free
  plans. `GLOBAL_QUOTE` returns delayed data on this connector; always
  state that plainly rather than presenting it as live.
- `TIME_SERIES_INTRADAY` and `TIME_SERIES_DAILY_ADJUSTED` are gated on this
  connector's current tier — `TIME_SERIES_DAILY` (unadjusted, compact) is
  used for the daily timeframe instead, and 1h comes from Twelve Data
  entirely (see Configuration).
- `MACD` fails on this connector regardless of interval — treated as
  best-effort, not required for the report.
- Rate limits apply to both data connectors; if a call fails or is
  rate-limited, say so in the relevant section rather than silently
  omitting it or inferring a number.

## Notes on scheduling

This skill runs when invoked in a conversation; it does not run
automatically before market open or on a recurring basis. If the user wants
a recurring check, mention that this requires a scheduling-capable surface
(e.g. Claude Code with a cron trigger) rather than promising it will run on
its own here.
