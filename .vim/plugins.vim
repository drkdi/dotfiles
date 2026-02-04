" ============================================================================
" PLUGINS - Performance Optimized
" ============================================================================
"
" CHANGES MADE (2026-02-04):
" --------------------------
" 1. REMOVED: ack.vim and ag.vim (redundant - fzf+ripgrep handles search)
"    To revert: uncomment them below
"
" 2. REMOVED: vim-sandwich (redundant - vim-surround does the same thing)
"    To revert: uncomment it below
"
" 3. REMOVED: Duplicate vim-localorie (was listed twice)
"
" 4. REMOVED: Duplicate dracula theme (was listed twice)
"
" 5. CHANGED: updatetime = 300 (was 100) - reduces CursorHold frequency
"    If git signs update too slowly, decrease this value
"
" 6. WRAPPED: nvim-treesitter and nvim-lspconfig in has('nvim') check
"    These only work in Neovim
"
" 7. ADDED: Lazy-loading for language plugins (only load for matching filetypes)
"    This speeds up vim startup for non-matching files
"
" 8. REMOVED: vim-sensible (you override all its settings anyway)
"    To revert: uncomment it below
"
" 9. REMOVED: vim-multiple-cursors (rarely used, adds complexity)
"    To revert: uncomment it below
"
" 10. REMOVED: vim-pairify (overlaps with pear-tree)
"     To revert: uncomment it below
"
" ============================================================================

" --- Search ---
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
" REMOVED: Redundant search tools (fzf+rg handles this)
" Plug 'mileszs/ack.vim'
" Plug 'epmatsw/ag.vim'

" --- Navigation ---
Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-startify'
Plug 'easymotion/vim-easymotion'
Plug 'rhysd/clever-f.vim'

" --- Editing ---
" REMOVED: vim-sensible (you override all its settings)
" Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
" REMOVED: vim-sandwich (vim-surround handles this)
" Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'junegunn/vim-easy-align'
Plug 'tmsvg/pear-tree'
Plug 'scrooloose/nerdcommenter'
" REMOVED: vim-multiple-cursors (rarely used)
" Plug 'terryma/vim-multiple-cursors'
" REMOVED: vim-pairify (overlaps with pear-tree)
" Plug 'dhruvasagar/vim-pairify'

" Pear-tree settings
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_backspace   = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_openers     = 1

" --- Git ---
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
" CHANGED: 300ms instead of 100ms for better performance
set updatetime=300

" --- Language Support (lazy-loaded by filetype) ---
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby', 'eruby'] }
Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby'] }
Plug 'othree/html5.vim', { 'for': ['html', 'eruby'] }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'typescript', 'jsx', 'tsx'] }
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascriptreact', 'jsx'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascriptreact', 'jsx'] }
Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescriptreact', 'tsx'] }
Plug 'maxmellon/vim-jsx-pretty', { 'for': ['javascript', 'typescript', 'jsx', 'tsx', 'javascriptreact', 'typescriptreact'] }

" --- LSP/Completion ---
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Neovim-only plugins
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'neovim/nvim-lspconfig'
  Plug 'lukas-reineke/indent-blankline.nvim'
endif

" --- Theme/UI ---
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
" REMOVED: Unused themes (uncomment if needed)
" Plug 'cocopon/iceberg.vim'
" Plug 'arcticicestudio/nord-vim'
" Plug 'dracula/vim', { 'as': 'dracula' }

" --- Utilities ---
Plug 'airblade/vim-localorie'
Plug 'kshenoy/vim-signature'

" ============================================================================
" Commented out themes (uncomment to use)
" ============================================================================
" Plug 'thiagoalessio/rainbow_levels.vim'
" Plug 'luochen1990/rainbow'
" Plug 'junegunn/seoul256.vim'
" Plug 'nightsense/snow'
" Plug 'nightsense/stellarized'
" Plug 'chriskempson/base16-vim'
" Plug 'joshdick/onedark.vim'
" Plug 'huyvohcmc/atlas.vim'
" Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
" Plug 'w0ng/vim-hybrid'
" Plug 'drewtempelmeyer/palenight.vim'
