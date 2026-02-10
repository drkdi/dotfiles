" ============================================================================
" VIMRC - Performance Optimized  (VIM-ONLY FALLBACK)
"
" NOTE: This file is only used by regular Vim. Neovim uses
"   ~/.config/nvim/init.lua  (native Lua config with lazy.nvim + native LSP)
" ============================================================================
"
" CHANGES MADE (2026-02-04):
" --------------------------
" 1. REMOVED: TextYankPost pbcopy autocmd - was spawning process on every yank
"    If clipboard stops working, uncomment the YankToClipboard augroup below
"
" 2. CHANGED: tmux rename-window now only triggers on BufEnter (was triggering
"    on BufReadPost, FileReadPost, BufNewFile, FocusGained - too frequent)
"    If tmux window names lag, revert to the old events
"
" 3. REMOVED: CursorHold/CursorHoldI checktime autocmd - was running every
"    100ms due to updatetime=100. FocusGained/BufEnter checktime remains.
"    If external file changes aren't detected, uncomment the CursorHold line
"
" 4. CHANGED: ale_completion_enabled = 0 (was 1) - conflicts with CoC
"    If you lose completion features, check CoC is working or re-enable
"
" 5. CHANGED: signify_line_highlight = 0 (was 1) - slow on large files
"    If you miss full-line git highlighting, set back to 1
"
" 6. REMOVED: Duplicate mappings and cleaned up organization
"
" 7. REPLACED: Airline with Lightline (much faster statusline)
"    If you want airline back, see plugins.vim and uncomment airline settings
"
" 8. ADDED: CoC deferred startup - only starts when you enter insert mode
"    If LSP features don't work immediately, remove coc_start_at_startup=0
"
" 9. ADDED: Large file optimization - disables syntax for files >1MB
"    If you need syntax on large files, remove the LargeFile augroup
"
" ============================================================================

" ================================ PLUGINS ===================================
filetype plugin on

" Auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/autoload')
  source ~/.vim/plugins.vim
call plug#end()

source ~/.vim/coc-plugin.vim

" ================================ THEME =====================================
set t_Co=256
set background=dark
colorscheme catppuccin_mocha

au ColorScheme * hi Normal ctermbg=None

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" ================================ HIGHLIGHTS ================================
highlight Visual cterm=bold ctermbg=Green ctermfg=Black
highlight CursorLine cterm=underline term=underline ctermbg=NONE guibg=NONE
highlight clear SignColumn
highlight clear LineNr
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
highlight Comment cterm=italic gui=italic guifg=#95989d

" Ruby syntax highlights
highlight! link rubyKeywordAsMethod Green
highlight! link rubyInterpolation Yellow
highlight! link rubyInterpolationDelimiter Yellow
highlight! link rubyStringDelimiter Green
highlight! link rubyBlockParameterList Blue
highlight! link rubyDefine RedItalic
highlight! link rubyModuleName Purple
highlight! link rubyAccess Orange
highlight! link rubyAttribute Yellow
highlight! link rubyMacro RedItalic

" ================================ SETTINGS ==================================
set re=0                                 " typescript regex for vim8
set nocompatible                         " system-wide vimrc
set backspace=indent,eol,start           " backspace over indentation, etc
set ruler                                " always show cursor position
set splitright                           " default split right
set mouse=a                              " use mouse
set cursorline                           " line at cursor row
set incsearch                            " incremental search for partial /
set hlsearch                             " search highlighting /
set showcmd                              " show command on bottom
set autoread                             " reread files if unmodified
set autoindent                           " new line inherits indent
set smartindent                          " new line inherits indent
set expandtab                            " tabs to spaces
set tabstop=4
set shiftwidth=4
set wildignore+=*/tmp/*,*.so,*.swp,*.zip " ignore these types of files
set history=1000                         " increase undo limit
set nowrap                               " disable auto wrap
set hidden                               " save previous buffer stuff
set noautochdir                          " no redirecting directory
set ignorecase                           " ignore case for search
set smartcase                            " automatically convert search to uppercase
set noswapfile                           " disable swap files
set tags=tags;/                          " tags
set clipboard^=unnamed,unnamedplus       " use system clipboard
set scrolloff=10                         " lines of buffer between top and bottom
set ttimeout
set ttimeoutlen=0
set timeoutlen=500                       " time in between commands v,c,y
syntax enable                            " colors, overrule with on
set number relativenumber
set numberwidth=2
set laststatus=2                         " always show statusline
set noshowmode                           " lightline shows mode
let &t_ZH="\e[3m"                        " italics
let &t_ZR="\e[23m"                       " italics

" ================================ CLIPBOARD =================================
" Clipboard configuration for macOS (works in Alacritty/tmux)
if has('mac') || has('macunix') || system('uname -s') =~? 'darwin'
  " Test command to verify clipboard works
  command! TestClipboard call system('pbcopy', 'test clipboard') | echo 'Clipboard test sent - try Cmd+V'

  " REMOVED FOR PERFORMANCE - uncomment if clipboard stops working:
  " augroup YankToClipboard
  "   autocmd!
  "   autocmd TextYankPost * if len(@") > 0 | call system('pbcopy', @") | endif
  " augroup END

  " Neovim clipboard provider configuration
  if has('nvim') && executable('pbcopy') && executable('pbpaste')
    let g:clipboard = {
      \   'name': 'pbcopy',
      \   'copy': {
      \      '+': 'pbcopy',
      \      '*': 'pbcopy',
      \    },
      \   'paste': {
      \      '+': 'pbpaste',
      \      '*': 'pbpaste',
      \   },
      \   'cache_enabled': 1,
      \ }
  endif
endif

" ================================ LEADER & BASIC MAPS =======================
map <Space> <Leader>
let mapleader = "\<Space>"
nmap ; :
map Q @@

" Movement
nnoremap J 5j
nnoremap K 5k
nnoremap H {
nnoremap L }
noremap vA ggVG

" Escape
inoremap jj <ESC>

" Undo/Redo
noremap U <C-r><CR>

" Yank/Delete to black hole (don't pollute registers)
noremap d "_d
noremap dd "_dd
noremap D "_D
noremap c "_c
noremap cc "_cc
noremap C "_C
vnoremap d "_d
vnoremap dd "_dd
vnoremap D "_D
vnoremap c "_c
vnoremap cc "_cc
vnoremap C "_C
nnoremap X yydd
nnoremap Y ^y$

" Paste from yank register
map <leader>r viw"0p

" Delete empty lines in visual
vnoremap de :g/^\s*$/d<CR>:noh<CR>

" Yank in /
onoremap <silent> i/ :<C-U>normal! T/vt/<CR>
onoremap <silent> a/ :<C-U>normal! F/vf/<CR>
xnoremap <silent> i/ :<C-U>normal! T/vt/<CR>
xnoremap <silent> a/ :<C-U>normal! F/vf/<CR>

" Paste mode toggle
nnoremap <F2> :set paste!<CR>
inoremap <F2> <C-O>:set paste!<CR>

" Word deletion in insert mode
inoremap <C-w> <C-\><C-o>dB
inoremap <C-BS> <C-\><C-o>db

" ================================ WINDOW MANAGEMENT =========================
" Split
nnoremap <silent> vv <C-w>v
nnoremap qq :close<cr>

" Save/Quit
nmap <Leader>w :w<CR>
nmap <Leader>q :q<CR>
nmap <Leader>e :wq<CR>
nmap <Leader>Q :qa!<CR>

" Buffers
cnoreabbrev b :Buffers
nmap <Leader>b :Buffers<CR>
cnoreabbrev QQ :browse oldfiles
cnoreabbrev Q :History
cnoreabbrev .. cd ..

" Duplicate lines
noremap du Yp
vnoremap du yp

" Buffer navigation
nnoremap <silent><leader><tab> :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:b#<CR>
nnoremap <silent> <tab> :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap <silent> <s-tab> :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

" Switch pane
nnoremap <Leader><space> <c-w><c-p>
nnoremap <Leader>0 <c-w><c-p>

" Window switching by number
let i = 1
while i <= 9
  execute 'nnoremap <Leader>' . i . ' :' . i . 'wincmd w<CR>'
  let i = i + 1
endwhile

" Resize window
nnoremap <silent> <Leader>> 30<C-w>>
nnoremap <silent> <Leader>< 30<C-w><
nnoremap <silent> <Leader>= <C-w>=

" Split with buffers/files
nnoremap <leader>v :vsp<space>\|:Buffers<CR>
nnoremap <leader>o :only

" Directional splits
nnoremap <Leader>ls :leftabove  vsplit<CR>
nnoremap <Leader>ks :rightbelow split<CR>
nnoremap <Leader>hn :leftabove  vnew<CR>
nnoremap <Leader>ln :rightbelow vnew<CR>
nnoremap <Leader>kn :leftabove  new<CR>
nnoremap <Leader>jn :rightbelow new<CR>

nnoremap <Leader>hb :leftabove  vnew<CR>:Buffers<CR>
nnoremap <Leader>lb :rightbelow vnew<CR>:Buffers<CR>
nnoremap <Leader>kb :leftabove  new<CR>:Buffers<CR>
nnoremap <Leader>jb :rightbelow new<CR>:Buffers<CR>

nnoremap <Leader>HH :leftabove  vnew<CR>:Rg!<CR>
nnoremap <Leader>LL :rightbelow vnew<CR>:Rg!<CR>
nnoremap <Leader>KK :leftabove  new<CR>:Rg!<CR>
nnoremap <Leader>JJ :rightbelow new<CR>:Rg!<CR>

nnoremap <Leader>H<Space> :leftabove  vnew<CR>:Files!<CR>
nnoremap <Leader>L<Space> :rightbelow vnew<CR>:Files!<CR>
nnoremap <Leader>K<Space> :leftabove  new<CR>:Files!<CR>
nnoremap <Leader>J<Space> :rightbelow new<CR>:Files!<CR>

nnoremap <silent> <Leader>hh :call JumpOrOpenNewSplit('h', ':leftabove vnew', 1)<CR>
nnoremap <silent> <Leader>ll :call JumpOrOpenNewSplit('l', ':rightbelow vnew', 1)<CR>
nnoremap <silent> <Leader>kk :call JumpOrOpenNewSplit('k', ':leftabove vnew', 1)<CR>
nnoremap <silent> <Leader>jj :call JumpOrOpenNewSplit('j', ':rightbelow vnew', 1)<CR>

nnoremap <silent> <Leader>h<Space> :call JumpOrOpenNewSplit('h', ':leftabove vsplit', 0)<CR>
nnoremap <silent> <Leader>l<Space> :call JumpOrOpenNewSplit('l', ':rightbelow vsplit', 0)<CR>
nnoremap <silent> <Leader>k<Space> :call JumpOrOpenNewSplit('k', ':leftabove split', 0)<CR>
nnoremap <silent> <Leader>j<Space> :call JumpOrOpenNewSplit('j', ':rightbelow split', 0)<CR>

" ================================ SEARCH ====================================
nmap s <Plug>(easymotion-bd-f)
cnoreabbrev rg Rg
cnoreabbrev files GFiles
cnoreabbrev f GFiles

nnoremap ff :Rg<cr>
nnoremap <silent>FF :Files<cr>
map <leader>f :rg <c-r>=expand("<cword>")<cr><cr>
map <leader>F :/<c-r>=expand("<cword>")<cr><cr>n

" Go to definition
nnoremap <leader>d :vsplit<CR>:exec("tag ".expand("<cword>"))<CR>

" Next/previous in quickfix
map <C-n> :cn<CR>
map <C-p> :cp<CR>

" Netrw tree
map <leader>t :Explore<cr>
map <leader>/ <Plug>NERDCommenterToggle

" ================================ FILE SHORTCUTS ============================
cnoreabbrev sv :source ~/.vimrc <CR>
cnoreabbrev ve :vsplit ~/.vimrc <CR>
cnoreabbrev ze :vsplit ~/.zshrc<CR>
cnoreabbrev te :vsplit ~/.tc_settings<CR>
cnoreabbrev N :e ~/notes.md<CR>Go<CR>
cnoreabbrev n :vsplit ~/notes.md<CR>Go<CR>

" Copy current file path
nnoremap <Leader>yp :call CopyCurrentFilePath()<CR>
nnoremap <leader>% :call CopyCurrentFilePath()<CR>

" Session management
cnoreabbrev save :SSave
cnoreabbrev load :SLoad
cnoreabbrev delete :SDelete

" Python debugger
nnoremap <leader>p oimport pdb; pdb.set_trace()<Esc>

" ================================ JOINS =====================================
noremap <silent> <Plug>(interactiveJoin)  :call <SID>interactiveJoin(0)<CR>
noremap <silent> <Plug>(interactiveGJoin) :call <SID>interactiveJoin(0,'g')<CR>
noremap <silent> <Plug>(repeatJoin)       :call <SID>interactiveJoin(1)<CR>
noremap <silent> <Plug>(repeatGJoin)      :call <SID>interactiveJoin(1,'g')<CR>
nmap z <Plug>(interactiveJoin)
xmap z <Plug>(interactiveJoin)
nmap gJ <Plug>(interactiveGJoin)
xmap gJ <Plug>(interactiveGJoin)

" Split lines
vnoremap s :LineBreakAt
nnoremap S :LineBreakAt

" ================================ AUTOCMDS ==================================
" Disable undo for sensitive files
augroup NoUndoUlysses
  autocmd!
  autocmd BufWritePre *boxer-*.yaml setlocal noundofile
augroup END

" Relative number only on current window
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
augroup END

" Auto-save when leaving window
au FocusLost,WinLeave * :silent! noautocmd w

" Check for external changes (REMOVED CursorHold for performance)
au FocusGained,BufEnter * :checktime
" REMOVED FOR PERFORMANCE - uncomment if external changes aren't detected:
" au CursorHold,CursorHoldI * checktime

" Source vimrc on save
augroup MyAutoCmd
  autocmd!
  autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END

" Rename tmux window (CHANGED: BufEnter only, was too many events)
autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
autocmd VimLeave * call system("tmux setw automatic-rename")

" Insert leave fix
inoremap 'C-c' <C-c>:doautocmd InsertLeave<CR>

" Large file optimization - disable syntax for files >1MB
augroup LargeFile
  autocmd!
  autocmd BufReadPre * if getfsize(expand("%")) > 1000000 | syntax off | set noswapfile | set undolevels=-1 | endif
augroup END

" ================================ TMUX CURSOR ===============================
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

cmap w!! %!sudo tee > /dev/null

" ================================ NETRW =====================================
let g:netrw_preview        = 1
let g:netrw_liststyle      = 3           " tree structure
let g:netrw_banner         = 0           " remove banner
let g:netrw_browse_split   = 0
let g:netrw_winsize        = 25          " explorer width
let g:netrw_keepdir        = 1           " make netrw not change directory
let g:ag_working_path_mode = "r"

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  nnoremap <buffer> l <CR>
endfunction

" ================================ PLUGIN SETTINGS ===========================

" --- Lightline (replaced Airline) ---
let g:lightline = {
  \ 'colorscheme': 'catppuccin_mocha',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ], [ 'percent' ] ]
  \ },
  \ }

" OLD AIRLINE CONFIG - uncomment if you switch back to airline:
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 0
" let g:airline#extensions#whitespace#enabled = 0
" let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline_section_c = '%t %#__accent_green#%m'
" let g:airline_section_b = ""
" let g:airline_section_x = ""
" let g:airline_section_y = ""
" let g:airline_section_z = ""
" let g:airline_detect_whitespace=0

" --- CoC (deferred startup for faster loading) ---
" ADDED: Defer CoC until insert mode - remove if LSP doesn't work immediately
let g:coc_start_at_startup = 0
augroup CocDeferred
  autocmd!
  autocmd InsertEnter * ++once call coc#start()
augroup END

" --- JSX ---
let g:jsx_ext_required = 0

" --- EasyAlign ---
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)

" --- Fugitive (Git) ---
nnoremap <silent> <leader>gd :Git diff<CR>
nnoremap <silent> <leader>gs :vertical Gstatus<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gg :GBrowse<CR>

" --- Signify ---
" CHANGED: line_highlight = 0 for performance (was 1)
let g:signify_line_highlight = 0
highlight SignifyLineAdd ctermfg=Black ctermbg=Black guibg=#415d41
highlight SignifyLineChange ctermfg=Black ctermbg=Yellow guibg=#685a22
highlight SignifyLineDelete ctermfg=Black ctermbg=Red guibg=#682b22

" --- Rainbow ---
map <leader>l :RainbowLevelsToggle<cr>
let g:rainbow_active = 1
hi! link RainbowLevel0 Constant
hi! link RainbowLevel1 Type
hi! link RainbowLevel2 Function
hi! link RainbowLevel3 String
hi! link RainbowLevel4 PreProc
hi! link RainbowLevel5 Statement
hi! link RainbowLevel6 Identifier
hi! link RainbowLevel7 Normal
hi! link RainbowLevel8 Comment

" --- Startify ---
let g:startify_files_number = 15
let g:startify_change_to_vcs_root = 0
let g:startify_change_to_dir = 0

" --- Localorie (YAML) ---
nnoremap <leader>yyp :call ExpandPhraseKey()<CR>
function! ExpandPhraseKey()
  let @+=localorie#expand_key()
  echo @+
endfunction

" --- ALE ---
let b:ale_fixers = ['autopep8', "black", "add_blank_lines_for_python_control_statements", "autoimport", "reorder-python-imports", 'ruff', 'remove_trailing_lines', 'trim_whitespace']
let g:ale_fix_on_save = 1
" CHANGED: completion disabled - CoC handles this (was enabled)
let g:ale_completion_enabled = 0

" ================================ FUNCTIONS =================================
function! CopyCurrentFilePath()
  let @+ = expand('%')
  echo @+
endfunction

function! WindowNumber()
  let str=tabpagewinnr(tabpagenr())
  return str
endfunction

" Toggle quickfix window
nnoremap <silent> <Leader>c :call QuickFix_toggle()<CR>
function! QuickFix_toggle()
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  copen
endfunction

" Ripgrep with preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0 )

" Interactive join
let g:last_join_separator = " "
function! s:interactiveJoin(use_last_sep,...) range
  if (a:use_last_sep == 0)
    call inputsave()
    echohl Question
    let l:sep = input("Separator:", g:last_join_separator)
    echohl None
    call inputrestore()
    redraw!
    let g:last_join_separator = l:sep
  else
    let l:sep = g:last_join_separator
  endif

  if (a:0 == 0)
    let l:subst = 's/\s*\n\+\s*/\=' . "'" . l:sep . "'/"
  else
    let l:subst = 's/\n\+/\=' . "'" . l:sep . "'/"
  endif

  if a:firstline < a:lastline
    execute a:firstline . ',' . (a:lastline - 1) . l:subst
    let l:count = a:lastline - a:firstline + 1
  else
    execute l:subst
    let l:count = 1
  endif

  if (a:0 == 0)
    silent! call repeat#set("\<Plug>(repeatJoin)", l:count)
  else
    silent! call repeat#set("\<Plug>(repeatGJoin)", l:count)
  endif
endfunction

" Line break at pattern
command! -bang -nargs=* -range LineBreakAt <line1>,<line2>call LineBreakAt('<bang>', <f-args>)
function! LineBreakAt(bang, ...) range
  let save_search = @/

  if empty(a:bang)
    let before = ''
    let after = '\ze.'
    let repl = '&\r'
  else
    let before = '.\zs'
    let after = ''
    let repl = '\r&'
  endif
  let pat_list = map(deepcopy(a:000), "escape(v:val, '/\\.*$^~[')")
  let find = empty(pat_list) ? @/ : join(pat_list, '\|')
  let find = before . '\%(' . find . '\)' . after
  execute a:firstline . ',' . a:lastline . 's/'. find . '/' . repl . '/ge'
  let @/ = save_search
endfunction

" Jump or open new split
function! JumpOrOpenNewSplit(key, cmd, fzf)
  let current_window = winnr()
  execute 'wincmd' a:key

  if current_window == winnr()
    execute a:cmd
    if a:fzf
      Files
    else
      :Rg
    endif
  else
    if a:fzf
      Files
    else
      :Rg
    endif
  endif
endfunction

" List buffers for fzf
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! B call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

" YAML tree navigation
function! YAMLTree()
  let l:list = []
  let l:cur = getcurpos()[1]
  let l:indent = indent(l:cur) + 1

  for l:n in reverse(range(1, l:cur))
    let l:i = indent(l:n)
    let l:line = getline(l:n)
    let l:key = substitute(l:line, '^\s*\(\<\w\+\>\):.*', "\\1", '')

    if (l:i < l:indent && l:key !=# l:line)
      let l:list = add(l:list, l:key)
      let l:indent = l:i
    endif
  endfor
  let l:list = reverse(l:list)
  echo join(l:list, ' -> ')
endfunction

" FZF MRU
command! FZFMru call fzf#run({
  \  'source':  v:oldfiles,
  \  'sink':    'e',
  \  'options': '-m -x +s',
  \  'down':    '40%'})

" ============================================================================
