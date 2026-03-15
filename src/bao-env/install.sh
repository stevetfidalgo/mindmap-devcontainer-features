#!/usr/bin/env bash
set -euo pipefail

# Feature options (with defaults from devcontainer-feature.json)
BAO_VERSION="${BAOVERSION:-2.1.1}"
YQ_VERSION="${YQVERSION:-4.52.4}"

ARCH="$(dpkg --print-architecture)"

echo "Installing bao-env feature (bao=${BAO_VERSION}, yq=${YQ_VERSION}, arch=${ARCH})..."

# ---------- Dependencies ----------

# jq — skip if already present
if ! command -v jq &>/dev/null; then
    echo "Installing jq..."
    apt-get update -y && apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*
fi

# yq — skip if already present at the requested version
if ! command -v yq &>/dev/null; then
    echo "Installing yq ${YQ_VERSION}..."
    curl -fsSL "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${ARCH}" \
        -o /usr/local/bin/yq
    chmod +x /usr/local/bin/yq
fi

# bao CLI — skip if already present at the requested version
if ! command -v bao &>/dev/null; then
    echo "Installing OpenBao CLI ${BAO_VERSION}..."
    # Use the official container image to copy the static binary
    TMPDIR="$(mktemp -d)"
    curl -fsSL "https://github.com/openbao/openbao/releases/download/v${BAO_VERSION}/openbao_${BAO_VERSION}_linux_${ARCH}.tar.gz" \
        | tar xz -C "${TMPDIR}"
    mv "${TMPDIR}/bao" /usr/local/bin/bao
    chmod +x /usr/local/bin/bao
    rm -rf "${TMPDIR}"
fi

# ---------- bao-env script ----------

echo "Installing bao-env CLI..."
install -m 0755 "$(dirname "$0")/bin/bao-env" /usr/local/bin/bao-env

echo "bao-env feature installed successfully."
