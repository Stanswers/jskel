" Name:     .vimrc
" Author:   Justin Helgesen <justinhelgesen@gmail.com>
" Created:  On a cold winter night in the year of the sheep
"
" Useage "{{{
"
" ---------------------------------------------------------------------
" ABOUT:
" ---------------------------------------------------------------------
" This is my vimrc file.  Setup is intended to be generic as possible
" accross a wide range of systems which I commonly use.
"
" Fitness for anyone else is purely coincidental.
"
" ---------------------------------------------------------------------
" PLUGIN INSTALLATION:
" ---------------------------------------------------------------------
"  Vundle:
"   1) Clone repo
"      $ mkdir -p ~/.vim/bundle
"      $ cd ~/.vim/bundle
"      $ git clone https://github.com/VundleVim/Vundle.vim.git
"   2) Install other plugins by executing :PluginInstall
"   Reference: https://github.com/VundleVim/Vundle.vim
"
"  VimProc:
"   1) Execute :PluginInstall
"   2) $ cd ~/.vim/bundle/vimproc.vim
"      $ make
"   References: :help vimproc
"
"  VimAutoFormat:
"   Optional External Format Programs:
"     clang-format: provided by clang - supports C, C++, Objective-C
"     astyle: provided by astyle - supports C#, C++, C Java
"     autopep8: provided by python-autopep8 - supports Python
"     tidy: proficec by tidy - supports HTML, XHTML, XML
"     js-beautify: profided by pip's jsbeautifier - supports javascript, json
"     For more see references.
"
"   1) dnf install astyle clang python-autopep8 tidy
"   2) pip install jsbeautifier
"   3) Execute :PluginInstall
"   References: https://github.com/Chiel92/vim-autoformat
"
" }}}
" Plugin Settings "{{{
"

" Only configure plugins if vundle is installed
if isdirectory(glob("~/.vim/bundle/Vundle.vim"))
  " =========================== Vundle Config ================================
  set nocompatible                   " be iMproved, required
  filetype off                       " required
  set rtp+=~/.vim/bundle/Vundle.vim  " set the runtime path to include Vundle
  call vundle#begin()                " initialize Vundle
  " =========================== Activate Plugins below =======================
  Plugin 'gmarik/Vundle.vim'         " let Vundle manage Vundle, required
  Plugin 'tpope/vim-fugitive'
  Plugin 'mileszs/ack.vim'
  Plugin 'altercation/vim-colors-solarized'
  Plugin 'mtth/scratch.vim'
  Plugin 'scrooloose/nerdtree'
  Plugin 'davidhalter/jedi-vim'
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
  "Plugin 'junegunn/fzf'
  "Plugin 'junegunn/fzf.vim'
  if v:version > 900
    Plugin 'ycm-core/YouCompleteMe'
  endif
  if v:version > 700
    Plugin 'Shougo/vimshell.vim'
    Plugin 'Shougo/vimproc.vim'
    Plugin 'scrooloose/nerdcommenter'
  endif
  if v:version > 702
    Plugin 'Chiel92/vim-autoformat'
  endif
  " =========================== Finish Vundle Config ========================
  call vundle#end()                  " required
  filetype plugin indent on          " required
  " To ignore plugin indent changes, instead use:
  " filetype plugin on
  " =========================== Plugin Settings ==============================

  let g:my#bundles = map(copy(g:vundle#bundles), 'v:val.name_spec')
  function! IsPluginInstalled(name)
    return index(g:my#bundles, a:name) > -1
  endfunction

  if IsPluginInstalled('vim-airline/vim-airline')
    let g:airline#extensions#tabline#enabled = 0
    if g:airline#extensions#tabline#enabled != 0
      let g:airline#extensions#tabline#buffer_idx_mode = 1
      nmap <leader>1 <Plug>AirlineSelectTab1
      nmap <leader>2 <Plug>AirlineSelectTab2
      nmap <leader>3 <Plug>AirlineSelectTab3
      nmap <leader>4 <Plug>AirlineSelectTab4
      nmap <leader>5 <Plug>AirlineSelectTab5
      nmap <leader>6 <Plug>AirlineSelectTab6
      nmap <leader>7 <Plug>AirlineSelectTab7
      nmap <leader>8 <Plug>AirlineSelectTab8
      nmap <leader>9 <Plug>AirlineSelectTab9
      nmap <leader>- <Plug>AirlineSelectPrevTab
      nmap <leader>= <Plug>AirlineSelectNextTab
      nmap <leader>+ <Plug>AirlineSelectNextTab
    endif
  endif

  "Autoformat settings
  if IsPluginInstalled('Chiel92/vim-autoformat')
    let g:formatterpath = ['/opt/llvm-14/bin/']
    let g:formatdef_my_custom_json='"js-beautify -s 2 -P -n -b expand "'
    let g:formatters_json = ['my_custom_json']
    noremap <Leader>af :Autoformat<CR>
  endif

  " YouCompleteMe
  if IsPluginInstalled('ycm-core/YouCompleteMe')
    let g:ycm_clangd_binary_path='/opt/llvm-14/bin/clangd'
    let g:ycm_clangd_args=[
      \ '-background-index',
      \ '-completion-style=bundled',
      \ '-j=16',
      \ '-header-insertion=iwyu',
      \ '--query-driver=/usr/**/*,/opt/**/*',
      \ '--suggest-missing-includes'
      \ ]
		noremap gd :YcmCompleter GoTo<CR>
  endif

  " NERDTree Settings
  if IsPluginInstalled('scrooloose/nerdtree')
    noremap <Leader>nt :NERDTreeToggle<CR>
    noremap <Leader>nc :NERDTreeClose<CR>
    noremap <Leader>nf :NERDTreeFind<CR>
  endif

  " Tagbar Settings
  if IsPluginInstalled('majutsushi/tagbar')
    noremap <Leader>ol :TagbarToggle<CR>
  endif

  " Scratch Setting
  if IsPluginInstalled('mtth/scratch.vim')
    let g:scratch_autohide = 0
  endif

  " Solarized color theme
  if IsPluginInstalled('altercation/vim-colors-solarized')
    if $TERM !~ '\.*256color$' && ! has('gui_running')
      let g:solarized_termcolors=256   " Use degraded 256 color schema
      set t_Co=256
    endif
    if $TERM == 'rxvt-256color'
      let g:solarized_termtrans=1      " Transparant background
      if exists('$WSL_INTEROP')
        set term=screen-256color       " Fix colors in WSL
      endif
    endif
    let g:solarized_hitrail=1          " Hilight trailing white space
    set background=dark                " Configure solarized[dark|light]
    syntax enable                      " Enable syntax highlighting
    colorscheme solarized              " Activate solarized color scheme
  endif
endif
" }}}
" General Key Mappings, Settings and Functions "{{{
"
" Change the local working directory to that of the current buffer
noremap <Leader>cd :lcd %:p:h<CR>

" Remove trailing white space
noremap <Leader>rts :%s/\s\+$//e \| :noh<CR>
noremap <Leader>rt :s/\s\+$//e \| :noh<CR>

" Enable mouse in terminal for all modes if clipboard is enabled
if has("clipboard")
  set mouse=a
endif

" Set display characters for list
set listchars=trail:~,tab:»·,eol:▼

" space was add in version 7.4.710
if has("patch-7.4.710")
  set listchars+=space:·
endif

" Display line numbers
set relativenumber

" Display right margin
if exists('+colorcolumn')
  set colorcolumn=80
endif

" Enable enhanced command-line completion
set wildmenu
" Complete longest common string => lists alternatives => each full match
set wildmode=longest,list,full

" Allow modified buffers to be hidden
set hidden

" Disable audio bell
set noerrorbells
if exists('+belloff')
  set belloff=all
endif

" Disable visual bell
" set novb t_vb=
set vb t_vb=

" Set the GUI font
set guifont=Consolas

" Always show status
set laststatus=2

" Disable incremental search
set noincsearch

" Indicates a fast terminal connection
set ttyfast

set makeprg=tbmake\ -sj\ TESTS=NO\ RECURSIVE=NO

autocmd FileType sh setlocal makeprg=shellcheck\ %

" tabsstop = shiftwidth = softtabstop
set tabstop=2 shiftwidth=0 softtabstop=-1

" Default to expandtab
set expandtab

" Fix issue where json file was detected as javascript
" NB: Must be executed before any "autocmd FileType"
autocmd BufEnter *.json :setlocal filetype=json

" tabs=2
autocmd FileType java,sh,html,xhtml,css setlocal tabstop=2

" tabs=4
autocmd FileType go,python,make,gitconfig,c,cpp,xml,xslt,xsd,json setlocal tabstop=4

" tabs=8
autocmd FileType markdown,help,text,make setlocal tabstop=8

" text like files: set text width
autocmd FileType markdown,help,text setlocal textwidth=78

" tabs->spaces
autocmd FileType c,cpp,sh,xml,html,java,perl,python,json setlocal expandtab

" tabs
autocmd FileType make setlocal noexpandtab

" turn on spell check
autocmd FileType gitcommit setlocal spell

" Trim trailing white space when writing
"autocmd FileType python,make,c,cpp,java,php,xml,html,sh,vim
"\ autocmd BufWritePre <buffer> if ! &diff | :%s/\s\+$//e | endif

" Use ":DiffOrig" to see the differences
" between the current buffer and the file it was loaded from.
" see ":help DiffOrig"
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" Syntax highlighting sucks for long lines, limit it to 365 characters
set synmaxcol=365

" }}}

" vim:foldmethod=marker:foldlevel=0:ts=2:noet
