let g:python3_host_prog='/home/vuzdylan/virtualenvs/neovim/bin/python'

" VIMPLUG ===============================================================================
call plug#begin('~/.config/nvim/plugged')
" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Linting
Plug 'w0rp/ale'

" Emmet for html and jsx
Plug 'mattn/emmet-vim'

" Vim surround
Plug 'tpope/vim-surround'

" Color schema
Plug 'chriskempson/base16-vim'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" TMUX Navigation
Plug 'christoomey/vim-tmux-navigator'

" Syntax plugin
Plug 'sheerun/vim-polyglot'
Plug 'jparise/vim-graphql'
Plug 'hhvm/vim-hack'

" Autocomplete
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'wellle/tmux-complete.vim'

" Filetypes
Plug 'Shougo/context_filetype.vim'

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

" NEOCLIENT ============================================================================
let g:LanguageClient_serverCommands = {
    \ 'hh': [ 'hh_client', 'lsp' ],
    \ 'javascript.jsx': [ 'flow', 'lsp' ],
    \ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition({ 'gotoCmd': 'vsplit' })<CR>

" DEOPLETE ==============================================================================
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let g:deoplete#enable_at_startup = 1

let g:deoplete#enable_camel_case = 1
set completeopt=longest,menuone,preview
let g:deoplete#enable_refresh_always = 1
let g:deoplete#file#enable_buffer_path = 1
let g:deoplete#tag#cache_limit_size = 800000

let g:deoplete#omni#functions = get(g:, 'deoplete#omni#functions', {})
let g:deoplete#omni#functions.css = 'csscomplete#CompleteCSS'
let g:deoplete#omni#functions.html = 'htmlcomplete#CompleteTags'
let g:deoplete#omni#functions.markdown = 'htmlcomplete#CompleteTags'

let g:deoplete#omni_patterns = get(g:, 'deoplete#omni_patterns', {})
let g:deoplete#omni_patterns.html = '<[^>]*'

call deoplete#custom#source('LanguageClient', 'mark', '⌁')
call deoplete#custom#source('omni', 'mark', '⌾')
call deoplete#custom#source('member', 'mark', '.')
call deoplete#custom#source('around', 'mark', '↻')
call deoplete#custom#source('file', 'mark', 'F')
call deoplete#custom#source('tag', 'mark', '⌦')
call deoplete#custom#source('buffer', 'mark', 'ℬ')
call deoplete#custom#source('tmux-complete', 'mark', '⊶')
call deoplete#custom#source('syntax', 'mark', '♯')

call deoplete#custom#source('LanguageClient', 'rank', 700)
call deoplete#custom#source('omni', 'rank', 600)
call deoplete#custom#source('member', 'rank', 550)
call deoplete#custom#source('around', 'rank', 400)
call deoplete#custom#source('file', 'rank', 500)
call deoplete#custom#source('tag', 'rank', 450)
call deoplete#custom#source('buffer', 'rank', 350)
call deoplete#custom#source('tmux-complete', 'rank', 300)
call deoplete#custom#source('syntax', 'rank', 200)

" ALE ===================================================================================
let g:ale_fix_on_save = 1
let g:ale_sign_error = '-'
let g:ale_sign_warning = '*'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_set_highlights = 1

let g:ale_hack_hack_executable = 'hh'
let g:ale_javascript_flow_executable = 'flow'
let g:ale_javascript_flow_use_global = 0
let g:ale_javascript_flow_use_home_config = 0

let g:ale_linters = {
\   'javascript': ['eslint', 'flow'],
\   'hh': ['hack', 'aurora'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'hh': ['hackfmt'],
\}

" MULTIPLE ==============================================================================
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" EMMET =================================================================================
let g:user_emmet_mode='a'
let g:user_emmet_settings = {'javascript.jsx': {'extends': 'jsx'}}

" HACK ==================================================================================
let g:hack#enable = 0 "Turn off vim-hack because we use LSP

function! s:FTSetHH()
  setlocal filetype=hh
  runtime! syntax/php.vim
  setlocal omnifunc=LanguageClient#complete
endfunction

function! s:FTDetectHH()
  if getline(1) =~ '^<?hh'
    call s:FTSetHH()
  elseif getline(1) =~ '^#!\.\+hhvm' && getline(2) =~ '^<?hh'
    call s:FTSetHH()
  endif
endfunction

autocmd BufNewFile,BufRead *.hh call s:FTDetectHH()
autocmd BufNewFile,BufRead *.php call s:FTDetectHH()

" MARKDOWN ==============================================================================
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" PYTHON ================================================================================
let python_highlight_all = 1
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``
autocmd BufNewFile,BufRead *.py :setlocal sw=4 ts=4 sts=4

" JAVASCRIPT ============================================================================
let g:jsx_ext_required = 0
let g:javascript_plugin_flow = 1 "Flow Syntax From Polyglot

" JAVA ==================================================================================
autocmd BufNewFile,BufRead *.java :setlocal sw=4 ts=4 sts=4

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

" FZF ===================================================================================
let g:fzf_layout = { 'down': '~25%' }
nnoremap <C-n> :Files<CR>
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" LEADER ================================================================================
let mapleader = ","

inoremap <leader>, <C-x><C-o>

nnoremap <leader>b :Buffers<CR>
nnoremap <leader>v :vnew<CR>
nnoremap <leader>s :set spell!<cr>
nnoremap <leader>/ /<C-r><C-w><CR>N

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
