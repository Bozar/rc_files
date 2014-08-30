" xiami "{{{1

" maps "{{{2

nno <buffer> <silent> <f1> :call DeleteAdd_Xiami()<cr>
nno <buffer> <silent> <f2> :call Substitute_Xiami()<cr>
nno <buffer> <silent> <f3> :call Move_Xiami()<cr>

 "}}}2

" functions "{{{2

fun! DeleteAdd_Xiami() "{{{

	1,$le0
	g!;^\d;d

endfun "}}}

fun! Substitute_Xiami() "{{{

" spaces to underlines

	%s;\t\d\{-}\s*$;;
	%s;\s\+$;;
	%s;\s\+;_;g

" lowercase

	%s;\(\a\);\l\1;g

" illegal characters

	%s;['():,];_;ge
	%s;[?!];;ge
	%s;[\[\|\]];_;ge
	%s;_\+;_;ge
	%s;_$;;ge

" extensions

	%s;$;.mp3;

" old filenames

	%s;^;\t;
	%s;^;\=line('.');

	if line('$')>9
		1,9s;^;0;
	endif

	%s;\(\d\)\t;\1.mp3 ;
	%s;^;!mv ;

" add blank lines

	%s;$;\r

endfun "}}}

fun! Move_Xiami() "{{{

	while line('.')<line('$')

		exe 'normal visy'
		exe @"
		+2

	endwhile

endfun "}}}

 "}}}2

 "}}}1
