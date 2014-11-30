" convertPost.vim "{{{1

" Last Update: Nov 30, Sun | 21:00:43 | 2014

" variables "{{{2

let s:Block = 'CODE {\{3}\d\{0,1}'
let s:FoldBegin = '{\{3}'
let s:FoldEnd = '}\{3}\d\{0,1}'

 "}}}2
" parts "{{{2

function s:ProtectBlock() "{{{3

    if search(s:Block . '$','cw')

        execute 'g;' . s:Block . ';' .
        \ '/' . s:Block . '$/+1' . ';' .
        \ '/^' . ' ' . s:FoldEnd . '$/-1' .
        \ 's;^;@;'

    endif

endfunction "}}}3

function s:JoinLines() "{{{3

    let g:TextWidth_Bullet = 9999

    Bullet w

    let g:TextWidth_Bullet = 50

endfunction "}}}3

function s:ShiftLeft() "{{{

    1,$<

    execute 'g;' . s:Block . ';' .
    \ '/' . s:Block . '$/+1;' .
    \ '/' . s:FoldEnd . '$/-1>'

endfunction "}}}

function s:DeleteBlock() "{{{

    execute 'g/' . s:Block . '/delete'

endfunction "}}}

function s:SubsTitle() "{{{

    if search(s:FoldBegin . '3$','cw')

        execute 'g/' . s:FoldBegin . '3$' . '/' .
        \ 's/^/## /'

    endif

    if search(s:FoldBegin . '4$','cw')

        execute 'g/' . s:FoldBegin . '4$' . '/' .
        \ 's/^/### /'

    endif

endfunction "}}}

function s:DeleteFoldEnd() "{{{

    execute 'g/' . s:FoldEnd . '/delete'

endfunction "}}}

function s:SubsFoldBegin() "{{{

    execute '%s/' . ' ' . s:FoldBegin . '[1-4]$//'

endfunction "}}}

function s:AddMarkdown() "{{{

    1s/^/[markdown]\r\r/
    $s/$/\r\r[\/markdown]/

endfunction "}}}
 "}}}2
" main "{{{2

function s:Convert2Trow() "{{{3

    call <sid>ProtectBlock()
    call <sid>JoinLines()

    call <sid>ShiftLeft()

    call <sid>DeleteBlock()
    call <sid>DeleteFoldEnd()

    call <sid>SubsTitle()
    call <sid>SubsFoldBegin()

    call <sid>AddMarkdown()

    DelAdd

endfunction "}}}3

"call <sid>Convert2Trow()

 "}}}2
" vim: set fdm=marker fdl=20 "}}}1
