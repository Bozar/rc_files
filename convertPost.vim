" convertPost.vim "{{{1

" Last Update: Apr 03, Fri | 15:28:16 | 2015

" variables "{{{2

let s:BlockCode = 'CODE {\{3}\d\{0,1}'

let s:BlockQuote = 'QUOTE {\{3}\d\{0,1}'

let s:BlockAll = '\(' . s:BlockCode . '\)'
let s:BlockAll .= '\|\(' . s:BlockQuote . '\)'

let s:FoldBegin = '{\{3}'

let s:FoldEnd = '}\{3}\d\{0,1}'

let s:Bullet = '^\* \{3}\( \)\@!'

let s:LinkText = '\(\['
let s:LinkText .= '[^\]]\{-}'
let s:LinkText .= '\]\)'

let s:LinkURL = '\((http.\{-})\)'

let s:LinkAll = s:LinkText . s:LinkURL

let s:LinkPart = '\[url='

 "}}}2
" parts "{{{2

function s:ProtectBlock() "{{{3

    1

    while search('^\(' . s:BlockAll . '\)$','cW')

        call moveCursor#SetLineJKFold()

        execute
        \ moveCursor#TakeLineNr('J','K',1,-1) .
        \ 's/^/@/'

        "execute moveCursor#TakeLineNr('K','',1)

        execute moveCursor#TakeLineNr('K','')

    endwhile

endfunction "}}}3

function s:DelExtraSpacesAfterBullet() "{{{3

    if search(s:Bullet,'cw')

        execute '%s/' . s:Bullet . '/* /'

    endif

endfunction "}}}3

function s:JoinLines(...) "{{{3

    let l:saveTW = g:TextWidth_Bullet

    let l:saveFO = g:CommentsAdd_Bullet

    if exists('a:1')

        let g:TextWidth_Bullet = a:1

    else

        let g:TextWidth_Bullet = 9999

    endif

    let g:CommentsAdd_Bullet = 'b:>,'

    Bullet w

    let g:TextWidth_Bullet = l:saveTW

    let g:CommentsAdd_Bullet = l:saveFO 

endfunction "}}}3

function s:ShiftLeft() "{{{

    1,$<

endfunction "}}}

function s:DelBlockCode() "{{{

    if search(s:BlockCode,'cw')

        execute 'g/' . s:BlockCode . '/delete'

    endif

endfunction "}}}

function s:DelBlockQuote() "{{{

    if search(s:BlockQuote,'cw')

        execute 'g/' . s:BlockQuote . '/delete'

    endif

endfunction "}}}

function s:SubsBlockCode() "{{{

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

function s:SubsBlockQuote() "{{{

    while search('^' . s:BlockQuote . '$','cw')

        if moveCursor#SetLineJKFold() == 1

            return

        else

            execute
            \ moveCursor#TakeLineNr('J','') .
            \ 's/^.*$/[quote]/'

            execute
            \ moveCursor#TakeLineNr('K','') .
            \ 's/^.*$/[\/quote]/'

        endif

    endwhile

endfunction "}}}

function s:SubsBullet() "{{{

    if search(s:Bullet,'cw')

        execute 'g/' . s:Bullet . '/s/$/[\/list]/'
        execute '%s/' . s:Bullet . '/[list]/'

    endif

endfunction "}}}

function s:SubsLink() "{{{

    if search(s:LinkAll,'cw')

        " seperate text and url

        execute '%s/' . s:LinkAll . '/\r\1\r\2\r/'

        " url: add [url=

        execute 'g/' . s:LinkURL . '/s/^/' .
        \ s:LinkPart . '/'

        " url: add ]

        execute 'g/' . s:LinkURL . '/s/$/]/'

        " url: delete (

        execute '%s/^\(' . s:LinkPart . '\)(/' .
        \ '\1/'

        " url: delete )

        execute 'g/^\(' . s:LinkPart . '\)/' .
        \ 's/)\]$/]/'

        " text: delete [

        execute 'g/^\(' . s:LinkPart . '\)/' .
        \ '-1s/^\[//'

        " text: add [/url]

        execute 'g/^\(' . s:LinkPart . '\)/' .
        \ '-1s/\]$/[\/url]/'

        " change position

        execute 'g/' . s:LinkPart . '/-1move .'

        " join lines

        execute 'g/' . s:LinkPart . '/-1,+2join!'

    endif

endfunction "}}}

function s:SubsTitle(forum) "{{{

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

function s:DelFoldEnd() "{{{

    if search(s:FoldEnd,'cw')

        execute 'g/' . s:FoldEnd . '/delete'

    endif

endfunction "}}}

function s:SubsFoldBegin() "{{{

    let l:pattern = ' ' . s:FoldBegin . '[1-4]$'

    if search(l:pattern,'cw')

        execute '%s/' . l:pattern . '//'

    endif

endfunction "}}}

function s:AddMarkdown() "{{{

    1s/^/[markdown]\r\r/
    $s/$/\r\r[\/markdown]/

endfunction "}}}

 "}}}2
" main "{{{2

function s:Convert2Trow() "{{{3

    call <sid>ProtectBlock()
    call <sid>ShiftLeft()

    call <sid>JoinLines()

    call <sid>DelBlockCode()

    call <sid>SubsBlockQuote()
    call <sid>SubsTitle('trow')

    call <sid>SubsFoldBegin()
    call <sid>DelFoldEnd()

    call <sid>AddMarkdown()

    DelAdd

endfunction "}}}3

function s:Convert2Mail() "{{{3

    call <sid>ProtectBlock()
    call <sid>ShiftLeft()
    call <sid>DelExtraSpacesAfterBullet()

    call <sid>JoinLines(50)

    call <sid>DelBlockCode()

    call <sid>SubsTitle('trow')

    call <sid>SubsFoldBegin()
    call <sid>DelFoldEnd()

    DelAdd

endfunction "}}}3

function s:Convert2SUSE() "{{{4

    call <sid>ProtectBlock()
    call <sid>ShiftLeft()

    call <sid>JoinLines()

    call <sid>SubsBlockCode()
    call <sid>SubsBlockQuote()
    call <sid>SubsBullet()
    call <sid>SubsLink()

    call <sid>SubsTitle('suse')

    call <sid>SubsFoldBegin()
    call <sid>DelFoldEnd()

    DelAdd

endfunction "}}}4

function s:SelectFunction() "{{{4

    execute 'normal! gg0'

    if search('trow','c',1)

        call <sid>Convert2Trow()

    elseif search('mail','c',1)

        call <sid>Convert2Mail()

    elseif search('suse','c',1)

        call <sid>Convert2SUSE()

    endif

endfunction "}}}4

if !exists(':ConvertPost')

    command ConvertPost call <sid>SelectFunction()

endif

 "}}}2
" vim: set fdm=marker fdl=20 "}}}1
