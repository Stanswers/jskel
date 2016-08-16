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
"  YouCompleteMe: code completion plugin Setup
"   1) dnf install automake gcc gcc-c++ kernel-devel cmake clang-devel python-devel python3-devel ncurses-compat-libs
"   2) Execute :PluginInstall
"   3) cd ~/.vim/bundle/YouCompleteMe
"   4) ./install.py --clang-completer --system-libclang
"   Reference: https://github.com/Valloric/YouCompleteMe
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
" General Key Mappings, Settings and Functions "{{{
"
" Map ,cd to change the local working directory to that of the current buffer
noremap <Leader>cd :lcd %:p:h<CR>
noremap <Leader>rts :RemoveTrailingSpaces<CR>

" Set display characters for list
set listchars=trail:~,tab:»·,eol:▼
" space was add in version 7.4.710
if has("patch-7.4.710")
	set listchars+=space:·
endif

" Display line numbers
set number

" Display right margin
if exists('+colorcolumn')
	set colorcolumn=80
endif

" Allow modified buffers to be hidden
set hidden

" Disable audio bell
set noerrorbells
if exists('+belloff')
	set belloff=all
endif

" Disable visual bell
set novb t_vb=

" Set the GUI font
set guifont=Consolas

" Always show status
set laststatus=2

" Indicates a fast terminal connection
set ttyfast

" tabs=2
set tabstop=2 shiftwidth=2

" tabs=4
autocmd FileType python,make,gitconfig,c,cpp setlocal tabstop=4 shiftwidth=4

" text like files: tabs=8
autocmd FileType markdown,help,text setlocal tabstop=8 shiftwidth=8 textwidth=78

" tabs->spaces
autocmd FileType c,cpp,sh,xml,html,java,perl setlocal expandtab

" turn on spell check
autocmd FileType gitcommit setlocal spell

" Trim trailing white space when writing
autocmd FileType python,make,c,cpp,java,php,xml,html,sh,vim
  \ autocmd BufWritePre <buffer> if ! &diff | :%s/\s\+$//e | endif

" Use ":DiffOrig" to see the differences
" between the current buffer and the file it was loaded from.
" see ":help DiffOrig"
if !exists(':DiffOrig')
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 \ | wincmd p | diffthis
endif

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
	Plugin 'altercation/vim-colors-solarized'
	Plugin 'mtth/scratch.vim'
	Plugin 'scrooloose/nerdtree'
	if v:version > 700
		Plugin 'Shougo/vimshell.vim'
		Plugin 'Shougo/vimproc.vim'
		Plugin 'scrooloose/nerdcommenter'
	endif
	if v:version > 702
		Plugin 'Chiel92/vim-autoformat'
	endif
	if v:version > 703
		Plugin 'Valloric/YouCompleteMe'
	endif
	" =========================== Finish Vundle Config ========================
	call vundle#end()                  " required
	filetype plugin indent on          " required
	" To ignore plugin indent changes, instead use:
	" filetype plugin on
	" =========================== Plugin Settings ==============================

	if isdirectory(glob("~/.vim/bundle/scratch.vim"))
		let g:scratch_autohide = 0         " Scratch plugin setting
	endif

	" YCM Settings
	if isdirectory(glob("~/.vim/bundle/YouCompleteMe"))
		let g:EclimCompletionMethod = 'omnifunc'
		let g:ycm_autoclose_preview_window_after_completion = 1
		set wildmode=longest,list,full
		set wildmenu
	endif

	" Solarized color theme
	if isdirectory(glob("~/.vim/bundle/vim-colors-solarized"))
		if $TERM != 'rxvt-256color' && ! has('gui_running')
			let g:solarized_termcolors=256   " Use degraded 256 color schema
			set t_Co=256
		endif
		if $TERM == 'rxvt-256color'
			let g:solarized_termtrans=1      " Transparant background
		endif
		let g:solarized_hitrail=1          " Hilight trailing white space
		set background=dark                " Configure solarized[dark|light]
		syntax enable                      " Enable syntax highlighting
		colorscheme solarized              " Activate solarized color scheme
	endif
endif
" }}}

" vim:foldmethod=marker:foldlevel=0:ts=2:noet
