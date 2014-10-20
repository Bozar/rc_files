" tmp key-mappings "{{{1

" Last Update: Oct 20, Mon | 10:54:56 | 2014

" global "{{{2

function s:WindowJump(align) "{{{3

	if a:align == 0
		wincmd w

	elseif a:align == 1
		let l:top = getpos('w0')
		let l:pos = getpos('.')
		wincmd w
		call setpos('.',l:top)
		execute 'normal zt'
		call setpos('.',l:pos)

	endif

endfunction "}}}3

fun s:SearchFold(level,direction) "{{{3

	let l:pattern = '^.* {{{' . a:level . '$'
	if a:direction == 0
		call search(l:pattern,'w')
	elseif a:direction == 1
		call search(l:pattern,'bw')
	endif

	execute 'normal zt'

endfun "}}}3

fun AddBlankLine_TmpKeyMap() "{{{3

	g;};-1s;^\(.\)\(}\)\@!;###MARK###\1;e
	%s;^\(###MARK###.*\)$;\1\r;e
	%s;^###MARK###;;e

endfun "}}}3

fun InsertBullet_TmpKeyMap(bullet) "{{{3

	'<,'>left 0

	if a:bullet == 0

		if line("'<") == line("'>")
			'<s;^;=;

		else
			'<s;^;=;
			'<+1,'>g;^.;s;^;-;

		endif

	elseif a:bullet == 1
		'<,'>g;^.;s;^;-;

	elseif a:bullet == 2
		'<s;^;==;
		'<+1,'>g;^.;s;^;--;

	elseif a:bullet == 3
		'<,'>g;^.;s;^;--;

	endif

endfun "}}}3

fun GlossaryIab_TmpKeyMap(title) "{{{3

	1
	call search(a:title . ' {\{3}\d$')
	+2
	mark j
	'}
	mark k
	'j,'ks;^\s\+;;e
	'j

	while line('.') < line("'k")
		if substitute(getline('.'),'\t','','') == getline('.')
			echo 'ERROR: Tab not found in Line ' . line('.') . '!'
			return
		endif
		let line = '^\(.\{-1,}\)\t\(.*\)$'
		let left = substitute(getline('.'),line,'\1','')
		let right = substitute(getline('.'),line,'\2','')
		exe 'iab <buffer> ' left right
		+1
	endwhile

endfun "}}}3

fun AddNote_TmpKeyMap(pattern,foldlevel) "{{{3

	exe 's;$;\r' . a:pattern . ' {{{' . a:foldlevel . '\r\r\r }}}' . a:foldlevel . '\r;'
	-1
	exe 'normal [zj'

endfun "}}}3

fun AddSpace_TmpKeyMap() "{{{3

	4,$s;\(\s\)\@<!+; +;ge
	4,$s;+\(\s\)\@!;+ ;ge

endfun "}}}3

fun IndentFold_TmpKeyMap(pattern,foldlevel) "{{{3

	let combine = '^' . a:pattern . ' {\{3}' . a:foldlevel .'$'

	1
	while line('.')<line('$')
		call search(combine,'W')
		if substitute(getline('.'),combine,'','') != getline('.')
			mark j
			exe 'normal ]z'
			mark k
			'j+1,'k-1s;^\(\t\{0,1}\)\(\S\);\t\t\2;e
			'k+1
		else
			$
		endif
	endwhile

endfun "}}}3

fun SubsQuote_TmpKeyMap() "{{{3

	4,$s;‘;“;ge
	4,$s;’;”;ge

endfun "}}}3

fun JoinLines_TmpKeyMap() "{{{3

	exe 'normal {j'
	mark j
	exe 'normal }k'
	mark k
	'j,'kleft 0
	'j,'kjoin
	call space#DelSpace_CJK()
	s;^;\t;

endfun "}}}3

 "}}}2
" files "{{{2

" jojo.watch "{{{3

fun Jojo_Format_TmpKeyMap() "{{{4

	call move_cursor#KeepPos(0)

	call space#DelSpace_CJK()
	call AddBlankLine_TmpKeyMap()

	call move_cursor#KeepPos(1)

endfun "}}}4

fun Jojo_Key_TmpKeyMap() "{{{4

	nno <buffer> <silent> <f1> :call Jojo_Format_TmpKeyMap()<cr>

endfun "}}}4

au Bufread jojo.watch call Jojo_Key_TmpKeyMap()

 "}}}3
" latex.read "{{{3

fun Latex_Format_TmpKeyMap() "{{{4

	call move_cursor#KeepPos(0)

	BuGlobalTW
	call space#DelSpace_CJK()
	call AddBlankLine_TmpKeyMap()

	call move_cursor#KeepPos(1)

endfun "}}}4

fun Latex_Key_TmpKeyMap() "{{{4

	nno <buffer> <silent> <f1> :call Latex_Format_TmpKeyMap()<cr>

endfun "}}}4

au Bufread latex.read call Latex_Key_TmpKeyMap()

 "}}}3
" ghost.read "{{{3

fun Ghost_Format_TmpKeyMap(mode) "{{{4

	if a:mode == 0

	call move_cursor#KeepPos(0)

		call IndentFold_TmpKeyMap('笔记',4)
		call space#DelSpace_CJK()
		call AddBlankLine_TmpKeyMap()

	call move_cursor#KeepPos(1)

	elseif a:mode == 1

		call AddNote_TmpKeyMap('笔记',4)

	elseif a:mode == 2

		call JoinLines_TmpKeyMap()

	endif

endfun "}}}4

fun Ghost_Key_TmpKeyMap() "{{{4

	nno <buffer> <silent> <f1> :call Ghost_Format_TmpKeyMap(0)<cr>
	nno <buffer> <silent> <f2> :call Ghost_Format_TmpKeyMap(1)<cr>
	nno <buffer> <silent> <f3> :call Ghost_Format_TmpKeyMap(2)<cr>

endfun "}}}4

au Bufread ghost.read call Ghost_Key_TmpKeyMap()

 "}}}3
" ghost.write "{{{3

fun s:Key_Ghost_Write() "{{{4

	nno <buffer> <silent> <f1>
	\ :call <sid>WindowJump(0)<cr>
	nno <buffer> <silent> <s-f1>
	\ :call <sid>WindowJump(1)<cr>

	nno <buffer> <silent> <f2> 
	\ :call <sid>SearchFold(2,0)<cr>
	nno <buffer> <silent> <s-f2> 
	\ :call <sid>SearchFold(2,1)<cr>

	nno <buffer> <silent> <f3> 
	\ :call <sid>SearchFold(3,0)<cr>
	nno <buffer> <silent> <s-f3> 
	\ :call <sid>SearchFold(3,1)<cr>

	nno <buffer> <silent> <f4> 
	\ :call <sid>SearchFold(4,0)<cr>
	nno <buffer> <silent> <s-f4> 
	\ :call <sid>SearchFold(4,1)<cr>

	nno <buffer> <silent> <f5> :BuWhole0TW<cr>

endfun "}}}4

" command "{{{4

au Bufread ghost.write call <sid>Key_Ghost_Write()

 "}}}4
 "}}}3
" aspect.read "{{{3

fun s:Key_Aspect() "{{{4

	nno <buffer> <silent> <f1>
	\ :call <sid>WindowJump(0)<cr>
	nno <buffer> <silent> <s-f1>
	\ :call <sid>WindowJump(1)<cr>

	nno <buffer> <silent> <f2> 
	\ :call <sid>SearchFold(2,0)<cr>
	nno <buffer> <silent> <s-f2> 
	\ :call <sid>SearchFold(2,1)<cr>

	nno <buffer> <silent> <f5> :BuWhole0TW<cr>

endfun "}}}4

au Bufread aspect.read call <sid>Key_Aspect()

 "}}}3
" fisherman.write "{{{3

fun s:Key_Fisherman() "{{{4

	nno <buffer> <silent> <f1>
	\ :call <sid>WindowJump(0)<cr>
	nno <buffer> <silent> <s-f1>
	\ :call <sid>WindowJump(1)<cr>

	nno <buffer> <silent> <f2> 
	\ :call <sid>SearchFold(2,0)<cr>
	nno <buffer> <silent> <s-f2> 
	\ :call <sid>SearchFold(2,1)<cr>

	nno <buffer> <silent> <f3> 
	\ :call <sid>SearchFold(3,0)<cr>
	nno <buffer> <silent> <s-f3> 
	\ :call <sid>SearchFold(3,1)<cr>

	nno <buffer> <silent> <f4> 
	\ :call <sid>SearchFold(4,0)<cr>
	nno <buffer> <silent> <s-f4> 
	\ :call <sid>SearchFold(4,1)<cr>

	nno <buffer> <silent> <f5> :BuWhole0TW<cr>

endfun "}}}4

" command "{{{4

au Bufread fisherman.write
\ call <sid>Key_Fisherman()

 "}}}4
 "}}}3
" echo_lines.write "{{{3

fun s:Key_Echo() "{{{4

	nno <buffer> <silent> <f1>
	\ :call <sid>WindowJump(0)<cr>
	nno <buffer> <silent> <s-f1>
	\ :call <sid>WindowJump(1)<cr>

endfun "}}}4

" command "{{{4

au Bufread echo_lines.write
\ call <sid>Key_Echo()

 "}}}4
 "}}}3
 "}}}2
 "}}}1
