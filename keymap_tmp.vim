" tmp key-mappings for specific files "{{{1

" gramma.read "{{{2

fun Gramma_Format_Tmp() "{{{3

	let current_cursor = getpos('.')

	exe 'normal H'
	let top_cursor = getpos('.')

	1mark j
	$mark k
	Bullet

	4,$s;‘;“;ge
	4,$s;’;”;ge
	4,$s;\( \)\@<!～\( \)\@!; ～ ;ge

	call setpos('.', top_cursor)
	exe 'normal zt'

	call setpos('.', current_cursor)

endfun "}}}3

fun Gramma_Key_Tmp() "{{{3

	nno <buffer> <silent> <f1> :call Gramma_Format_Tmp()<cr>

endfun "}}}3

au Bufread gramma.read call Gramma_Key_Tmp()

 "}}}2
" scarlet.read "{{{2

fun Scarlet_Format_Tmp() "{{{3

	let current_cursor = getpos('.')

	exe 'normal H'
	let top_cursor = getpos('.')

	1mark j
	$mark k
	Bullet

	call setpos('.', top_cursor)
	exe 'normal zt'

	call setpos('.', current_cursor)

endfun "}}}3

fun Scarlet_Key_Tmp() "{{{3

	nno <buffer> <silent> <f1> :call Scarlet_Format_Tmp()<cr>

endfun "}}}3

au Bufread scarlet.read call Scarlet_Key_Tmp()

 "}}}2
 "}}}1
