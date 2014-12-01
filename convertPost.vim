" convertPost.vim "{{{1

" Last Update: Dec 01, Mon | 15:57:06 | 2014

" variables "{{{2

let s:BlockCode = 'CODE {\{3}\d\{0,1}'

let s:BlockAll = s:BlockCode

let s:FoldBegin = '{\{3}'
let s:FoldEnd = '}\{3}\d\{0,1}'

let s:Bullet = '^\* \{3}\( \)\@!'

 "}}}2
" parts "{{{2

function! s:ProtectBlock() "{{{3

    if search(s:BlockAll . '$','cw')

        execute 'g;' . s:BlockAll . ';' .
        \ '/' . s:BlockAll . '$/+1' . ';' .
        \ '/^' . ' ' . s:FoldEnd . '$/-1' .
        \ 's;^;@;'

    endif

endfunction "}}}3

function! s:JoinLines() "{{{3

    let g:TextWidth_Bullet = 9999

    Bullet w

    let g:TextWidth_Bullet = 50

endfunction "}}}3

function! s:ShiftLeft() "{{{

    1,$<

    if search(s:BlockAll . '$','cw')

        execute 'g;' . s:BlockAll . ';' .
        \ '/' . s:BlockAll . '$/+1;' .
        \ '/' . s:FoldEnd . '$/-1>'

    endif

endfunction "}}}

function! s:DeleteBlock() "{{{

    execute 'g/' . s:BlockAll . '/delete'

endfunction "}}}

function! s:SubsBlockCode() "{{{

    while search('^' . s:BlockCode . '$','cw')

        if moveCursor#SetLineJKFold() == 1

            return

        else

            execute
            \ moveCursor#TakeLineNr('J','') .
            \ 's/^.*$/[code]/'

            execute
            \ moveCursor#TakeLineNr('K','') .
            \ 's/^.*$/[\/code]/'

        endif

    endwhile

endfunction "}}}

function! s:SubsBullet() "{{{

    if search(s:Bullet,'cw')

        execute 'g/' . s:Bullet . '/s/$/[\/list]/'
        execute '%s/' . s:Bullet . '/[list]/'

    endif

endfunction "}}}

function! s:SubsTitle(forum) "{{{

    if search(s:FoldBegin . '3$','cw')

        if a:forum == 'trow'

            execute 'g/' . s:FoldBegin . '3$' .
            \ '/s/^/## /'

        elseif a:forum == 'suse'

            execute '%s/^\(.*\)' . ' ' .
            \ s:FoldBegin . '3$/' .
            \ '[size=200]\1[\/size]/'

        endif

    endif

    if search(s:FoldBegin . '4$','cw')

        if a:forum == 'trow'

            execute 'g/' . s:FoldBegin . '4$' .
            \ '/s/^/### /'

        elseif a:forum == 'suse'

            execute '%s/^\(.*\)' . ' ' .
            \ s:FoldBegin . '4$/' .
            \ '[size=150]\1[\/size]/'

        endif

    endif

endfunction "}}}

function! s:DeleteFoldEnd() "{{{

    execute 'g/' . s:FoldEnd . '/delete'

endfunction "}}}

function! s:SubsFoldBegin() "{{{

    execute '%s/' . ' ' . s:FoldBegin . '[1-4]$//'

endfunction "}}}

function! s:AddMarkdown() "{{{

    1s/^/[markdown]\r\r/
    $s/$/\r\r[\/markdown]/

endfunction "}}}

 "}}}2
" main "{{{2

function! s:Convert2Trow() "{{{3

    call <sid>ProtectBlock()
    call <sid>JoinLines()

    call <sid>ShiftLeft()

    call <sid>DeleteBlock()

    call <sid>SubsTitle('trow')

    call <sid>SubsFoldBegin()
    call <sid>DeleteFoldEnd()

    call <sid>AddMarkdown()

    DelAdd

endfunction "}}}3

function! s:Convert2SUSE() "{{{4

    call <sid>ProtectBlock()
    call <sid>JoinLines()

    call <sid>ShiftLeft()

    call <sid>SubsBlockCode()
    call <sid>SubsBullet()

    call <sid>DeleteFoldEnd()

    call <sid>SubsTitle('suse')
    call <sid>SubsFoldBegin()

    DelAdd

endfunction "}}}4

"call <sid>Convert2Trow()
"call <sid>Convert2SUSE()

 "}}}2
" vim: set fdm=marker fdl=20 "}}}1
