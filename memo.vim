" memo.vim "{{{1

" Last Update: Feb 10, Tue | 14:30:52 | 2015

function s:TmpKeyMap() "{{{

    execute "normal! o\<cr>" . @* .
    \ "\<cr>\<esc>kvis\<f4>"

endfunction "}}}

autocmd BufRead memo.loc
\ nnoremap <buffer> <silent> <f12>
\ :call <sid>TmpKeyMap()<cr>

 "}}}1
