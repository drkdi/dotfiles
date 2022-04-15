#!/bin/zsh
#symlink


#todo:
# CREATE ..3, repeat .. 3 times
# automatically create alias, takes input and current directory, append to TC

#plugins=(git)

export ZSH="/Users/.oh-my-zsh.sh"
ZSH_THEME=""
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
# for m1 mac, brew directory moved from usr/local to opt
fpath+=/opt/homebrew/share/zsh/site-functions
fpath+=$HOME/.zsh/pure

autoload -U promptinit; promptinit
prompt pure

export TERM="xterm-256color"
export EDITOR='nvim'
set editing-mode v

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PAGER="less -S"
export PSQL_PAGER="less -S"

##################################### ALIAS  #########################################################
#   git
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
    alias gf='git checkout `git branch --format="%(refname:short)" | fzf`'
    alias gdel='git branch -d'
    alias gpom='git pull origin master'
    alias go="nvim $(git status --porcelain | awk '{print $2}')"

#   vim
    alias mux='tmuxinator'
    alias tmux='TERM=screen-256color tmux'
    alias v='nvim -S ~/.vimrc'
    alias vim='vim -S ~/.vimrc'
    alias ve='v $HOME/.vimrc'
    alias ze='v $HOME/.zshrc'
    alias ce='v $HOME/copy'
    alias vf='v "$(fzf)"'
    alias ae='v $HOME/.alacritty.yml'
    alias te='v $HOME/.tmux.conf'
    alias pe='v $HOME/.vim/plugins.vim'



#   etc
    alias ..='cd ..'
    alias q='fc -e : -1'
    alias stats="watch -n1 istats --no-graphs"
    alias c=code
    alias r='ranger'
    alias s='spt'
    alias n='spt playback -n'
    alias p='spt playback -p'
    alias pp='spt playback -t'
    alias file='fzf | pbcopy'
    alias sz='source $HOME/.zshrc ; echo "sourced .zshrc"'
    alias ctags="`brew --prefix`/bin/ctags"
    alias t='tmux'
    #alias t='vim -t "$(cut -f1 tags | tail +7 | uniq | fzf)"'
    alias tags="ctags -R --exclude=node_modules --exclude=public --exclude=vendor --exclude=db --exclude=tmp"
#   alias n='vim "+normal Go" $HOME/notes.md'
#   alias n='vim "+normal G$" +startinsert $HOME/notes.md'
    alias rag='vim `rg "what" | fzf`'

#   copy
    alias dotfiles='. ./copy dotfiles'
    alias copy='bash copy'

    function pb() {
        echo "$@" | pb
    }

##################################### STUFF #########################################################
    function personal() {
#   hardcoded version
#   sed -i '' 's/nord0_gui = .*/nord0_gui = "#1b1e24"/g' ~/.vim/autoload/nord-vim/colors/nord.vim
#   -i in place, '' s/ substitute, $1 $2 parameters, \" escapes
        function replaceEqual() {
            sed -i '' "s/$1 = .*/$1 = \"$2\"/g" ~/.vim/autoload/nord-vim/colors/nord.vim
        }

        function replaceColon() {
            sed -i '' "s/$1: .*/$1: $2/g" ~/.alacritty.yml
        }
        
        source ~/.zshrc
        replaceEqual "nord0_gui" "#1e232b"
        replaceColon "size" "14.0"
        echo "updated personal"
    }

    function qq() { 
      #print -z $( ([ -n "$ZSH_NAME" ] && fc -li 1 || history) | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
      print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
    }

#   kill ruby rails server
    function kill() {
      kill -9 $(lsof -i tcp:3000 -t)
    }

    function regex() {
      gawk 'match($0,/'$1'/, ary) {print ary['${2:-'0'}']}'
    }



##################################### GIT #########################################################
#   reset file if provided, otherwise entire branch
#   TODO: create han, delete everything BUT what's passed in
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
        #yarn lint --fix
        git add .
        git commit -a -m "$1" --no-verify
        git push
    }

#   broken by vim-startify
    function changed() {
      vim -O $(git status --porcelain | awk '{print $2}')
    }

#   reset file path from git head
    function reset() {
      git checkout head -- "$1"
    }

    function git_repo() {
      if [ ! -d .git ] ;
        then echo "ERROR: This isnt a git directory" && return false;
      fi
      git config --get remote.origin.url | regex "\/(.*)\.git" 1
    }




##################################### FZF #########################################################
    export FZF_DEFAULT_OPTS="--bind tab:up,shift-tab:down"

    if type rg &> /dev/null; then
      export FZF_DEFAULT_COMMAND='Rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git}"'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_DEFAULT_OPTS='--height 96% --reverse --preview "cat {}"'
    fi

    

##################################### 墓 ぼ 地 ち  #########################################################
# status line 
#   reset_color="\033[0m"
#   git_clean_color="\033[0;32m"
#   git_dirty_color="\033[0;31m"
#   parse_git_branch() {
#       git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
#   }
#   parse_color() {
#     if ! git rev-parse --git-dir > /dev/null 2>&1; then
#         return 0
#     fi
#   git_color=${reset_color}
#   git diff-index --quiet
#     if [ -z "$(git status --untracked-files=no --porcelain)" ];
#     # if [[ -z $(git status -s) ]];
#     then
#         git_color=${git_clean_color}
#     else
#         git_color=${git_dirty_color}
#     fi
#     echo -e $git_color
#   }
#   export PS1="\[\$(parse_color)\]\$(parse_git_branch)\[\e[0m\] \W \$ "
#   setopt PROMPT_SUBST
#   autoload -U colors && colors
#   export PS1="\$(parse_color)\$(parse_git_branch) $fg[white]%1d \$ "
#   #function changes() {
#     code `git changed`
#     default input to current branch + master
#       for i in $(git changed)
#         do
#           code $i
#         done
#     echo $arr
#     }

#   alias q='fc -s'
#   qq() {
#     eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
#   }


##################################### SOURCING  #########################################################
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

# no idea
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

