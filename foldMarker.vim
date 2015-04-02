" fold marker "{{{
" Last Update: Apr 02, Thu | 17:45:25 | 2015

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

function! s:ExpandFold(when)

    if a:when ==# 0
        let s:foldlevel = &foldlevel
        let &foldlevel = 20
    endif
    if a:when ==# 1
        let &foldlevel = s:foldlevel
    endif

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
    call <sid>ExpandFold(0)
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
        if line("'<") ==# line("'>")
            call <sid>ExpandFold(1)
            return
        endif
        call <sid>CreatMarker(2)
    endif

    call <sid>CreatLevel()
    normal! [z
    +1
    call <sid>ExpandFold(1)

endfunction

" append, insert and creat fold marker
command! FmNew call <sid>FoldMarker('new')
command! FmAfter call <sid>FoldMarker('after')
command! FmBefore call <sid>FoldMarker('before')
command! -range FmWrap
\ call <sid>FoldMarker('wrap')

" append, insert and creat fold marker
nnoremap <silent> <tab> :FmAfter<cr>
nnoremap <silent> <s-tab> :FmBefore<cr>
nnoremap <silent> <c-tab> :FmNew<cr>
vnoremap <silent> ~ :FmWrap<cr>

"}}}
