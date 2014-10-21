" tmp key-mappings "{{{1

" Last Update: Oct 21, Tue | 22:22:21 | 2014

" global "{{{2

function s:KeyMapLoop(begin,end) "{{{3

	let l:i = a:begin

	while l:i < a:end

		execute 'nno <buffer> <silent> <f' . l:i .
		\ '> :call <sid>SearchFold(' . l:i .
		\ ',0)<cr>'
		execute 'nno <buffer> <silent> <s-f' .
		\ l:i . '> :call <sid>SearchFold(' . l:i .
		\ ',1)<cr>'

		let l:i = l:i + 1

	endwhile

endfunction "}}}3

function s:AddNum4Note(note) "{{{3

	call move_cursor#ToColumn1("'j",0)

	let l:pattern = '^' . a:note . '\d\{0,2}'

	if search(l:pattern,'c',line("'k"))

		execute "'j,'k" . 's;' . l:pattern . ';' .
		\ a:note . ';'

		execute 'let i=1|' . "'j,'k" . 'g;\(' .
		\ a:note . '\)\@<=;s;;\=i;|let i=i+1'

	else

		echo "ERROR: '" . a:note . "' not found!"
		return 1

	endif

endfunction "}}}3

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

fun s:AddNote(pattern) "{{{3

	let l:foldlevel = foldlevel('.') + 1

	exe 's;$;\r' . a:pattern . ' {{{' .
	\ l:foldlevel . '\r\r\r }}}' . l:foldlevel .
	\ '\r;'
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

		call <sid>AddNote('笔记')

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

	call <sid>KeyMapLoop(2,5)

	nno <buffer> <silent> <f12> :BuWhole0TW<cr>

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

	call <sid>KeyMapLoop(2,3)

	nno <buffer> <silent> <f12> :BuWhole0TW<cr>

endfun "}}}4

au Bufread aspect.read call <sid>Key_Aspect()

 "}}}3
" fisherman.write "{{{3

fun s:Format_Fisherman(mode) "{{{4

	call move_cursor#KeepPos(0)

	if a:mode == 0

		if search(' {\{3}4$','bW')
			call move_cursor#SetMarkJK_Fold()
		else
			echo "ERROR: Level 4 fold not found!"
			call move_cursor#KeepPos(1)
			return
		endif

		call <sid>AddNum4Note('片段 ')

	endif

	call move_cursor#KeepPos(1)

endfun "}}}4

fun s:Key_Fisherman() "{{{4

	nno <buffer> <silent> <f1>
	\ :call <sid>WindowJump(0)<cr>
	nno <buffer> <silent> <s-f1>
	\ :call <sid>WindowJump(1)<cr>

	call <sid>KeyMapLoop(2,5)

	nno <buffer> <silent> <f5>
	\ :call <sid>AddNote('片段 ')<cr>
	nno <buffer> <silent> <s-f5>
	\ :call <sid>Format_Fisherman(0)<cr>

	nno <buffer> <silent> <f12> :BuWhole0TW<cr>

endfun "}}}4

" command "{{{4

au Bufread fisherman.write
\ call <sid>Key_Fisherman()

 "}}}4
 "}}}3
 "}}}2
 "}}}1
