# Custom Profile

My custom zsh profile. The `profile` file in this repo is the source of truth — sync it to `~/.zshrc` on any new machine.

## New machine setup

### 1. Clone the repo

```zsh
mkdir -p ~/git && git clone <repo-url> ~/git/custom-profile
```

### 2. Install required tools

These tools are used by aliases/functions in the profile:

| Tool | Purpose | Install |
|------|---------|---------|
| [Homebrew](https://brew.sh) | Package manager (install this first) | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` |
| [Claude Code](https://claude.ai/claude-code) | AI coding CLI (`cc`, `ccd` aliases) | `npm install -g @anthropic-ai/claude-code` |
| [Codex](https://github.com/openai/codex) | OpenAI coding CLI (`cx`, `cxd` aliases) | `npm install -g @openai/codex` |
| [bun](https://bun.sh) | JS runtime used for `ccusage-*` aliases | `npm install -g bun` |
| ffmpeg | Video utilities (`play`, `burn-subs`, `mux`) | `brew install ffmpeg` |
| speedtest-cli | `speedt` alias | `brew install speedtest-cli` |
| IntelliJ IDEA CE | `ij` alias | Install from jetbrains.com or via cask |
| Cursor | `cursor` / `cursorme` aliases | Install from cursor.com |
| Docker | Docker aliases | Install Docker Desktop |
| kubectl | `k*` aliases | `brew install kubectl` |
| terraform | `tp`, `tir` aliases | `brew install terraform` |

Optional but used in PATH setup:
- Java 21 (`brew install --cask temurin@21` or download from Adoptium)
- Maven (`brew install maven` or place binary at `~/.local/apache-maven-3.9.6/`)
- npm global bin dir: run `npm config set prefix ~/.npm-global` then add to PATH
- opencode: install separately; binary expected at `~/.opencode/bin/`

### 3. Sync the profile

Copy (or symlink) the profile file to `~/.zshrc`:

```zsh
# Option A: copy
cp ~/git/custom-profile/profile ~/.zshrc

# Option B: symlink (changes to the file are reflected immediately)
ln -sf ~/git/custom-profile/profile ~/.zshrc
```

Then source it:

```zsh
source ~/.zshrc
```

## Keeping things in sync

When you update your profile on one machine, commit the change to this repo, then on other machines:

```zsh
cd ~/git/custom-profile && git pull
```

If you used the copy approach in step 3, re-run the `cp` command. If you symlinked, the pull is sufficient.

To edit the profile, use one of these aliases (once the profile is loaded):

| Alias | Action |
|-------|--------|
| `editme` | Open in vim |
| `codeme` | Open in VS Code |
| `cursorme` | Open in Cursor |
| `sourceme` | Re-source `~/.zshrc` |

## Alias/function reference

### Claude & Codex

| Command | Description |
|---------|-------------|
| `cc` | Launch Claude Code with experimental agent teams |
| `ccd` | Launch Claude Code with all permissions skipped |
| `cx` | Launch Codex with common dirs added (cache, gh, aws, kube, git worktree) |
| `cxd` | Launch Codex in full-access/no-approval mode |
| `ccusage-codex` | Run ccusage for Codex via bunx |
| `ccusage-opencode` | Run ccusage for opencode via bunx |

### Git

| Command | Description |
|---------|-------------|
| `gs` | `git status` |
| `gd` | `git diff` |
| `ga` | `git add .` |
| `gap` | `git add -p` (interactive patch) |
| `gcm` | `git commit -m` |
| `gca` | `git commit --amend` (opens editor) |
| `gcane` | `git commit --amend --no-edit` |
| `gcaa` | `git commit --amend --no-edit --allow-empty` |
| `gp` | `git pull` |
| `gpoh` | `git push -u origin HEAD` |
| `gpohf` | `git push origin HEAD --force-with-lease` |
| `gl` | `git log --oneline` |
| `grh` | `git reset --soft HEAD^` |
| `grs` | `git restore --staged` |
| `gsu` | `git stash -u` |
| `gsp` | `git stash pop` |
| `gcb` | `git checkout -b` |
| `gc <branch>` | `git checkout <branch>` |
| `gcom` | Checkout main branch |
| `gpom` | Pull from origin main |
| `grb` | Rebase onto main |
| `squash <n>` | Interactive rebase last N commits |
| `openpr` | Open GitHub compare/PR page in browser |

### Git worktrees

| Command | Description |
|---------|-------------|
| `gwt <branch>` | Create a worktree at `~/git/{repo}-{branch}-{suffix}`, cd into it |
| `gwt -c <branch>` | Same, but also opens Cursor in the new worktree |
| `gwtr` | Remove current worktree, close its Cursor window, return to main |

To symlink files into new worktrees automatically (e.g. `.env`), add filenames to `.git/worktree-link-files` in the main repo:
```zsh
echo ".env" >> .git/worktree-link-files
```

### Kubectl

| Command | Description |
|---------|-------------|
| `kgp` | `kubectl get pods` |
| `kgpw` | `kubectl get pods -w` |
| `kgpaW` | `kubectl get pods -A -o wide` |
| `kgpawW` | `kubectl get pods -A -o wide -w` |
| `kgd` | `kubectl get deployments` |
| `kgdw` | `kubectl get deployments -w` |
| `kctx` | `kubectl config current-context` |

### Docker

| Command | Description |
|---------|-------------|
| `dock-destroy` | Remove all containers and images |
| `ubuntu` | Spin up and exec into an Ubuntu container |
| `debian` | Spin up and exec into a Debian container |
| `alpine` | Spin up and exec into an Alpine container |

### Terraform

| Command | Description |
|---------|-------------|
| `tp` | `terraform plan` |
| `tir` | `terraform init -reconfigure` |

### ffmpeg

| Command | Description |
|---------|-------------|
| `play <file>` | Play video with PTS timestamp overlay |
| `burn-subs <video> <subs> <out>` | Burn subtitles into video (h264, crf 18) |
| `mux <video> <audio> <out>` | Mux video and audio streams into one file |

### Utility

| Command | Description |
|---------|-------------|
| `ll` | `ls -l` |
| `la` | `ls -a` |
| `cdb` | `cd ..` |
| `cdbb` | `cd ../..` |
| `mkcd <dir>` | mkdir + cd |
| `mvcd <src> <dst>` | mv + cd into destination |
| `speedt` | Run a speedtest |
| `urlencode <str>` | URL-encode a string |
| `urldecode <str>` | URL-decode a string |
| `interface` | Print the default network interface |
| `ij <path>` | Open path in IntelliJ IDEA CE |
| `cursor <path>` | Open path in Cursor |
