#!/usr/bin/env bash
# Flutter Android release AAB (delegates to deployment-kit).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/deployment-kit/scripts/build_android.sh" "$@"
