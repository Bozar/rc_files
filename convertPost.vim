" convertPost.vim "{{{1

" Last Update: Apr 19, Sun | 21:05:23 | 2015

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

let s:Star = '\v^(\s*\*\s*)'
let s:Cross = '\v^(\s*\+\s*)'
let s:SpaceFour = '    '

"}}}2
" parts "{{{2

function! s:SubsStarsInQuote() "{{{3

    while search('^' . s:BlockQuote . '$','cw')
        mark j
        normal ]z
        mark k
        'j,'ks/^\*/ /e
        'j,'ks/^\v(\s+)\+/\1 /e
        'j,'ks/`//ge
        'js/^.*//
        'ks/^.*//
    endwhile

endfunction "}}}3

function! s:Surround() "{{{3

    while search('[^`]<','cw')
        %s/\v([^`])\</\1`</g
    endwhile

    while search('<[^`]','cw')
        %s/\v\<([^`])/<`\1/g
    endwhile

    while search('[^`]>','cw')
        %s/\v([^`])\>/\1`>/g
    endwhile

    while search('>[^`]','cw')
        %s/\v\>([^`])/>`\1/g
    endwhile

endfunction "}}}3

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

    "call <sid>DelBlockCode()
    "call <sid>SubsBlockQuote()
    "call <sid>Surround()
    call <sid>SubsStarsInQuote()
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

function! s:Convert2HTML() "{{{4

    let l:BeginUL = '<ul>'
    let l:EndUL = '<\/ul>'
    let l:BeginLI = '<li>'
    let l:EndLI = '<\/li>'

    1s/^/\r/
    $s/$/\r/
    execute '%s/\v^.*\}{3}\d//e'

    " &lt and &gt
    normal! gg
    if search('<','cW',line('$'))
        %s/</\&lt/g
    endif
    normal! gg
    if search('>','cW',line('$'))
        %s/>/\&gt/g
    endif

    " insert <ul> before s:Cross
    normal! gg
    while search(s:Cross,'cW',line('$'))
        if getline(line('.')-1) =~# s:Star
            execute 's/^/' . s:SpaceFour .
            \ l:BeginUL . '\r/'
        endif
        normal! j0
    endwhile

    " insert </ul> after s:Cross
    normal! gg
    while search(s:Cross,'cW',line('$'))
        if getline(line('.')+1) =~# s:Star
            execute 's/$/\r' . s:SpaceFour .
            \ l:EndUL . '/'
        endif
        normal! j0
    endwhile
    normal! gg
    while search(s:Cross,'cW',line('$'))
        if getline(line('.')+1) =~# '^$'
            execute 's/$/\r' . s:SpaceFour .
            \ l:EndUL . '/'
        endif
        normal! j0
    endwhile

    " surround s:Star with <ul> and </ul>
    normal! gg
    while search(s:Star,'cw',line('$'))
        call moveCursor#SetLineJKPara()
        execute moveCursor#TakeLineNr('J','') .
        \ 's/^/' . l:BeginUL . '\r/'
        execute moveCursor#TakeLineNr('K','',1) .
        \ 's/$/\r' . l:EndUL . '/'
        execute 'normal! }'
    endwhile

    " substitute s:Star and s:Cross
    if search(s:Star,'cw')
        execute '%s/' . s:Star . '/' .
        \ l:BeginLI . '/'
    endif
    if search(s:Cross,'cw')
        execute '%s/' . s:Cross . '/' .
        \ s:SpaceFour . l:BeginLI . '/'
    endif
    if search(l:BeginLI,'cw')
        execute 'g/' . l:BeginLI . '/s/$/' .
        \ l:EndLI . '/'
    endif

    " <h1> and <p>
    execute 'g/\v\{{3}\d/s/\v^(.*)( \{{3})' .
    \ '(\d)$/<h\3>\1<\/h\3>'
    execute 'g/\v^([^< ])/s/^/<p>\1/'
    execute 'g/^<p>/s/$/<\/p>/'

    call <sid>SubsLink()
    %s/\v(\[url=)(.{-1,})(\])/<a href="\2">/e
    %s/\v\[\/url\]/<\/a>/e

endfunction "}}}4

function s:SelectFunction() "{{{4

    1,$left 0
    let g:TextWidth_Bullet = 9999
    BuW0TW
    let g:TextWidth_Bullet = 50
    normal! gg

    if search('trow','c',1)
        call <sid>Convert2Trow()
    elseif search('mail','c',1)
        call <sid>Convert2Mail()
    elseif search('suse','c',1)
        call <sid>Convert2SUSE()
    elseif search('html','c',1)
        call <sid>Convert2HTML()
    endif

endfunction "}}}4

if !exists(':ConvertPost')

    command ConvertPost call <sid>SelectFunction()

endif

"}}}2
" vim: set fdm=marker fdl=20 "}}}1
