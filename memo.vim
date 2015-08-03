" memo.vim
" Last Update: Aug 03, Mon | 11:09:28 | 2015

function s:Console()
    execute "normal! o\<cr>" . @* .
    \ "\<cr>\<esc>kvis\<f4>"
endfunction

function s:Item()
    execute line('.') . '+1,' . line('$') .
    \ 'g;' . @a . ';s;\t;\t' . @" . ';'
endfunction

function s:TmpKeyMap()
    nnoremap <buffer> <silent> <f12>
    \ :call <sid>Console()<cr>
    vnoremap <buffer> <silent> <f8>
    \ y:call <sid>Item()<cr>
endfunction

autocmd BufRead memo.loc call <sid>TmpKeyMap()

" vim: set fdm=indent:
