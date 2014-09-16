" tmp key-mappings for specific files "{{{1

" global "{{{2

fun AddSpace_TmpKeyMap() "{{{

	4,$s;\(\s\)\@<!～; ～;ge
	4,$s;～\(\s\)\@!;～ ;ge

	4,$s;\(\s\)\@<!+; +;ge
	4,$s;+\(\s\)\@!;+ ;ge

endfun "}}}

fun Fold_TmpKeyMap(mode,pattern) "{{{

	if a:mode == 0

		1
		while line('.')<line('$')
			call search(a:pattern,'W')
			if substitute(getline('.'),a:pattern,'','') != getline('.')
				mark j
				exe 'normal ]z'
				mark k
				'j+1,'k-1g;.$;le 8
				'k+1
			else
				return
			endif
		endwhile

	endif

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

	%s;\(\a\|\d\)\@<! \(\a\|\d\|{\|}\)\@!;;gec

endfun "}}}

fun Cursor_TmpKeyMap(when) "{{{

	if a:when == 0

		let s:current_cursor = getpos('.')

		exe 'normal H'
		let s:top_cursor = getpos('.')

	elseif a:when == 1

		call setpos('.', s:top_cursor)
		exe 'normal zt'

		call setpos('.', s:current_cursor)

	endif

endfun "}}}

fun Combine_TmpKeyMap() "{{{

	'<,'>left 0
	'<,'>join!
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

		call Fold_TmpKeyMap(0,'笔记 {{{5$')
		call Blank_TmpKeyMap()
		call Bullet_TmpKeyMap()
		call DelSpace_TmpKeyMap()

		call Cursor_TmpKeyMap(1)

	elseif a:mode == 1

		call Combine_TmpKeyMap()

	elseif a:mode == 2

		s;$;\r笔记 {{{5\r\r\r }}}5;
		exe 'normal [zj'

	endif

endfun "}}}

fun Scarlet_Key_TmpKeyMap() "{{{

	nno <buffer> <silent> <f1> :call Scarlet_Format_TmpKeyMap(0)<cr>
	vno <buffer> <silent> <f1> <esc>:call Scarlet_Format_TmpKeyMap(1)<cr>
	nno <buffer> <silent> <f2> :call Scarlet_Format_TmpKeyMap(2)<cr>

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
 "}}}2
 "}}}1
