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
PROMPT='${NEWLINE}%{$fg[blue]%}% %n%{$reset_color%}@%{$fg[red]%}% ${IP} %{$reset_color%}${PWD/#$HOME/~}%B${vcs_info_msg_0_}%b${NEWLINE}\$ '


# Docker
alias dock-destroy='docker rm -f $(docker ps -a -q) ; docker rmi -f $(docker images -q)'

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

# Terraform
alias tp='terraform plan'
alias tir='terraform init -reconfigure'

# Kubectl
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kgdw='kubectl get deployments -w'
alias kgpw='kubectl get pods -w'

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
alias ip='curl ifconfig.me'
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'
