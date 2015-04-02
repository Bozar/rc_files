" fold marker "{{{
" Last Update: Apr 02, Thu | 16:28:15 | 2015

let s:Title = 'FOLDMARKER'

function! s:LoadVars()

    let s:Bra =
    \ substitute(&foldmarker,'\v(.*)(,.*)','\1',
    \ '')
    let s:Ket =
    \ substitute(&foldmarker,'\v(.*,)(.*)','\2',
    \ '')

    let s:FoldBegin = '\v^(.*)\s(\S{-})\M' .
    \ s:Bra . '\v(\d{0,2})\s{-}$'
    let s:FoldEnd = '\v^(.*)\s(\S{-})\M' .
    \ s:Ket . '\v(\d{0,2})\s{-}$'

endfunction

" fold level & fold prefix
function! s:GetFoldInfo()

    let l:pos = getpos('.')
    let s:Level = foldlevel('.')
    if s:Level ># 0
        call moveCursor#GotoFoldBegin()
        let s:Prefix =
        \ substitute(getline('.'),s:FoldBegin,
        \ '\2','')
    else
        let s:Prefix = ''
    endif
    call setpos('.',l:pos)

endfunction

function! s:CreatMarker(line)

    let l:begin = ' ' . s:Prefix . s:Bra
    let l:end = s:Prefix . s:Ket

    " before current line
    if a:line ==# 0
        execute 's/^/' . s:Title . l:begin .
        \ '\r\r\r' . l:end . '\r/'
        -1
    endif

    " after current line
    if a:line ==# 1
        execute 's/$/\r' . s:Title . l:begin .
        \ '\r\r\r' . l:end . '/'
    endif

    " wrap visual block
    if a:line ==# 2
        if getline("'<") =~# '\v^\s*$'
            execute "'<" . 's/$/' . s:Title .
            \ l:begin . '/'
        else
            execute "'<" . 's/$/' . l:begin . '/'
        endif
        if getline("'>") =~# '\v^\s*$'
            execute "'>" . 's/$/' . l:end . '/'
        else
            execute "'>" . 's/$/' . ' ' . l:end .
            \ '/'
        endif
    endif

endfunction

function! s:CreatLevel()

    call moveCursor#GotoFoldBegin()
    if foldlevel('.') ==# 0
        s/$/1/
    else
        execute 's/$/' . foldlevel('.') . '/'
    endif
    normal! ]z
    if foldlevel('.') ==# 0
        s/$/1/
    else
        execute 's/$/' . foldlevel('.') . '/'
    endif

endfunction

" main function
function! s:FoldMarker(line)

    call <sid>LoadVars()
    call <sid>GetFoldInfo()

    if a:line ==# 'new'
        call <sid>CreatMarker(1)
    endif
    if a:line ==# 'before'
        call moveCursor#GotoFoldBegin()
        call <sid>CreatMarker(0)
    endif
    if a:line ==# 'after'
        call moveCursor#GotoFoldBegin()
        normal! ]z
        call <sid>CreatMarker(1)
    endif
    if a:line ==# 'wrap'
        call <sid>CreatMarker(2)
    endif

    call <sid>CreatLevel()
    normal! [z
    +1

endfunction

"nno <f8> :call <sid>FoldMarker('new')<cr>
"nno <f9> :call <sid>FoldMarker('before')<cr>
"nno <f10> :call <sid>FoldMarker('after')<cr>
"nno <f11> :call <sid>FoldMarker('new')<cr>
"vno <f12> <esc>:call <sid>FoldMarker('wrap')<cr>

" DO NOT call 'CreatFoldMarker()' alone
" call 'MoveFoldMarker()' instead
" which has fail-safe protocol 'substitute()'
"function! s:CreatFoldMarker(creat)

"    " level one
"    if a:creat ==# 0
"        execute 's/$/' .
"        \ '\r' . s:Title . ' ' . s:Bra .
"        \ '\r\r\r' . s:Ket . '/'
"        .-3,.g/./s/$/1/
"    endif

"    " move cursor
"        if substitute(getline('.'),
"            \'{\{3}\d\{0,2}$','','') != getline('.')
"            +1
"        endif
"    " same level
"        if a:creat==1 "{{{
"            execute 'normal [zmh]zml'
"            'hyank
"            'hput
"            'hput
"            'h+1,'h+2s/^.*\(.\{0,1}{\{3}\d\{0,2}\)$/\1/
"            "'h+1,'h+2s/^.*\( .\{0,1}{\{3}\d\{0,2}\)$/\1/
"            'h+2s/{{{/}}}/
"            'h+1s/^/FOLDMARKER / "}}}
"    " higher level
"        elseif a:creat==2 "{{{
"            call <sid>CreatFoldMarker(1)
"            'h+1,'h+2s/\(\d\{1,2}\)$/\=submatch(0)+1/e "}}}
"        endif

"endfunction

" new (0), after (1), before (2)
" inside (3), wrap text (4,5)
"function! s:MoveFoldMarker(move) "{{{

"    " creat level one marker
"        if a:move==0 "{{{
"            call <sid>CreatFoldMarker(0)
"            mark k
"            -1mark j
"            -1
"        endif "}}}

"    " remember position
"        execute 'normal H'
"        let Top=line('.')
"        ''

"    " detect fold
"        let SaveCursor=getpos('.')
"        if substitute(getline('.'),
"            \'{\{3}\d\{0,2}$','','') != getline('.')
"            +1
"        endif
"        execute 'normal [z'
"        if substitute(getline('.'),'{\{3}\d\{0,2}$','','')==getline('.') "{{{
"            echo "ERROR: Fold '[z' not found!"
"            call setpos('.', SaveCursor)
"            return
"        else
"            call setpos('.', SaveCursor)
"        endif "}}}

"    " after
"        if a:move==1 "{{{
"            call <sid>CreatFoldMarker(1)
"            'h+1,'h+2delete
"            'lput
"            execute Top ' | normal zt'
"            'l+1 "}}}

"    " before
"        elseif a:move==2 "{{{
"            call <sid>CreatFoldMarker(1)
"            'h+1,'h+2delete
"            'hput!
"            execute Top ' | normal zt'
"            'h-1 "}}}

"    " inside
"        elseif a:move==3 "{{{
"            mark z
"            call <sid>CreatFoldMarker(2)
"            'h+1,'h+2delete
"            'zput
"            execute Top ' | normal zt'
"            'z+1 "}}}

"    " wrap text, normal
"        elseif a:move==4 "{{{
"            call <sid>CreatFoldMarker(2)
"            'h+1,'h+2s/\d\{0,2}$//
"            'h+1,'h+2delete
"            'jput
"            'j+1s/^FOLDMARKER//
"            'j+2delete
"            'kput
"            'j,'j+1join!
"            'k,'k+1join!
"            execute 'normal [z'
"            execute Top ' | normal zt'
"            '' "}}}

"    " wrap text, visual
"        elseif a:move==5 "{{{
"            '<mark j
"            '>mark k
"            call <sid>MoveFoldMarker(4)
"            execute Top ' | normal zt'
"            '' "}}}
"        endif

"endfunction "}}}


" append, insert and creat fold marker
command! FmNew call <sid>FoldMarker('new')
command! FmAfter call <sid>FoldMarker('after')
command! FmBefore call <sid>FoldMarker('before')
command! -range FmWrap call <sid>FoldMarker('wrap')

" append, insert and creat fold marker
nnoremap <silent> <tab> :FmAfter<cr>
nnoremap <silent> <s-tab> :FmBefore<cr>
nnoremap <silent> <c-tab> :FmNew<cr>
vnoremap <silent> ~ :FmWrap<cr>

"}}}
