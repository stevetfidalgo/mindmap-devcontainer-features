#!/usr/bin/env bash
# Devcontainer feature test — verifies bao-env and its dependencies are installed.
set -euo pipefail

echo "Testing bao-env feature..."

# Check that all binaries are on PATH
check() {
    if command -v "$1" &>/dev/null; then
        echo "  PASS: $1 found at $(command -v "$1")"
    else
        echo "  FAIL: $1 not found"
        exit 1
    fi
}

check bao-env
check bao
check yq
check jq

# Verify bao-env runs (prints usage)
if bao-env --help 2>&1 | grep -q "Usage"; then
    echo "  PASS: bao-env --help works"
else
    echo "  FAIL: bao-env --help did not print usage"
    exit 1
fi

echo "All tests passed."
