" file search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" text search
Plug 'jremmen/vim-ripgrep'
Plug 'mileszs/ack.vim'
Plug 'epmatsw/ag.vim'
" tmux navigation
Plug 'christoomey/vim-tmux-navigator'
" default home screen
Plug 'mhinz/vim-startify'
" syntax
Plug 'tpope/vim-sensible'
" deletes around ) , etc
"Plug 'wellle/targets.vim'
" keep pressing f for find
Plug 'rhysd/clever-f.vim'
" automatically closes quotes
Plug 'tmsvg/pear-tree'
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_backspace   = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_openers     = 1
"<leader + /> to comment
Plug 'scrooloose/nerdcommenter'
" multiple cursor w/ <C-n>
Plug 'terryma/vim-multiple-cursors'
" easily add/remove parents
" ysiw" normal, S visual
Plug 'tpope/vim-surround'
" extend repeat commands
Plug 'tpope/vim-repeat'
" autoindent stuff, visual-mode, ga + <align-by>
Plug 'junegunn/vim-easy-align'
" abbreviate bad spelling, change cases
Plug 'tpope/vim-abolish'
" easymotion
Plug 'easymotion/vim-easymotion'
Plug 'dhruvasagar/vim-pairify'
"git gud
Plug 'tpope/vim-fugitive'
"set diffopt+=vertical
" show = - changes
Plug 'mhinz/vim-signify'
set updatetime=100
" language
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'othree/html5.vim'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'mxw/vim-jsx'
Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
" theme
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'gkeep/iceberg-dark'
"let g:airline_theme='everforest'

Plug 'cocopon/iceberg.vim'
"Plug 'thiagoalessio/rainbow_levels.vim'
"Plug 'luochen1990/rainbow'

"Plug 'junegunn/seoul256.vim'
"colo seoul256

"let g:seoul256_background = 234

"Plug 'nightsense/snow'
"colorscheme snow

"Plug 'nightsense/stellarized'
"colo stellarized

"Plug 'chriskempson/base16-vim'
"let base16colorspace=256
"colorscheme base16-default-dark

"Plug 'joshdick/onedark.vim'
"colorscheme onedark

"Plug 'huyvohcmc/atlas.vim'
"colorscheme atlas

"Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
"colorscheme challenger_deep
"Plug 'w0ng/vim-hybrid'
"Plug 'drewtempelmeyer/palenight.vim'

Plug 'arcticicestudio/nord-vim'
"colorscheme 'nord'

"Plug 'dracula/vim', { 'as': 'dracula' }
"Plug 'dracula/vim', { 'name': 'dracula' }

"phraseapp YML specific
Plug 'airblade/vim-localorie'
" yank yml file key
Plug 'airblade/vim-localorie'

"Show where marks are
Plug 'kshenoy/vim-signature'

"nvim specific
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lspconfig'
