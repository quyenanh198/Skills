#!/usr/bin/env bash
# Fetches 1h price series + RSI/MFI/OBV for a symbol from Twelve Data.
# Reads TWELVE_DATA_API_KEY from a .env file at the plugin root (never committed —
# see .gitignore). If the key is missing, prints an error to stderr and exits
# non-zero so the caller can skip the 1h timeframe rather than fail the whole report.
set -euo pipefail

SYMBOL="${1:?Usage: twelvedata_1h.sh SYMBOL}"
ENV_FILE="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}/.env"

if [ ! -f "$ENV_FILE" ] || ! grep -q '^TWELVE_DATA_API_KEY=' "$ENV_FILE"; then
  echo "TWELVE_DATA_API_KEY not found in $ENV_FILE — 1h timeframe unavailable, skipping." >&2
  exit 1
fi

TWELVE_DATA_API_KEY="$(grep '^TWELVE_DATA_API_KEY=' "$ENV_FILE" | head -1 | cut -d= -f2-)"
BASE="https://api.twelvedata.com"
OUTPUTSIZE="${2:-30}"

for endpoint in time_series rsi mfi obv; do
  case "$endpoint" in
    time_series) extra="" ;;
    rsi) extra="&time_period=14&series_type=close" ;;
    mfi) extra="&time_period=14" ;;
    obv) extra="" ;;
  esac
  echo "=== $endpoint ==="
  curl -s "${BASE}/${endpoint}?symbol=${SYMBOL}&interval=1h&outputsize=${OUTPUTSIZE}${extra}&apikey=${TWELVE_DATA_API_KEY}"
  echo ""
done
