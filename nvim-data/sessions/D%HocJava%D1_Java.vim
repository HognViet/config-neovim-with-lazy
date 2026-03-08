let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
let NvimTreeSetup =  1 
let NvimTreeRequired =  1 
silent only
silent tabonly
cd D:/HocJava/D1_Java
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +23 D:/HocJava/D1_Java/src/d1_java/Bai2_De1.java
argglobal
%argdel
$argadd .
edit D:/HocJava/D1_Java/src/d1_java/Bai2_De1.java
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
setlocal foldmethod=expr
setlocal foldexpr=v:lua.vim.lsp.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
12
sil! normal! zo
12
sil! normal! zo
13
sil! normal! zo
13
sil! normal! zo
14
sil! normal! zo
24
sil! normal! zo
24
sil! normal! zo
26
sil! normal! zo
26
sil! normal! zo
27
sil! normal! zo
35
sil! normal! zo
35
sil! normal! zo
36
sil! normal! zo
44
sil! normal! zo
44
sil! normal! zo
48
sil! normal! zo
let s:l = 23 - ((22 * winheight(0) + 17) / 34)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 23
normal! 0
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
