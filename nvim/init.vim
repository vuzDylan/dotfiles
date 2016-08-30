""""""""""""""""""""""""""""""
"          VIMPLUG           "
""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/context_filetype.vim'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'christoomey/vim-tmux-navigator'
Plug 'neomake/neomake'
Plug 'terryma/vim-multiple-cursors'
Plug 'chriskempson/base16-vim'

call plug#end()

syntax enable
filetype plugin indent on

if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif

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
map <F7> mzgg=G`z

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

if filereadable($PWD .'/node_modules/.bin/eslint')
  let g:neomake_jsx_enabled_makers = ['eslint']
  let g:neomake_jsx_eslint_exe = $PWD .'/node_modules/.bin/eslint'
  let g:neomake_javascript_enabled_makers = ['eslint']
  let g:neomake_javascript_eslint_exe = $PWD .'/node_modules/.bin/eslint'
endif

autocmd! BufWritePost * Neomake

""""""""""""""""""""""""""""""
"          Deoplete          "
""""""""""""""""""""""""""""""
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes.js = 'jsx'
let g:context_filetype#same_filetypes.jsx = 'js'
let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

if exists('g:plugs["tern_for_vim"]')
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1
  autocmd FileType javascript setlocal omnifunc=tern#Complete
endif

""""""""""""""""""""""""""""""
"          MARKDOWN           "
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
let g:jsx_ext_required = 0

""""""""""""""""""""""""""""""
"          HTML              "
""""""""""""""""""""""""""""""
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
  "Remove this when they fix neovim
  nnoremap <silent> <BS> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  "Remove this when they fix neovim
  map <BS>  <C-w>h 
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif
