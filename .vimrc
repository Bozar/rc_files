" Bozar's .vimrc file "{{{1
" Last Update: Mar 15, Sat | 15:59:55 | 2014

" Plugins "{{{2

set nocompatible
filetype off
filetype plugin on

" fcitx
" NerdTree
 "}}}2

" Functions "{{{2

" windows or linux "{{{3
function! CheckOS() "{{{
	if has('win32')
		return 'windows'
	elseif has('win64')
		return 'windows'
	else
		return 'linux'
	endif
endfunction "}}}
 "}}}3

" switch settings "{{{3
function! SwitchSettings(setting) "{{{
	if a:setting=='0' "{{{
		set hlsearch!
		set hlsearch? "}}}
	elseif a:setting=='1' "{{{
		set linebreak!
		set linebreak? "}}}
	" :h expr-option
	elseif a:setting=='2' "{{{
		if &background=='dark'
			set background=light
		else
			set background=dark
		endif "}}}
	endif
endfunction "}}}
 "}}}3

" search pattern "{{{3
function! SearchPattern(pattern) "{{{
	" a-b substitution
		if a:pattern==0 "{{{
			execute '%s/'.@a.'/'.@b.'/gc'
		endif "}}}
	" count matches 1
		let @z=@"
	" search
		if a:pattern==1 "{{{
			let @/=@" "}}}
	" yank all matched pattern
		elseif a:pattern==2 "{{{
			let @x=''
			execute 'g/'.@".'/yank X'
			let @"=@x
			'' "}}}
		endif
	" count matches 2
		execute '%s/'.@z.'//gn'
	" vim grep
		if a:pattern==3 "{{{
			execute 'vim /'.@".'/ %'
		endif "}}}
endfunction "}}}
 "}}}3

" put text to another file "{{{3
function! PutText(put) "{{{
	" overwrite (0)
		if a:put==0 "{{{
			$mark h|$put
			1,'hdelete "}}}
	" before (1)
		elseif a:put==1 "{{{
			1put! "
			1 "}}}
	" after (2)
		elseif a:put==2 "{{{
			$mark h|$put
			'h+1 "}}}
		endif
endfunction "}}}
 "}}}3

" mapping markers "{{{3
function! MappingMarker(marker) "{{{
	" visual mode to j,k
		if a:marker==0
			'<mark j
			'>mark k
	" h,l to j,k
		elseif a:marker==1
			'hmark j
			'lmark k
		endif
endfunction "}}}
 "}}}3

" detect cursor position "{{{3
function! CursorAtFoldBegin() "{{{
	if substitute(getline('.'),'{\{3}\d\{0,2}$','','')!=getline('.')
		+1
	endif
endfunction "}}}
 "}}}3

" fold marker "{{{3
" creat new fold marker
" DO NOT call 'CreatFoldMarker()' alone
" call 'MoveFoldMarker()' instead
" which has fail-safe protocol 'substitute()'
function! CreatFoldMarker(creat) "{{{
	" level one
		if a:creat==0 "{{{
			s/$/\rFOLDMARKER {{{\r }}}/
			.-1,.s/$/1/
		endif "}}}
	" move cursor
		call CursorAtFoldBegin()
	" same level
		if a:creat==1 "{{{
			normal [zmh]zml
			'hyank
			'hput
			'hput
			'h+1,'h+2s/^.*\( .\{0,1}{\{3}\d\{0,2}\)$/\1/
			'h+2s/{{{/}}}/
			'h+1s/^/FOLDMARKER/ "}}}
	" higher level
		elseif a:creat==2 "{{{
			call CreatFoldMarker(1)
			'h+1,'h+2s/\(\d\{1,2}\)$/\=submatch(0)+1/e "}}}
		endif
endfunction "}}}
" new (0), after (1), before (2)
" inside (3), wrap text (4,5)
function! MoveFoldMarker(move) "{{{
	" creat level one marker
		if a:move==0 "{{{
			call CreatFoldMarker(0)
			mark k
			-1mark j
			-1
		endif "}}}
	" detect fold
		mark h
		call CursorAtFoldBegin()
		normal [z
		if substitute(getline('.'),'{\{3}\d\{0,2}$','','')==getline('.') "{{{
			" fold dose not exsist
			echo "ERROR: Fold '[z' not found!"
			'h
			return
		else
			'h
		endif "}}}
	" after
		if a:move==1 "{{{
			call CreatFoldMarker(1)
			'h+1,'h+2delete
			'lput
			-1 "}}}
	" before
		elseif a:move==2 "{{{
			call CreatFoldMarker(1)
			'h+1,'h+2delete
			'hput!
			-1 "}}}
	" inside
		elseif a:move==3 "{{{
			mark z
			call CreatFoldMarker(2)
			'h+1,'h+2delete
			'zput
			-1 "}}}
	" wrap text
	" normal
		elseif a:move==4 "{{{
			call CreatFoldMarker(2)
			'h+1,'h+2s/\d\{0,2}$//
			'h+1,'h+2delete
			'jput
			'j+1s/^FOLDMARKER//
			'j+2delete
			'kput
			'j,'j+1join!
			'k,'k+1join!
			normal [z
		 "}}}
	" visual
		elseif a:move==5 "{{{
			call MappingMarker(0)
			call MoveFoldMarker(4) "}}}
		endif
endfunction "}}}
 "}}}3

" bullets: '*' and '+' "{{{3
function! BulletPoint(bullet) "{{{
	if a:bullet==0 "{{{
		" title
		" do not indent title '-'
			'j,'kg/^\t\{0,2}-/left 0
			'j,'ks/^-//e
		" paragraph
		" '==' will be replaced with '+'
		" indent 2 tabs
			'j,'kg/^\t\{0,2}==/left 8
			'j,'ks/^\(\t\t\)==/\1+ /e
		" '=' will be replaced with '*'
		" indent 1 tab
			'j,'kg/^\t\{0,2}=/left 4
			'j,'ks/^\(\t\)=/\1* /e "}}}
	elseif a:bullet==1 "{{{
			call MappingMarker(0)
			call BulletPoint(0) "}}}
	endif
endfunction "}}}
 "}}}3

" change fold level "{{{3
" substract (0,1); add (2,3)
" delete number (4,5); append number (6,7)
function! ChangeFoldLevel(level)  "{{{
	" substract, normal
		if a:level==0 "{{{
			" detect level one marker
				'j
				call search("{{{\|}}}","c","'k")
				if substitute(getline("."),'\({{{\|}}}\)1$','','')!=getline('.')
					echo 'ERROR: Fold level 1 detected!'
					return
				endif
				'j,'ks/\({{{\|}}}\)\@<=\d\{1,2}$/\=submatch(0)-1/e "}}}
	" substract, visual
		elseif a:level==1 "{{{
			call MappingMarker(0)
			call ChangeFoldLevel(0) "}}}
	" add, normal
		elseif a:level==2 "{{{
			" fold level exceeds 20
				'j
				call search("\({{{\|}}}\)[2-9][0-9]$","c","'k")
				if substitute(getline("."),'\({{{\|}}}\)[2-9][0-9]$','','')!=getline('.')
					echo 'ERROR: Fold level exceeds 20!'
					return
				endif
				'j,'ks/\({{{\|}}}\)\@<=\d\{1,2}$/\=submatch(0)+1/e "}}}
	" add, visual
		elseif a:level==3 "{{{
			call MappingMarker(0)
			call ChangeFoldLevel(2) "}}}
	" delete number, normal
		elseif a:level==4 "{{{
			'j,'ks/\({{{\|}}}\)\@<=\d\{1,2}$//e "}}}
	" delete number, visual
		elseif a:level==5 "{{{
			call MappingMarker(0)
			call ChangeFoldLevel(4) "}}}
	" append number, normal
		elseif a:level==6 "{{{
			'j
			while line(".")<=line("'k")
				if search('\({{{\|}}}\)$','c')==0
					return
				endif
				call search('\({{{\|}}}\)$','c')
				s/\({{{\|}}}\)\@<=$/\=foldlevel(line('.'))/e
				+1
			endwhile "}}}
	" append number, visual
		elseif a:level==7 "{{{
			call MappingMarker(0)
			call ChangeFoldLevel(6) "}}}
		endif
endfunction "}}}
 "}}}3

" delete lines "{{{3
function! EmptyLines(line) "{{{
	if a:line==0
		1,$-1g/^$/.+1s/^$/###DELETE_EMPTY_LINES###/
		g/^###DELETE_EMPTY_LINES###$/delete
		$g/^$/delete
	elseif a:line==1
		g/^$/delete
	endif
endfunction "}}}
 "}}}3

" time stamp "{{{3
" 'Date:' and 'Last Update:'
" there should be at least 3 lines in a file
" year (%Y) | month (%b) | day (%d) | weekday (%a)
" hour (%H) | miniute (%M) | second (%S)
function! TimeStamp(time) "{{{
	" check lines
		set nofoldenable
		mark h "{{{
		if line('$')<3
			echo 'ERROR: There should be at least 3 lines!'
			'h
			return
		endif
		let Date_Time="s/\\(Date: \\)\\@<=.*$/\\=strftime('%b %d | %a | %Y')/e"
		let Update_Time="s/\\(Last Update: \\)\\@<=.*$/\\=strftime('%b %d, %a | %H:%M:%S | %Y')/e"
		 "}}}
	" creat new date
		if a:time==0 "{{{
			s/$/\rDate: /
			execute Date_Time
			s/$/\rLast Update: /
			execute Update_Time
			return
		endif "}}}
	" update time
	" detect time stamp "{{{
		1
		call search("Last Update: ","c",3)
		if substitute(getline('.'),'Last Update: ','','')==getline('.')
			$-2
			call search("Last Update: ","c","$")
			if substitute(getline('.'),'Last Update: ','','')==getline('.')
				echo 'ERROR: Time stamp not found!'
				return
			endif
		endif "}}}
		if a:time==1 "{{{
			execute '1,3'.Update_Time
			execute '$-2,$'.Update_Time
			'h
		echo 'NOTE: Time stamp updated!'
		endif "}}}
		set foldenable
endfunction "}}}
 "}}}3

" creat page number "{{{3
function! PageNumber() "{{{
	" creat two strings
		let a=1|g/1/s//\=a/|let a=a+10/
		%s/$/\r#INSERT_NUMBER#\r/
		let a=10|g/#INSERT_NUMBER#/s//\=a/|let a=a+10
	" join nearby lines
		g/0$/.-1,.j
	" add fold marker
		%s/\s/-/
		%s/$/ {{{/|%s/$/\r\r }}}/
		%s/\({\|}\)$/\12/
	" delete additional lines
		g/^ {\{3}2$/.,.+1delete
	" insert title
		1s/^\(.*\)$/\1\r\1/
		1s/2$/1/|$s/2$/1/
endfunction "}}}
 "}}}3

" Scratch buffer "{{{3
" switch to Scratch
function! SwitchToScratch() "{{{
	" not loaded
		if bufwinnr(2)==-1
			buffer 2
	" loaded, switch to Scratch
		elseif bufwinnr(2)!=bufwinnr('%')
			execute bufwinnr(2) . 'wincmd w'
		endif
endfunction "}}}
" creat the first Scratch (0), edit (1)
" substitute (2), insert (3) and append (4)
" move (5,6) text between buffers
" creat more Scratches (7)
function! ScratchBuffer(scratch) "{{{
	" creat Scratch
		if a:scratch==0 "{{{
			new
			setlocal buftype=nofile
			setlocal bufhidden=hide
			setlocal noswapfile
			setlocal nobuflisted
			s/^/SCRATCH_BUFFER\r/
			close
		endif "}}}
	" detect if Scratch exsists
		if bufexists(2)==0 "{{{
			echo 'ERROR: Scratch Buffer 2 not found!'
			return
		endif "}}}
	" edit Scratch
		if a:scratch==1 "{{{
			call SwitchToScratch() "}}}
	" substitute whole Scratch
		elseif a:scratch==2 "{{{
			call SwitchToScratch()
			call PutText(0) "}}}
	" before
		elseif a:scratch==3 "{{{
			call SwitchToScratch()
			call PutText(1) "}}}
	" after
		elseif a:scratch==4 "{{{
			call SwitchToScratch()
			call PutText(2) "}}}
	" move text between Scratch and other buffers
	" normal mode
		elseif a:scratch==5 "{{{
			if bufnr('%')!=2 "{{{
				set nofoldenable
				1s/^/\r/
				if line("'j")==1
					'jmark H
					'j+1,'kdelete
				elseif line("'j")!=1
					'j-1mark H
					'j,'kdelete
				endif
				set foldenable
				call ScratchBuffer(2) "}}}
			elseif bufnr('%')==2 "{{{
				1,$yank
				'H
				set nofoldenable
				'Hput
				1g/^$/d
				set foldenable
				'H "}}}
			endif "}}}
	" visual mode
		elseif a:scratch==6 "{{{
			call MappingMarker(0)
			call ScratchBuffer(5) "}}}
	" creat more Scratches
		elseif a:scratch==7 "{{{
			call ScratchBuffer(0)
			echo 'Scratch buffer' bufnr('$') 'created!'
			"}}}
		endif
endfunction "}}}
 "}}}3

" GTD "{{{3

" Function key: <F1> "{{{4
" to-do (*) and finished (~)
function! Finished_GTD() "{{{
	" substitute '*' with '~'
		if substitute(getline("."),'^\t\*','','')!=getline('.')
			s/^\t\*/\t\~/
	" substitute '~' with '+'
		elseif substitute(getline("."),'^\t\~','','')!=getline('.')
			s/^\t\~/\t\*/
		endif "}}}
endfunction "}}}

function! F1_GTD() "{{{
	nnoremap <buffer> <silent> <f1> :call Finished_GTD()<cr>
endfunction "}}}
 "}}}4

" Function key: <F2> "{{{4
function! AnotherDay_GTD() "{{{
	" detect cursor position
		mark h "{{{
		call CursorAtFoldBegin()
		normal [z
		if substitute(getline("."),'^\d\{1,2}月\d\{1,2}日 {\{3}\d$','','')==getline('.')
			'h
			echo 'ERROR: Date not found!'
			return
		else
			'h
		endif "}}}
	" insert new lines for another day
		call MoveFoldMarker(2) "{{{
		'h-2mark z
		'h,'l-1yank
		'zput
	" change date
		'z+1s/\d\{1,2}\(日\)\@=/\=submatch(0)+1/
	" change foldlevel
		call MappingMarker(1)
		call ChangeFoldLevel(2)
	" fix substitution errors on rare occasions:
	" the second day in a month
	" in which case both }2 will be changed
		g/^ }\{3}3$/.+1s/^\( }\{3}\)3$/\12/e
		g/^ }\{3}2$/.+1s/^\( }\{3}\)2$/###TO_BE_DELETED###/e
		g/###TO_BE_DELETED###/delete
	" delete additional lines
		'zdelete "}}}
	" clear old markers "{{{
		normal mh]zml
	" progress bar: substitute 'page 2-5' with 'page 6-'
		'h,'ls/\(\d\+-\)\@<=\(\d\+\)/\=submatch(0)+1/e
		'h,'ls/\d\+-\(\d\+\)/\1-/e
	" substitute finished (~) with unfinished (*)
		'h,'ls/\t\~/\t\*/e
	" new marker
		'h+2
		normal wma
		 "}}}
endfunction "}}}

function! F2_GTD() "{{{
	nnoremap <buffer> <silent> <f2> :call AnotherDay_GTD()<cr>
endfunction "}}}
 "}}}4

function! GetThingsDone() "{{{
	call F1_GTD()
	call F2_GTD()
endfunction "}}}
 "}}}3

" English vocabulary "{{{3

" Function key: <F1> "{{{4
" search bracket '['
function! F1_Normal_Vocab() "{{{
	nnoremap <buffer> <silent> <f1> /[<cr>"+yi[
endfunction "}}}
function! F1_Shift_Normal_Vocab() "{{{
	nnoremap <buffer> <silent> <s-f1> 2?[<cr>"+yi[
endfunction "}}}

function! F1_Vocab() "{{{
	call F1_Normal_Vocab()
	call F1_Shift_Normal_Vocab()
endfunction "}}}
 "}}}4

" Function key: <F2> "{{{4
" search word
function! F2_Normal_Vocab() "{{{
	nnoremap <buffer> <silent> <f2> "+yi[/\[<c-r>"\]<cr>zz
endfunction "}}}

function! F2_Vocab() "{{{
	call F2_Normal_Vocab()
endfunction "}}}
 "}}}4

" Function key: <F3> "{{{4
" insert brackets
function! F3_Normal_Vocab() "{{{
	nnoremap <buffer> <silent> <f3> "+ciw[<c-r>"]<esc>
endfunction "}}}
function! F3_Visual_Vocab() "{{{
	vnoremap <buffer> <silent> <f3> s[<c-r>"]<esc>
endfunction "}}}
" delete brackets
function! F3_Shift_Normal_Vocab() "{{{
	nnoremap <buffer> <silent> <s-f3> di[pF[2x
endfunction "}}}

function! F3_Vocab() "{{{
	call F3_Normal_Vocab()
	call F3_Shift_Normal_Vocab()
	call F3_Visual_Vocab()
endfunction "}}}
 "}}}4

" Function key: <F4> "{{{4
" update word list
" there should be ONLY ONE list in a file
" Word List "{{{
" [word 1]
" [word 2]
 "}}}
function! UpdateWordList_Vocab() "{{{
		mark h
	" detect word list in the first five lines
		if line('$')<5
			echo 'ERROR: There should be at least 5 lines!'
			return
		endif
		1
		call search("Word List {{{$","c",5) "}}}
		if substitute(getline('.'),'^Word List {{{$','','')==getline('.')
			'h
			echo "ERROR: '^Word List {{{$' not found!"
			return
	" move cursor out of word list
		elseif line("'h")<=5
			normal [z
			mark h
		endif "}}}
	" clear old list "{{{
		/^Word List {{{$/+2;/^ }\{3}$/-1delete
	" put whole text into Scratch
		1,$yank
		call ScratchBuffer(2) "}}}
	" delete non-bracket text
		%s/\[/\r[/ge "{{{
		%s/\]/]\r/ge
		g!/\[/delete
	" move words back to list
		1,$yank
		buffer #
		1
		/^Word List {{{$/+1put "}}}
		'h
endfunction "}}}
function! F4_Normal_Vocab() "{{{
	nnoremap <buffer> <silent> <f4> :call UpdateWordList_Vocab()<cr>
endfunction "}}}

function! F4_Vocab() "{{{
	call F4_Normal_Vocab()
endfunction "}}}
 "}}}4

function! Vocabulary() "{{{
	call F1_Vocab()
	call F2_Vocab()
	call F3_Vocab()
	call F4_Vocab()
endfunction "}}}
 "}}}3

" translation "{{{3
function! Glossary_Trans() "{{{
	if bufname('%')!='glossary_toc.write'
		wincmd j
		execute 'buffer glossary_toc.write'
		let @/=@"
		call search(@",'c')
		if substitute(getline('.'),@",'','')==getline('.')
			echo substitute("ERROR: '0' not found!",0,@","")
			return
		else
			execute '%s/\('.@".'\)/\1/gn'
		endif
	elseif bufname('%')=='glossary_toc.write'
		let @"=substitute(getline('.'),'^.*\t','','')
		buffer #
	endif
endfunction "}}}
function! Buffer_Trans() "{{{
	if bufname('%')=='chinese_toc.write'
		execute 'buffer english_toc.write'
	elseif bufname('%')=='english_toc.write'
		execute 'buffer glossary_toc.write'
	else
		execute 'buffer chinese_toc.write'
	endif
endfunction "}}}
function! PageNumber_Trans() "{{{
	3,$s/\(\d\+\),/（见第\1页）/gec
endfunction "}}}

" Function key: <F1> "{{{4
function! F1_Normal_Trans() "{{{
	nnoremap <buffer> <silent> <f1> <c-w>w
endfunction "}}}
function! F1_Shift_Normal_Trans() "{{{
	nnoremap <buffer> <silent> <s-f1> :call PageNumber_Trans()<cr>
endfunction "}}}

function! F1_Trans() "{{{
	call F1_Normal_Trans()
	call F1_Shift_Normal_Trans()
endfunction "}}}
 "}}}4

" Function key: <F2> "{{{4
function! F2_Normal_Trans() "{{{
	nnoremap <buffer> <silent> <f2> :call Buffer_Trans()<cr>
endfunction "}}}

function! F2_Trans() "{{{
	call F2_Normal_Trans()
endfunction "}}}
 "}}}4

" Function key: <F3> "{{{4
function! F3_Normal_Trans() "{{{
	nnoremap <buffer> <silent> <f3> :call Glossary_Trans()<cr>
endfunction "}}}
function! F3_Visual_Trans() "{{{
	vnoremap <buffer> <silent> <f3> y:call Glossary_Trans()<cr>
endfunction "}}}

function! F3_Trans() "{{{
	call F3_Normal_Trans()
	call F3_Visual_Trans()
endfunction "}}}
 "}}}4

function! Translation() "{{{
	call F1_Trans()
	call F2_Trans()
	call F3_Trans()
endfunction "}}}
 "}}}3

" Localization "{{{3

" need to tweak the Excel table first
" insert #MARK# before English column | #END# after the last column

" Chinese | English = glossary = tmp
" left | up-right = middle-right = down-right
" modeline: from left to right
" vim: set linebreak:
" vim: set linebreak nonumber nomodifiable cursorline:
" vim: set nonumber nomodifiable:

" split window equally between all buffers except for glossary
" :resize 3

function! FileFormat_Loc() "{{{
	set fileencoding=utf-8
	set fileformat=unix
	%s/\r//ge
endfunction "}}}
function! LineBreak_Loc() "{{{
	1s/$/\r
	1
	while line('.')<line('$')
		call search('#MARK#')
		if substitute(getline('.'),'#MARK#.*#END#','','')==getline('.')
			mark j
			/#END#/mark k
			'j,'k-1s/$/<br10>/
			'j,'kjoin!
		endif
	endwhile
endfunction
 "}}}
function! SwitchBuffer_Loc() "{{{
	if bufname('%')=='chinese.loc'
		execute 'buffer tmp.loc'
	elseif bufname('%')=='tmp.loc'
		execute 'buffer 2'
	elseif bufname('%')==''
		execute 'buffer chinese.loc'
	endif
endfunction "}}}

" Function key: <F1> "{{{4
" put cursor after the first \t
function! F1_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f1> ^f	
endfunction "}}}
" search glossary
" let @c='search pattern'
function! F1_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <f1>
		\ "cy:3wincmd w<cr>gg
		\ :%s/<c-r>c\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}}
" search GUID (short line) in English buffer
" let @d='GUID'
function! F1_Shift_Normal_Loc() "{{{
  nnoremap <buffer> <silent> <s-f1>
		\ $2F	l"dyt	:2wincmd w<cr>gg
		\ :%s/<c-r>d\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}} 

function! F1_Loc() "{{{
	call F1_Normal_Loc()
	call F1_Visual_Loc()
	call F1_Shift_Normal_Loc()
endfunction "}}}
 "}}}4

" Function key: <F2> "{{{4
" search buffer and put cursor after the first '\t'
function! F2_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f2> 
		\ ^yt	gg
		\ :%s/^<c-r>"\(\t\)\@=\c//n<cr>
		\ /<c-r>/<cr>^f	
endfunction "}}}
function! F2_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <f2> 
		\ ygg
		\ :%s/<c-r>"\c//n<cr>
		\ /<c-r>/<cr>^f	
endfunction "}}}
" search English buffer
function! F2_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f2> 
		\ ^yt	:2wincmd w<cr>gg
		\ :%s/\(\t#MARK#\t.\{-\}\)\@<=<c-r>"\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}}
function! F2_Shift_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <s-f2> 
		\ y:2wincmd w<cr>gg
		\ :%s/\(\t#MARK#\t.\{-\}\)\@<=<c-r>"\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}}

function! F2_Loc() "{{{
	call F2_Normal_Loc()
	call F2_Visual_Loc()
	call F2_Shift_Normal_Loc()
	call F2_Shift_Visual_Loc()
endfunction "}}}
 "}}}4

" Function key: <F3> "{{{4
" put '<c-r>/' text into tmp buffer
" let @d='search pattern'
" note: it seems that when a command will delete all characters in one buffer,
" and it is at the end of a script line,
" it will break the key mapping
" compare these two mappings
" nnoremap <f12> ggdG
" \ oTEST<esc>
" nnoremap <f12> ggdGoTEST<esc>
function! F3_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f3>
		\ :let @d=''\|:g/<c-r>//y D<cr>:4wincmd w<cr>
		\ :call PutText(0)<cr>
endfunction "}}}
" search wrong translation
" let @c='English'
" let @b='Chinese correction'
function! F3_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f3>
		\ :%s/<c-r>c\(.\{-\}\t.\{-\}<c-r>b\)\@!\c//n<cr>
endfunction "}}}

function! F3_Loc() "{{{
	call F3_Normal_Loc()
	call F3_Shift_Normal_Loc()
endfunction "}}}
 "}}}4

" Function key: <F4> "{{{4
" switch buffer
function! F4_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f4> <c-w>w
endfunction "}}}
function! F4_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f4>
		\ :call SwitchBuffer_Loc()<cr>
endfunction "}}}

function! F4_Loc() "{{{
	call F4_Normal_Loc()
	call F4_Shift_Normal_Loc()
endfunction "}}}
 "}}}4

" Function key: <F5> "{{{4
" search and complete missing lines
" when there are more than one lines in an Excel cell
" let @d='search pattern'
" let @e='completion'
" mark S (shared between buffers): search line
function! F5_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f5>
		\ mS^"dy$
		\ :2wincmd w<cr>gg/<c-r>d/+1<cr>
		\ :let @e=''<cr>
		\ :?#MARK#?;/#END#/y E<cr>
		\ :1wincmd w<cr>'Scc<c-r>e<esc>gg
		\ :g/^$/d<cr>/<c-r>d<cr>/#END#/+1<cr>
endfunction "}}}
function! F5_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <f5>
		\ mS"dy
		\ :2wincmd w<cr>gg/<c-r>d/+1<cr>
		\ :let @e=''<cr>
		\ :?#MARK#?;/#END#/y E<cr>
		\ :1wincmd w<cr>'Scc<c-r>e<esc>gg
		\ :g/^$/d<cr>/<c-r>d<cr>/#END#/+1<cr>
endfunction "}}}
" put broken lines into Scratch (left)
function! F5_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f5>
		\ :let @d=''<cr>
		\ :g/\(#END#\)\@<!$/d D<cr>
		\ :let @"=@d<cr>
		\ :1wincmd w<cr>:b 2<cr>:call PutText(0)<cr>
endfunction "}}}

function! F5_Loc() "{{{
	call F5_Normal_Loc()
	call F5_Visual_Loc()
	call F5_Shift_Normal_Loc()
endfunction "}}}
 "}}}4

" Function key: <F6> "{{{4
" add text to bug fix
function! F6_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f6>
		\ :1,$yank<cr>:1wincmd w<cr>
		\ :b chinese.loc<cr>
		\ :$-1put! "<cr>'a
		\ :4wincmd w<cr>
endfunction "}}}
" search GUID (long line) in English buffer
function! F6_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f6>
		\ $F-T	yt	
		\ :2wincmd w<cr>gg
		\ :%s/<c-r>"\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}}

function! F6_Loc() "{{{
	call F6_Normal_Loc()
	call F6_Shift_Normal_Loc()
endfunction "}}}
 "}}}4

" Function key: <F7> "{{{4
" put text into the lower-right buffer
" overwrite buffer
function! F7_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f7>
		\ :y<cr>:4wincmd w<cr>
		\ :call PutText(0)<cr>
endfunction "}}}
function! F7_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <f7>
		\ :y<cr>:4wincmd w<cr>
		\ :call PutText(0)<cr>
endfunction "}}}
" append to buffer
function! F7_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f7>
		\ :y<cr>:4wincmd w<cr>
		\ :call PutText(2)<cr>
endfunction "}}}
function! F7_Shift_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <s-f7>
		\ :y<cr>:4wincmd w<cr>
		\ :call PutText(2)<cr>
endfunction "}}}
function! F7_Loc() "{{{
	call F7_Normal_Loc()
	call F7_Visual_Loc()
	call F7_Shift_Normal_Loc()
	call F7_Shift_Visual_Loc()
endfunction "}}}
 "}}}4

" Function key: <F8> "{{{4
" move cursor to Chinese in an Excel line
function! F8_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f8>
		\ ^5/\t<cr>l
endfunction "}}}
" move cursor into the top-right buffer
function! F8_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f8>
		\ :2wincmd w<cr>
endfunction "}}}
function! F8_Loc() "{{{
	call F8_Normal_Loc()
	call F8_Shift_Normal_Loc()
endfunction "}}}
 "}}}4

function! Localization() "{{{
	call F1_Loc()
	call F2_Loc()
	call F3_Loc()
	call F4_Loc()
	call F5_Loc()
	call F6_Loc()
	call F7_Loc()
	call F8_Loc()
endfunction "}}}
 "}}}3
 "}}}2

" Vim settings "{{{2

" Encoding "{{{3
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,latin1
set nobomb
 "}}}3

" Display "{{{3
" text line
set linespace=0
set display=lastline
set nolinebreak
" syntax
syntax enable
" close buffer
set hidden
" language
" change the name of 'lang' folder will force vim to use English
" window size
" windows | linux GUI | linux terminal
if CheckOS()=='windows' "{{{
	autocmd GUIEnter * simalt ~x
elseif has('gui_running')
	set lines=999
	set columns=999
elseif CheckOS()=='linux'
	set lines=30
	set columns=100
endif "}}}
" colorscheme
set background=dark
if has('gui_running') "{{{
	colorscheme solarized
else
	colorscheme desert
endif "}}}
" status line
set laststatus=2
set ruler
" clear previous settings "{{{
set statusline=
" relative path, modified, readonly, help, preview
set statusline+=%f%m%r%h%w
" fileencoding, fileformat, buffer number, window number
set statusline+=\ [%{&fenc}][%{&ff}][%n]
" set statusline+=\ [%{&fenc}][%{&ff}][%n,%{winnr()}]
" right aligned items
set statusline+=%=
" cursor line number
" can be obtained from :echo line('.')
" keep digits from right to left (just as text item)
set statusline+=%1.4(%l%),
" number of lines
set statusline+=%1.5L
" percentage through file
set statusline+=\ %P
" column number and virtual column number
" set statusline+=[%1.3(%c%)
" set statusline+=%1.4V] "}}}
" number
set number
" command line
set showcmd
set cmdheight=2
set history=100
set wildmenu
" font
set ambiwidth=double
if CheckOS()=='windows' "{{{
	set guifont=Consolas:h15:cANSI
elseif CheckOS()=='linux'
	set guifont=DejaVu\ Sans\ \Mono\ 14
endif "}}}
 "}}}3

" Editing "{{{3
set modelines=1
set backspace=indent,eol,start
set sessionoptions=buffers,folds,sesdir,slash,unix,winsize
set matchpairs+=<:>
" use both * and + registers when yanking in visual mode
" least GUI components
set guioptions=aP
" fold
set foldmethod=marker
set foldlevel=20
" search
set ignorecase
set incsearch
set smartcase
" tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
" indent
set autoindent
set smartindent
" change directory
if CheckOS()=='windows' "{{{
	cd d:\Documents\
elseif CheckOS()=='linux'
	cd ~/documents/
endif "}}}
 "}}}3
 "}}}2

" Key mappings and abbreviations "{{{2

" use function keys and commands instead of mapleader "{{{
" see below: '; and :'
set timeoutlen=0
let mapleader='\'
 "}}}
" switch case "{{{
nnoremap ` ~
vnoremap ` ~
 "}}}
" search backward "{{{
nnoremap , ?
vnoremap , ?
 "}}}
" next/previous buffer "{{{
nnoremap <silent> ? :bn<cr>
nnoremap <silent> <a-/> :bp<cr>
 "}}}
" save "{{{
nnoremap <silent> <cr> :wa<cr>
 "}}}
" open or close fold "{{{
nnoremap <space> za
 "}}}
" move to mark "{{{
nnoremap ' `
 "}}}
" modified 'Y' "{{{
nnoremap Y y$
 "}}}
" ';', ',' and ':' "{{{
nnoremap ; :
nnoremap <c-n> ;
nnoremap <a-n> ,
vnoremap ; :
vnoremap <c-n> ;
vnoremap <a-n> ,
 "}}}
" gj and  gk "{{{
nnoremap <c-j> gj
nnoremap <c-k> gk
vnoremap <c-j> gj
vnoremap <c-k> gk
 "}}}
" ^ and $ "{{{
nnoremap 0 ^
nnoremap - $
nnoremap ^ 0
vnoremap 0 ^
vnoremap - $
vnoremap ^ 0
onoremap 0 ^
onoremap - $
onoremap ^ 0
 "}}}
" jump between brackets "{{{
nnoremap q %
vnoremap q %
onoremap q %
 "}}}
" a-b substitution "{{{
nnoremap <silent> <a-q> :ABSubs<cr>
vnoremap <silent> <a-q> "by:ABSubs<cr>
 "}}}
" bullet points "{{{
nnoremap <silent> <a-b> :Bullet<cr>
vnoremap <silent> <a-b> <esc>:BulletV<cr>
 "}}}
" switch settings "{{{
nnoremap <silent> \ :SwBackground<cr>
nnoremap <silent> <c-\> :SwHlsearch<cr>
nnoremap <silent> <a-\> :SwLinebreak<cr>
 "}}}
" change fold level "{{{
nnoremap <silent> <a-=> :FlAdd<cr>
vnoremap <silent> <a-=> <esc>:FlVAdd<cr>
nnoremap <silent> <a--> :FlSub<cr>
vnoremap <silent> <a--> <esc>:FlVSub<cr>
nnoremap <silent> _ :FlDelNum<cr>
vnoremap <silent> _ <esc>:FlVDelNum<cr>
nnoremap <silent> + :FlAppNum<cr>
vnoremap <silent> + <esc>:FlVAppNum<cr>
 "}}}
" append, insert and creat fold marker "{{{
nnoremap <silent> <tab> :FmAfter<cr>
nnoremap <silent> <s-tab> :FmBefore<cr>
nnoremap <silent> <c-tab> :FmInside<cr>
nnoremap <silent> ~ :FmCreat<cr>
nnoremap <silent> Q :FmWrap<cr>
vnoremap <silent> Q <esc>:FmVWrap<cr>
 "}}}
" search visual selection "{{{
" forward, backward and yank match pattern
vnoremap <silent> <tab> y:SearchForward<cr>
vnoremap <silent> <s-tab> y:SearchYankAll<cr>
vnoremap <silent> <c-tab> y:SearchGrep<cr>:copen<cr>
 "}}}
" Scratch buffer "{{{
" edit
nnoremap <silent> <c-q> :ScrEdit<cr>
" substitute
nnoremap <silent> <backspace> :ScrSubs<cr>
vnoremap <silent> <backspace> y:ScrSubs<cr>
" append
nnoremap <silent> <s-backspace> :ScrAfter<cr>
vnoremap <silent> <s-backspace> y:ScrAfter<cr>
" insert
nnoremap <silent> <c-backspace> :ScrBefore<cr>
vnoremap <silent> <c-backspace> y:ScrBefore<cr>
" move
nnoremap <silent> <a-backspace> :ScrMove<cr>
vnoremap <silent> <a-backspace> zi<esc>:ScrVMove<cr>
 "}}}
 "}}}2

" User defined commands "{{{2

" insert bullet points "{{{
command! Bullet call BulletPoint(0)
command! BulletV call BulletPoint(1)
 "}}}
" creat page number "{{{
command! Page call PageNumber()
 "}}}
" update current time "{{{
" search 'http://vim.wikia.com' for help
" change language settings in windows
" 时钟、语言和区域——区域和语言——格式：英语（美国）
command! Time call TimeStamp(1)
command! Date call TimeStamp(0)
 "}}}
" delete empty lines "{{{
command! DelEmpty call EmptyLines(1)
command! DelAdd call EmptyLines(0)
 "}}}
" a-b substitution "{{{
command! ABSubs call SearchPattern(0)
 "}}}
" foward/backward search "{{{
command! SearchForward call SearchPattern(1)
command! SearchYankAll call SearchPattern(2)
command! SearchGrep call SearchPattern(3)
 "}}}
" Scratch buffer "{{{
" put text to Scratch
command! ScrAfter call ScratchBuffer(4)
command! ScrBefore call ScratchBuffer(3)
command! ScrSubs call ScratchBuffer(2)
" creat new Scratch
command! ScrCreat call ScratchBuffer(7)
" edit Scratch
command! ScrEdit call ScratchBuffer(1)
" move text between Scratch and other buffers
command! ScrMove call ScratchBuffer(5)
command! ScrVMove call ScratchBuffer(6)
 "}}}
" folds "{{{
" change fold level
command! FlSub call ChangeFoldLevel(0)
command! FlVSub call ChangeFoldLevel(1)
command! FlAdd call ChangeFoldLevel(2)
command! FlVAdd call ChangeFoldLevel(3)
command! FlDelNum call ChangeFoldLevel(4)
command! FlVDelNum call ChangeFoldLevel(5)
command! FlAppNum call ChangeFoldLevel(6)
command! FlVAppNum call ChangeFoldLevel(7)
" append, insert and creat fold marker
command! FmCreat call MoveFoldMarker(0)
command! FmAfter call MoveFoldMarker(1)
command! FmBefore call MoveFoldMarker(2)
command! FmInside call MoveFoldMarker(3)
command! FmWrap call MoveFoldMarker(4)
command! FmVWrap call MoveFoldMarker(5)
 "}}}
" switch settings "{{{
command! SwHlsearch call SwitchSettings(0)
command! SwLinebreak call SwitchSettings(1)
command! SwBackground call SwitchSettings(2)
 "}}}
" Chines word count "{{{
command! Word %s/[^\x00-\xff]//gn
 "}}}
" load key mappings "{{{
command! KeVocab call Vocabulary()
command! KeLocal call Localization()
command! KeGTD call GetThingsDone()
command! KeTranslation call Translation()
 "}}}
" localization "{{{
command! LocFormat call FileFormat_Loc()
command! LocLine call LineBreak_Loc()
 "}}}
" edit .vimrc "{{{
command! EdVimrc e $MYVIMRC
 "}}}
" autocommands "{{{
autocmd BufRead *.loc call Localization()
autocmd BufRead *.gtd call GetThingsDone()
autocmd BufRead *.vocab call Vocabulary()
autocmd BufRead *toc.write call Translation()
autocmd VimEnter * call ScratchBuffer(0)
 "}}}
 "}}}2
" vim: set nolinebreak number foldlevel=20: "}}}1
