let g:coc_disable_startup_warning = 1
let g:coc_node_path = expand("/data/users/$USER/fbsource/xplat/third-party/node/bin/node")

scriptencoding utf-8
source ~/.config/nvim/plugins.vim

" Options ===============================================================================
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

" NEOFORMAT =============================================================================
autocmd BufWritePre *.js Neoformat

" COC ===================================================================================
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

" FZF ===================================================================================
let g:fzf_layout = { 'down': '~30%' }
nnoremap <C-t> :Files<CR>
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

set rtp+=/usr/local/share/myc/vim
nmap <C-n> :MYC<CR>

" UNDO ==================================================================================
set undodir=~/.config/nvim/undodir
set undofile

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

" SNIPS =================================================================================
imap <C-j> <Plug>(coc-snippets-expand-jump)

" TABS ==================================================================================
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tt :tabnew<CR>

" NO ARROWS =============================================================================
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" LEADER ================================================================================
let mapleader = ","

nnoremap <leader>/ /<C-r><C-w><CR>N
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :CocFix<CR>
nnoremap <leader>k vi{:sort<CR>
nnoremap <leader>m :!tmux send-keys -t Bottom 'meerkat' Enter<CR>
nnoremap <leader>s :set spell!<CR>
nnoremap <leader>d :execute "!tmux send-keys -t Bottom 'vim_fburl" . " " . expand('%') . " " . line('.') . "' Enter"<CR>

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
