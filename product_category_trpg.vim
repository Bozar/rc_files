" Last Update: Sun, Jan 26 | 20:36:01 | 2014
" trpg product category "{{{1
function! BlockedText() "{{{
	" product name
	g/^http/s/^\(.*\)$/\1\r\r\1
	g/^http/.+2s/^http.*\//英文名：/
	g/^英文名：/s/-/ /g
	g/^英文名：/s/\(?\|-%\).*$//
	g/^英文名：/.+1d
	" other information
	%s/^\(\$\d\)/售价：\1
	%s/^Pages \(\d\)/页数：\1
	%s/^File Size: \(\d\)/PDF文件大小：\1
	%s/^File Last Updated: \(.*\)$/最后更新：\1年月日
	g/^最后更新：/s/$/\r\r点击标题阅读原文
	g/^最后更新：/s/\(最后更新：\)\(.*\)\(\d\{4\}年.*\)$/\1\3\r\2
endfunction "}}}

function! MarkDown() "{{{
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
	%s/}\{3\}1/[\/markdown]
	" translator's note
	g/^$/.-1s/^\(\[\d\{1,2\}\]\s.*\)$/\1\r__________
	g/^$/.+1s/^\(\[\d\{1,2\}\]\s.*\)$/__________\r\1
	g/^_\{10\}$/.+1s//######
	g/^#\{6\}$/d
endfunction "}}}

function! HyperLinkJoin() "{{{
mark j
'j,'j+2s/^\t//e
'js/^\(.*\)$/[\1]
'j+1s/^\(.*\)$/(\1)
'j-1,'j+2join!
endfunction "}}}

function! HyperLinkSeperate() "{{{
put!
s/$/\r
.-1mark a
endfunction "}}}

vnoremap <buffer> <silent> <f1> s**<c-r>"**<esc>
vnoremap <buffer> <silent> <f2> s*<c-r>"*<esc>
nnoremap <buffer> <silent> <f3> :call HyperLinkJoin()<cr>
vnoremap <buffer> <silent> <f3> s<cr><esc>:call HyperLinkSeperate()<cr>
nnoremap <buffer> <silent> <f4> :s/^/#### <cr>

nnoremap <buffer> <silent> <f11> :call BlockedText()<cr>
nnoremap <buffer> <silent> <f12> :call MarkDown()<cr>
 "}}}1
