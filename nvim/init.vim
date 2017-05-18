""""""""""""""""""""""""""""""
"          VIMPLUG           "
""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

" Basic
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'chriskempson/base16-vim'
Plug 'Shougo/context_filetype.vim'
Plug 'christoomey/vim-tmux-navigator'

" neovim basic
Plug 'neomake/neomake'
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" JAVA
Plug 'artur-shaik/vim-javacomplete2'

" JAVASCRIPT
Plug 'mxw/vim-jsx'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'pangloss/vim-javascript'
Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install' }
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install -g tern' }
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }

" HTML
Plug 'mattn/emmet-vim'
Plug 'othree/html5.vim'

" CSHARP
Plug 'OrangeT/vim-csharp'

"PYTHON
Plug 'zchee/deoplete-jedi'

" CPP
Plug 'zchee/deoplete-clang'
Plug 'Shougo/neoinclude.vim'

"RUST
Plug 'rust-lang/rust.vim'
Plug 'sebastianmarkow/deoplete-rust'

call plug#end()

syntax enable
filetype plugin indent on

if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif

" Must be bellow base16colorspace setup
" Allows for transparent background
hi Normal ctermbg=none
hi NonText ctermbg=none

inoremap jj <Esc>
set timeoutlen=1000 ttimeoutlen=0

set autoindent
set expandtab
set ts=2
set shiftwidth=2
set backspace=2 "backspace like most editors
set shiftround

set ignorecase
set smartcase
set ruler
set cursorline

set number
set relativenumber

set hlsearch
set showmatch

set splitbelow
set splitright

set mouse-=a

set pastetoggle=<F2>
map <F7> mzgg=G`z:%s/\s\+$//e

inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
let mapleader = ","


""""""""""""""""""""""""""""""
"          Undo              "
""""""""""""""""""""""""""""""
set undodir=~/.config/nvim/undodir
set undofile

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
"          Deoplete          "
""""""""""""""""""""""""""""""
let g:deoplete#enable_at_startup = 1
set completeopt=longest,menuone,preview

let g:deoplete#omni#functions = {}
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes.js = 'jsx'
let g:context_filetype#same_filetypes.jsx = 'js'

let g:deoplete#sources = {}
let g:deoplete#sources['javascript'] = ['buffer', 'ultisnips', 'ternjs']
let g:deoplete#sources['javascript.jsx'] = ['buffer', 'ultisnips', 'ternjs']

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let g:deoplete#omni#functions.javascript = [
  \ 'tern#Complete',
  \ 'jspc#omni'
\]

augroup omnifuncs
  autocmd!
  autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
augroup end

""""""""""""""""""""""""""""""
"          CPP               "
""""""""""""""""""""""""""""""
let g:deoplete#sources#clang = {}
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-3.8/lib/clang/'
let g:neoinclude#_paths='/home/dylan/freenect2/include'
setlocal path+=/home/dylan/freenect2/include

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

""""""""""""""""""""""""""""""
"          JAVASCRIPT        "
""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger="<C-j>"

let g:jsx_ext_required = 0
let g:user_emmet_settings = {'javascript.jsx': {'extends': 'jsx'}}

let g:tern_request_timeout = 1
let g:tern_show_signature_in_pum = '0'
let g:tern#filetypes = [ 'javascript', 'jsx', 'javascript.jsx' ]
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]

""""""""""""""""""""""""""""""
"          JAVA              "
""""""""""""""""""""""""""""""
autocmd BufNewFile,BufRead *.java :setlocal sw=4 ts=4 sts=4

""""""""""""""""""""""""""""""
"          HTML              "
""""""""""""""""""""""""""""""
autocmd BufNewFile,BufRead *.ejs set filetype=html
set matchpairs+=<:>
let g:html_indent_tags = 'li\|p'

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
  "Remove this when they fix neovim
  nnoremap <silent> <C-M> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <BS> :call TmuxOrSplitSwitch('h', 'L')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
  "Remove this when they fix neovim
  map <C-M> <C-w>j
  map <BS>  <C-w>h 
endif
