#!/usr/bin/env bash
# Upload Google Play listing metadata (Android).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/deployment-kit/scripts/upload_android_metadata.sh" "$@"
