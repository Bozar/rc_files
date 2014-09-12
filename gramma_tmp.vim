" tmp key-mapping for gramma.read "{{{1

fun Gramma_Tmp() "{{{

	let current_cursor = getpos('.')

	exe 'normal H'
	let top_cursor = getpos('.')

	1mark j
	$mark k
	Bullet

	exe '4,$s;‘;“;ge'
	exe '4,$s;’;”;ge'

	call setpos('.', top_cursor)
	exe 'normal zt'

	call setpos('.', current_cursor)

endfun "}}}

fun Key_Gramma_Tmp() "{{{

	nno <buffer> <silent> <f1> :call Gramma_Tmp()<cr>

endfun "}}}

au Bufread gramma.read call Key_Gramma_Tmp()

 "}}}1
