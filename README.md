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

#### Installation

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

#### Setting up a new project

1. Install the feature (see above) and rebuild your devcontainer.

2. Bootstrap a `bao-env.yml` manifest from the master:

   ```bash
   # Interactive — pick which variables your project needs:
   bao-env init https://raw.githubusercontent.com/stevetfidalgo/mindmap-infra/main/bao-env.yml

   # Or take everything:
   bao-env init --all https://raw.githubusercontent.com/stevetfidalgo/mindmap-infra/main/bao-env.yml
   ```

   This creates a `bao-env.yml` in your repo root with a `master:` field, your selected
   config/secret vars, and the shared project settings (environments, sparse).

3. Commit `bao-env.yml` to your repo.

4. After initial setup, you can add more variables later:

   ```bash
   # Shows only vars available in master but not yet in your manifest:
   bao-env init
   ```

#### Auditing against the master

Validate your project's manifest against the master to catch drift:

```bash
bao-env audit
```

Reports:
- **Errors** (exit code 1): variables not in master, config/secret type mismatches
- **Available**: master variables not claimed by your project (informational)

#### Per-project manifest

Each project has a `bao-env.yml` in its repo root declaring which variables it consumes:

```yaml
master: https://raw.githubusercontent.com/stevetfidalgo/mindmap-infra/main/bao-env.yml
project: mindmap
environments: [dev, test, cicd, demo, prod, shared]
sparse: [shared, prod]
config:
  - LOG_LEVEL
  - NEO4J_URI
secret:
  - NEO4J_PASSWORD
  - OPENAI_API_KEY
```

The `master:` field points to the authoritative superset manifest in
[mindmap-infra](https://github.com/stevetfidalgo/mindmap-infra/blob/main/bao-env.yml).
Per-project manifests are subsets declaring what that service needs.

#### All subcommands

| Command | Description |
|---------|-------------|
| `bao-env show <env>` | Show all variables for an environment |
| `bao-env check` | Drift detection across all environments |
| `bao-env compare VAR[,VAR...]` | Cross-environment table for variables |
| `bao-env sync` | Interactive gap-filler for missing values |
| `bao-env set <env> KEY=VAL[,...]` | Set values in an environment |
| `bao-env copy <from> <to> KEY[,...]` | Copy specific keys between environments |
| `bao-env copy <from> <to> --all` | Copy all keys between environments |
| `bao-env delete <env> KEY[,...]` | Delete specific keys from an environment |
| `bao-env delete <env> --all` | Delete all data for an environment |
| `bao-env clear <env> KEY[,...]` | Clear values (set to "") for specific keys |
| `bao-env clear <env> --all` | Clear all values for an environment |
| `bao-env init [--all] [URL\|PATH]` | Initialize/update local manifest from master |
| `bao-env audit` | Compare local manifest against master |

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
