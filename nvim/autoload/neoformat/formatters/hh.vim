function! neoformat#formatters#hh#enabled() abort
    return ['hackfmt']
endfunction

function! neoformat#formatters#hh#hackfmt() abort
    return {
        \ 'exe': 'hackfmt',
        \ 'stdin': 1
        \ }
endfunction

