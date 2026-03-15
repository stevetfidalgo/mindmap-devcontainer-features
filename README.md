# Mindmap Devcontainer Features

Shared [devcontainer features](https://containers.dev/implementors/features/) for Mindmap platform projects.

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

## Adding New Features

Create a new directory under `src/` with:

```
src/<feature-name>/
├── devcontainer-feature.json   # Feature metadata and options
├── install.sh                  # Installation script
└── bin/                        # (optional) Scripts to install
```

## Publishing

Features are published as OCI artifacts to `ghcr.io` via GitHub Actions on push to `main`.
