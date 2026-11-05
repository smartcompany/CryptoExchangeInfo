#!/usr/bin/env bash
# Flutter iOS release build (delegates to deployment-kit).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/deployment-kit/scripts/build_ios.sh" "$@"
