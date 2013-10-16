" Bozar's .vimrc file "{{{1
" Last Update: Wed, Oct 16 | 19:32:23 | 2013

set nocompatible
filetype off
" }}}1
"
" Vundle "{{{1
" I'll try on some plugins later

filetype plugin on
" }}}1
"
" Functions "{{{1
"
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
"
" append(1) or insert(0) fold markers "{{{2
" apply the fold level of cursor line
function! YankFoldMarker(fold_line) "{{{
	normal [zmj]zmk
	if a:fold_line==0
		'jy "
		'jpu! "
		'ky "
		'jpu! "
		'j-2s/^.*\({\{3\}\)\@=//
	elseif a:fold_line==1
		'ky "
		'kpu "
		'jy "
		'kpu "
		'k+1s/^.*\({\{3\}\)\@=//
	endif
endfunction "}}}
" }}}2
"
" insert bullets: special characters at the beginning of a line "{{{2
" do not indent title '-'
function! IndentTitle() "{{{
	'j,'kg/^\(\t\|\s\{4\}\)\-/left 0
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
"
" add(1) or substract(0) fold level "{{{2
function! ChangeFoldLevel(level)  "{{{
	if a:level==0
		'j,'ks/\({{{\|}}}\)\@<=\d/\=submatch(0)-1
	elseif a:level==1
		'j,'ks/\({{{\|}}}\)\@<=\d/\=submatch(0)+1
	endif
endfunction "}}}
" }}}2
"
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

" add time-stamp {{{2
function! CurrentTime() "{{{
	1,5s/\(Last Update: \|Date: \|最后更新：\|日期：\)\@<=.*$/\=strftime('%a, %b %d | %H:%M:%S | %Y')/e
	$-4,$s/\(Last Update: \|Date: \|最后更新：\|日期：\)\@<=.*$/\=strftime('%a, %b %d | %H:%M:%S | %Y')/e
endfunction "}}}
" }}}2
"
" GTD "{{{2
"
" replace bullet point (*) with:
" finished (~) or unfinished (!)
function! Finished_GTD() "{{{
	nnoremap <buffer> <silent> <f1> :s/^\t\(\*\\|!\)/\t\~<cr>
	nnoremap <buffer> <silent> <s-f1> :s/^\t\(\*\\|\~\)/\t!<cr>
endfunction "}}}

" insert new lines for another day
function! AnotherDay_GTD() "{{{
	nnoremap <buffer> <silent> <f2>
		\ :call YankFoldMarker(0)<cr>
		\ :'j-2<cr>dd:'j<cr>yy:'j-1<cr>P
		\ :s/\d\{1,2\}\(日\)\@=/\=submatch(0)+1<cr>
		\ :call ChangeFoldLevel(1)<cr>
		\ 'jk[zo<esc>
endfunction "}}}

function! GetThingsDone() "{{{
	call Finished_GTD()
	call AnotherDay_GTD()
endfunction "}}}
" }}}2
"
" Localization "{{{2
" 
" need to tweak the Excel table first
" insert #MARK# before English column
" insert #END# after the last column
" 
" Chinese | English = glossary = tmp
" left | up-right = middle-right = down-right
" modeline: from left to right
" vim: set linebreak:
" vim: set linebreak nonumber nomodifiable cursorline:
" vim: set nonumber nomodifiable:
" vim: set linebreak:
"
" split window equally between all buffers
" except for glossary buffer
" :resize 3
"
" search nearby lines in English buffer
" let @d='previous search pattern'
" let @e='current search pattern'
" :h 10.3
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

" Function key: <F1> "{{{3
" 
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

function! F1_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f1>
		\ ^"cyt	<c-w>b<c-w>kgg
		\ :%s/<c-r>d\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}}

function! F1_Loc() "{{{
	call F1_Normal_Loc()
	call F1_Visual_Loc()
	call F1_Shift_Normal_Loc()
endfunction "}}}
" }}}3
"
" Function key: <F2> "{{{3
"
" search current buffer
" put cursor after the first '\t'
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
" in combination with <F5>
function! F2_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f2> 
		\ ^yt	<c-w>b<c-w>2kgg
		\ :%s/\(\t#MARK#\t.\{-\}\)\@<=<c-r>"\c//n<cr>
		\ /<c-r>/<cr>
endfunction "}}}
function! F2_Shift_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <s-f2> 
		\ y<c-w>b<c-w>2kgg
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
"
" Function key: <F3> "{{{3
"
" search wrong translation
" let @c='English'
" let @b='Chinese correction'
function! F3_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f3>
		\ gg:%s/<c-r>c\(.\{-\}\t.\{-\}<c-r>b\)\@!\c//n<cr>
endfunction "}}}

" put '<c-r>/' text into tmp buffer
" note: it seems that when a command will delete all characters in one buffer,
" and it is at the end of a script line,
" it will break the key mapping
" compare these two mappings
" nnoremap <f12> ggdG
" \ oTEST<esc>
" nnoremap <f12> ggdGoTEST<esc>
" let @d='search pattern'
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
"
" Function key: <F4> "{{{3
" substitute words
" let @c='English'
" let @b='Chinese correction'
" let @a='wrong translation'
function! F4_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f4>
		\ gg:%s/\(<c-r>c.\{-\}\t.\{-\}\)\@<=<c-r>a\c//n<cr>
		\ :%s/<c-r>//<c-r>b/g<cr>
endfunction "}}}

" substitute the whole line
" mark s: substituted line
" mark a: previous line
function! F4_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <s-f4>
		\ ms^"ayt	f	l"byt	
		\ :%s/^\(<c-r>a\t\).\{-\}\(\t\)/\1<c-r>b\2/g<cr>'a
endfunction "}}}

function! F4_Loc() "{{{
	call F4_Normal_Loc()
	call F4_Shift_Normal_Loc()
endfunction "}}}
" }}}3
"
" Function key: <F5> "{{{3
" search and complete missing lines
" when there are more than one lines in an Excel cell
" let @d='search pattern'
" let @e='completion'
" mark S (shared between buffers): search line

function! F5_Normal_Loc() "{{{
	nnoremap <buffer> <silent> <f5>
		\ mS^"dy$<c-w>h<c-w>wgg
		\ :%s/<c-r>d//n<cr>
		\ /<c-r>/<cr>
		\ :let @e=''<cr>
		\ $?#MARK#<cr>
		\ ^"ey/#END#<cr>
		\ <c-w>h'Scc<c-r>e#END#<esc>j
endfunction "}}}
function! F5_Visual_Loc() "{{{
	vnoremap <buffer> <silent> <f5>
		\ mS"dy<c-w>h<c-w>wgg
		\ :%s/<c-r>d//n<cr>
		\ /<c-r>/<cr>
		\ :let @e=''<cr>
		\ $?#MARK#<cr>
		\ ^"ey/#END#<cr>
		\ <c-w>h'Scc<c-r>e#END#<esc>j
endfunction "}}}

function! F5_Loc() "{{{
	call F5_Normal_Loc()
	call F5_Visual_Loc()
endfunction "}}}
" }}}3
"
" Function key: <F6> "{{{3
" 
" put lines into Scratch buffer
" the previous search pattern is shown at the center of window
function! F6_Normal_Loc() "{{{
	nnoremap <buffer> <f6>
		\ :call NearbyLines_Loc()<cr>
		\ <c-w>h:buffer 2\|call PutText(0)<cr>
		\ /<c-r>d<cr>ma
		\ :call DeleteColumns_Loc()<cr>
		\ 'azz
endfunction "}}}

" ready for completion
" put broken lines into Scratch (left)
function! F6_Shift_Normal_Loc() "{{{
	nnoremap <buffer> <s-f6>
		\ :let @d=''<cr>
		\ :g/\(#END#\)\@<!$/d D<cr>
		\ :let @"=@d<cr>
		\ <c-w>h:b 2<cr>:call PutText(0)<cr>
endfunction "}}}

function! F6_Loc() "{{{
	call F6_Normal_Loc()
	call F6_Shift_Normal_Loc()
endfunction "}}}
" }}}3

function! LocKeyMapping() "{{{
	call F1_Loc()
	call F2_Loc()
	call F3_Loc()
	call F4_Loc()
	call F5_Loc()
	call F6_Loc()
endfunction "}}}
" }}}2
"
" add scratch buffer "{{{2
" load LocKeyMapping
function! ScratchBuffer() "{{{
	new
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
	setlocal nobuflisted
	call LocKeyMapping()
	close
endfunction "}}}
" }}}2
" }}}1
"
" Vim settings "{{{1
"
" Encoding "{{{2

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,latin1
set nobomb
" }}}2
"
" Display "{{{2
"
" text line
set linespace=0
set display=lastline
set nolinebreak

" syntax
syntax enable

" close buffer
set hidden

" language
" change the folder name 'lang'
" will force vim to use English

" window size
" windows | linux GUI | linux terminal
if CheckOS()=='windows'
	autocmd GUIEnter * simalt ~x
elseif has('gui_running')
	set lines=999
	set columns=999
elseif CheckOS()=='linux'
	set lines=30
	set columns=100
endif

" colorscheme
set background=dark

if has('gui_running')
	colorscheme solarized
else
	colorscheme desert
endif

" status line
set laststatus=2
set ruler

" clear previous settings
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
"	set statusline+=[%1.3(%c%)
"	set statusline+=%1.4V]

" number
set number
set numberwidth=3

" command line
set showcmd
set cmdheight=2
set history=100
set wildmenu

" font
set ambiwidth=double

if CheckOS()=='windows'
	set guifont=Consolas:h15:cANSI
elseif CheckOS()=='linux'
	set guifont=DejaVu\ Sans\ \Mono\ 14
endif
" }}}2
"
" Editing "{{{2

set modelines=1
set backspace=indent,eol,start
set sessionoptions=buffers,folds,sesdir,slash,unix,winsize
set matchpairs+=<:>

" yank behavior
" use both * and + registers
" least GUI components
set guioptions=aP

" fold
set foldmethod=marker
set foldminlines=3
set foldlevel=1

" search
set ignorecase
set incsearch
set smartcase

" indent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set autoindent
set smartindent

" change directory
if CheckOS()=='windows'
	cd d:\Documents\
elseif CheckOS()=='linux'
	cd ~/Documents/
endif
" }}}2
" }}}1
"
" Key mappings and abbreviations "{{{1
"
" use function keys and commands instead of mapleader
" see below: '; and :'
set timeoutlen=0
let mapleader='\'

" switch case
nnoremap ` ~
vnoremap ` ~

" search backward
nnoremap , ?
vnoremap , ?

" enter
nnoremap <silent> <cr> :wa<cr>

" append or insert fold marker
nnoremap <tab> :call YankFoldMarker(1)<cr>
nnoremap <s-tab> :call YankFoldMarker(0)<cr>

" open or close fold
nnoremap <space> za

" move to mark
nnoremap ' `

" modified 'Y'
nnoremap Y y$

" ';', ',' and ':'
nnoremap ; :
nnoremap <c-n> ;
nnoremap <c-p> ,

vnoremap ; :
vnoremap <c-n> ;
vnoremap <c-p> ,

" gj and  gk
nnoremap <c-j> gj
nnoremap <c-k> gk

vnoremap <c-j> gj
vnoremap <c-k> gk

" ^ and $
nnoremap 0 ^
nnoremap - $

vnoremap 0 ^
vnoremap - $

onoremap 0 ^
onoremap - $

" }}}1
"
" User defined commands "{{{1
"
" insert bullet points
command! BulletPoint call InsertBulletPoint()

" append time-stamp to cursor line
" search 'http://vim.wikia.com' for help
" change language settings in windows
" 时钟、语言和区域——区域和语言——格式：英语（美国）
command! TimeStamp call CurrentTime()|normal ''

" change fold level
command! AddFoldLevel call ChangeFoldLevel(1)
command! SubFoldLevel call ChangeFoldLevel(0)

" replace '\t' with '\s\s\s\s'
" replace '\t\t' with '\t'
command! TabToSpace 'j,'ks/\(\t\)\@<!\t\(\t\)\@!/    /ge|'j,'ks/\t\t/\t/ge

" put text to Scratch buffer
command! AppendToScratch buffer 2|call PutText(2)
command! InsertIntoScratch buffer 2|call PutText(1)
command! OverwriteScratch buffer 2|call PutText(0)

" word count
command! WordCountCN %s/[^\x00-\xff]//gn
command! WordCountEN %s/\a\+//gn

" edit .vimrc
command! EditVimrc e $MYVIMRC

" switch settings
command! HighlightSwitch set hlsearch!
command! LightBackground set background=light
command! DarkBackground set background=dark

" autocommands
autocmd BufRead *.loc call LocKeyMapping()
autocmd BufRead *.gtd call GetThingsDone()
autocmd VimEnter * call ScratchBuffer()

" }}}1
"
" vim: set nolinebreak number foldlevel=9:
