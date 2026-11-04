#!/usr/bin/env bash
# Fails unless a compiled Dart binary (App.framework/App, libapp.so) targets the environment.
# Usage: scripts/check_binary_env.sh <binary> [prod|dev]
set -euo pipefail

BINARY="${1:?Usage: check_binary_env.sh <binary> [prod|dev]}"
EXPECTED="${2:-prod}"

[[ -f "$BINARY" ]] || { echo "error: binary not found: $BINARY" >&2; exit 1; }
grep -aq "nanimo-env-$EXPECTED" "$BINARY" && exit 0

echo "error: $BINARY does not target $EXPECTED: its --dart-define=ENV disagrees with the bundle id." >&2
exit 1
