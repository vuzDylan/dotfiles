" VIMPLUG ===============================================================================
call plug#begin('~/.config/nvim/plugged')
" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Linting
Plug 'dense-analysis/ale'

" Emmet for html and jsx
Plug 'mattn/emmet-vim'

" Close tag
Plug 'alvan/vim-closetag'

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

" Auto Complete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'

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

" Auto completion config ================================================================
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
nnoremap <silent> gd :LspDefinition<CR>

if executable('flow')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'flow',
        \ 'cmd': {server_info->['flow', 'lsp', '--from', 'vim-lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
endif

if executable('hh_client')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'hh_client',
        \ 'cmd': {server_info->['hh_client', 'lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.hhconfig'))},
        \ 'whitelist': ['php', 'hh'],
        \ })
endif

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'buffer',
      \ 'whitelist': ['*'],
      \ 'priority': 10,
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ 'config': {
      \    'max_buffer_size': -1,
      \  },
      \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'whitelist': ['*'],
      \ 'priority': 15,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))

" UNDO ==================================================================================
set undodir=~/.config/nvim/undodir
set undofile

" ALE ===================================================================================
let g:ale_fix_on_save = 1
let g:ale_sign_error = '-'
let g:ale_sign_warning = '*'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_set_highlights = 1
let g:ale_ignore_2_4_warnings = 1

let g:ale_hack_hack_executable = 'hh'
let g:ale_javascript_flow_executable = 'flow'
let g:ale_javascript_flow_use_global = 0
let g:ale_javascript_flow_use_home_config = 0

let g:ale_linters = {
\   'javascript': ['flow', 'eslint-lsp'],
\   'javascript.jsx': ['flow', 'eslint-lsp'],
\   'hh': ['hack', 'aurora'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'javascript.jsx': ['prettier', 'eslint'],
\   'hh': ['hackfmt'],
\}

call ale#linter#Define('javascript', {
\   'name': 'eslint-lsp',
\   'lsp': 'socket',
\   'address': 'localhost:6012',
\   'language': 'javascript',
\   'project_root': 'ale_linters#javascript#flow_ls#FindProjectRoot',
\})

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
let g:flow#enable = 0 "Don't type check on save vim-flow
let g:jsx_ext_required = 0
let g:javascript_plugin_flow = 1 "Flow Syntax From Polyglot
autocmd BufNewFile,BufRead *.js.flow set filetype=javascript

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

nnoremap <leader>/ /<C-r><C-w><CR>N
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>k vi{:sort<CR>
nnoremap <leader>s :set spell!<cr>
nnoremap <leader>t :tab sp<CR>
nnoremap <leader>v :vsp<CR>
nnoremap <leader>x :sp<CR>
nnoremap <leader>{ mm?^[^ \t#]<CR>

set rtp+=/usr/local/share/myc/vim
" Replace with a keybind you like
nmap <leader>n :MYC<CR>

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
  nnoremap <silent> <C-M> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-M> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif

" CLOSE TAG ============================================================================
let g:closetag_filenames = '*.html,*.react.js'
let g:closetag_xhtml_filenames = '*.react.js'
let g:closetag_shortcut = '<leader>>'
let g:closetag_close_shortcut = '>'
