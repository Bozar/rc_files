" Bozar's .vimrc file "{{{1
" Last Update: Wed, Jan 29 | 01:14:58 | 2014

set nocompatible
filetype off
" }}}1

" Vundle "{{{1

" I'll try on some plugins later
filetype plugin on
" }}}1

" Functions "{{{1

" windows or linux "{{{2
function! CheckOS() "{{{
	if has('win32')
		return 'windows'
	elseif has('win64')
		return 'windows'
	else
		return 'linux'
	endif
endfunction "}}}
" }}}2

" change background color "{{{2
" :h expr-option
function! SetBackground() "{{{
	if &background=='dark'
		set background=light
	else
		set background=dark
	endif
endfunction "}}}
" }}}2

" put text to another file "{{{2
" 0: overwrite old text
" 1: insert into old text
" 2: append to old text
function! PutText(put_line) "{{{
	if a:put_line==0
		$mark j|$put "
		1,'jdelete
	elseif a:put_line==1
		1put! "
		1
	elseif a:put_line==2
		$mark j|$put "
		'j+1
	endif
endfunction "}}}
" }}}2

" move text from/to scratch "{{{2
" put text between mark j and mark k to Scratch buffer
" and take them back when necessary
function! MoveScratchText(move_position) "{{{
	if a:move_position==0
		'j-1mark J
		'j,'kyank
		ScratchOverwrite
	elseif a:move_position==1
		1,$yank
		'J
		put "
		'j,'kdelete
	endif
endfunction "}}}
" }}}2

" append(1), insert(0) and creat(2) fold markers "{{{2
" apply the fold level of cursor line
function! YankFoldMarker(fold_line) "{{{
	if a:fold_line==0
		normal [zmj]zmk
		'jyank "
		'jput! "
		'jput! "
		'j-2,'j-1s/^.*\( \(\|"\){\{3\}\)\@=//
		'j-1s/{{{/}}}
		'j-2
		normal ^
	elseif a:fold_line==1
		normal [zmj]zmk
		'jyank "
		'kput "
		'kput "
		'k+1,'k+2s/^.*\( \(\|"\){\{3\}\)\@=//
		'k+2s/{{{/}}}
		'k+1
		normal ^
	elseif a:fold_line==2
		s/$/\rFOLDMARKER {{{\r }}}
		.-1,.s/$/1
		-1
	endif
endfunction "}}}
" }}}2

" insert bullets: special characters at the beginning of a line "{{{2
" do not indent title '-'
function! IndentTitle() "{{{
	'j,'kg/^\(\t\{1,2\}\|\s\{4,8\}\)\-/left 0
	'j,'ks/^-//e
endfunction "}}}
" '==' will be replaced with '+'
"		indent 2 tabs (8 spaces)
" '=' will be replaced with '*'
"	indent 1 tab (4 spaces)
function! IndentParagraph() "{{{
	'j,'kg/^\(\|\t\|\s\{4\}\)==/left 8
	'j,'ks/^\(\t\t\)==/\1+ /e

	'j,'kg/^\(\|\s\{4\}\)=/left 4
	'j,'ks/^\(\t\)=/\1* /e
endfunction "}}}

function! InsertBulletPoint() "{{{
	call IndentTitle()
	call IndentParagraph()
endfunction "}}}
" }}}2

" add(1) or substract(0) fold level "{{{2
function! ChangeFoldLevel(level)  "{{{
	if a:level==0
		'j,'ks/\({{{\|}}}\)\@<=\d/\=submatch(0)-1
	elseif a:level==1
		'j,'ks/\({{{\|}}}\)\@<=\d/\=submatch(0)+1
	endif
endfunction "}}}
" }}}2

" delete lines "{{{2
function! EmptyLines(line) "{{{
	if a:line==0
	g/^$/.+1s/^$/###DELETE_EMPTY_LINES###
	g/^###DELETE_EMPTY_LINES###$/d
	elseif a:line==1
		g/^$/d
	endif	
endfunction "}}}
" }}}2

" add time-stamp {{{2
" there should be at least 5 lines in a file
function! CurrentTime() "{{{
	1,5s/\(Last Update: \|Date: \|最后更新：\|日期：\)\@<=.*$/\=strftime('%a, %b %d | %H:%M:%S | %Y')/e
	$-4,$s/\(Last Update: \|Date: \|最后更新：\|日期：\)\@<=.*$/\=strftime('%a, %b %d | %H:%M:%S | %Y')/e
endfunction "}}}
" }}}2

" add scratch buffer "{{{2
function! ScratchBuffer() "{{{
	new
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
	setlocal nobuflisted
	s/^/SCRATCH_BUFFER\r
	close
endfunction "}}}
" }}}2

" GTD "{{{2
" substitute bullet point (*) with finished mark (~)
function! Finished_GTD() "{{{
	nnoremap <buffer> <silent> <f1> :s/^\t\*/\t\~<cr>
	nnoremap <buffer> <silent> <s-f1> :s/^\t\~/\t\*<cr>
endfunction "}}}
" insert new lines for another day
"	mark j and k: yesterday
"	mark h and l: another day
" change date
" fix substitution errors on rare occasions:
"	the second day in a month (in which case both two }2 will be changed)
" change foldlevel
function! AnotherDay_GTD() "{{{
	nnoremap <buffer> <silent> <f2>
		\ :call YankFoldMarker(0)<cr>
		\ :'j-2mark h<cr>:'j-1mark l<cr>
		\ :'j,'j+2y<cr>:'hput<cr>
		\ :'h+1s/\d\{1,2\}\(日\)\@=/\=submatch(0)+1<cr>
		\ :call ChangeFoldLevel(1)<cr>
		\ :g/^ }\{3\}3$/.+1s/^\( }\{3\}\)3$/\12<cr>
		\ :'hd<cr>:'l-1<cr>wma
endfunction "}}}

function! GetThingsDone() "{{{
	call Finished_GTD()
	call AnotherDay_GTD()
endfunction "}}}
" }}}2

" English vocabulary "{{{2

" Function key: <F1> "{{{3
" search bracket '['
function! F1_Normal_EnVoc() "{{{
	nnoremap <buffer> <silent> <f1> /\[<cr>"+yi[
endfunction "}}}
function! F1_Shift_Normal_EnVoc() "{{{
	nnoremap <buffer> <silent> <s-f1> b?\[<cr>"+yi[
endfunction "}}}

function! F1_EnVoc() "{{{
	call F1_Normal_EnVoc()
	call F1_Shift_Normal_EnVoc()
endfunction "}}}
" }}}3

" Function key: <F2> "{{{3
" search word
function! F2_Normal_EnVoc() "{{{
	nnoremap <buffer> <silent> <f2> "+yi[/\[<c-r>+\]<cr>zz
endfunction "}}}

function! F2_EnVoc() "{{{
	call F2_Normal_EnVoc()
endfunction "}}}
" }}}3

" Function key: <F3> "{{{3
" insert brackets
function! F3_Normal_EnVoc() "{{{
	nnoremap <buffer> <silent> <f3> "+ciw[<c-r>"]<esc>
endfunction "}}}
function! F3_Visual_EnVoc() "{{{
	vnoremap <buffer> <silent> <f3> s[<c-r>"]<esc>
endfunction "}}}
" delete brackets
function! F3_Shift_Normal_EnVoc() "{{{
	nnoremap <buffer> <silent> <s-f3> di[pF[2x
endfunction "}}}

function! F3_EnVoc() "{{{
	call F3_Normal_EnVoc()
	call F3_Shift_Normal_EnVoc()
	call F3_Visual_EnVoc()
endfunction "}}}
" }}}3

" Function key: <F4> "{{{3
" update word list
" Word List {{{
" [word 1]
" [word 2]
" }}}
" h: cursor line | l: last line | j: folder begins | k: folder ends
function! UpdateWordList_EnVoc() "{{{
	mark h|? {\{3\}\d$?mark j|/ }\{3\}\d$/mark k
	?^Word List {{{$?+1;/^ }}}$/-1delete
	'j,'ky|$mark l|'lput
	'l+1,$s/\[/\r[/g|'l+1,$s/\]/]\r/g|'l+1,$g!/\[/d
	'l+1,$delete
	normal 'j
	/^Word List {\{3\}$/put
	?^Word List {\{3\}?s/$/\r
	"}}}
	normal 'h
endfunction "}}}
function! F4_Normal_EnVoc() "{{{
	nnoremap <buffer> <silent> <f4> :call UpdateWordList_EnVoc()<cr>
endfunction "}}}
" creat blank word list
function! F4_Shift_Normal_EnVoc() "{{{
	nnoremap <buffer> <silent> <s-f4> :?{{{?+1s/^/\rWord List {{{\r\r }}}\r<cr>
endfunction "}}}

function! F4_EnVoc() "{{{
	call F4_Normal_EnVoc()
	call F4_Shift_Normal_EnVoc()
endfunction "}}}
" }}}3

" Function key: <F5> "{{{3
" collect word lists
function! ColletWordList_EnVoc() "{{{
	let @a=''
	'j,'kg/^Word List {{{$/.+1;/ }}}$/-1y A
	let @"=@a
	ScratchOverwrite
	g/^$/d
	1s/^/Word List {{{1\r\r
	$s/$/\r }}}1
	%s/\[//n
endfunction "}}}
function! F5_Normal_EnVoc() "{{{
	nnoremap <buffer> <silent> <f5> :call ColletWordList_EnVoc()<cr>
endfunction "}}}

function! F5_EnVoc() "{{{
	call F5_Normal_EnVoc()
endfunction "}}}
" }}}3

function! EnglishVocabulary() "{{{
	call F1_EnVoc()
	call F2_EnVoc()
	call F3_EnVoc()
	call F4_EnVoc()
	call F5_EnVoc()
endfunction "}}}
" }}}2

" Localization "{{{2

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

" search nearby lines in English buffer
" let @d='previous search pattern'
" let @e='current search pattern'
function! NearbyLines_Loc() "{{{
	let @d=@/
	let @e=''
	?#MARK#?-20,/#MARK#/+20g=#MARK#=y E
endfunction "}}}
" delete all other columns except English and Chinese
" example: A1, B1, C1(#MARK#), D1(ENG), E1(CHS), F1, ...
function! DeleteColumns_Loc() "{{{
	%s/^.*#MARK#\t//e
	%s/\(^.\{-\}\t.\{-\}\)\t.*$/\1/e
endfunction "}}}
function! FileFormat_Loc() "{{{
	set fileencoding=utf-8
	set fileformat=unix
	%s/\r//ge
	%s/ \+\t/\t/ge
	%s/\t \+/\t/ge
endfunction "}}}

" Function key: <F1> "{{{3
" put cursor after the first \t
function! F1_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f1> ^f	
endfunction "}}}
" search glossary
" let @c='search pattern'
function! F1_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <f1>
		\ "cy<c-w>b<c-w>kgg
		\ :%s/<c-r>c\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}}
" search GUID in English buffer
" let @d='GUID'
function! F1_Shift_Normal_Loc() "{{{
  nnoremap <buffer> <silent> <s-f1>
		\ $2F	l"dyt	<c-w>t<c-w>wgg
		\ :%s/<c-r>d\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}} 

function! F1_Loc() "{{{
	call F1_Normal_Loc()
	call F1_Visual_Loc()
	call F1_Shift_Normal_Loc()
endfunction "}}}
" }}}3

" Function key: <F2> "{{{3
" search current buffer and put cursor after the first '\t'
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
		\ ^yt	<c-w>t<c-w>wgg
		\ :%s/\(\t#MARK#\t.\{-\}\)\@<=<c-r>"\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}}
function! F2_Shift_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <s-f2> 
		\ y<c-w>t<c-w>wgg
		\ :%s/\(\t#MARK#\t.\{-\}\)\@<=<c-r>"\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}}

function! F2_Loc() "{{{
	call F2_Normal_Loc()
	call F2_Visual_Loc()
	call F2_Shift_Normal_Loc()
	call F2_Shift_Visual_Loc()
endfunction "}}}
" }}}3

" Function key: <F3> "{{{3
" search wrong translation
" let @c='English'
" let @b='Chinese correction'
function! F3_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f3>
		\ :%s/<c-r>c\(.\{-\}\t.\{-\}<c-r>b\)\@!\c//n<cr>
endfunction "}}}
" put '<c-r>/' text into tmp buffer
" let @d='search pattern'
" note: it seems that when a command will delete all characters in one buffer,
" and it is at the end of a script line,
" it will break the key mapping
" compare these two mappings
" nnoremap <f12> ggdG
" \ oTEST<esc>
" nnoremap <f12> ggdGoTEST<esc>
function! F3_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f3>
		\ :let @d=''\|:g/<c-r>//y D<cr><c-w>b
		\ :call PutText(0)<cr>
endfunction "}}}

function! F3_Loc() "{{{
	call F3_Normal_Loc()
	call F3_Shift_Normal_Loc()
endfunction "}}}
" }}}3

" Function key: <F4> "{{{3
" substitute words
" let @c='English'
" let @b='Chinese correction'
" let @a='wrong translation'
function! F4_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f4>
		\ :%s/\(<c-r>c.\{-\}\t.\{-\}\)\@<=<c-r>a\c//n<cr>
		\ :%s/<c-r>//<c-r>b/gc<cr>
endfunction "}}}
" substitute the whole line
" mark s: substituted line
" mark a: previous line
function! F4_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f4>
		\ ms^"ayt	f	l"byt	
		\ :%s/^\(<c-r>a\t\).\{-\}\(\t\)/\1<c-r>b\2/gc<cr>
endfunction "}}}
" a-b substitution
function! F4_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <f4>
		\ "by
		\ :%s/<c-r>a/<c-r>b/gc<cr>
endfunction "}}}
function! F4_Shift_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <s-f4>
		\ "ay
		\ :%s/<c-r>a//gc<cr>
endfunction "}}}

function! F4_Loc() "{{{
	call F4_Normal_Loc()
	call F4_Shift_Normal_Loc()
	call F4_Visual_Loc()
	call F4_Shift_Visual_Loc()
endfunction "}}}
" }}}3

" Function key: <F5> "{{{3
" search and complete missing lines
" when there are more than one lines in an Excel cell
" let @d='search pattern'
" let @e='completion'
" mark S (shared between buffers): search line
function! F5_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f5>
		\ mS^"dy$
		\ <c-w>t<c-w>wgg/<c-r>d/+1<cr>
		\ :let @e=''<cr>
		\ :?#MARK#?;/#END#/y E<cr>
		\ <c-w>t'Scc<c-r>e<esc>gg
		\ :g/^$/d<cr>/<c-r>d<cr>/#END#/+1<cr>
endfunction "}}}
function! F5_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <f5>
		\ mS"dy
		\ <c-w>t<c-w>wgg/<c-r>d/+1<cr>
		\ :let @e=''<cr>
		\ :?#MARK#?;/#END#/y E<cr>
		\ <c-w>t'Scc<c-r>e<esc>gg
		\ :g/^$/d<cr>/<c-r>d<cr>/#END#/+1<cr>
endfunction "}}}
" put broken lines into Scratch (left)
function! F5_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f5>
		\ :let @d=''<cr>
		\ :g/\(#END#\)\@<!$/d D<cr>
		\ :let @"=@d<cr>
		\ <c-w>t:b 2<cr>:call PutText(0)<cr>
endfunction "}}}

function! F5_Loc() "{{{
	call F5_Normal_Loc()
	call F5_Visual_Loc()
	call F5_Shift_Normal_Loc()
endfunction "}}}
" }}}3

" Function key: <F6> "{{{3
" add text to bug fix
function! F6_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f6>
		\ :1,$yank<cr><c-w>t
		\ :b chinese.loc<cr>
		\ :$put! "<cr>'a
		\ <c-w>b
endfunction "}}}
" put lines into Scratch buffer
" the previous search pattern is shown at the center of window
function! F6_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f6>
		\ :call NearbyLines_Loc()<cr>
		\ <c-w>t:buffer 2\|call PutText(0)<cr>
		\ /<c-r>d<cr>ma
		\ :call DeleteColumns_Loc()<cr>
		\ 'azz
endfunction "}}}

function! F6_Loc() "{{{
	call F6_Normal_Loc()
	call F6_Shift_Normal_Loc()
endfunction "}}}
" }}}3

" Function key: <F7> "{{{3
" put text into the lower-right buffer
" overwrite buffer
function! F7_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f7>
		\ :y<cr><c-w>b
		\ :call PutText(0)<cr>
endfunction "}}}
function! F7_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <f7>
		\ :y<cr><c-w>b
		\ :call PutText(0)<cr>
endfunction "}}}
" append to buffer
function! F7_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f7>
		\ :y<cr><c-w>b
		\ :call PutText(2)<cr>
endfunction "}}}
function! F7_Shift_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <s-f7>
		\ :y<cr><c-w>b
		\ :call PutText(2)<cr>
endfunction "}}}
function! F7_Loc() "{{{
	call F7_Normal_Loc()
	call F7_Visual_Loc()
	call F7_Shift_Normal_Loc()
	call F7_Shift_Visual_Loc()
endfunction "}}}
" }}}3

" Function key: <F8> "{{{3
" move cursor to Chinese in an Excel line
function! F8_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f8>
		\ ^5/\t<cr>l
endfunction "}}}
" move cursor into the top-right buffer
function! F8_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f8>
		\ <c-w>h<c-w>w
endfunction "}}}
function! F8_Loc() "{{{
	call F8_Normal_Loc()
	call F8_Shift_Normal_Loc()
endfunction "}}}
" }}}3

function! LocKeyMapping() "{{{
	call F1_Loc()
	call F2_Loc()
	call F3_Loc()
	call F4_Loc()
	call F5_Loc()
	call F6_Loc()
	call F7_Loc()
	call F8_Loc()
endfunction "}}}
" }}}2
" }}}1

" Vim settings "{{{1

" Encoding "{{{2
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,latin1
set nobomb
" }}}2

" Display "{{{2
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
" fileencoding, fileformat, buffer number
set statusline+=\ [%{&fenc}][%{&ff}][%n]
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
" }}}2

" Editing "{{{2
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
" }}}2
" }}}1

" Key mappings and abbreviations "{{{1

" use function keys and commands instead of mapleader "{{{
" see below: '; and :'
set timeoutlen=0
let mapleader='\'
" }}}
" switch case "{{{
nnoremap ` ~
vnoremap ` ~
" }}}
" search backward "{{{
nnoremap , ?
vnoremap , ?
" }}}
" save "{{{
nnoremap <silent> <cr> :wa<cr>
" }}}
" append, insert and creat fold marker "{{{
nnoremap <tab> :call YankFoldMarker(1)<cr>
nnoremap <s-tab> :call YankFoldMarker(0)<cr>
nnoremap <c-tab> :call YankFoldMarker(2)<cr>
" }}}
" open or close fold "{{{
nnoremap <space> za
" }}}
" move to mark "{{{
nnoremap ' `
" }}}
" modified 'Y' "{{{
nnoremap Y y$
" }}}
" ';', ',' and ':' "{{{
nnoremap ; :
nnoremap <c-n> ;
nnoremap <a-n> ,
vnoremap ; :
vnoremap <c-n> ;
vnoremap <a-n> ,
" }}}
" gj and  gk "{{{
nnoremap <c-j> gj
nnoremap <c-k> gk
vnoremap <c-j> gj
vnoremap <c-k> gk
" }}}
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
" }}}
" jump between brackets "{{{
nnoremap q %
vnoremap q %
onoremap q %
" }}}
" switch settings "{{{
nnoremap <silent> <c-\> :set hlsearch!<cr>:set hlsearch?<cr>
nnoremap <silent> <a-\> :set linebreak!<cr>:set linebreak?<cr>
nnoremap <silent> \ :call SetBackground()<cr>
" }}}
" change fold level "{{{
nnoremap <silent> <a-=> :call ChangeFoldLevel(1)<cr>
nnoremap <silent> <a--> :call ChangeFoldLevel(0)<cr>
" }}}
" switch to Scratch buffer "{{{
nnoremap <silent> <c-q> :buffer 2<cr>
" }}}
" search visual selection "{{{
vnoremap <silent> <tab> y:%s/<c-r>"\c//gn<cr>/<c-r>/<cr>''
vnoremap <silent> <s-tab> y:%s/<c-r>"\c//gn<cr>?<c-r>/<cr>''
" }}}
" Scratch buffer "{{{
nnoremap <silent> <backspace> :ScratchOverwrite<cr>
nnoremap <silent> <c-backspace> :ScratchAppend<cr>
nnoremap <silent> <s-backspace> :ScratchInsert<cr>
nnoremap <silent> <a-backspace> :ScratchCreat<cr>
" }}}
" }}}1

" User defined commands "{{{1

" insert bullet points
command! BulletPoint call InsertBulletPoint()
" search 'http://vim.wikia.com' for help
" change language settings in windows
" 时钟、语言和区域——区域和语言——格式：英语（美国）
command! TimeStamp call CurrentTime()|normal ''
" replace '\t' with '\s\s\s\s' | '\t\t' with '\t'
command! TabToSpace 'j,'ks/\(\t\)\@<!\t\(\t\)\@!/    /ge|'j,'ks/\t\t/\t/ge
" delete empty lines
command! DeleteEmpty call EmptyLines(1)
command! DeleteAdditional call EmptyLines(0)
" put text to Scratch buffer
command! ScratchAppend buffer 2|call PutText(2)
command! ScratchInsert buffer 2|call PutText(1)
command! ScratchOverwrite buffer 2|call PutText(0)
" creat new Scratch buffer
command! ScratchCreat call ScratchBuffer()|ls!
" word count
command! WordCountCN %s/[^\x00-\xff]//gn
command! WordCountEN %s/\a\+//gn
" load key mappings
command! KeyMappingEN call EnglishVocabulary()
command! KeyMappingLoc call LocKeyMapping()
" localization
command! FormatLocFile call FileFormat_Loc()
" edit .vimrc
command! EditVimrc e $MYVIMRC
" autocommands
autocmd BufRead *.loc call LocKeyMapping()
autocmd BufRead achievement.note call GetThingsDone()
autocmd VimEnter * call ScratchBuffer()
" }}}1

" vim: set nolinebreak number foldlevel=20:
