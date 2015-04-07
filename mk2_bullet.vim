" bullet.vim Mark II "{{{1
" Last Update: Apr 05, Sun | 22:24:13 | 2015

let s:SpaceFour = '    '
let s:SpaceThree = '   '
let s:Mark = 'PlaceHolder_Bullet'
let s:BulletSpace = '\v^\s+'
let s:BulletStar = '\v^\s+\*\s*'
let s:BulletCross = '\v^\s+\+\s*'
"let s:BulletSelect = '\v^\s+(\*|\+)'

inoremap <silent> <c-l>
\ <c-o>:call <sid>Bullet_Insert()<cr>

" command name modified
"command! -range Test call <sid>Bullet_Visual()

function! s:Bullet_Insert() "{{{2

    let l:before = getpos('.')
    let l:after = l:before

    " from star to cross
    if getline('.') =~# s:BulletStar
        execute 's/' . s:BulletStar . '/' .
        \ s:SpaceFour . s:SpaceFour .
        \ '+' . s:SpaceThree . '/'
        let l:after[2] = l:after[2]+4
        call setpos('.',l:after)

    " from cross to space
    elseif getline('.') =~# s:BulletCross
        execute 's/' . s:BulletCross . '/' .
        \ s:SpaceFour . '/'
        let l:after[2] = l:after[2]-8
        call setpos('.',l:after)

    " from space to star
    elseif getline('.') =~# s:BulletSpace
        execute 's/' . s:BulletSpace . '/' .
        \ s:SpaceFour . '*' . s:SpaceThree . '/'
        let l:after[2] = l:after[2]+4
        call setpos('.',l:after)
    endif

endfunction "}}}2

"function! s:Bullet_Visual() "{{{2
"
"    '<
"    normal! 0
"    while search(s:BulletSelect,'cW',line("'>"))
"        call moveCursor#SetLineJKPara()
"        let l:listBegin =
"        \ [line("'<"),
"        \ moveCursor#TakeLineNr('J','')]
"        let l:listEnd =
"        \ [line("'>"),
"        \ moveCursor#TakeLineNr('K','')]
"        let l:numBegin = max(l:listBegin)
"        let l:numEnd = min(l:listEnd)
"        execute
"        \ l:numBegin . ',' . l:numEnd .
"        \ 'g/^/s/^/' . s:Mark . '/'
"    endwhile
"
"    " +
"    '<
"    normal! 0
"    while search('\v^\s{8}\S','cW',line("'>"))
"        if getline(line('.')-1) =~# '^\s*$'
"            execute 's/\v^\s+/' .
"            \ s:SpaceFour . s:SpaceFour .
"            \ '+' . s:SpaceThree . '/'
"        else
"            execute 's/\v^\s+/' .
"            \ s:SpaceFour . s:SpaceFour .
"            \ s:SpaceFour . '/'
"        endif
"    endwhile
"
"    " *
"    '<
"    normal! 0
"    while search('\v^\s{4}\S','cW',line("'>"))
"        if getline(line('.')-1) =~# '^\s*$'
"            execute 's/\v^\s+/' .
"            \ s:SpaceFour .
"            \ '*' . s:SpaceThree . '/'
"        else
"            execute 's/\v^\s+/' .
"            \ s:SpaceFour . s:SpaceFour . '/'
"        endif
"    endwhile
"
"    " keep these blank lines
"    '<
"    normal! 0
"    while search('^[^ ]','cW',line("'>"))
"        if getline(line('.')-1) =~# '^\s*$' &&
"        \ line('.') ># line("'<")
"            execute '-1s/^/' . s:Mark . '/'
"            +1
"        endif
"        if getline(line('.')+1) =~# '^\s*$' &&
"        \ line('.')+1 <=# line("'>")
"            execute '+1s/^/' . s:Mark . '/'
"        endif
"        +1
"        normal! 0
"        if line('.') ==# line("'>")
"            break
"        endif
"    endwhile
"
"    " delete these lines
"    '<+1
"    normal! 0
"    if search('^$','cW',line("'>"))
"        execute "'<+1,'>" . 'g/^$/d'
"    endif
"
"    " delete place holders
"    '<
"    normal! 0
"    if search(s:Mark,'cW',line("'>"))
"        execute "'<,'>" . 'g/^' . s:Mark . '/s///'
"    endif
"
"endfunction "}}}2

"}}}1
