# Load version control information
autoload -Uz vcs_info
autoload -Uz compinit && compinit
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '(branch %b)'

# Load up some colors
autoload -U colors && colors 

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
NEWLINE=$'\n'
IP=$(curl -s  ifconfig.me)
PROMPT='${NEWLINE}%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[red]%}${IP}%{$reset_color%} %{$fg[yellow]%}[%*]%{$reset_color%} ${PWD/#$HOME/~}%B${vcs_info_msg_0_}%b${NEWLINE}\$ '


# Custom profile
alias editme='vim ~/.zshrc'
alias sourceme='source ~/.zshrc'
alias codeme='code ~/.zshrc'

# Claude
alias cc='CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 claude --dangerously-load-development-channels server:claude-peers'
alias ccd='claude --dangerously-skip-permissions'

# Codex
cx() {
  local args=(
    --add-dir "$HOME/.cache"
    --add-dir "$HOME/.config/gh"
    --add-dir "$HOME/.aws"
    --add-dir "$HOME/.kube"
  )

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local common
    common="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"
    args+=(--add-dir "$common")
    args+=(--add-dir "$(dirname "$common")")
  fi

  codex "${args[@]}" "$@"
}

cxd() {
  local args=(
    -a never
    -s danger-full-access
    --add-dir "$HOME/.cache"
    --add-dir "$HOME/.config/gh"
    --add-dir "$HOME/.aws"
    --add-dir "$HOME/.kube"
  )

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local common
    common="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"
    args+=(--add-dir "$common")
    args+=(--add-dir "$(dirname "$common")")
  fi

  codex "${args[@]}" "$@"
}
alias ccusage-codex='bunx @ccusage/codex@latest'
alias ccusage-opencode='bunx @ccusage/opencode@latest'

# Docker
alias dock-destroy='docker rm -f $(docker ps -a -q) ; docker rmi -f $(docker images -q)'
alias ubuntu='docker exec -it $(docker run -dit ubuntu) /bin/bash'
alias debian='docker exec -it $(docker run -dit debian) /bin/bash'
alias alpine='docker exec -it $(docker run -dit alpine) /bin/sh'

# git
alias main_branch='git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4'
alias gcom='git checkout $(main_branch)'
alias gpom='git pull origin $(main_branch)'
alias gcb='git checkout -b '
alias gsu='git stash -u'
alias gsp='git stash pop'
alias gs='git status'
alias gd='git diff'
alias grb='git rebase $(main_branch)'
alias ga='git add .'
alias gcm='git commit -m '
alias gpoh='git push -u origin HEAD'
gc() { git checkout $1 }
function openpr() {
  github_url=`git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's%\.git$%%' | awk '/github/'`;
  branch_name=`git symbolic-ref HEAD | cut -d"/" -f 3,4`;
  pr_url=$github_url"/compare/$(git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4)..."$branch_name
  open $pr_url;
}
alias gca='git commit --amend --no-edit'
alias gpohf='git push origin HEAD --force-with-lease'
alias gcaa='git commit --amend --no-edit --allow-empty'
alias gp='git pull'
alias gap='git add -p'
alias gca='git commit --amend'
alias gcane='git commit --amend --no-edit'
squash() { git rebase -i HEAD~$1 }
alias gl='git log --oneline'
alias grh='git reset --soft HEAD^'
alias grs='git restore --staged'

# Git worktree helper
# Usage: gwt [-c] <branch-name> [git-worktree-args...]
#   Creates worktree at ~/git/{repo}-{branch} and symlinks configured files
#   -c          Open Cursor in the new worktree
#   Extra args are passed to `git worktree add` (e.g., -f to force)
#
# To configure files to symlink (in main repo):
#   echo ".env" >> .git/worktree-link-files
#   echo ".env.local" >> .git/worktree-link-files
#   echo "config/local.yml" >> .git/worktree-link-files
gwt() {
  local open_cursor=false
  if [[ "$1" == "-c" ]]; then
    open_cursor=true
    shift
  fi

  local branch="$1"
  if [[ -z "$branch" ]]; then
    echo "Usage: gwt [-c] <branch-name> [git-worktree-args...]"
    return 1
  fi
  shift
  local extra_args=("$@")

  local suffix
  suffix=$(LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c 6)
  branch="${branch}-${suffix}"

  local repo_name
  repo_name=$(basename -s .git "$(git config --get remote.origin.url)" 2>/dev/null)
  if [[ -z "$repo_name" ]]; then
    repo_name=$(basename "$(git rev-parse --show-toplevel)")
  fi

  local main_worktree
  main_worktree=$(git worktree list --porcelain | head -1 | cut -d' ' -f2)

  local worktree_dir="$HOME/git/${repo_name}-${branch}"

  if ! git worktree add "$worktree_dir" -b "$branch" "${extra_args[@]}" 2>/dev/null; then
    git worktree add "$worktree_dir" "$branch" "${extra_args[@]}" || return 1
  fi

  local link_list="$main_worktree/.git/worktree-link-files"
  if [[ -f "$link_list" ]]; then
    while IFS= read -r file || [[ -n "$file" ]]; do
      [[ -z "$file" || "$file" == \#* ]] && continue
      if [[ -e "$main_worktree/$file" ]]; then
        mkdir -p "$worktree_dir/$(dirname "$file")"
        ln -sf "$main_worktree/$file" "$worktree_dir/$file"
        echo "Linked: $file"
      fi
    done < "$link_list"
  fi

  echo "Worktree created: $worktree_dir"
  cd "$worktree_dir"

  if $open_cursor; then
    cursor .
  fi
}

# Git worktree remove - removes current worktree and returns to main
# Usage: gwtr [git-worktree-remove-options]
#   All arguments are passed directly to `git worktree remove`
gwtr() {
  local current_dir
  current_dir=$(pwd)

  local main_worktree
  main_worktree=$(git worktree list --porcelain | head -1 | cut -d' ' -f2)

  if [[ "$current_dir" == "$main_worktree" ]]; then
    echo "Error: Already in main worktree, nothing to remove"
    return 1
  fi

  # Get the worktree root (in case we're in a subdirectory)
  local worktree_root
  worktree_root=$(git rev-parse --show-toplevel)

  # Close any Cursor window with this worktree open
  local worktree_name
  worktree_name=$(basename "$worktree_root")
  osascript -e "
    tell application \"System Events\"
      tell process \"Cursor\"
        repeat with w in windows
          if name of w contains \"$worktree_name\" then
            click button 1 of w
          end if
        end repeat
      end tell
    end tell
  " 2>/dev/null

  cd "$main_worktree" || return 1
  git worktree remove "$worktree_root" "$@" || {
    cd "$worktree_root"
    return 1
  }

  echo "Removed worktree: $worktree_root"
  echo "Now in: $main_worktree"
}

# Terraform
alias tp='terraform plan'
alias tir='terraform init -reconfigure'

# Kubectl
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kgdw='kubectl get deployments -w'
alias kgpw='kubectl get pods -w'
alias kgpaW='kubectl get pods -A -o wide'
alias kgpawW='kubectl get pods -A -o wide -w'
alias kctx='kubectl config current-context'

# ffmpeg utilities
play() {ffplay -vf "drawtext=text='%{pts}':fontcolor=white:fontsize=24:x=10:y=10" $1}
burn-subs() {ffmpeg -i $1 -vf subtitles=$2 -c:a copy -c:v libx264 -crf 18 $3}
mux() {ffmpeg -i $1 -i $2 -c:v copy -c:a aac -map 0:v:0 -map 1:a $3}

# Utility
alias grep="grep --color=always "
alias ll='ls -l'
alias la='ls -a'
alias ls='ls -G'
mkcd() {mkdir $1 && cd $1}
alias cdb='cd ..'
alias cdbb='cd ../..'
alias speedt='speedtest-cli'
mvcd() {mv $1 $2 && cd $2}
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'
alias interface='route -n get 0.0.0.0 2>/dev/null | awk "/interface: / {print $2}"'
