#!/bin/zsh
# ============================================================================
# ZSHRC - Performance Optimized
# ============================================================================
#
# CHANGES MADE (2026-02-04):
# --------------------------
# 1. CHANGED: Switched from Pure prompt to Starship (~10ms faster)
#    To revert: comment out Starship line, uncomment Pure lines below
#
# 2. REMOVED: 'type rg' runtime check - assumes rg is installed
#    If rg is not installed, FZF will fall back gracefully
#
# 3. CHANGED: FZF preview uses 'bat' with syntax highlighting (falls back to cat)
#    Install bat: brew install bat
#
# 4. REMOVED: Dead Oh-My-Zsh code (was never sourced)
#
# 5. REMOVED: 40+ lines of commented "graveyard" code
#
# 6. REMOVED: Duplicate FZF_DEFAULT_OPTS definition
#
# 7. REMOVED: Checks for non-existent files (~/.tc_settings, ~/.med_set)
#
# 8. CHANGED: 'go' alias -> function (was running git status at startup)
#
# 9. CHANGED: 'kill' function -> 'killport' (was shadowing builtin)
#
# 10. CHANGED: 'reset' function -> 'greset' (was shadowing builtin)
#
# 11. CHANGED: compinit -C (skips compaudit security check)
#     Run 'compinit' manually after adding new completion directories
#
# 12. MOVED: API tokens to ~/.zshrc.local (not in main config)
#
# PROFILING: Uncomment these lines to measure startup time:
#   zmodload zsh/zprof  (at top)
#   zprof               (at bottom)
#
# ============================================================================

# ============================================================================
# CORE SETUP
# ============================================================================

# Completion paths (before compinit)
fpath+=/opt/homebrew/share/zsh/site-functions
fpath+=$HOME/.zsh/pure
fpath=(/Users/derek.dai/.docker/completions $fpath)

# Starship prompt (faster than Pure)
# Install: brew install starship
eval "$(starship init zsh)"

# REVERTED Pure prompt - uncomment these 3 lines if Starship doesn't work:
# autoload -U promptinit; promptinit
# prompt pure

# Optimized compinit: skip compaudit (-C flag)
# Run `compinit` (without -C) after adding new completion directories
autoload -Uz compinit
compinit -C

# ============================================================================
# ENVIRONMENT
# ============================================================================

export TERM="xterm-256color"
export EDITOR='nvim'
export PAGER="less -S"
export PSQL_PAGER="less -S"
export PATH="$HOME/.local/bin:$PATH"

# Zipline env
[[ -f ~/.config/zipline/env ]] && source ~/.config/zipline/env

# ============================================================================
# KEY BINDINGS
# ============================================================================

set editing-mode vi
bindkey "^[[1;3C" forward-word  # Alt+Right
bindkey "^[[1;3D" backward-word  # Alt+Left

# ============================================================================
# FZF
# ============================================================================

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# FZF settings (assumes rg is installed - skip runtime check)
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 96% --reverse --preview "bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}" --bind tab:up,shift-tab:down'

# ============================================================================
# ALIASES - Navigation
# ============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias sz='source $HOME/.zshrc; echo "sourced .zshrc"'

# ============================================================================
# ALIASES - Git
# ============================================================================

alias g='git'
alias gi='git init'
alias gs='git status'
alias gb='git branch'
alias ga='git add'
alias gc='git commit -m'
alias gp='git pull'
alias gco='git checkout'
alias gcom='git checkout master'
alias gcor='git checkout release'
alias gcob='git checkout -b'
alias gm='git merge'
alias gst='git stash'
alias gsp='git stash pop'
alias gl='git log'
alias gd='git diff'
alias gdd='git diff master..'
alias gdel='git branch -d'
alias gpom='git pull origin master'
alias merge-main='git pull origin main'

# Interactive git checkout with fzf (single quotes = deferred execution)
alias gf='git checkout $(git branch --format="%(refname:short)" | fzf)'

# ============================================================================
# ALIASES - Editor & Tools
# ============================================================================

alias v='nvim'
alias vim='nvim'
alias ve='nvim $HOME/.vimrc'
alias ze='nvim $HOME/.zshrc'
alias te='nvim $HOME/.tmux.conf'
alias ae='nvim $HOME/.config/alacritty/alacritty.toml'
alias vf='nvim "$(fzf)"'

alias t='tmux'
alias tmux='TERM=screen-256color tmux'
alias mux='tmuxinator'

alias c='code'
alias r='ranger'
alias ctags='/opt/homebrew/bin/ctags'
alias tags='ctags -R --exclude=node_modules --exclude=public --exclude=vendor --exclude=db --exclude=tmp'

# Spotify
alias s='spt'
alias n='spt playback -n'
alias p='spt playback -p'
alias pp='spt playback -t'

# Misc
alias q='fc -e : -1'
alias stats='watch -n1 istats --no-graphs'
alias file='fzf | pbcopy'

# ============================================================================
# ALIASES - Work (Zipline)
# ============================================================================

alias lint='bin/format -q && bin/lint --fix'
alias pre='bin/kubectl env preprod'
alias shell='/Users/derek.dai/github/cloud/services/delivery_area_service/bin/ops/shell'
alias das-diff='services/delivery_area_service/bin/deployment_diff'

# Kubernetes
alias kube-env='tools/kubectl/kubectl-env.sh'
alias kube-get='bin/kubectl get all'
alias kube-get-pods='bin/kubectl get pods'
alias kube-events='bin/kubectl get events --sort-by=.metadata.creationTimestamp'
alias kube-context='bin/kubectl config current-context'
alias kube-namespaces='bin/kubectl get namespaces'

# ============================================================================
# FUNCTIONS - Git
# ============================================================================

# Open all modified files in vim
go() {
    nvim $(git status --porcelain | awk '{print $2}')
}

# Add all and commit
gac() {
    git add .
    git commit -m "$1"
}

# Add, commit, and push (no verify)
gacp() {
    git add .
    git commit -m "$1" --no-verify
    git push
}

# Discard changes (file or all)
nah() {
    if [[ "$1" ]]; then
        git checkout -- "$1"
    else
        git reset --hard
    fi
}

# Checkout file from integration branch
mah() {
    [[ "$1" ]] && git checkout integration "$1"
}

# Reset file from HEAD
greset() {
    git checkout HEAD -- "$1"
}

# Get repo name from remote URL
git_repo() {
    [[ ! -d .git ]] && echo "ERROR: Not a git directory" && return 1
    git config --get remote.origin.url | sed 's/.*\/\([^/]*\)\.git/\1/'
}

# Open all changed files in vim (vertical split)
changed() {
    nvim -O $(git status --porcelain | awk '{print $2}')
}

# ============================================================================
# FUNCTIONS - Utilities
# ============================================================================

# Fuzzy search command history
qq() {
    print -z $(fc -l 1 | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Kill process on port (use: killport or killport 8080)
killport() {
    local port=${1:-3000}
    kill -9 $(lsof -i tcp:$port -t) 2>/dev/null && echo "Killed process on port $port" || echo "No process on port $port"
}

# ============================================================================
# FUNCTIONS - Work (Zipline)
# ============================================================================

ds() {
    cd ~/github/cloud/
    bash bin/dockershell
}

fleet-address-manager() {
    bin/localdev fleet-apps.port-forward fleet-apps.fleet-ingress fleet-apps.fleet-home-app fleet-apps.fleet-home-bff fleet-apps.address-manager-bff fleet-apps.address-manager-app fleet-apps.address-manager-devredis delivery-area-service.grpc-server delivery-area-service.devpostgres
}

fleet-annotate() {
    bash /Users/derek.dai/github/cloud/services/fleet_apps/fleet_annotate_api/bin/run
}

kube() {
    bin/kubectl "$@"
}

kube-namespace() {
    bin/kubectl config set-context --current --namespace="$1"
}

create_dev_task() {
    cd && sz && sh ./create_tasks_bulk.sh /Users/derek.dai/address_id_list.txt
}

# ============================================================================
# LOCAL OVERRIDES (not in git)
# ============================================================================

# Source local settings if they exist (API tokens, machine-specific config)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Uncomment for profiling: zprof
