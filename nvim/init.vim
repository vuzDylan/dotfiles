""""""""""""""""""""""""""""""
"          VIMPLUG           "
""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

" Syntax plugin
Plug 'sheerun/vim-polyglot'

" Linting
Plug 'w0rp/ale'

" Emmet for html and jsx
Plug 'mattn/emmet-vim'

" Fuzzy finding
Plug 'ctrlpvim/ctrlp.vim'

" Vim surround
Plug 'tpope/vim-surround'

" Color schema
Plug 'chriskempson/base16-vim'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" TMUX Navigation
Plug 'christoomey/vim-tmux-navigator'

" Autocomplete
Plug 'roxma/nvim-completion-manager'
Plug 'mhartington/nvim-typescript'
Plug 'roxma/ncm-clang'

call plug#end()

syntax enable
filetype plugin indent on

"Must be bellow base16colorspace setup
"Allows for transparent background
if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif

hi Normal ctermbg=none
hi NonText ctermbg=none

" Use jj to enter command mode
inoremap jj <Esc>
set timeoutlen=1000 ttimeoutlen=0

" Two space tabs
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

" Let tab work in autocomlete menu
imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" UNDO ==================================================================================
set undodir=~/.config/nvim/undodir
set undofile

" ALE ===================================================================================
let g:ale_fixers = { 'javascript': ['eslint'] }
let g:ale_fix_on_save = 1

" MULTIPLE ==============================================================================
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" MARKDOWN ==============================================================================
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" PYTHON ================================================================================
let python_highlight_all = 1
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``
autocmd BufNewFile,BufRead *.py :setlocal sw=4 ts=4 sts=4

" JAVASCRIPT ============================================================================
let g:jsx_ext_required = 0
let g:user_emmet_settings = {'javascript.jsx': {'extends': 'jsx'}}
let g:nvim_typescript#javascript_support = 1

" JAVA ==================================================================================
autocmd BufNewFile,BufRead *.java :setlocal sw=4 ts=4 sts=4

" C/CPP =================================================================================
autocmd BufNewFile,BufRead *.c :setlocal sw=3 ts=3 sts=3
autocmd BufNewFile,BufRead *.h :setlocal sw=3 ts=3 sts=3
autocmd BufNewFile,BufRead *.cpp :setlocal sw=3 ts=3 sts=3
autocmd BufNewFile,BufRead *.hpp :setlocal sw=3 ts=3 sts=3

" HTML ==================================================================================
set matchpairs+=<:>
let g:html_indent_tags = 'li\|p'
autocmd BufNewFile,BufRead *.ejs set filetype=html

" TABS ==================================================================================
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tt :tabnew<CR>

" CTRLP =================================================================================
let g:ctrlp_map = '<c-n>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|dist'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" TMUX ==================================================================================
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
