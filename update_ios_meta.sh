#!/usr/bin/env bash
# Upload App Store Connect listing metadata (iOS).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/deployment-kit/scripts/upload_ios_metadata.sh" "$@"
