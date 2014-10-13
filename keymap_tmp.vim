" tmp key-mappings for specific files "{{{1

" global "{{{2

fun AddBlankLine_TmpKeyMap() "{{{

	g;};-1s;^\(.\)\(}\)\@!;###MARK###\1;e
	%s;^\(###MARK###.*\)$;\1\r;e
	%s;^###MARK###;;e

endfun "}}}

fun InsertBullet_TmpKeyMap(bullet) "{{{

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

endfun "}}}

fun GlossaryIab_TmpKeyMap(title) "{{{

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

endfun "}}}

fun AddNote_TmpKeyMap(pattern,foldlevel) "{{{

	exe 's;$;\r' . a:pattern . ' {{{' . a:foldlevel . '\r\r\r }}}' . a:foldlevel . '\r;'
	-1
	exe 'normal [zj'

endfun "}}}

fun AddSpace_TmpKeyMap() "{{{

	4,$s;\(\s\)\@<!+; +;ge
	4,$s;+\(\s\)\@!;+ ;ge

endfun "}}}

fun IndentFold_TmpKeyMap(pattern,foldlevel) "{{{

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

endfun "}}}

fun SubsQuote_TmpKeyMap() "{{{

	4,$s;‘;“;ge
	4,$s;’;”;ge

endfun "}}}

fun DelSpace_TmpKeyMap() "{{{

	%s;\s\+$;;e
	%s;\([^\x00-\xff]\) \+\([^\x00-\xff]\);\1\2;ge

endfun "}}}

fun JoinLines_TmpKeyMap() "{{{

	exe 'normal {j'
	mark j
	exe 'normal }k'
	mark k
	'j,'kleft 0
	'j,'kjoin
	call DelSpace_TmpKeyMap()
	s;^;\t;

endfun "}}}

 "}}}2
" files "{{{2

" jojo.watch "{{{3

fun Jojo_Format_TmpKeyMap() "{{{

	call move_cursor#KeepPos(0)

	call DelSpace_TmpKeyMap()
	call AddBlankLine_TmpKeyMap()

	call move_cursor#KeepPos(1)

endfun "}}}

fun Jojo_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> :call Jojo_Format_TmpKeyMap()<cr>

endfun "}}}

au Bufread jojo.watch call Jojo_Key_TmpKeyMap()

 "}}}3
" latex.read "{{{3

fun Latex_Format_TmpKeyMap() "{{{

	call move_cursor#KeepPos(0)

	BuGlobalTW
	call DelSpace_TmpKeyMap()
	call AddBlankLine_TmpKeyMap()

	call move_cursor#KeepPos(1)

endfun "}}}

fun Latex_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> :call Latex_Format_TmpKeyMap()<cr>

endfun "}}}

au Bufread latex.read call Latex_Key_TmpKeyMap()

 "}}}3
" ghost.read "{{{3

fun Ghost_Format_TmpKeyMap(mode) "{{{

	if a:mode == 0

	call move_cursor#KeepPos(0)

		call IndentFold_TmpKeyMap('笔记',4)
		call DelSpace_TmpKeyMap()
		call AddBlankLine_TmpKeyMap()

	call move_cursor#KeepPos(1)

	elseif a:mode == 1

		call AddNote_TmpKeyMap('笔记',4)

	elseif a:mode == 2

		call JoinLines_TmpKeyMap()

	endif

endfun "}}}

fun Ghost_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> :call Ghost_Format_TmpKeyMap(0)<cr>
	nno <buffer> <silent> <f2> :call Ghost_Format_TmpKeyMap(1)<cr>
	nno <buffer> <silent> <f3> :call Ghost_Format_TmpKeyMap(2)<cr>

endfun "}}}

au Bufread ghost.read call Ghost_Key_TmpKeyMap()

 "}}}3
" aspects.read "{{{3

fun Aspect_Format_TmpKeyMap() "{{{

	call move_cursor#KeepPos(0)

	call DelSpace_TmpKeyMap()
	call AddBlankLine_TmpKeyMap()

	call move_cursor#KeepPos(1)

endfun "}}}

fun Aspect_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> :call Aspect_Format_TmpKeyMap()<cr>

endfun "}}}

au Bufread aspects.read call Aspect_Key_TmpKeyMap()

 "}}}3
" fisherman.write "{{{3

fun Fisherman_Format_TmpKeyMap() "{{{

	call move_cursor#KeepPos(0)

	call DelSpace_TmpKeyMap()
	call AddBlankLine_TmpKeyMap()

	call move_cursor#KeepPos(1)

endfun "}}}

fun Fisherman_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> <c-w>w

	nno <buffer> <silent> <f2> :call search('{2$')<cr>
	nno <buffer> <silent> <s-f2> :call search('{2$','b')<cr>

	nno <buffer> <silent> <f3> :call search('{3$')<cr>
	nno <buffer> <silent> <s-f3> :call search('{3$','b')<cr>

	nno <buffer> <silent> <f4> :call search('{4$')<cr>
	nno <buffer> <silent> <s-f4> :call search('{4$','b')<cr>

	nno <buffer> <silent> <f5> :call Fisherman_Format_TmpKeyMap()<cr>

endfun "}}}

au Bufread fisherman.write call Fisherman_Key_TmpKeyMap()

 "}}}3
 "}}}2
 "}}}1
