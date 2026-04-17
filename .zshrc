#!/bin/zsh
# ============================================================================
# ZSHRC - Performance Optimized
# ============================================================================
#
# CHANGES MADE (2026-02-04):
# --------------------------
# 1. REMOVED: 'type rg' runtime check - assumes rg is installed
#
# 2. CHANGED: FZF preview uses 'bat' with syntax highlighting
#
# 3. REMOVED: Dead Oh-My-Zsh code, graveyard comments, duplicate definitions
#
# 4. CHANGED: 'go' alias -> function (was running git status at startup)
#
# 5. CHANGED: 'kill' -> 'killport', 'reset' -> 'greset' (shadowed builtins)
#
# 6. CHANGED: compinit -C (skips compaudit security check)
#
# 7. MOVED: Work aliases/functions to ~/.zshrc.local
#
# 8. ADDED: Modern CLI aliases (eza, fd, bat, lazygit)
#
# 9. ADDED: zsh-syntax-highlighting for command coloring
#
# PROFILING: Uncomment to measure startup time:
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

# Pure prompt
autoload -U promptinit; promptinit
prompt pure

# Optimized compinit: skip compaudit (-C flag)
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

# Keep terminal/tmux titles stable; do not auto-update from shell prompt
export DISABLE_AUTO_TITLE="true"

# ============================================================================
# KEY BINDINGS
# ============================================================================

if [[ -o interactive ]]; then
    bindkey -v                              # Vi mode
    bindkey "^[[1;3C" forward-word          # Alt+Right
    bindkey "^[[1;3D" backward-word         # Alt+Left
    bindkey '^R' history-incremental-search-backward  # Ctrl+R for history
fi

# ============================================================================
# FZF
# ============================================================================

# FZF shell integration (Homebrew)
if [[ -o interactive ]]; then
    [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh
    [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 96% --reverse --preview "bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}"'

# ============================================================================
# ZSH PLUGINS
# ============================================================================

# Syntax highlighting + autosuggestions only in interactive shells.
if [[ -o interactive ]]; then
    [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
        source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
        source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Keep Tab for completion; use Shift+Tab to accept autosuggestions.
if [[ -o interactive ]]; then
    ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(end-of-line)
    bindkey '^I' expand-or-complete
    bindkey '^[[Z' autosuggest-accept
fi

# ============================================================================
# ALIASES - Navigation
# ============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias sz='source $HOME/.zshrc; echo "sourced .zshrc"'

# ============================================================================
# ALIASES - Modern CLI Tools (install: brew install eza bat fd)
# ============================================================================

# eza (better ls) - fallback to ls if not installed
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -la --icons --git'
    alias la='eza -a --icons'
    alias lt='eza --tree --level=2 --icons'
    alias tree='eza --tree --icons'
else
    alias ll='ls -la'
    alias la='ls -a'
fi

# bat (better cat)
if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat'  # with paging
fi

# fd (better find)
if command -v fd &> /dev/null; then
    alias find='fd'
fi

# lazygit
alias lg='lazygit'

# ============================================================================
# ALIASES - Git
# ============================================================================

alias g='git'
alias gs='git status -sb'
alias gb='git branch -vv'
alias ga='git add'
alias gc='git commit -m'
alias gp='git pull'
alias gpu='git push'
alias gco='git checkout'
alias gcom='git checkout main'
alias gcob='git checkout -b'
alias gm='git merge'
alias gst='git stash'
alias gsp='git stash pop'
alias gl='git log --oneline -20'
alias gll='git log --graph --oneline --decorate -20'
alias gd='git diff'
alias gds='git diff --staged'
alias gdel='git branch -d'
alias gpom='git pull origin main'
alias merge-main='git pull origin main'

# Interactive git with fzf
alias gf='git checkout $(git branch --format="%(refname:short)" | fzf)'
alias gaf='git add $(git status -s | fzf -m | awk "{print \$2}")'  # fuzzy add

# ============================================================================
# ALIASES - Editor & Tools
# ============================================================================

alias v='nvim'
alias vim='nvim'
alias ve='nvim $HOME/.config/nvim/init.lua'
alias ze='nvim $HOME/.zshrc'
alias te='nvim $HOME/.tmux.conf'
alias ae='nvim $HOME/.config/alacritty/alacritty.toml'
alias ge='nvim $HOME/.gitconfig'
alias vf='nvim "$(fzf)"'

alias t='tmux'
alias tmux='TERM=screen-256color tmux'
alias mux='tmuxinator'

alias c='codex --yolo'
alias r='ranger'
alias ctags='/opt/homebrew/bin/ctags'
alias tags='ctags -R --exclude=node_modules --exclude=public --exclude=vendor --exclude=db --exclude=tmp'

# Spotify
alias s='spt'

# Misc
alias q='fc -e : -1'
alias stats='watch -n1 istats --no-graphs'
alias path='echo $PATH | tr ":" "\n"'  # Pretty print PATH

# ============================================================================
# FUNCTIONS - Git
# ============================================================================

# Open all modified files in vim
go() {
    local files=$(git status --porcelain | awk '{print $2}')
    [[ -n "$files" ]] && nvim $files || echo "No modified files"
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

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ============================================================================
# LOCAL OVERRIDES (not in git)
# ============================================================================

# Source local settings (API tokens, work aliases, machine-specific config)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Uncomment for profiling: zprof

# Source any env files from ~/.config subdirectories
for env_file in "$HOME"/.config/*/env; do
    [[ -f "$env_file" ]] && source "$env_file"
done

# ============================================================================
# DISPLAY MODE SYNC
# ============================================================================

display_mode_current() {
    if ioreg -r -k AppleClamshellState -d 4 | grep -q '"AppleClamshellState" = Yes'; then
        echo clamshell
    else
        echo laptop
    fi
}

display_mode_sync() {
    [[ ! -o interactive ]] && return
    [[ -n "$SSH_CONNECTION" ]] && return

    local current last_file last_mode display_mode_cmd
    current="$(display_mode_current)"
    last_file="${XDG_CACHE_HOME:-$HOME/.cache}/display-mode.last"
    [[ -f "$last_file" ]] && last_mode="$(<"$last_file")" || last_mode=""
    if [[ -x "$HOME/display-mode" ]]; then
        display_mode_cmd="$HOME/display-mode"
    elif command -v display-mode >/dev/null 2>&1; then
        display_mode_cmd="$(command -v display-mode)"
    else
        display_mode_cmd=""
    fi

    if [[ "$current" != "$last_mode" ]] && [[ -n "$display_mode_cmd" ]]; then
        "$display_mode_cmd" "$current" >/dev/null 2>&1
        mkdir -p "${last_file:h}"
        print -r -- "$current" > "$last_file"
    fi
}

display_mode_sync
