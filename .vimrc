" ##################################### PLUGS  #########################################################
"
  filetype plugin on

" source vimplugs
  call plug#begin('~/.vim/autoload')
      source ~/.vim/plugins.vim
  call plug#end()

" autoload
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif

  source ~/.vim/coc-plugin.vim


" NVIM
map Q @@
"set term=screen-256color
let g:airline_powerline_fonts = 1
"let g:tmuxline_preset = {
            "\ 'a': '#S',
            "\ 'win': '#I #W',
            "\ 'cwin': '#I #W',
            "\ 'z': '%I:%M',
            "\ 'options': {
            "\'status-justify': 'left'}}
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
" don't show path
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_section_c = '%t %#__accent_green#%m'
let g:jsx_ext_required = 0
let g:airline_section_b = ""
let g:airline_section_x = ""
let g:airline_section_y = ""
let g:airline_section_z = ""
let g:airline_detect_whitespace=0
"let g:airline_theme='icebergDark'



"let &runtimepath = '~/.vim/bundle/rainbow,' . &runtimepath

" ##################################### THEME  #########################################################
  "set statusline=%{WindowNumber()}\ %f\ %h%w%m%r%=%-14.(%l,%c%V%)\ %P
  set t_Co=256
  set background=dark
  colorscheme nord
  au ColorScheme * hi Normal ctermbg=None
  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif

" ##################################### HIGHLIGHT  #########################################################
  highlight Visual cterm=bold ctermbg=Green ctermfg=Black
  highlight CursorLine cterm=underline term=underline ctermbg=NONE guibg=NONE
  highlight clear SignColumn
  highlight clear LineNr
  highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
  highlight Comment cterm=italic gui=italic

" ##################################### SET  #########################################################
  set re=0                                 " typescript regex for vim8
  set nocompatible                         "  system-wide vimrc
  set backspace=indent,eol,start           "  backspace over indentation, etc
  set ruler                                "  always show cursor position
  set splitright                           "  default split right
  set mouse=a                              " use mouse
  set cursorline                           "  line at cursor row
  set incsearch                            "  incremental search for partial /
  set hlsearch                             "  search highlighting /
  set showcmd                              "  show command on bottom
  set autoread                             "  reread files if unmodified
  set autoindent                           "  new line inherits indent
  set smartindent                          "  new line inherits indent
  set expandtab                            "  tabs to spaces
  set tabstop=4
  set softtabstop=2
  set shiftwidth=2
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip "  ignore these types of files
  set history=1000                         "  increase undo limit
  set nowrap                               "  disable auto wrap
  set hidden                               "  save previous buffer stuff
  " set path=$PWD/**                       " makes current vim path relative
  set noautochdir                          " no redirecting directory
  set ignorecase                           "  ignore case for search
  set smartcase                            "  automatically convert search to uppercase
  set noswapfile                           "  disable swap files
  set tags=tags;/                          "  tags
  set clipboard^=unnamed,unnamedplus       "  use system clipboard
  set scrolloff=10                         "  lines of buffer between top and bottom
  set ttimeout
  set ttimeoutlen=0
  set timeoutlen=600                       "  time in between commands v,c
  syntax enable                            "  colors, overrule with on
  set number relativenumber
  set numberwidth=2
  let &t_ZH="\e[3m"                        "  italics
  let &t_ZR="\e[23m"                       "  italics

" ##################################### MAPS  #########################################################

" BEFORE I FORGET
" delete empty lines in visual
  vnoremap de :g/^\s*$/d<CR>:noh<CR>  
  map Q @@

" text 
  map <Space> <Leader>
  let mapleader = "\<Space>"
  nmap ; :
  nnoremap J 5j
  nnoremap K 5k
  noremap vA ggVG
  inoremap jj <ESC>
  nnoremap <silent> vv <C-w>v
  nnoremap H {
  nnoremap L }
  nnoremap qq :close<cr>
  map <leader>r viw"0p
  set pastetoggle=<F2>
  noremap U <C-r><CR>

  inoremap <C-w> <C-\><C-o>dB
  inoremap <C-BS> <C-\><C-o>db

  nnoremap Y ^y$
  noremap d "_d
  noremap dd "_dd
  noremap D "_D
  noremap c "_c
  noremap cc "_cc
  noremap C "_C
  nnoremap X yydd

  vnoremap d "_d
  vnoremap dd "_dd
  vnoremap D "_D
  vnoremap c "_c
  vnoremap cc "_cc
  vnoremap C "_C

" windows
  nmap <Leader>w :w<CR>
  nmap <Leader>q :q<CR>
  cnoreabbrev b :Buffers
  nmap <Leader>b :Buffers<CR>
  nmap <Leader>Q :History<CR>
  cnoreabbrev QQ :browse oldfiles 
  cnoreabbrev Q :History
  cnoreabbrev .. cd ..

" duplicate
  noremap du Yp
  vnoremap du yp

" split
  vnoremap s :LineBreakAt
  nnoremap S :LineBreakAt

" joins
  noremap <silent> <Plug>(interactiveJoin)  :call <SID>interactiveJoin(0)<CR>
  noremap <silent> <Plug>(interactiveGJoin) :call <SID>interactiveJoin(0,'g')<CR>
  noremap <silent> <Plug>(repeatJoin)       :call <SID>interactiveJoin(1)<CR>
  noremap <silent> <Plug>(repeatGJoin)      :call <SID>interactiveJoin(1,'g')<CR>
  nmap z <Plug>(interactiveJoin)
  xmap z <Plug>(interactiveJoin)
  nmap gJ <Plug>(interactiveGJoin)
  xmap gJ <Plug>(interactiveGJoin)

" autocomplete
  "imap bp binding.pry
  "imap bpp <%= binding.pry %>

" source / edit
  cnoreabbrev sv :source $MYVIMRC<CR>         
  cnoreabbrev ve :vsplit $MYVIMRC<CR>         
  cnoreabbrev ze :vsplit ~/.zshrc<CR>         
  cnoreabbrev te :vsplit ~/.tc_settings<CR>   
  cnoreabbrev N :e ~/notes.md<CR>Go<CR>  
  cnoreabbrev n :vsplit ~/notes.md<CR>Go<CR>  

  "nnoremap <Leader>yp :let @+=expand("%")<CR> 
  nnoremap <Leader>yp :call CopyCurrentFilePath()<CR> 
  " Copy current file path to clipboard
  nnoremap <leader>% :call CopyCurrentFilePath()<CR>

" switch pane
  nnoremap <Leader><space> <c-w><c-p>
  nnoremap <Leader>0 <c-w><c-p>

  inoremap 'C-c' <C-c>:doautocmd InsertLeave<CR>

" save session
  cnoreabbrev save :SSave
  cnoreabbrev load :SLoad
  cnoreabbrev delete :SDelete


" ##################################### AUTO  #########################################################
  augroup numbertoggle "only use relativenumber on current window
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  augroup END

"  auto read when leaving window
  au FocusLost,WinLeave * :silent! noautocmd w
  au FocusGained,BufEnter * :checktime
  au CursorHold,CursorHoldI * checktime

" Source vim configuration file whenever it is saved
  "autocmd bufwritepost .vimrc source $MYVIMRC
  augroup MyAutoCmd
    autocmd!
    autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
  augroup END

"  rename tmux window to file name
  autocmd BufReadPost,FileReadPost,BufNewFile,FocusGained * call system("tmux rename-window " . expand("%:t"))                                                                                                                                                                                                         
  autocmd VimLeave * call system("tmux setw automatic-rename")

" ##################################### TMUX / WINDOW #########################################################

  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif

  cmap w!! %!sudo tee > /dev/null

  nnoremap  <silent><leader><tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:b#<CR>
  nnoremap  <silent> <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
  nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

  nnoremap <leader>b :Buffers<CR>
  nnoremap <leader>B :B<CR>
  "nnoremap <silent>bb :Buffers<CR>

  nnoremap <leader>v :vsp<space>\|:Buffers<CR>
  nnoremap <silent>vv :vsp<space>\|:Buffers<CR>

  "nnoremap <leader>s :sp<space>\|:Buffers<CR>
  nnoremap <leader>s :vsplit<CR>:Startify<CR>
  cnoreabbrev s :vsplit<CR>:Startify<CR>

  nnoremap <leader>o :only

  "resize window
  nnoremap <silent> <Leader>> 30<C-w>>
  nnoremap <silent> <Leader>< 30<C-w><
  nnoremap <silent> <Leader>= <C-w>=

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

  nnoremap <Leader>H<Space>  :leftabove  vnew<CR>:Files!<CR>
  nnoremap <Leader>L<Space>  :rightbelow vnew<CR>:Files!<CR>
  nnoremap <Leader>K<Space>  :leftabove  new<CR>:Files!<CR>
  nnoremap <Leader>J<Space>  :rightbelow new<CR>:Files!<CR>

  nnoremap <silent> <Leader>hh :call JumpOrOpenNewSplit('h', ':leftabove vnew', 1)<CR>
  nnoremap <silent> <Leader>ll :call JumpOrOpenNewSplit('l', ':rightbelow vnew', 1)<CR>
  nnoremap <silent> <Leader>kk :call JumpOrOpenNewSplit('k', ':leftabove vnew', 1)<CR>
  nnoremap <silent> <Leader>jj :call JumpOrOpenNewSplit('j', ':rightbelow vnew', 1)<CR>

  nnoremap <silent> <Leader>h<Space> :call JumpOrOpenNewSplit('h', ':leftabove vsplit', 0)<CR>
  nnoremap <silent> <Leader>l<Space> :call JumpOrOpenNewSplit('l', ':rightbelow vsplit', 0)<CR>
  nnoremap <silent> <Leader>k<Space> :call JumpOrOpenNewSplit('k', ':leftabove split', 0)<CR>
  nnoremap <silent> <Leader>j<Space> :call JumpOrOpenNewSplit('j', ':rightbelow split', 0)<CR>

" ##################################### NETRW  #########################################################
  let g:netrw_preview        = 1
  let g:netrw_liststyle      = 3      " tree structure
  let g:netrw_banner         = 0         " remove banner
  let g:netrw_browse_split   = 2   " default open vertical split
  let g:netrw_winsize        = 25       " explorer width
  let g:netrw_keepdir        = 1        " make netrw not change directory
  let g:ag_working_path_mode = "r" " ag stuff

  augroup netrw_mapping
   autocmd!
   autocmd filetype netrw call NetrwMapping()
  augroup END

  function! NetrwMapping()
      nnoremap <buffer> l <CR>
  endfunction

" ##################################### SEARCH  #########################################################
  nmap s <Plug>(easymotion-bd-f)
  cnoreabbrev rg Rg
  cnoreabbrev files GFiles
  cnoreabbrev f GFiles
  "nnoremap <silent>ff :Rg <c-r>=expand("")<cr>
  nnoremap ff :Rg<cr>
  nnoremap <silent>FF :Files<cr>
  "map <leader>F :Files <c-r>=expand("")<cr>
  map <leader>f :rg <c-r>=expand("<cword>")<cr><cr>
  " go to definition
  nnoremap <leader>d :vsplit<CR>:exec("tag ".expand("<cword>"))<CR>

" netrw tree
  map <leader>t :Explore<cr>
  map <leader>/ <Plug>NERDCommenterToggle

" next / previous in search
  map <C-n> :cn<CR>
  map <C-p> :cp<CR>

" ##################################### FUNCTIONS  #########################################################
  function! CopyCurrentFilePath()
    let @+ = expand('%')
    echo @+
  endfunction
  
  " Switch between windows
  let i = 1
  while i <= 9
    execute 'nnoremap <Leader>' . i . ' :' . i . 'wincmd w<CR>'
    let i = i + 1
  endwhile

  " put window # in status line
  function! WindowNumber()
    let str=tabpagewinnr(tabpagenr())
    return str
  endfunction

  "  turn off quickfix (annoying thing on bottom of screen) w/ <Leader + c>
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

"RIPGREP
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0 )
" RG full screen
  "command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" INTERACTIVE JOIN
  let g:last_join_separator = " "
  function! s:interactiveJoin(use_last_sep,...) range
      if (a:use_last_sep == 0) "interactive, ask for separator to use
          call inputsave()
          echohl Question
          let l:sep = input("Separator:", g:last_join_separator)
          echohl None
          call inputrestore()
          redraw!
          let g:last_join_separator = l:sep "update last separator value
      else "non-interactive (when repeating with '.')
          let l:sep = g:last_join_separator
      endif
      if (a:0 == 0) "with no argument, remove indentation *and trailing spaces*
          let l:subst = 's/\s*\n\+\s*/\=' . "'" . l:sep . "'/"
      else " don't remove indentation or trailing spaces (act like 'gJ')
          let l:subst = 's/\n\+/\=' . "'" . l:sep . "'/"
      endif
      if a:firstline < a:lastline "join given range
          execute a:firstline . ',' . (a:lastline - 1) . l:subst
          let l:count = a:lastline - a:firstline + 1 "default count for repeat
      else "or join only with next line
          execute l:subst
          let l:count = 1 "default count for repeat
      endif
      "make command repeatable
      "(with the tpope/vim-repeat plugin: optional, recommended)
      if (a:0 == 0)
          silent! call repeat#set("\<Plug>(repeatJoin)", l:count)
      else
          silent! call repeat#set("\<Plug>(repeatGJoin)", l:count)
      endif
  endfunction

  command! -bang -nargs=* -range LineBreakAt <line1>,<line2>call LineBreakAt('<bang>', <f-args>)
  "figure out how to == fix line indent
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
    " Example: 10,20s/\%(arg1\|arg2\|arg3\)\ze./&\r/ge
    execute a:firstline . ',' . a:lastline . 's/'. find . '/' . repl . '/ge'
    let @/ = save_search
  endfunction

  function! JumpOrOpenNewSplit(key, cmd, fzf) " {{{
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
  endfunction " }}}

  "ADD LEADER L F to CREATE NEW FIND WINDOW
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

  function! YAMLTree()
      let l:list = []
      let l:cur = getcurpos()[1]
      " Retrieve the current line indentation
      let l:indent = indent(l:cur) + 1
      " Loop from the cursor position to the top of the file
      for l:n in reverse(range(1, l:cur))
          let l:i = indent(l:n)
          let l:line = getline(l:n)
          let l:key = substitute(l:line, '^\s*\(\<\w\+\>\):.*', "\\1", '')
          " If the indentation decreased and the pattern matched
          if (l:i < l:indent && l:key !=# l:line)
              let l:list = add(l:list, l:key)
              let l:indent = l:i
          endif
      endfor
      let l:list = reverse(l:list)
      echo join(l:list, ' -> ')
  endfunction


" ##################################### PLUGIN SETTINGS ########################

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)

nnoremap <silent> <leader>gd :Git diff<CR>
nnoremap <silent> <leader>gs :vertical Gstatus<CR>
nnoremap <silent> <leader>gb :Git blame<CR>

let g:signify_line_highlight = 1
highlight SignifyLineAdd ctermfg=Black ctermbg=Black guibg=#415d41
highlight SignifyLineChange ctermfg=Black ctermbg=Yellow guibg=#685a22
highlight SignifyLineDelete ctermfg=Black ctermbg=Red guibg=#682b22

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

let g:startify_files_number = 15
let g:startify_change_to_vcs_root = 0
let g:startify_change_to_dir = 0


nnoremap <leader>yyp :call ExpandPhraseKey()<CR>
function! ExpandPhraseKey()
    let @+=localorie#expand_key()
    echo @+
endfunction

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

command! FZFMru call fzf#run({
      \  'source':  v:oldfiles,
      \  'sink':    'e',
      \  'options': '-m -x +s',
      \  'down':    '40%'})
