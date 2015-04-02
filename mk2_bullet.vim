" bullet.vim Mark II "{{{
" Last Update: Apr 02, Thu | 09:13:37 | 2015

let s:SpaceFour = '    '
let s:SpaceThree = '   '
let s:Mark = 'PlaceHolder_Bullet'
let s:BulletStar = '\v^(\s{4})([^\* ]|$)'
let s:BulletCross = '\v^(\s{8})([^\+ ]|$)'

inoremap <silent> <c-b>
\ <esc>:call <sid>Bullet_Insert()<cr>

command! -range BuVisual call <sid>Bullet_Visual()

function! s:Bullet_Insert()

    let l:before = getpos('.')
    let l:after = l:before
    let l:after[2] = l:after[2]+4

    " star
    if getline('.') =~# s:BulletStar
        execute 's;' . s:BulletStar . ';' .
        \ '\1*' . s:SpaceThree . '\2;'
        call setpos('.',l:after)
    endif

    " cross
    if getline('.') =~# s:BulletCross
        execute 's;' . s:BulletCross . ';' .
        \ '\1+' . s:SpaceThree . '\2;'
        call setpos('.',l:after)
    endif

endfunction

function! s:Bullet_Visual()

    " +
    '<
    normal! 0
    while search('\v^\s{8}\S','cW',line("'>"))
        if getline(line('.')-1) =~# '^\s*$'
            execute 's;\v^\s+;' .
            \ s:SpaceFour . s:SpaceFour .
            \ '+' . s:SpaceThree . ';'
        else
            execute 's;\v^\s+;' .
            \ s:SpaceFour . s:SpaceFour .
            \ s:SpaceFour . ';'
        endif
    endwhile

    " *
    '<
    normal! 0
    while search('\v^\s{4}\S','cW',line("'>"))
        if getline(line('.')-1) =~# '^\s*$'
            execute 's;\v^\s+;' .
            \ s:SpaceFour .
            \ '*' . s:SpaceThree . ';'
        else
            execute 's;\v^\s+;' .
            \ s:SpaceFour . s:SpaceFour . ';'
        endif
    endwhile

    " keep these blank lines
    '<
    normal! 0
    while search('^[^ ]','cW',line("'>"))
        if getline(line('.')-1) =~# '^\s*$' &&
        \ line('.') ># line("'<")
            execute '-1s;^;' . s:Mark . ';'
            +1
        endif
        if getline(line('.')+1) =~# '^\s*$' &&
        \ line('.')+1 <=# line("'>")
            execute '+1s;^;' . s:Mark . ';'
        endif
        +1
        normal! 0
        if line('.') ==# line("'>")
            break
        endif
    endwhile

    " delete these lines
    '<+1
    normal! 0
    if search('^$','cW',line("'>"))
        execute "'<+1,'>" . 'g;^$;d'
    endif

    " delete place holders
    '<
    normal! 0
    if search(s:Mark,'cW',line("'>"))
        execute "'<,'>" . 's;^' . s:Mark . '$;;'
    endif

endfunction

"}}}
