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

# Terraform
alias tp='terraform plan'
alias tir='terraform init -reconfigure'

# Kubectl
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kgdw='kubectl get deployments -w'
alias kgpw='kubectl get pods -w'

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
