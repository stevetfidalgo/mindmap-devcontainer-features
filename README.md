# Mindmap Devcontainer Features

Shared [devcontainer features](https://containers.dev/implementors/features/) for Mindmap platform projects.

Features are published as OCI artifacts to `ghcr.io` via GitHub Actions on every push to `main`.

## Features

### `bao-env`

OpenBao environment variable manager. Installs:

- **`bao-env`** — CLI for managing config/secrets in OpenBao KV stores from a `bao-env.yml` manifest
- **`bao`** — OpenBao CLI (configurable version)
- **`yq`** — YAML processor (configurable version)
- **`jq`** — JSON processor

#### Usage

Add to your project's `.devcontainer/devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/stevetfidalgo/mindmap-devcontainer-features/bao-env:1": {}
    }
}
```

#### Options

| Option | Default | Description |
|--------|---------|-------------|
| `baoVersion` | `2.1.1` | OpenBao CLI version |
| `yqVersion` | `4.52.4` | yq version |

#### Per-project manifest

Each project that uses `bao-env` should have a `bao-env.yml` in its repo root declaring which variables it consumes:

```yaml
project: mindmap
environments: [dev, test, cicd, demo, prod, shared]
config:
  - LOG_LEVEL
  - NEO4J_URI
secret:
  - NEO4J_PASSWORD
  - OPENAI_API_KEY
```

The authoritative superset manifest lives in [mindmap-infra](https://github.com/stevetfidalgo/mindmap-infra/blob/main/bao-env.yml). Per-project manifests are subsets declaring what that service needs.

## Updating `bao-env`

The source of truth for `bao-env` is [`mindmap-infra/bin/bao-env`](https://github.com/stevetfidalgo/mindmap-infra/blob/main/bin/bao-env). To publish an update:

```bash
# In the mindmap-infra devcontainer:
make sync-bao-env                       # copies bin/bao-env → this repo

# Then commit and push in this repo:
cd ~/mindmap-devcontainer-features
git add -A && git commit -m "feat: update bao-env" && git push
```

The push triggers the GitHub Action which re-publishes the feature to `ghcr.io`. Devcontainers pick up the new version on their next rebuild.

> **Note:** `mindmap-infra`'s devcontainer auto-clones this repo to `~/mindmap-devcontainer-features` on creation, and `make sync-bao-env` will also auto-clone if the repo is missing.

## Adding New Features

Create a new directory under `src/` with:

```
src/<feature-name>/
├── devcontainer-feature.json   # Feature metadata and options
├── install.sh                  # Installation script
└── bin/                        # (optional) Scripts to install
```

Then add documentation for the new feature to this README.
