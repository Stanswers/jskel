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
"  VimRtags:
"    vim-rtags requires RTags to be installed.  See
"    doc/README.codecompletion.md and https://github.com/Andersbakken/rtags
"    for more information.
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
	Plugin 'altercation/vim-colors-solarized'
	Plugin 'mtth/scratch.vim'
	Plugin 'scrooloose/nerdtree'
	Plugin 'lyuts/vim-rtags'
	Plugin 'Shougo/neocomplete.vim'
	if v:version > 700
		Plugin 'Shougo/vimshell.vim'
		Plugin 'Shougo/vimproc.vim'
		Plugin 'scrooloose/nerdcommenter'
	endif
	if v:version > 701
		Plugin 'majutsushi/tagbar'
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

	"Autoformat settings
	if IsPluginInstalled('Chiel92/vim-autoformat')
		noremap <Leader>af :Autoformat<CR>
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

	" Setup Neocomplete for Cpp with vim-rtags
	if IsPluginInstalled('lyuts/vim-rtags') && IsPluginInstalled('Shougo/neocomplete.vim')
		function! SetupNeocomleteForCppWithRtags()
			setlocal omnifunc=RtagsCompleteFunc
			if !exists('g:neocomplete#sources#omni#input_patterns')
				let g:neocomplete#sources#omni#input_patterns = {}
			endif
			let l:cpp_patterns='[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
			let g:neocomplete#sources#omni#input_patterns.cpp = l:cpp_patterns
			set completeopt+=longest,menuone
		endfunction
		autocmd FileType cpp,c call SetupNeocomleteForCppWithRtags()
	endif

	" Setup neocomplete
	if IsPluginInstalled('Shougo/neocomplete.vim')
		let g:acp_enableAtStartup = 0
		let g:neocomplete#enable_at_startup = 1
		let g:neocomplete#enable_smart_case = 1
		let g:neocomplete#sources#syntax#min_keyword_length = 3
		let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
		let g:neocomplete#sources#dictionary#dictionaries = {
			\ 'default' : '',
			\ 'vimshell' : $HOME.'/.vimshell_hist',
			\ 'scheme' : $HOME.'/.gosh_completions'
		\ }
		if !exists('g:neocomplete#keyword_patterns')
			let g:neocomplete#keyword_patterns = {}
		endif
		let g:neocomplete#keyword_patterns['default'] = '\h\w*'
		inoremap <expr><C-g>     neocomplete#undo_completion()
		inoremap <expr><C-l>     neocomplete#complete_common_string()
		inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
		function! s:my_cr_function()
			return pumvisible() ? "\<C-y>" : "\<CR>"
		endfunction
		inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
		inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
		inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
		autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
		autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
		autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
		autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
		autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
		if !exists('g:neocomplete#sources#omni#input_patterns')
			let g:neocomplete#sources#omni#input_patterns = {}
		endif
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
"autocmd FileType python,make,c,cpp,java,php,xml,html,sh,vim
  "\ autocmd BufWritePre <buffer> if ! &diff | :%s/\s\+$//e | endif

" Use ":DiffOrig" to see the differences
" between the current buffer and the file it was loaded from.
" see ":help DiffOrig"
if !exists(':DiffOrig')
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 \ | wincmd p | diffthis
endif

" }}}

" vim:foldmethod=marker:foldlevel=0:ts=2:noet
