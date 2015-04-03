" foldMarker.vim "{{{1
" Last Update: Apr 03, Fri | 14:26:09 | 2015

function! s:LoadVars() "{{{2

    let s:Title = 'FOLDMARKER'

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

endfunction "}}}2

function! s:ExpandFold(when) "{{{2

    if a:when ==# 0
        let s:foldlevel = &foldlevel
        let &foldlevel = 20
    endif
    if a:when ==# 1
        let &foldlevel = s:foldlevel
    endif

endfunction "}}}2

" fold level & fold prefix
function! s:GetFoldInfo() "{{{2

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

endfunction "}}}2

function! s:CreatMarker(line) "{{{2

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

endfunction "}}}2

function! s:CreatLevel() "{{{2

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

endfunction "}}}2

function! s:ChangeLevel() "{{{2

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

endfunction "}}}2

" main function
function! s:FoldMarker(line) "{{{2

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
    normal! zz

endfunction "}}}2

function! s:FoldLevel() "{{{2

    call <sid>LoadVars()
    call <sid>ExpandFold(0)

    call <sid>ChangeLevel()

    call <sid>ExpandFold(1)

endfunction "}}}2

function! s:Commands() "{{{2

    command! FmNew
    \ call <sid>FoldMarker('new')
    command! FmAfter
    \ call <sid>FoldMarker('after')
    command! FmBefore
    \ call <sid>FoldMarker('before')
    command! -range FmWrap
    \ call <sid>FoldMarker('wrap')
    command! -range FmLevel
    \ call <sid>FoldLevel()

    if !exists('g:LoadKeyMap_foldMarker') ||
    \ g:LoadKeyMap_foldMarker ># 0
        nnoremap <silent> <tab> :FmAfter<cr>
        nnoremap <silent> <s-tab> :FmBefore<cr>
        nnoremap <silent> <c-tab> :FmNew<cr>
        vnoremap <silent> <s-tab> :FmLevel<cr>
        vnoremap <silent> <c-tab> :FmWrap<cr>
    endif

endfunction "}}}2

call <sid>Commands()

"}}}1
