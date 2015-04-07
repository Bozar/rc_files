" bullet.vim "{{{1

" Last Update: Apr 03, Fri | 15:26:56 | 2015

" summary "{{{2

" License: GPL v2
" Author: Bozar

" Vim global plugin

" substitute characters with bullet points
" format paragraph/fold block/whole text

 "}}}2
" load & cpoptions "{{{2

if !exists('g:Loaded_Bullet')

    let g:Loaded_Bullet = 0

endif

if g:Loaded_Bullet > 0

    finish

endif

let g:Loaded_Bullet = 1

let s:Save_cpo = &cpoptions
set cpoptions&vim

 "}}}2
" variables "{{{2

" list character "{{{3

if !exists('g:StrListBefore_Bullet')

    let g:StrListBefore_Bullet = ''

endif

if !exists('g:StrListAfter_Bullet')

    let g:StrListAfter_Bullet = ''

endif

if !exists('g:StrParaBefore_Bullet')

    let g:StrParaBefore_Bullet = ''

endif

 "}}}3
" sublist character "{{{3

if !exists('g:StrSubListBefore_Bullet')

    let g:StrSubListBefore_Bullet = ''

endif

if !exists('g:StrSubListAfter_Bullet')

    let g:StrSubListAfter_Bullet = ''

endif

if !exists('g:StrSubParaBefore_Bullet')

    let g:StrSubParaBefore_Bullet = ''

endif

 "}}}3
" list pattern "{{{3

if !exists('g:PatListBefore_Bullet')

    let g:PatListBefore_Bullet = ''

endif

if !exists('g:PatListAfter_Bullet')

    let g:PatListAfter_Bullet = ''

endif

if !exists('g:PatParaBefore_Bullet')

    let g:PatParaBefore_Bullet = ''

endif

if !exists('g:PatParaAfter_Bullet')

    let g:PatParaAfter_Bullet = ''

endif

 "}}}3
" sublist pattern "{{{3

if !exists('g:PatSubListBefore_Bullet')

    let g:PatSubListBefore_Bullet = ''

endif

if !exists('g:PatSubListAfter_Bullet')

    let g:PatSubListAfter_Bullet = ''

endif

if !exists('g:PatSubParaBefore_Bullet')

    let g:PatSubParaBefore_Bullet = ''

endif

if !exists('g:PatSubParaAfter_Bullet')

    let g:PatSubParaAfter_Bullet = ''

endif

 "}}}3
" text width "{{{3

if !exists('g:TextWidth_Bullet')

    let g:TextWidth_Bullet = ''

endif

 "}}}3
" format options "{{{3

if !exists('g:FormatOptionsOverwrite_Bullet')

    let g:FormatOptionsOverwrite_Bullet = ''

endif

if !exists('g:SwitchFormatOptionsPut_Bullet')

    let g:SwitchFormatOptionsPut_Bullet = ''

endif

 "}}}3
" comments "{{{3

if !exists('g:CommentsOverwrite_Bullet')

    let g:CommentsOverwrite_Bullet = ''

endif

if !exists('g:CommentsAdd_Bullet')

    let g:CommentsAdd_Bullet = ''

endif

if !exists('g:StrComEnd_Bullet')

    let g:StrComEnd_Bullet = ''

endif

if !exists('g:PatComEnd_Bullet')

    let g:PatComEnd_Bullet = ''

endif

 "}}}3
" protect lines "{{{3

if !exists('g:PatProtectOverwrite_Bullet')

    let g:PatProtectOverwrite_Bullet = ''

endif

if !exists('g:PatProtectAdd_Bullet')

    let g:PatProtectAdd_Bullet = ''

endif

if !exists('g:StrProtect_Bullet')

    let g:StrProtect_Bullet = ''

endif

 "}}}3
" autocommands "{{{3

if !exists('g:AutoLoad_Bullet')

    let g:AutoLoad_Bullet = ''

endif

 "}}}3
" load delete-space functions "{{{3

" load space#DelSpaceTrail()

if !exists('g:SwitchDelSpaceTrail_Bullet')

    let g:SwitchDelSpaceTrail_Bullet = ''

endif

" load space#DelSpaceCJK()

if !exists('g:SwitchDelSpaceCJK_Bullet')

    let g:SwitchDelSpaceCJK_Bullet = ''

endif

 "}}}3
" placeholder "{{{3

if !exists('g:StrMark_Bullet')

    let g:StrMark_Bullet = ''

endif

 "}}}3
 "}}}2
" function "{{{2

" parts "{{{3

function s:LoadBullets() "{{{4

    " list character, before

    if g:StrListBefore_Bullet != ''

        let s:StrListBefore =
        \ g:StrListBefore_Bullet

    else

        let s:StrListBefore = '='

    endif

    " list character, after

    if g:StrListAfter_Bullet != ''

        let s:StrListAfter =
        \ g:StrListAfter_Bullet

    else

        let s:StrListAfter = '*'

    endif

    " para character, before

    if g:StrParaBefore_Bullet != ''

        let s:StrParaBefore =
        \ g:StrParaBefore_Bullet

    else

        let s:StrParaBefore = '-'

    endif

    " sub-list character, before

    if g:StrSubListBefore_Bullet != ''

        let s:StrSubListBefore =
        \ g:StrSubListBefore_Bullet

    else

        let s:StrSubListBefore = '=='

    endif

    " sub-list character, after

    if g:StrSubListAfter_Bullet != ''

        let s:StrSubListAfter =
        \ g:StrSubListAfter_Bullet

    else

        let s:StrSubListAfter = '+'

    endif

    " sub-para character, before

    if g:StrSubParaBefore_Bullet != ''

        let s:StrSubParaBefore =
        \ g:StrSubParaBefore_Bullet

    else

        let s:StrSubParaBefore = '--'

    endif

    " list pattern, before

    if g:PatListBefore_Bullet != ''

        let s:PatListBefore =
        \ g:PatListBefore_Bullet

    else

        let s:PatListBefore = '^\s*=\(=\)\@!\s*'

    endif

    " list pattern, after

    if g:PatListAfter_Bullet != ''

        let s:PatListAfter =
        \ g:PatListAfter_Bullet

    else

        let s:PatListAfter = '    *   '

    endif

    " para pattern, before

    if g:PatParaBefore_Bullet != ''

        let s:PatParaBefore =
        \ g:PatParaBefore_Bullet

    else

        let s:PatParaBefore = '^\s*-\(-\)\@!\s*'

    endif

    " para pattern, after

    if g:PatParaAfter_Bullet != ''

        let s:PatParaAfter =
        \ g:PatParaAfter_Bullet

    else

        let s:PatParaAfter = '        '

    endif

    " sub-list pattern, before

    if g:PatSubListBefore_Bullet != ''

        let s:PatSubListBefore =
        \ g:PatSubListBefore_Bullet

    else

        let s:PatSubListBefore =
        \ '^\s*==\(=\)\@!\s*'

    endif

    " sub-list pattern, after

    if g:PatSubListAfter_Bullet != ''

        let s:PatSubListAfter =
        \ g:PatSubListAfter_Bullet

    else

        let s:PatSubListAfter = '        +   '

    endif

    " sub-para pattern, before

    if g:PatSubParaBefore_Bullet != ''

        let s:PatSubParaBefore =
        \ g:PatSubParaBefore_Bullet

    else

        let s:PatSubParaBefore =
        \ '^\s*--\(-\)\@!\s*'

    endif

    " sub-para pattern, after

    if g:PatSubParaAfter_Bullet != ''

        let s:PatSubParaAfter =
        \ g:PatSubParaAfter_Bullet

    else

        let s:PatSubParaAfter = '            '

    endif

    let s:PatSearch =
    \ s:PatListBefore . '\|' .
    \ s:PatParaBefore . '\|' .
    \ s:PatSubListBefore . '\|' .
    \ s:PatSubParaBefore

endfunction "}}}4

function s:LoadStrings() "{{{4

    " put &formatoptions into register

    if g:SwitchFormatOptionsPut_Bullet > 0

        let s:SwitchFormatOptionsPut = 1

    else

        let s:SwitchFormatOptionsPut = 0

    endif

    " comment end character

    if g:StrComEnd_Bullet != ''

        let s:StrComEnd = g:StrComEnd_Bullet

    else

        let s:StrComEnd = '/'

    endif

    " comment end pattern

    if g:PatComEnd_Bullet != ''

        let s:PatComEnd = g:PatComEnd_Bullet

    else

        let s:PatComEnd = '\s*\/'

    endif

    " protection characters
    " such strings will appear in comments
    " as well

    if g:StrProtect_Bullet != ''

        let s:StrProtect =
        \ g:StrProtect_Bullet

    else

        let s:StrProtect = '@'

    endif

    " protection patterns

    if g:PatProtectOverwrite_Bullet != ''

        let s:PatProtectFinal =
        \ g:PatProtectOverwrite_Bullet .
        \ g:PatProtectAdd_Bullet

    else

        let s:PatProtectOrigin = '\(\({\{3}'
        let s:PatProtectOrigin .=  '\|}\{3}\)'
        let s:PatProtectOrigin .= '\d\{0,2}$\)'

        let s:PatProtectFinal =
        \ s:PatProtectOrigin .
        \ g:PatProtectAdd_Bullet

    endif

    " load space#DelSpaceTrail()

    if g:SwitchDelSpaceTrail_Bullet < 0

        let s:SwitchDelSpaceTrail = 0

    else

        let s:SwitchDelSpaceTrail = 1

    endif

    " load space#DelSpaceCJK()

    if g:SwitchDelSpaceCJK_Bullet < 0

        let s:SwitchDelSpaceCJK = 0

    else

        let s:SwitchDelSpaceCJK = 1

    endif

    " place holder mark

    if g:StrMark_Bullet != ''

        let s:StrMark = g:StrMark_Bullet

    else

        let s:StrMark =
        \ '###LONG_PLACEHOLDER_FOR_BULLET###'

    endif

endfunction "}}}4

function s:LoadSettings(when) "{{{4

    " load settings

    if a:when == 0

        let s:SaveTextWidth = &textwidth
        let s:SaveFormatOptions = &formatoptions
        let s:SaveComments = &comments

        " textwidth

        if g:TextWidth_Bullet > 0

            let &l:textwidth = g:TextWidth_Bullet

        endif

        " formatoptions, overwrite

        if g:FormatOptionsOverwrite_Bullet != ''

            let &l:formatoptions =
            \ g:FormatOptionsOverwrite_Bullet

        else

            let &l:formatoptions = 'tcqro2mB1j'

        endif

        " put &formatoptions into register

        if s:SwitchFormatOptionsPut == 1

            let @" = &l:formatoptions

        endif

        " comments

        " overwrite comment setting

        if g:CommentsOverwrite_Bullet != ''

            let &l:comments =
            \ g:CommentsOverwrite_Bullet

        else

            setl comments=

            " sublist characters, before

            let &l:comments .=
            \ 's:' . s:StrSubListBefore .
            \ ',m:' . s:StrSubParaBefore.
            \ ',ex:' . s:StrComEnd

            " list characters, before

            let &l:comments .=
            \ ',s:' . s:StrListBefore .
            \ ',m:' . s:StrParaBefore .
            \ ',ex:' . s:StrComEnd

            " sublist characters, after

            let &l:comments .=
            \ ',f:' . s:StrSubListAfter

            " list characters, after

            let &l:comments .=
            \ ',f:' . s:StrListAfter

            " protect characters

            let &l:comments .=
            \ ',s:' . s:StrProtect .
            \ ',m:' . s:StrProtect .
            \ ',ex:' . s:StrProtect

        endif

        " add new comments

        let &l:comments .= ',' .
        \ g:CommentsAdd_Bullet

    endif

    " unload settings

    if a:when == 1

        " textwidth

        let &l:textwidth = s:SaveTextWidth

        " formatoptions

        let &l:formatoptions =
        \ s:SaveFormatOptions

        " comments

        let &l:comments = s:SaveComments

    endif

endfunction "}}}4

function s:LoadAll(when) "{{{4

    call <sid>LoadBullets()
    call <sid>LoadStrings()
    call <sid>LoadSettings(a:when)

endfunction "}}}4

function s:DelSpaceTrail() "{{{4

    " delete trailing blank characters: tabs,
    " half-width spaces and full-width spaces
    " NOTE: cursor position must be set first!

    call space#DelSpaceTrail()
    call moveCursor#KeepPos(1)

endfunction "}}}4

function s:DelBullet(when) "{{{4

    " suppose '=' will be replaced with bullet '*'

    " delete lines containing only such characters
    " '^\s*=\s*$' or '^\s*\/\s*$'

    " '/' appears in a three-piece comment
    " which is defined in s:LoadStrings()

    " :help format-comments

    if a:when == 0

        " delete character, s:PatComEnd at the end
        " of line

        execute moveCursor#TakeLineNr('J','')
        execute 'normal! 0'

        let l:eol = '\(' . s:PatSearch . '\).*'
        let l:eol .= s:PatComEnd . '$'

        if search(l:eol,'cn',
        \ moveCursor#TakeLineNr('K',''))

            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 'g/' . l:eol . '/' .
            \ 's/' . s:PatComEnd . '//'

        endif

        " delete line, only bullet

        execute moveCursor#TakeLineNr('J','')
        execute 'normal! 0'

        let l:bullet = '\(' . s:PatSearch . '\)$'

        if search(l:bullet,'cn',
        \ moveCursor#TakeLineNr('K',''))

            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 's/' . l:bullet . '/' . s:StrMark .
            \ '/'

        endif

        " delete line, only s:PatComEnd

        execute moveCursor#TakeLineNr('J','')
        execute 'normal! 0'

        let l:com = '^' . s:PatComEnd . '$'

        if search(l:com,'cn',
        \ moveCursor#TakeLineNr('K',''))

            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 's/' . l:com . '/' . s:StrMark . '/'

        endif

    endif

    " delete marked lines after substitution
    " in case the first/last line contains mark

    if a:when == 1

        execute moveCursor#TakeLineNr('J','')
        execute 'normal! 0'

        if search(s:StrMark,'c',
        \ moveCursor#TakeLineNr('K','')) != 0

            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 'g/' . s:StrMark . '/delete'

        endif

    endif

endfunction "}}}4

function s:SubsBulletCore() "{{{4

    let l:i = 0

    while l:i < 4

        execute moveCursor#TakeLineNr('J','')
        execute 'normal! 0'

        " list

        " substitute '=' with '*'
        " indent 4 spaecs

        " substitute '-' with ''
        " indent 4 spaecs

        if l:i == 0 && 
        \ search(s:PatListBefore,'c',
        \ moveCursor#TakeLineNr('K',''))

            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 's/' .
            \ s:PatListBefore .  '/' .
            \ s:PatListAfter . '/'

        endif

        if l:i == 1 && 
        \ search(s:PatParaBefore,'c',
        \ moveCursor#TakeLineNr('K',''))

            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 's/' .
            \ s:PatParaBefore . '/' .
            \ s:PatParaAfter . '/'

        endif

        " sub list

        " substitute '==' with '+'
        " indent 8 spaces

        " substitute '--' with ''
        " indent 8 spaces

        if l:i == 2 && 
        \ search(s:PatSubListBefore,'c',
        \ moveCursor#TakeLineNr('K',''))

            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 's/' .
            \ s:PatSubListBefore . '/' .
            \ s:PatSubListAfter . '/'

        endif

        if l:i == 3 && 
        \ search(s:PatSubParaBefore,'c',
        \ moveCursor#TakeLineNr('K',''))

            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 's/' .
            \ s:PatSubParaBefore . '/' .
            \ s:PatSubParaAfter . '/'

        endif

        let l:i = l:i + 1

    endwhile

endfunction "}}}4

function s:AutoCommand() "{{{4

    if g:AutoLoad_Bullet == ''

        return

    endif

    execute 'autocmd BufRead,BufNewFile' .
    \ ' ' . g:AutoLoad_Bullet .
    \ ' call <sid>LoadAll(0)'

endfunction "}}}4

function s:EchoVars(name) "{{{4

    echo a:name . " == '" . eval(a:name) . "'"

endfunction "}}}4

 "}}}3
" main "{{{3

function s:SubsBulletNoTW(range) "{{{4

    call moveCursor#KeepPos(0)
    call <sid>LoadAll(0)
    call <sid>LoadAll(1)

    " delete trailing spaces

    if s:SwitchDelSpaceTrail == 1

        call <sid>DelSpaceTrail()

    endif

    " set format range

    " paragraph

    if a:range == 0

        call moveCursor#SetLineJKPara()

    " whole text

    elseif a:range == 1

        call moveCursor#SetLineJKWhole()

    endif

    " mark lines to be deleted

    call <sid>DelBullet(0)

    " substitute bullets

    call <sid>SubsBulletCore()

    " delete marked lines

    call <sid>DelBullet(1)

    " delete spaces between two CJK characters
    " delete spaces between CJK punctuation mark
    " and '\w' character

    if s:SwitchDelSpaceCJK == 1

        call space#DelSpaceCJK()

    endif

    call moveCursor#KeepPos(1)

endfunction "}}}4

function s:SubsBulletTW(range) "{{{4

    call moveCursor#KeepPos(0)
    call <sid>LoadAll(0)

    " delete trailing spaces

    if s:SwitchDelSpaceTrail == 1

        call <sid>DelSpaceTrail()

    endif

    let l:i = 0

    while 1

        " set format range

        " paragraph

        if a:range == 0

            call moveCursor#SetLineJKPara()

        " whole text

        elseif a:range == 1

            call moveCursor#SetLineJKWhole()

        endif

        " substitute bullets once

        " set marks twice (before and after
        " substitution)

        " in case the first/last line is deleted

        if l:i > 0

            break

        endif

        " mark lines to be deleted

        call <sid>DelBullet(0)

        " substitute bullets

        call <sid>SubsBulletCore()

        " delete marked lines

        call <sid>DelBullet(1)

        let l:i = l:i +1

    endwhile

    " protect lines

    execute moveCursor#TakeLineNr('J','')
    execute 'normal! 0'

    if search(s:PatProtectFinal,'c',
    \ moveCursor#TakeLineNr('K',''))

        execute moveCursor#TakeLineNr('J','K') .
        \ 'g/' .
        \ s:PatProtectFinal . '/' .
        \ 's/^/' . s:StrProtect . '/'

    endif

    let l:j = 0

    while 1

        " delete spaces between two CJK characters

        " delete spaces between CJK punctuation
        " mark and '\w' character

        if s:SwitchDelSpaceCJK == 1

            call space#DelSpaceCJK()

        endif

        if l:j > 0

            break

        endif

        " format

        if a:range == 0

            execute moveCursor#TakeLineNr('J','')
            execute "normal gqip"

        elseif a:range == 1

            1

            let l:k = 0

            while l:k < 2

                exe 'normal gqip'

                '}
                +1

                if line('.') == line('$')

                    let l:k = l:k + 1

                endif

            endwhile

            " execute 'normal gggqG'

            " use 'gqip' instead of 'gqG'

            "   indent line 1
            " DO NOT indent line 2
            "
            " * text 1
            " * text 2
            "
            "   indent line 3
            " DO NOT indent line 4

            " let &comments = 's:*,m:*,ex:*'
            " let &formatoptions = 'tq2'
            " gqG

            " if there are at least two continous
            " lines beginning with stars(*), 'gqG'
            " will NOT indent 'line 2', but it
            " will indent 'line 4'

        endif

        " unprotect lines

        if a:range == 0

            call moveCursor#SetLineJKPara()

        elseif a:range == 1

            call moveCursor#SetLineJKWhole()

        endif

        execute moveCursor#TakeLineNr('J','')
        execute 'normal! 0'

        if search('^' . s:StrProtect,'c',
        \ moveCursor#TakeLineNr('K',''))

            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 's/^' . s:StrProtect . '//'

        endif

        let l:j = l:j +1

    endwhile

    " unload settings

    call <sid>LoadAll(1)

    " reset cursor position

    call moveCursor#KeepPos(1)

endfunction "}}}4

function s:SelectFuns(...) "{{{4

    " show help

    if !exists('a:1')

        call <sid>EchoCommandArgs(0)

    " paragraph, textwidth

    elseif a:1 == 'p'

        call <sid>SubsBulletTW(0)

    " paragraph, no textwidth

    elseif a:1 == 'pn'

        call <sid>SubsBulletNoTW(0)

    " whole text, textwidth

    elseif a:1 == 'w'

        call <sid>SubsBulletTW(1)

    " whole text, no textwidth

    elseif a:1 == 'wn'

        call <sid>SubsBulletNoTW(1)

    " echo bullet variables

    elseif a:1 == 'b'

        call <sid>EchoBullets()

    " echo settings

    elseif a:1 == 's'

        call <sid>EchoSettings()

    " show help

    elseif a:1 == 'h'

        call <sid>EchoCommandArgs(0)

    " report error and show help

    else

        call <sid>EchoCommandArgs(1)

    endif

endfunction "}}}4

function s:EchoSettings() "{{{4

    call <sid>LoadAll(0)

    let l:format = "&formatoptions == '"
    let l:options = &formatoptions

    let l:text = "&textwidth == '"
    let l:width = &textwidth

    let l:com = "&comments == '"
    let l:ments = &comments

    " NOTE: Reload default settings before echoing
    " lines.

    " If the number of lines to be echohed are
    " greater than the screen height, and user
    " break the 'echo function' half-way,

    " Vim will not process the unechoed part.

    " Such as lines to be echoed and functions to
    " be called.

    call <sid>LoadAll(1)

    let l:put = 'Put &formatoptions into'
    let l:put .= ' register @": '

    if s:SwitchFormatOptionsPut == 1

        let l:register = 'YES'

    elseif s:SwitchFormatOptionsPut == 0

        let l:register = 'NO'

    endif

    let l:auto =  'Auto load bullet settings: '

    if g:AutoLoad_Bullet != ''

        let l:command = 'YES'

    else

        let l:command = 'NO'

    endif

    let l:del = 'Delete trailing spaces: '

    if s:SwitchDelSpaceTrail == 1

        let l:space = 'YES'

    elseif s:SwitchDelSpaceTrail == 0

        let l:space = 'NO'

    endif

    let l:cjk = 'Delete spaces between two CJK'
    let l:cjk .= ' characters:'
    let l:cjk .= ' '

    let l:punc = 'Delete spaces between CJK'
    let l:punc .= ' punctuation mark'

    let l:tuation = "and '\\w' character:"
    let l:tuation .= ' '

    if s:SwitchDelSpaceCJK == 1

        let l:wordCha = 'YES'

    elseif s:SwitchDelSpaceCJK == 0

        let l:wordCha = 'NO'

    endif

    echo '=============================='

    echo l:format . l:options . "'"
    echo l:put . l:register

    echo '------------------------------'

    call <sid>EchoVars(
    \'g:FormatOptionsOverwrite_Bullet')

    call <sid>EchoVars(
    \'g:SwitchFormatOptionsPut_Bullet')

    echo '=============================='

    echo l:text . l:width . "'"

    echo '------------------------------'

    call <sid>EchoVars('g:TextWidth_Bullet')

    echo '=============================='

    echo l:com . l:ments . "'"

    echo '------------------------------'

    call <sid>EchoVars(
    \'g:CommentsOverwrite_Bullet')

    call <sid>EchoVars('g:CommentsAdd_Bullet')

    echo '=============================='

    call <sid>EchoVars('&tabstop')

    call <sid>EchoVars('&softtabstop')

    call <sid>EchoVars('&shiftwidth')

    call <sid>EchoVars('&expandtab')

    echo '=============================='

    call <sid>EchoVars('s:PatSearch')

    echo '=============================='

    call <sid>EchoVars('s:StrComEnd')

    echo '------------------------------'

    call <sid>EchoVars('g:StrComEnd_Bullet')

    echo '=============================='

    call <sid>EchoVars('s:PatComEnd')

    echo '------------------------------'

    call <sid>EchoVars('g:PatComEnd_Bullet')

    echo '=============================='

    call <sid>EchoVars('s:StrMark')

    echo '------------------------------'

    call <sid>EchoVars('g:StrMark_Bullet')

    echo '=============================='

    call <sid>EchoVars('s:StrProtect')

    echo '------------------------------'

    call <sid>EchoVars('g:StrProtect_Bullet')

    echo '=============================='

    call <sid>EchoVars('s:PatProtectFinal')

    echo '------------------------------'

    call <sid>EchoVars(
    \'g:PatProtectOverwrite_Bullet')

    call <sid>EchoVars(
    \'g:PatProtectAdd_Bullet')

    echo '=============================='

    echo l:del . l:space

    echo '------------------------------'

    call <sid>EchoVars(
    \'g:SwitchDelSpaceTrail_Bullet')

    echo '=============================='

    echo l:cjk . l:wordCha

    echo l:punc
    echo l:tuation . l:wordCha

    echo '------------------------------'

    call <sid>EchoVars(
    \'g:SwitchDelSpaceCJK_Bullet')

    echo '=============================='

    echo l:auto . l:command

    echo '------------------------------'

    call <sid>EchoVars('g:AutoLoad_Bullet')

    echo '=============================='

endfunction "}}}4

function s:EchoBullets() "{{{4

    call <sid>LoadAll(0)
    call <sid>LoadAll(1)

    echo '=============================='

    call <sid>EchoVars('s:StrListBefore')

    call <sid>EchoVars('s:StrListAfter')

    call <sid>EchoVars('s:StrParaBefore')

    echo '------------------------------'

    call <sid>EchoVars('g:StrListBefore_Bullet')

    call <sid>EchoVars('g:StrListAfter_Bullet')

    call <sid>EchoVars('g:StrParaBefore_Bullet')

    echo '=============================='

    call <sid>EchoVars('s:PatListBefore')

    call <sid>EchoVars('s:PatListAfter')

    call <sid>EchoVars('s:PatParaBefore')

    call <sid>EchoVars('s:PatParaAfter')

    echo '------------------------------'

    call <sid>EchoVars('g:PatListBefore_Bullet')

    call <sid>EchoVars('g:PatListAfter_Bullet')

    call <sid>EchoVars('g:PatParaBefore_Bullet')

    call <sid>EchoVars('g:PatParaAfter_Bullet')

    echo '=============================='

    call <sid>EchoVars('s:StrSubListBefore')

    call <sid>EchoVars('s:StrSubListAfter')

    call <sid>EchoVars('s:StrSubParaBefore')

    echo '------------------------------'

    call <sid>EchoVars(
    \ 'g:StrSubListBefore_Bullet')

    call <sid>EchoVars(
    \'g:StrSubListAfter_Bullet')

    call <sid>EchoVars(
    \ 'g:StrSubParaBefore_Bullet')

    echo '=============================='

    call <sid>EchoVars('s:PatSubListBefore')

    call <sid>EchoVars('s:PatSubListAfter')

    call <sid>EchoVars('s:PatSubParaBefore')

    call <sid>EchoVars('s:PatSubParaAfter')

    echo '------------------------------'

    call <sid>EchoVars(
    \ 'g:PatSubListBefore_Bullet')

    call <sid>EchoVars(
    \'g:PatSubListAfter_Bullet')

    call <sid>EchoVars(
    \ 'g:PatSubParaBefore_Bullet')

    call <sid>EchoVars(
    \'g:PatSubParaAfter_Bullet')

    echo '=============================='

endfunction "}}}4

function s:EchoCommandArgs(help) "{{{4

    if a:help == 1

        echo '------------------------------'

        echo 'ERROR: Wrong arguments!'

    endif

    echo '------------------------------'

    echo 'Quick Reference:'

    echo '------------------------------'

    echo 'Format: Bullet [args]'
    echo 'Example: Bullet p'

    echo '------------------------------'

    echo 'Paragraph, textwidth: p'
    echo 'Paragraph, no textwidth: pn'

    echo '------------------------------'

    echo 'Whole text, textwidth: w'
    echo 'Whole text, no textwidth: wn'

    echo '------------------------------'

    echo 'Echo bullet variables: b'
    echo 'Echo settings: s'

    echo '------------------------------'

    echo 'Show help: h'

    echo '------------------------------'

endfunction "}}}4

 "}}}3
 "}}}2
" commands "{{{2

autocmd VimEnter * call <sid>AutoCommand()

if !exists(':Bullet')

    command -nargs=? Bullet
    \ call <sid>SelectFuns(<f-args>)

endif

 "}}}2
" cpotions "{{{2

let &cpoptions = s:Save_cpo
unlet s:Save_cpo

 "}}}2
" vim: set fdm=marker fdl=20 tw=50: "}}}1
