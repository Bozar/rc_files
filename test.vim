nno <buffer> <f12> <esc>:call <sid>Test()<cr>
ino <buffer> <f12> <esc>:call <sid>Test()<cr>


fun! s:Test()
    let l:line = line('.')
    call <sid>OneLine(expand('<cword>'))
    if line('.') != l:line
        exe l:line
        exe 'normal! f^'
    endif
endfun

fun! s:OneLine(abbr)
    split template
    let l:pat = '^' . a:abbr . '$'
    if search(l:pat,'w')
        let l:condensed = getline(line('.')+1)
        wincmd c
        let l:indent = indent(line('.'))
        exe 's/' . expand('<cword>') . '/'. l:condensed . '/'
        call <sid>Expand(l:indent)
    else
        wincmd c
    endif
endfun

fun! s:Expand(indent)
    let l:begin = line('.') + 1
    s;\$;\r;ge
    exe l:begin . ',.left ' . a:indent
    exe l:begin . ',.s/>/' . '    /ge'
endfun

