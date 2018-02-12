""""""""""""""""""""""""""""""
"          VIMPLUG           "
""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

" Syntax
Plug 'mxw/vim-jsx'
Plug 'chr4/nginx.vim'
Plug 'othree/html5.vim'
Plug 'rust-lang/rust.vim'
Plug 'jparise/vim-graphql'
Plug 'pangloss/vim-javascript'

" Completion
Plug 'Shougo/context_filetype.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins', 'tag': '4.0-serial' }
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install -g tern' }
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-clang'
Plug 'Shougo/neoinclude.vim'
Plug 'sebastianmarkow/deoplete-rust'

" TMUX
Plug 'christoomey/vim-tmux-navigator'

" Other
Plug 'mattn/emmet-vim'
Plug 'neomake/neomake', { 'commit': '63b02e3475a44eb91ea2444d1fe923363df4979c' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'chriskempson/base16-vim'
Plug 'terryma/vim-multiple-cursors'

call plug#end()

syntax enable
filetype plugin indent on

if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif

"Must be bellow base16colorspace setup
"Allows for transparent background
hi Normal ctermbg=none
hi NonText ctermbg=none

" Use jj to enter command mode
inoremap jj <Esc>
set timeoutlen=1000 ttimeoutlen=0

" Set up 2 space tabs
set autoindent
set expandtab
set ts=2
set shiftwidth=2
set backspace=2
set shiftround

" Search settings
set ignorecase
set smartcase
set hlsearch
set showmatch

" Current line highlight
set ruler
set cursorline

" Relative numbering
set number
set relativenumber

" Split settings
set splitbelow
set splitright

" Remove mouse mode
set mouse-=a

" Paste toggle
set pastetoggle=<F2>

" F7 for reindent + trim whitespace
map <F7> mzgg=G`z:%s/\s\+$//e

" I dont use leaders but if I did it would be ,
let mapleader = ","

""""""""""""""""""""""""""""""
"          Undo              "
""""""""""""""""""""""""""""""
set undodir=~/.config/nvim/undodir
set undofile

""""""""""""""""""""""""""""""
"          Filetype          "
""""""""""""""""""""""""""""""
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes.js = 'jsx'
let g:context_filetype#same_filetypes.jsx = 'js'

""""""""""""""""""""""""""""""
"          Deoplete          "
""""""""""""""""""""""""""""""
let g:deoplete#enable_at_startup = 1

imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let g:deoplete#enable_camel_case = 1
set completeopt=longest,menuone,preview
let g:deoplete#enable_refresh_always = 1
let g:deoplete#file#enable_buffer_path = 1
let g:deoplete#tag#cache_limit_size = 800000

let g:deoplete#sources = get(g:, 'deoplete#sources', {})
let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})

let g:deoplete#omni#functions = get(g:, 'deoplete#omni#functions', {})
let g:deoplete#omni#functions.css = 'csscomplete#CompleteCSS'
let g:deoplete#omni#functions.html = 'htmlcomplete#CompleteTags'
let g:deoplete#omni#functions.markdown = 'htmlcomplete#CompleteTags'

let g:deoplete#omni_patterns = get(g:, 'deoplete#omni_patterns', {})
let g:deoplete#omni_patterns.html = '<[^>]*'

call deoplete#custom#set('omni',          'mark', '⌾')
call deoplete#custom#set('ternjs',        'mark', '⌁')
call deoplete#custom#set('jedi',          'mark', '⌁')
call deoplete#custom#set('vim',           'mark', '⌁')
call deoplete#custom#set('neosnippet',    'mark', '⌘')
call deoplete#custom#set('tag',           'mark', '⌦')
call deoplete#custom#set('around',        'mark', '↻')
call deoplete#custom#set('buffer',        'mark', 'ℬ')
call deoplete#custom#set('tmux-complete', 'mark', '⊶')
call deoplete#custom#set('syntax',        'mark', '♯')

call deoplete#custom#set('vim',           'rank', 630)
call deoplete#custom#set('ternjs',        'rank', 620)
call deoplete#custom#set('jedi',          'rank', 610)
call deoplete#custom#set('omni',          'rank', 600)
call deoplete#custom#set('neosnippet',    'rank', 510)
call deoplete#custom#set('member',        'rank', 500)
call deoplete#custom#set('file_include',  'rank', 420)
call deoplete#custom#set('file',          'rank', 410)
call deoplete#custom#set('tag',           'rank', 400)
call deoplete#custom#set('around',        'rank', 330)
call deoplete#custom#set('buffer',        'rank', 320)
call deoplete#custom#set('dictionary',    'rank', 310)
call deoplete#custom#set('tmux-complete', 'rank', 300)
call deoplete#custom#set('syntax',        'rank', 200)

call deoplete#custom#set('_', 'converters', [
	\ 'converter_remove_paren',
	\ 'converter_remove_overlap',
	\ 'converter_truncate_abbr',
	\ 'converter_truncate_menu',
	\ 'converter_auto_delimiter',
	\ ])

""""""""""""""""""""""""""""""
"          Multiple          "
""""""""""""""""""""""""""""""
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

""""""""""""""""""""""""""""""
"          NeoMake           "
""""""""""""""""""""""""""""""
let g:neomake_open_list = 2
let g:neomake_list_height = 5
let g:neomake_java_enabled_makers = []

if filereadable($PWD .'/node_modules/.bin/eslint')
  let g:neomake_jsx_enabled_makers = ['eslint']
  let g:neomake_jsx_eslint_exe = $PWD .'/node_modules/.bin/eslint'
  let g:neomake_javascript_enabled_makers = ['eslint']
  let g:neomake_javascript_eslint_exe = $PWD .'/node_modules/.bin/eslint'
endif

autocmd! BufWritePost * Neomake
let g:neomake_dot_maker = { 'exe': 'dotnet', 'args': ['build'] }

""""""""""""""""""""""""""""""
"          CPP               "
""""""""""""""""""""""""""""""
let g:neoinclude#paths = {}
let g:deoplete#sources#clang = {}
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-3.8/lib/clang/'

""""""""""""""""""""""""""""""
"          RUST              "
""""""""""""""""""""""""""""""
let g:deoplete#sources#rust#racer_binary='/home/dylan/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/home/dylan/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
let g:deoplete#sources#rust#disable_keymap=1
let g:deoplete#sources#rust#documentation_max_height=20
nmap <buffer> gd <plug>DeopleteRustGoToDefinitionDefault
nmap <buffer> K  <plug>DeopleteRustShowDocumentation

""""""""""""""""""""""""""""""
"          MARKDOWN          "
""""""""""""""""""""""""""""""
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

""""""""""""""""""""""""""""""
"          PYTHON            "
""""""""""""""""""""""""""""""
let python_highlight_all = 1
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``
autocmd BufNewFile,BufRead *.py :setlocal sw=4 ts=4 sts=4

let g:deoplete#sources#jedi#statement_length = 30
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#short_types = 1

""""""""""""""""""""""""""""""
"          JAVASCRIPT        "
""""""""""""""""""""""""""""""
let g:jsx_ext_required = 0
let g:deoplete#sources#ternjs#types = 1
let g:user_emmet_settings = {'javascript.jsx': {'extends': 'jsx'}}
let g:deoplete#sources#ternjs#filetypes = [ 'jsx', 'javascript.jsx', 'vue', 'javascript' ]

""""""""""""""""""""""""""""""
"          JAVA              "
""""""""""""""""""""""""""""""
autocmd BufNewFile,BufRead *.java :setlocal sw=4 ts=4 sts=4

""""""""""""""""""""""""""""""
"          HTML              "
""""""""""""""""""""""""""""""
set matchpairs+=<:>
let g:html_indent_tags = 'li\|p'
autocmd BufNewFile,BufRead *.ejs set filetype=html

""""""""""""""""""""""""""""""
"          TABS              "
""""""""""""""""""""""""""""""
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tt :tabnew<CR>

""""""""""""""""""""""""""""""
"          CTRLP             "
""""""""""""""""""""""""""""""
let g:ctrlp_map = '<c-n>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|dist'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

""""""""""""""""""""""""""""""
"          TMUX              "
""""""""""""""""""""""""""""""
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr> 
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif
