" trpg product category "{{{1
" Last Update: Feb 16, Sun | 14:58:49 | 2014

" title and paragraph "{{{2

" product information "{{{3
function! BlockedText_Product() "{{{
	g/{\{3\}2/.+3s/^/英文名：
	g/^英文名：/.+1s/^/出版方：
	%s/^\(\$\d\)/\r售价：\1
	%s/^Pages \(\d\)/页数：\1
	%s/^File Size: \(\d\)/PDF文件大小：\1
	%s/^File Last Updated: \(.*\)$/最后更新：\1年月日
	g/^最后更新：/s/$/\r\r点击标题阅读原文
	g/^最后更新：/s/\(最后更新：\)\(.*\)\(\d\{4\}年.*\)$/\1\3\r\2
endfunction "}}}
" }}}3

" markdown style "{{{3
function! MarkDown_Product() "{{{
	" indent
		1,$left 0
		g/^英文名：/.;/^点击标题阅读原文$/left 4
	" title
		g/{\{3\}2$/s/^/[
		g/{\{3\}2$/s/$/]
		g/^http/s/$/)
		g/^http/s/^/(
		g/^(http/.-1,.join!
		g/{\{3\}2/s/^/### 
	" foldmarker
		%s/ {\{3\}2//
		%s/}\{3\}2//
		g/{\{3\}1/s/^.*$/[markdown]\r## 《TRPG产品目录》第一辑，第期
		g/^##\s《TRPG产品目录》/s/$/\r译者：Bozar
		%s/}\{3\}1/[\/markdown]
	" translator's note
		g/^$/.-1s/^\(\[\d\{1,2\}\]\s.*\)$/\1\r__________
		g/^$/.+1s/^\(\[\d\{1,2\}\]\s.*\)$/__________\r\1
		g/^_\{10\}$/.+1s//######
		g/^#\{6\}$/d
endfunction "}}}
" }}}3
" }}}2

" character "{{{2

" hyper link "{{{3
function! LineJoin_Product() "{{{
	mark j
	'j,'j+2s/^\t//e
	'js/^\(.*\)$/[\1]
	'j+1s/^\(.*\)$/(\1)
	'j-1,'j+2join!
endfunction "}}}
function! LineSeperate_Product() "{{{
	put!
	s/$/
	mark a
endfunction "}}}
" }}}3
" }}}2

" key mapping "{{{2

" title and paragraph
nnoremap <buffer> <silent> <f11> :call BlockedText_Product()<cr>
nnoremap <buffer> <silent> <f12> :call MarkDown_Product()<cr>
" hyper link
nnoremap <buffer> <silent> <f2> :call LineJoin_Product()<cr>
vnoremap <buffer> <silent> <f2> s<cr><esc>:call LineSeperate_Product()<cr>
" bold, italic and subtitle 2
vnoremap <buffer> <silent> <f1> s**<c-r>"**<esc>
vnoremap <buffer> <silent> <s-f1> s*<c-r>"*<esc>
nnoremap <buffer> <silent> <f1> :s/^/#### <cr>
" }}}2
" vim: set nolinebreak number foldlevel=20: "}}}1
