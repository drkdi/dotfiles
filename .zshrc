#!/bin/zsh


#todo:
# CREATE ..3, repeat .. 3 times
# automatically create alias, takes input and current directory, append to TC


# new machine:
# defaults write -g InitialKeyRepeat -int 10 
#   normal minimum is 15 (225 ms)
# defaults write -g KeyRepeat -int 1 
#   normal minimum is 2 (30 ms)
#defaults write -g ApplePressAndHoldEnabled -bool false


#_______ZSH STUFF_________



#plugins=(git)

# update for work, nested
#source ~/zsh-syntax-highlighting

export ZSH="/Users/.oh-my-zsh.sh"
ZSH_THEME=""
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
# for m1 mac, brew directory moved from usr/local to opt
fpath+=/opt/homebrew/share/zsh/site-functions
fpath+=$HOME/.zsh/pure

autoload -U promptinit; promptinit
prompt pure

#_______GIT STUFF_________
alias g='git'
alias gi='git init'
alias gs='git status'
alias gb='git branch'
alias ga='git add'
alias gc='git commit -m'
alias gp='git pull'
alias gco='git checkout'
alias gcom='git checkout master'
alias gcob='git checkout -b'
alias gm='git merge'
alias gst='git stash'
alias gsp='git stash pop'
alias gl='git log'
alias gd='git diff'
alias gdd='git diff master..'
alias gf='git checkout `git branch --format="%(refname:short)" | fzf`'
alias gdel='git branch -d'
alias gpom='git pull origin master'
alias go="vim $(git status --porcelain | awk '{print $2}')"
alias mux='tmuxinator'
alias tmux='TERM=screen-256color tmux'
alias r='ranger'
alias copy='bash copy'

# hardcoded version
# sed -i '' 's/nord0_gui = .*/nord0_gui = "#1b1e24"/g' ~/.vim/autoload/nord-vim/colors/nord.vim
# -i in place, '' s/ substitute, $1 $2 parameters, \" escapes
function personal() {
    function replaceEqual() {
        sed -i '' "s/$1 = .*/$1 = \"$2\"/g" ~/.vim/autoload/nord-vim/colors/nord.vim
    }
    replaceEqual "nord0_gui" "#1b1e24"

    function replaceColon() {
        sed -i '' "s/$1: .*/$1: $2/g" ~/.alacritty.yml
    }
    replaceColon "size" "14.0"
    echo "updated personal"
}

#alias nah="git reset --hard"

# reset file if provided, otherwise entire branch
#  TODO: create han, delete everything BUT what's passed in
#   take any number of optional arguments,

function mah() {
  if [[ "$1" ]]; then
    git checkout integration "$1"
  fi
}

function nah() {
  if [[ "$1" ]]; then
    git checkout -- "$1"
  else
    git reset --hard 
  fi
}


function gac() {
    git add .
    git commit -a -m "$1"
}
function gacp() {
    #git ls-files -m | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs rubocop -a
    yarn lint --fix
    git add .
    git commit -a -m "$1"
    git push
}

function rb() {
  git ls-files -m | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs rubocop -a
}
# broken by vim-startify
function changed() {
  vim -O $(git status --porcelain | awk '{print $2}')
}

# reset file path from git head
function reset() {
  git checkout head -- "$1"
}
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word



#___________GENERAL__________
export TERM="xterm-256color"
export EDITOR='vim'
alias ..='cd ..'
alias c=code
alias v='vim -S ~/.vimrc'
alias vim='vim -S ~/.vimrc'
alias q='fc -e : -1'
alias stats="watch -n1 istats --no-graphs"
set editing-mode v

# search history with fzf and execute
function qq() { 
  #print -z $( ([ -n "$ZSH_NAME" ] && fc -li 1 || history) | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# sourcing
alias sz='source $HOME/.zshrc ; echo "sourced .zshrc"'
alias ve='v $HOME/.vimrc'
alias ze='v $HOME/.zshrc'
alias te='v $HOME/.tc_settings'
alias n='vim "+normal Go" $HOME/notes.md'
#alias n='vim "+normal G$" +startinsert $HOME/notes.md'

# tags
alias ctags="`brew --prefix`/bin/ctags"
alias t='vim -t "$(cut -f1 tags | tail +7 | uniq | fzf)"'
alias tags="ctags -R --exclude=node_modules --exclude=public --exclude=vendor --exclude=db --exclude=tmp"



# FZF
alias vf='vim "$(fzf)"'
export FZF_DEFAULT_OPTS="--bind tab:up,shift-tab:down"

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='Rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git}"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='--height 96% --reverse --preview "cat {}"'
fi

# kill ruby rails server
function kill() {
  kill -9 $(lsof -i tcp:3000 -t)
}

alias rag='vim `rg "what" | fzf`'

function regex() {
  gawk 'match($0,/'$1'/, ary) {print ary['${2:-'0'}']}'
}

function git_repo() {
  if [ ! -d .git ] ;
    then echo "ERROR: This isnt a git directory" && return false;
  fi

  git config --get remote.origin.url | regex "\/(.*)\.git" 1
}



# add ripgrep stuff


# graveyard
# # OLD BASH STUFF
# reset_color="\033[0m"
# git_clean_color="\033[0;32m"
# git_dirty_color="\033[0;31m"
# parse_git_branch() {
#     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
# }
# parse_color() {
#     if ! git rev-parse --git-dir > /dev/null 2>&1; then
#         return 0
#     fi
#     git_color=${reset_color}
# # git diff-index --quiet
#     if [ -z "$(git status --untracked-files=no --porcelain)" ];
#     # if [[ -z $(git status -s) ]];
#     then
#         git_color=${git_clean_color}
#     else
#         git_color=${git_dirty_color}
#     fi
#     echo -e $git_color
# }
# export PS1="\[\$(parse_color)\]\$(parse_git_branch)\[\e[0m\] \W \$ "
# setopt PROMPT_SUBST
# autoload -U colors && colors
# export PS1="\$(parse_color)\$(parse_git_branch) $fg[white]%1d \$ "
# #function changes() {
    #code `git changed`
    ## default input to current branch + master
    #for i in $(git changed)
    #do
        #code $i
    #done
    #echo $arr
#}
#function gfind() {
    #declare -a arr
    #phrase=""
    #for word in "$@"
    #do
        #phrase+="$word"
        #phrase+="-"
    #done

    #for i in `git branch -l | grep "${phrase%?}"`

    #do
        #arr+=("$i")
        ## echo $i
    #done
    ## echo $arr
    #for i in ${!arr[@]};
    #do
        #echo $i: ${arr[$i]}
    #done

    #read index
    #git checkout ${arr["$index"]}

    ## echo each element w/ index
    ## read number
    ## git checkout array[number]
    ## return matching branches and number them to select from
#}

# bash -> zsh changes
# alias q='fc -s'



# tree navigation
#function fd() {
    #if [[ "$#" != 0 ]]; then
        #builtin fd "$@";
        #return
    #fi
    #while true; do
        #local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        #local dir="$(printf '%s\n' "${lsd[@]}" |
            #fzf --preview '
                #__fd_nxt="$(echo {})";
                #__fd_path="$(echo $(pwd)/${__fd_nxt} | sed "s;//;/;")";
                #echo $__fd_path;
                #echo;
                #ls -p "${__fd_path}";
        #')"
        #[[ ${#dir} != 0 ]] || return 0
        #builtin fd "$dir" &> /dev/null
    #done
#}
## fh - repeat history
#qq() {
  #eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
#}


# sourcing
if [[ -f ~/.tc_settings ]]; then
  source ~/.tc_settings
  alias st='source $HOME/.tc_settings; echo "sourced tc_settings"'
fi

if [[ -f ~/.med_set ]]; then
  source ~/.med_set
  alias sm='source $HOME/.med_set; echo "sourced med_set"'
fi


if [[ -f ~/.personal ]]; then
  source ~/.personal
  alias st='source $HOME/.personal; echo "sourced personal'
fi


if [[ -f ~/.tmux.conf ]]; then
  alias me='vim $HOME/.tmux.conf'
fi

export PAGER="less -S"
export PSQL_PAGER="less -S"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
