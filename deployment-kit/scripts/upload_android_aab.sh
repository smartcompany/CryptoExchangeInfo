#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PLAY_DIR="$KIT_DIR/play-metadata"

cd "$PLAY_DIR"

if [[ -f "$PLAY_DIR/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$PLAY_DIR/.env"
  set +a
fi

APP_CONFIG="$KIT_DIR/app-config.json"
DEFAULT_PACKAGE="$(node -e "const c=require(process.argv[1]); console.log(c.packageName??'');" "$APP_CONFIG" 2>/dev/null || true)"
export PLAY_PACKAGE_NAME="${PLAY_PACKAGE_NAME:-${DEFAULT_PACKAGE:-com.smartcompany.cryptoExchangeInfo}}"
DEFAULT_PLAY_KEY="/Users/smart/Projects/auth/play-publisher/play-publisher-504708-798db1ae50fd.json"
export PLAY_SERVICE_ACCOUNT_JSON="${PLAY_SERVICE_ACCOUNT_JSON:-$DEFAULT_PLAY_KEY}"
# Production track. Override with PLAY_UPLOAD_TRACK or --track (internal | alpha | beta | production).
export PLAY_UPLOAD_TRACK="${PLAY_UPLOAD_TRACK:-production}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --package-name)
      export PLAY_PACKAGE_NAME="$2"
      shift 2
      ;;
    --track)
      export PLAY_UPLOAD_TRACK="$2"
      shift 2
      ;;
    --help|-h)
      exec node "$PLAY_DIR/upload-aab.mjs" --help
      ;;
    *)
      break
      ;;
  esac
done

if [[ ! -d "$PLAY_DIR/node_modules/googleapis" ]]; then
  echo "Installing dependencies (googleapis)…"
  npm install --no-fund --no-audit
fi

if [[ -z "${PLAY_SERVICE_ACCOUNT_JSON:-}" ]]; then
  echo "PLAY_SERVICE_ACCOUNT_JSON is required."
  exit 1
fi

echo "Package: $PLAY_PACKAGE_NAME"
echo "Track:   $PLAY_UPLOAD_TRACK"
echo "Key:     $PLAY_SERVICE_ACCOUNT_JSON"
echo

exec node "$PLAY_DIR/upload-aab.mjs" --track "$PLAY_UPLOAD_TRACK" "$@"
