call plug#begin('~/.config/nvim/plugged')

" COC
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" EMMET
Plug 'mattn/emmet-vim'

" THEME
Plug 'chriskempson/base16-vim'

" MULTI CURSORS
Plug 'terryma/vim-multiple-cursors'

" TMUX NAVIGATION
Plug 'christoomey/vim-tmux-navigator'

" SYNTAX
Plug 'sheerun/vim-polyglot'
Plug 'jparise/vim-graphql'

call plug#end()
