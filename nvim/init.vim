""""""""""""""""""""""""""""""
"          VIMPLUG           "
""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

" Syntax plugin
Plug 'sheerun/vim-polyglot'
Plug 'jparise/vim-graphql'

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
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-clang'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/context_filetype.vim'
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install -g tern' }

call plug#end()

syntax enable
filetype plugin indent on

let mapleader = ","

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
set timeoutlen=500 ttimeoutlen=0

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

" Let tab work in autocomlete menu
imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" UNDO ==================================================================================
set undodir=~/.config/nvim/undodir
set undofile

" FILETYPE ==============================================================================
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes.js = 'jsx'
let g:context_filetype#same_filetypes.jsx = 'js'

" DEOPLETE ==============================================================================
let g:deoplete#enable_at_startup = 1

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

call deoplete#custom#source('omni',          'mark', '⌾')
call deoplete#custom#source('ternjs',        'mark', '⌁')
call deoplete#custom#source('jedi',          'mark', '⌁')
call deoplete#custom#source('vim',           'mark', '⌁')
call deoplete#custom#source('neosnippet',    'mark', '⌘')
call deoplete#custom#source('tag',           'mark', '⌦')
call deoplete#custom#source('around',        'mark', '↻')
call deoplete#custom#source('buffer',        'mark', 'ℬ')
call deoplete#custom#source('tmux-complete', 'mark', '⊶')
call deoplete#custom#source('syntax',        'mark', '♯')

call deoplete#custom#source('vim',           'rank', 630)
call deoplete#custom#source('ternjs',        'rank', 620)
call deoplete#custom#source('jedi',          'rank', 610)
call deoplete#custom#source('omni',          'rank', 600)
call deoplete#custom#source('neosnippet',    'rank', 510)
call deoplete#custom#source('member',        'rank', 500)
call deoplete#custom#source('file_include',  'rank', 420)
call deoplete#custom#source('file',          'rank', 410)
call deoplete#custom#source('tag',           'rank', 400)
call deoplete#custom#source('around',        'rank', 330)
call deoplete#custom#source('buffer',        'rank', 320)
call deoplete#custom#source('dictionary',    'rank', 310)
call deoplete#custom#source('tmux-complete', 'rank', 300)
call deoplete#custom#source('syntax',        'rank', 200)

call deoplete#custom#source('_', 'converters', [
	\ 'converter_remove_paren',
	\ 'converter_remove_overlap',
	\ 'converter_truncate_abbr',
	\ 'converter_truncate_menu',
	\ 'converter_auto_delimiter',
	\ ])

" ALE ===================================================================================
let g:ale_fixers = { 'javascript': ['eslint'] }
let g:ale_linters = { 'graphql': ['gqlint'] }
let g:ale_fix_on_save = 1
let g:ale_sign_error = '-'
let g:ale_sign_warning = '*'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_set_highlights = 1

" MULTIPLE ==============================================================================
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" EMMET =================================================================================
let g:user_emmet_mode='a'
let g:user_emmet_leader_key='<leader>'  
let g:user_emmet_settings = {'javascript.jsx': {'extends': 'jsx'}}

" MARKDOWN ==============================================================================
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" PYTHON ================================================================================
let python_highlight_all = 1
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``
autocmd BufNewFile,BufRead *.py :setlocal sw=4 ts=4 sts=4

" JAVASCRIPT ============================================================================
let g:jsx_ext_required = 0
let g:deoplete#sources#ternjs#types = 1
let g:user_emmet_settings = {'javascript.jsx': {'extends': 'jsx'}}
let g:deoplete#sources#ternjs#filetypes = [ 'jsx', 'javascript.jsx', 'vue', 'javascript' ]

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

" NO ARROWS =============================================================================
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" SPLITS ================================================================================
nnoremap <leader>v :vnew<CR>

" CTRLP =================================================================================
let g:ctrlp_map = '<c-n>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|dist'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" SPELLING ==============================================================================
nnoremap <leader>s :set spell!<cr>

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
