" tmp key-mappings for specific files "{{{1

" global "{{{2

fun Bullet_Tmp() "{{{3

	1mark j
	$mark k
	Bullet

endfun "}}}3

fun Quote_Tmp() "{{{3

	4,$s;‘;“;ge
	4,$s;’;”;ge

endfun "}}}3

fun Space_Tmp() "{{{3

	%s;\(\a\|\d\)\@<! \(\a\|\d\|{\|}\)\@!;;gec

endfun "}}}3

fun Cursor_Tmp(when) "{{{3

	if a:when == 0

		let s:current_cursor = getpos('.')

		exe 'normal H'
		let s:top_cursor = getpos('.')

	elseif a:when == 1

		call setpos('.', s:top_cursor)
		exe 'normal zt'

		call setpos('.', s:current_cursor)

	endif

endfun "}}}3

 "}}}2
" files "{{{2

" gramma.read "{{{3

fun Gramma_Format_Tmp() "{{{4

	call Cursor_Tmp(0)

	call Bullet_Tmp()
	call Quote_Tmp()

	4,$s;\( \)\@<!～\( \)\@!; ～ ;ge

	call Cursor_Tmp(1)

endfun "}}}4

fun Gramma_Key_Tmp() "{{{4

	nno <buffer> <silent> <f1> :call Gramma_Format_Tmp()<cr>

endfun "}}}4

au Bufread gramma.read call Gramma_Key_Tmp()

 "}}}3
" scarlet.read "{{{3

fun Scarlet_Format_Tmp() "{{{4

	call Cursor_Tmp(0)

	call Bullet_Tmp()
	call Space_Tmp()

	call Cursor_Tmp(1)

endfun "}}}4

fun Scarlet_Key_Tmp() "{{{4

	nno <buffer> <silent> <f1> :call Scarlet_Format_Tmp()<cr>

endfun "}}}4

au Bufread scarlet.read call Scarlet_Key_Tmp()

 "}}}3
" jojo.watch "{{{3

fun Jojo_Format_Tmp() "{{{4

	call Cursor_Tmp(0)

	call Space_Tmp()

	call Cursor_Tmp(1)

endfun "}}}4

fun Jojo_Key_Tmp() "{{{4

	nno <buffer> <silent> <f1> :call Jojo_Format_Tmp()<cr>

endfun "}}}4

au Bufread jojo.watch call Jojo_Key_Tmp()

 "}}}3
 "}}}2
 "}}}1
