" memo.vim
" Last Update: Aug 10, Mon | 09:57:44 | 2015

function s:Console()
    execute "normal! o\<cr>" . @* .
    \ "\<cr>\<esc>kvis\<f4>"
endfunction

function s:Item(pos)
    if a:pos ==# 'before'
        execute line('.') . '+1,' . line('$') .
        \ 'g;' . @a . ';s;\t;\t' . @" . ';'
    elseif a:pos ==# 'after'
        execute line('.') . '+1,' . line('$') .
        \ 'g;' . @a . ';s;\v(\t.{-})\t;\1' . @" .
        \ '\t;'
    endif
endfunction

function s:TmpKeyMap()
    nnoremap <buffer> <silent> <f12>
    \ :call <sid>Console()<cr>
    vnoremap <buffer> <silent> <f8>
    \ y:call <sid>Item('before')<cr>
    vnoremap <buffer> <silent> <s-f8>
    \ y:call <sid>Item('after')<cr>
endfunction

autocmd BufRead memo.loc call <sid>TmpKeyMap()
command! KeMemoQ call <sid>TmpKeyMap()

" vim: set fdm=indent:
