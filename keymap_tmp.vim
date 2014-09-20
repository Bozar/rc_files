" tmp key-mappings for specific files "{{{1

" global "{{{2

fun AddNote_TmpKeyMap(pattern,foldlevel) "{{{

	exe 's;$;\r' . a:pattern . ' {{{' . a:foldlevel . '\r\r\r }}}' . a:foldlevel . '\r;'

	+1
	if substitute(getline('.'),'^ }}}\d$','','') != getline('.')
		-1g;^$;d
		-1
	else
		-2
	endif

	exe 'normal [zj'

endfun "}}}

fun AddSpace_TmpKeyMap() "{{{

	4,$s;\(\s\)\@<!～; ～;ge
	4,$s;～\(\s\)\@!;～ ;ge

	4,$s;\(\s\)\@<!+; +;ge
	4,$s;+\(\s\)\@!;+ ;ge

endfun "}}}

fun Fold_TmpKeyMap(pattern) "{{{

	1
	while line('.')<line('$')
		call search(a:pattern,'W')
		if substitute(getline('.'),a:pattern,'','') != getline('.')
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

fun Bullet_TmpKeyMap() "{{{

	1mark j
	$mark k
	Bullet

endfun "}}}

fun Blank_TmpKeyMap() "{{{

	%s;^\s\+$;;e

endfun "}}}

fun Quote_TmpKeyMap() "{{{

	4,$s;‘;“;ge
	4,$s;’;”;ge

endfun "}}}

fun DelSpace_TmpKeyMap() "{{{

	%s;\([^\x00-\xff]\) \([^\x00-\xff]\);\1\2;ge

endfun "}}}

fun Cursor_TmpKeyMap(when) "{{{

	if a:when == 0

		let s:current_cursor = getpos('.')

		exe 'normal H'
		let s:top_cursor = getpos('.')

		call setpos('.', s:current_cursor)

	elseif a:when == 1

		call setpos('.', s:top_cursor)
		exe 'normal zt'

		call setpos('.', s:current_cursor)

	endif

endfun "}}}

fun Combine_TmpKeyMap() "{{{

	exe 'normal {j'
	mark j
	exe 'normal }k'
	mark k

	'j,'kleft 0
	'j,'kjoin!
	s;^;\t;

endfun "}}}

 "}}}2
" files "{{{2

" gramma.read "{{{3

fun Gramma_Format_TmpKeyMap() "{{{

	call Cursor_TmpKeyMap(0)

	call Blank_TmpKeyMap()
	call Bullet_TmpKeyMap()
	call Quote_TmpKeyMap()
	call AddSpace_TmpKeyMap()

	call Cursor_TmpKeyMap(1)

endfun "}}}

fun Gramma_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> :call Gramma_Format_TmpKeyMap()<cr>

endfun "}}}

au Bufread gramma.read call Gramma_Key_TmpKeyMap()

 "}}}3
" scarlet.read "{{{3

fun Scarlet_Format_TmpKeyMap(mode) "{{{

	if a:mode == 0

		call Cursor_TmpKeyMap(0)

		call Fold_TmpKeyMap('笔记 {{{5$')
		call Blank_TmpKeyMap()
		call Bullet_TmpKeyMap()
		call DelSpace_TmpKeyMap()

		call Cursor_TmpKeyMap(1)

	elseif a:mode == 1

		call AddNote_TmpKeyMap('笔记',5)

		" s;$;\r笔记 {{{5\r\r\r }}}5\r;
		" exe 'normal [zj'

	elseif a:mode == 2

		call Combine_TmpKeyMap()

	endif

endfun "}}}

fun Scarlet_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> :call Scarlet_Format_TmpKeyMap(0)<cr>
	nno <buffer> <silent> <f2> :call Scarlet_Format_TmpKeyMap(1)<cr>
	nno <buffer> <silent> <f3> :call Scarlet_Format_TmpKeyMap(2)<cr>

endfun "}}}

au Bufread scarlet.read call Scarlet_Key_TmpKeyMap()

 "}}}3
" jojo.watch "{{{3

fun Jojo_Format_TmpKeyMap() "{{{

	call Cursor_TmpKeyMap(0)

	call Blank_TmpKeyMap()
	call DelSpace_TmpKeyMap()

	call Cursor_TmpKeyMap(1)

endfun "}}}

fun Jojo_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> :call Jojo_Format_TmpKeyMap()<cr>

endfun "}}}

au Bufread jojo.watch call Jojo_Key_TmpKeyMap()

 "}}}3
" latex.read "{{{3

fun Latex_Format_TmpKeyMap() "{{{

	call Cursor_TmpKeyMap(0)

	call Bullet_TmpKeyMap()
	call Blank_TmpKeyMap()

	call Cursor_TmpKeyMap(1)

endfun "}}}

fun Latex_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> :call Latex_Format_TmpKeyMap()<cr>

endfun "}}}

au Bufread latex.read call Latex_Key_TmpKeyMap()

 "}}}3
" fiasco_gm.write "{{{3

fun Fiasco_Format_TmpKeyMap(mode) "{{{

	if a:mode == 0

		call Cursor_TmpKeyMap(0)

		call Bullet_TmpKeyMap()
		call Blank_TmpKeyMap()

		call Cursor_TmpKeyMap(1)

	elseif a:mode == 1

		call Combine_TmpKeyMap()

	endif

endfun "}}}

fun Fiasco_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> :call Fiasco_Format_TmpKeyMap(0)<cr>
	nno <buffer> <silent> <f2> :call Fiasco_Format_TmpKeyMap(1)<cr>

endfun "}}}

au Bufread fiasco_gm.write call Fiasco_Key_TmpKeyMap()

 "}}}3
 "}}}2
 "}}}1
