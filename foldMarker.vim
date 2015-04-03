" fold marker "{{{
" Last Update: Apr 03, Fri | 00:42:09 | 2015

let s:Title = 'FOLDMARKER'

function! s:LoadVars()

    let s:Bra =
    \ substitute(&foldmarker,'\v(.*)(,.*)','\1',
    \ '')
    let s:Ket =
    \ substitute(&foldmarker,'\v(.*,)(.*)','\2',
    \ '')

    let s:FoldBegin = '\v^(.*)\s(\S{-})' .
    \ '\M' . s:Bra . '\v(\d{0,2})\s*$'
    let s:FoldEnd = '\v^(.*)' .
    \ '\M' . s:Ket . '\v(\d{0,2})\s*$'

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

function! s:ChangeLevel()

    if line("'<") <# 1 ||
    \ line("'<") ># line('$') ||
    \ line("'>") <# 1 ||
    \ line("'>") ># line('$')
        echo 'ERROR: Visual block not found!'
        return
    endif

    let l:BeginNum =
    \ substitute(s:FoldBegin,'{0,2}','+','')
    let l:BeginNoNum =
    \ substitute(s:FoldBegin,'{0,2}','{0}','')
    let l:EndNum =
    \ substitute(s:FoldEnd,'{0,2}','+','')
    let l:EndNoNum =
    \ substitute(s:FoldEnd,'{0,2}','{0}','')

    normal! '<
    normal! 0
    if search(l:BeginNoNum,'cnW',line("'>"))
        execute "'<,'>" . 'g/' . l:BeginNoNum .
        \ '/s/\v\s*$/\=foldlevel(".")/'
    elseif search(l:BeginNum,'cnW',line("'>"))
        execute "'<,'>" . 'g/' . l:BeginNum .
        \ '/s//\1 \2' . s:Bra . '/'
    endif

    normal! '<
    normal! 0
    if search(l:EndNoNum,'cnW',line("'>"))
        execute "'<,'>" . 'g/' . l:EndNoNum .
        \ '/s/\v\s*$/\=foldlevel(".")/'
    elseif search(l:EndNum,'cnW',line("'>"))
        execute "'<,'>" . 'g/' . l:EndNum .
        \ '/s//\1' . s:Ket . '/'
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
        if line("'<") ==# line("'>") ||
        \ getline(line("'<")) =~# s:FoldBegin ||
        \ getline(line("'>")) =~# s:FoldEnd
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

function! s:FoldLevel()

    call <sid>LoadVars()
    call <sid>ExpandFold(0)

    call <sid>ChangeLevel()

    call <sid>ExpandFold(1)

endfunction

" creat fold marker
command! FmNew call <sid>FoldMarker('new')
command! FmAfter call <sid>FoldMarker('after')
command! FmBefore call <sid>FoldMarker('before')
command! -range FmWrap
\ call <sid>FoldMarker('wrap')

" change fold level
command! -range FmLevel call <sid>FoldLevel()

" creat fold marker
nnoremap <silent> <tab> :FmAfter<cr>
nnoremap <silent> <s-tab> :FmBefore<cr>
nnoremap <silent> <c-tab> :FmNew<cr>
nnoremap <silent> ~ :FmWrap<cr>
vnoremap <silent> ~ :FmWrap<cr>

"}}}
