let SessionLoad = 1
if &cp | set nocp | endif
map  :wa:!make
noremap ;,c :call rtags#FindSubClasses()
noremap ;,C :call rtags#FindSuperClasses()
noremap ;,b :call rtags#JumpBack()
noremap ;,v :call rtags#FindVirtuals()
noremap ;,w :call rtags#RenameSymbolUnderCursor()
noremap ;,l :call rtags#ProjectList()
noremap ;,r :call rtags#ReindexFile()
noremap ;,s :call rtags#FindSymbols(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))
noremap ;,n :call rtags#FindRefsByName(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))
noremap ;,F :call rtags#FindRefsCallTree()
noremap ;,f :call rtags#FindRefs()
noremap ;,p :call rtags#JumpToParent()
noremap ;,T :call rtags#JumpTo(g:NEW_TAB)
noremap ;,V :call rtags#JumpTo(g:V_SPLIT)
noremap ;,S :call rtags#JumpTo(g:H_SPLIT)
noremap ;,J :call rtags#JumpTo(g:SAME_WINDOW, { '--declaration-only' : '' })
noremap ;; :call rtags#JumpTo(g:SAME_WINDOW)
noremap ;,i :call rtags#SymbolInfo()
let s:cpo_save=&cpo
set cpo&vim
vmap gx <Plug>NetrwBrowseXVis
nmap gx <Plug>NetrwBrowseX
vnoremap <silent> <Plug>NetrwBrowseXVis :call netrw#BrowseXVis()
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(netrw#GX(),netrw#CheckIfRemote(netrw#GX()))
map <F7> :! echo "You hit F7!" 
map <C-1><C-1> 1gt
map <C-M><C-M> :wa:!make
let &cpo=s:cpo_save
unlet s:cpo_save
set autoindent
set background=dark
set backspace=indent,eol,start
set completefunc=RtagsCompleteFunc
set exrc
set fileencodings=ucs-bom,utf-8,default,latin1
set helplang=en
set hlsearch
set incsearch
set nomodeline
set printoptions=paper:a4
set ruler
set runtimepath=~/.vim,~/.vim/pack/plug/start/rtags,~/.vim/pack/plug/start/q,~/.vim/pack/plug/start/lua-support,~/.vim/pack/git-plugins/start/vim-which-key,/var/lib/vim/addons,/etc/vim,/usr/share/vim/vimfiles,/usr/share/vim/vim82,/usr/share/vim/vimfiles/after,/etc/vim/after,/var/lib/vim/addons/after,~/.vim/after
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/src/5p
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
argglobal
%argdel
$argadd project.lua
$argadd lib/all.lua
set stal=2
tabnew
tabnew
tabnew
tabrewind
edit project.lua
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
let s:cpo_save=&cpo
set cpo&vim
inoremap <buffer> <silent> <C-J> u=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
inoremap <buffer> <silent> <C-D> u:call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"i")gi
nnoremap <buffer> <silent>  :call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"n")
nnoremap <buffer> <silent> <NL> i=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
nnoremap <buffer> \ro :LuaOutputMethod 
vnoremap <buffer> \ro :LuaOutputMethod 
nnoremap <buffer> \rd :LuaDirectRun 
vnoremap <buffer> \rd :LuaDirectRun 
nnoremap <buffer> \rse :LuaExecutable 
vnoremap <buffer> \rse :LuaExecutable 
nnoremap <buffer> \rsc :LuaCompilerExec 
vnoremap <buffer> \rsc :LuaCompilerExec 
nnoremap <buffer> <silent> \rs :call Lua_Settings(0)
vnoremap <buffer> <silent> \rs :call Lua_Settings(0)
nnoremap <buffer> <silent> \cfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment")
vnoremap <buffer> <silent> \cfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment")
nnoremap <buffer> <silent> \cfb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment, big")
vnoremap <buffer> <silent> \cfb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment, big")
nnoremap <buffer> <silent> \cfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.file description")
vnoremap <buffer> <silent> \cfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.file description")
nnoremap <buffer> <silent> \cfu :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.function description")
vnoremap <buffer> <silent> \cfu :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.function description")
nnoremap <buffer> <silent> \cb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.shebang")
vnoremap <buffer> <silent> \cb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.shebang")
nnoremap <buffer> <silent> \cke :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.keyword comments")
vnoremap <buffer> <silent> \cke :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.keyword comments")
nnoremap <buffer> <silent> \cma :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.macros")
vnoremap <buffer> <silent> \cma :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.macros")
nnoremap <buffer> <silent> \cd :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.date")
vnoremap <buffer> <silent> \cd :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.date")
nnoremap <buffer> <silent> \sfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, range")
vnoremap <buffer> <silent> \sfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, range","v")
nnoremap <buffer> <silent> \sfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, in")
vnoremap <buffer> <silent> \sfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, in","v")
nnoremap <buffer> <silent> \sw :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.while")
vnoremap <buffer> <silent> \sw :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.while","v")
nnoremap <buffer> <silent> \sr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.repeat")
vnoremap <buffer> <silent> \sr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.repeat","v")
nnoremap <buffer> <silent> \sif :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, end")
vnoremap <buffer> <silent> \sif :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, end","v")
nnoremap <buffer> <silent> \sie :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, else")
vnoremap <buffer> <silent> \sie :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, else","v")
nnoremap <buffer> <silent> \sei :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.elseif")
vnoremap <buffer> <silent> \sei :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.elseif")
nnoremap <buffer> <silent> \sel :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.else")
vnoremap <buffer> <silent> \sel :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.else")
nnoremap <buffer> <silent> \sb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.do block")
vnoremap <buffer> <silent> \sb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.do block","v")
nnoremap <buffer> <silent> \if :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.function definition")
vnoremap <buffer> <silent> \if :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.function definition","v")
nnoremap <buffer> <silent> \in :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.inline function definition")
vnoremap <buffer> <silent> \in :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.inline function definition","v")
nnoremap <buffer> <silent> \im :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.metamethod")
vnoremap <buffer> <silent> \im :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.metamethod","v")
nnoremap <buffer> <silent> \iea :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.argument error")
vnoremap <buffer> <silent> \iea :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.argument error")
nnoremap <buffer> <silent> \iet :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.type error")
vnoremap <buffer> <silent> \iet :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.type error")
nnoremap <buffer> <silent> \it :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.table constructor")
vnoremap <buffer> <silent> \it :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.table constructor","v")
nnoremap <buffer> <silent> \il :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library functions")
vnoremap <buffer> <silent> \il :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library functions")
nnoremap <buffer> <silent> \iv :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library variables")
vnoremap <buffer> <silent> \iv :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library variables")
nnoremap <buffer> <silent> \ii :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.iterators")
vnoremap <buffer> <silent> \ii :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.iterators","v")
nnoremap <buffer> <silent> \iof :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open file")
vnoremap <buffer> <silent> \iof :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open file")
nnoremap <buffer> <silent> \iot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open tmp-file")
vnoremap <buffer> <silent> \iot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open tmp-file")
nnoremap <buffer> <silent> \iop :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open pipe")
vnoremap <buffer> <silent> \iop :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open pipe")
nnoremap <buffer> <silent> \ip :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.add to path")
vnoremap <buffer> <silent> \ip :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.add to path")
nnoremap <buffer> <silent> \ot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class metatable")
vnoremap <buffer> <silent> \ot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class metatable")
nnoremap <buffer> <silent> \oc :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, constructor")
vnoremap <buffer> <silent> \oc :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, constructor","v")
nnoremap <buffer> <silent> \ois :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, is object")
vnoremap <buffer> <silent> \ois :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, is object")
nnoremap <buffer> <silent> \om :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.method")
vnoremap <buffer> <silent> \om :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.method","v")
nnoremap <buffer> <silent> \fm :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.module")
vnoremap <buffer> <silent> \fm :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.module")
nnoremap <buffer> <silent> \fs :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.script")
vnoremap <buffer> <silent> \fs :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.script")
nnoremap <buffer> <silent> \xca :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.capture")
vnoremap <buffer> <silent> \xca :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.capture","v")
nnoremap <buffer> <silent> \xco :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.collection")
vnoremap <buffer> <silent> \xco :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.collection","v")
nnoremap <buffer> <silent> \xcl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.character classes")
vnoremap <buffer> <silent> \xcl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.character classes")
nnoremap <buffer> <silent> \he :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.English")
vnoremap <buffer> <silent> \he :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.English")
nnoremap <buffer> <silent> \hl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua function, browser")
vnoremap <buffer> <silent> \hl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua function, browser")
nnoremap <buffer> <silent> \h1 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 51 function, Vim help")
vnoremap <buffer> <silent> \h1 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 51 function, Vim help")
nnoremap <buffer> <silent> \h2 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 52 function, Vim help")
vnoremap <buffer> <silent> \h2 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 52 function, Vim help")
nnoremap <buffer> <silent> \h3 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 53 function, Vim help")
vnoremap <buffer> <silent> \h3 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 53 function, Vim help")
nnoremap <buffer> <silent> \ntl :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,0)
vnoremap <buffer> <silent> \ntl :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,0)
nnoremap <buffer> <silent> \ntp :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,1)
vnoremap <buffer> <silent> \ntp :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,1)
nnoremap <buffer> <silent> \ntc :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,2)
vnoremap <buffer> <silent> \ntc :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,2)
nnoremap <buffer> <silent> \ntr :call mmtemplates#core#ReadTemplates(g:Lua_Templates,"reload","all")
vnoremap <buffer> <silent> \ntr :call mmtemplates#core#ReadTemplates(g:Lua_Templates,"reload","all")
nnoremap <buffer> <silent> \ntw :call mmtemplates#wizard#SetupWizard(g:Lua_Templates)
vnoremap <buffer> <silent> \ntw :call mmtemplates#wizard#SetupWizard(g:Lua_Templates)
nnoremap <buffer> <silent> \nts :call mmtemplates#core#ChooseStyle(g:Lua_Templates,"!pick")
vnoremap <buffer> <silent> \nts :call mmtemplates#core#ChooseStyle(g:Lua_Templates,"!pick")
nnoremap <buffer> <silent> <C-J> i=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
nnoremap <buffer> <silent> <C-D> :call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"n")
inoremap <buffer> <silent>  u:call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"i")gi
inoremap <buffer> <silent> <NL> u=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
inoremap <buffer> \ro :LuaOutputMethod 
inoremap <buffer> \rd :LuaDirectRun 
inoremap <buffer> \rse :LuaExecutable 
inoremap <buffer> \rsc :LuaCompilerExec 
inoremap <buffer> <silent> \rs :call Lua_Settings(0)
inoremap <buffer> <silent> \cfr u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment","i")
inoremap <buffer> <silent> \cfb u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment, big","i")
inoremap <buffer> <silent> \cfi u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.file description","i")
inoremap <buffer> <silent> \cfu u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.function description","i")
inoremap <buffer> <silent> \cb u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.shebang","i")
inoremap <buffer> <silent> \cke u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.keyword comments","i")
inoremap <buffer> <silent> \cma u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.macros","i")
inoremap <buffer> <silent> \cd u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.date","i")
inoremap <buffer> <silent> \sfr u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, range","i")
inoremap <buffer> <silent> \sfi u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, in","i")
inoremap <buffer> <silent> \sw u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.while","i")
inoremap <buffer> <silent> \sr u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.repeat","i")
inoremap <buffer> <silent> \sif u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, end","i")
inoremap <buffer> <silent> \sie u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, else","i")
inoremap <buffer> <silent> \sei u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.elseif","i")
inoremap <buffer> <silent> \sel u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.else","i")
inoremap <buffer> <silent> \sb u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.do block","i")
inoremap <buffer> <silent> \if u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.function definition","i")
inoremap <buffer> <silent> \in u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.inline function definition","i")
inoremap <buffer> <silent> \im u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.metamethod","i")
inoremap <buffer> <silent> \iea u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.argument error","i")
inoremap <buffer> <silent> \iet u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.type error","i")
inoremap <buffer> <silent> \it u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.table constructor","i")
inoremap <buffer> <silent> \il u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library functions","i")
inoremap <buffer> <silent> \iv u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library variables","i")
inoremap <buffer> <silent> \ii u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.iterators","i")
inoremap <buffer> <silent> \iof u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open file","i")
inoremap <buffer> <silent> \iot u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open tmp-file","i")
inoremap <buffer> <silent> \iop u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open pipe","i")
inoremap <buffer> <silent> \ip u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.add to path","i")
inoremap <buffer> <silent> \ot u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class metatable","i")
inoremap <buffer> <silent> \oc u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, constructor","i")
inoremap <buffer> <silent> \ois u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, is object","i")
inoremap <buffer> <silent> \om u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.method","i")
inoremap <buffer> <silent> \fm u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.module","i")
inoremap <buffer> <silent> \fs u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.script","i")
inoremap <buffer> <silent> \xca u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.capture","i")
inoremap <buffer> <silent> \xco u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.collection","i")
inoremap <buffer> <silent> \xcl u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.character classes","i")
inoremap <buffer> <silent> \he u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.English","i")
inoremap <buffer> <silent> \hl u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua function, browser","i")
inoremap <buffer> <silent> \h1 u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 51 function, Vim help","i")
inoremap <buffer> <silent> \h2 u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 52 function, Vim help","i")
inoremap <buffer> <silent> \h3 u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 53 function, Vim help","i")
inoremap <buffer> <silent> \ntl :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,0)
inoremap <buffer> <silent> \ntp :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,1)
inoremap <buffer> <silent> \ntc :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,2)
inoremap <buffer> <silent> \ntr :call mmtemplates#core#ReadTemplates(g:Lua_Templates,"reload","all")
inoremap <buffer> <silent> \ntw :call mmtemplates#wizard#SetupWizard(g:Lua_Templates)
inoremap <buffer> <silent> \nts :call mmtemplates#core#ChooseStyle(g:Lua_Templates,"!pick")
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal autoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=RtagsCompleteFunc
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'lua'
setlocal filetype=lua
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=tcq
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal nomodeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
setlocal nonumber
setlocal numberwidth=4
setlocal omnifunc=
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=8
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'lua'
setlocal syntax=lua
endif
setlocal tabstop=8
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 29) / 58)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 049|
tabnext
edit lib/all.lua
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
2argu
balt project.lua
let s:cpo_save=&cpo
set cpo&vim
inoremap <buffer> <silent> <C-J> u=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
inoremap <buffer> <silent> <C-D> u:call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"i")gi
nnoremap <buffer> <silent>  :call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"n")
nnoremap <buffer> <silent> <NL> i=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
nnoremap <buffer> \ro :LuaOutputMethod 
vnoremap <buffer> \ro :LuaOutputMethod 
nnoremap <buffer> \rd :LuaDirectRun 
vnoremap <buffer> \rd :LuaDirectRun 
nnoremap <buffer> \rse :LuaExecutable 
vnoremap <buffer> \rse :LuaExecutable 
nnoremap <buffer> \rsc :LuaCompilerExec 
vnoremap <buffer> \rsc :LuaCompilerExec 
nnoremap <buffer> <silent> \rs :call Lua_Settings(0)
vnoremap <buffer> <silent> \rs :call Lua_Settings(0)
nnoremap <buffer> <silent> \cfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment")
vnoremap <buffer> <silent> \cfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment")
nnoremap <buffer> <silent> \cfb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment, big")
vnoremap <buffer> <silent> \cfb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment, big")
nnoremap <buffer> <silent> \cfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.file description")
vnoremap <buffer> <silent> \cfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.file description")
nnoremap <buffer> <silent> \cfu :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.function description")
vnoremap <buffer> <silent> \cfu :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.function description")
nnoremap <buffer> <silent> \cb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.shebang")
vnoremap <buffer> <silent> \cb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.shebang")
nnoremap <buffer> <silent> \cke :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.keyword comments")
vnoremap <buffer> <silent> \cke :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.keyword comments")
nnoremap <buffer> <silent> \cma :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.macros")
vnoremap <buffer> <silent> \cma :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.macros")
nnoremap <buffer> <silent> \cd :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.date")
vnoremap <buffer> <silent> \cd :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.date")
nnoremap <buffer> <silent> \sfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, range")
vnoremap <buffer> <silent> \sfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, range","v")
nnoremap <buffer> <silent> \sfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, in")
vnoremap <buffer> <silent> \sfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, in","v")
nnoremap <buffer> <silent> \sw :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.while")
vnoremap <buffer> <silent> \sw :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.while","v")
nnoremap <buffer> <silent> \sr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.repeat")
vnoremap <buffer> <silent> \sr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.repeat","v")
nnoremap <buffer> <silent> \sif :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, end")
vnoremap <buffer> <silent> \sif :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, end","v")
nnoremap <buffer> <silent> \sie :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, else")
vnoremap <buffer> <silent> \sie :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, else","v")
nnoremap <buffer> <silent> \sei :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.elseif")
vnoremap <buffer> <silent> \sei :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.elseif")
nnoremap <buffer> <silent> \sel :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.else")
vnoremap <buffer> <silent> \sel :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.else")
nnoremap <buffer> <silent> \sb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.do block")
vnoremap <buffer> <silent> \sb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.do block","v")
nnoremap <buffer> <silent> \if :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.function definition")
vnoremap <buffer> <silent> \if :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.function definition","v")
nnoremap <buffer> <silent> \in :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.inline function definition")
vnoremap <buffer> <silent> \in :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.inline function definition","v")
nnoremap <buffer> <silent> \im :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.metamethod")
vnoremap <buffer> <silent> \im :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.metamethod","v")
nnoremap <buffer> <silent> \iea :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.argument error")
vnoremap <buffer> <silent> \iea :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.argument error")
nnoremap <buffer> <silent> \iet :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.type error")
vnoremap <buffer> <silent> \iet :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.type error")
nnoremap <buffer> <silent> \it :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.table constructor")
vnoremap <buffer> <silent> \it :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.table constructor","v")
nnoremap <buffer> <silent> \il :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library functions")
vnoremap <buffer> <silent> \il :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library functions")
nnoremap <buffer> <silent> \iv :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library variables")
vnoremap <buffer> <silent> \iv :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library variables")
nnoremap <buffer> <silent> \ii :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.iterators")
vnoremap <buffer> <silent> \ii :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.iterators","v")
nnoremap <buffer> <silent> \iof :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open file")
vnoremap <buffer> <silent> \iof :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open file")
nnoremap <buffer> <silent> \iot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open tmp-file")
vnoremap <buffer> <silent> \iot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open tmp-file")
nnoremap <buffer> <silent> \iop :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open pipe")
vnoremap <buffer> <silent> \iop :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open pipe")
nnoremap <buffer> <silent> \ip :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.add to path")
vnoremap <buffer> <silent> \ip :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.add to path")
nnoremap <buffer> <silent> \ot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class metatable")
vnoremap <buffer> <silent> \ot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class metatable")
nnoremap <buffer> <silent> \oc :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, constructor")
vnoremap <buffer> <silent> \oc :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, constructor","v")
nnoremap <buffer> <silent> \ois :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, is object")
vnoremap <buffer> <silent> \ois :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, is object")
nnoremap <buffer> <silent> \om :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.method")
vnoremap <buffer> <silent> \om :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.method","v")
nnoremap <buffer> <silent> \fm :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.module")
vnoremap <buffer> <silent> \fm :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.module")
nnoremap <buffer> <silent> \fs :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.script")
vnoremap <buffer> <silent> \fs :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.script")
nnoremap <buffer> <silent> \xca :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.capture")
vnoremap <buffer> <silent> \xca :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.capture","v")
nnoremap <buffer> <silent> \xco :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.collection")
vnoremap <buffer> <silent> \xco :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.collection","v")
nnoremap <buffer> <silent> \xcl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.character classes")
vnoremap <buffer> <silent> \xcl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.character classes")
nnoremap <buffer> <silent> \he :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.English")
vnoremap <buffer> <silent> \he :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.English")
nnoremap <buffer> <silent> \hl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua function, browser")
vnoremap <buffer> <silent> \hl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua function, browser")
nnoremap <buffer> <silent> \h1 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 51 function, Vim help")
vnoremap <buffer> <silent> \h1 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 51 function, Vim help")
nnoremap <buffer> <silent> \h2 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 52 function, Vim help")
vnoremap <buffer> <silent> \h2 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 52 function, Vim help")
nnoremap <buffer> <silent> \h3 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 53 function, Vim help")
vnoremap <buffer> <silent> \h3 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 53 function, Vim help")
nnoremap <buffer> <silent> \ntl :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,0)
vnoremap <buffer> <silent> \ntl :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,0)
nnoremap <buffer> <silent> \ntp :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,1)
vnoremap <buffer> <silent> \ntp :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,1)
nnoremap <buffer> <silent> \ntc :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,2)
vnoremap <buffer> <silent> \ntc :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,2)
nnoremap <buffer> <silent> \ntr :call mmtemplates#core#ReadTemplates(g:Lua_Templates,"reload","all")
vnoremap <buffer> <silent> \ntr :call mmtemplates#core#ReadTemplates(g:Lua_Templates,"reload","all")
nnoremap <buffer> <silent> \ntw :call mmtemplates#wizard#SetupWizard(g:Lua_Templates)
vnoremap <buffer> <silent> \ntw :call mmtemplates#wizard#SetupWizard(g:Lua_Templates)
nnoremap <buffer> <silent> \nts :call mmtemplates#core#ChooseStyle(g:Lua_Templates,"!pick")
vnoremap <buffer> <silent> \nts :call mmtemplates#core#ChooseStyle(g:Lua_Templates,"!pick")
nnoremap <buffer> <silent> <C-J> i=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
nnoremap <buffer> <silent> <C-D> :call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"n")
inoremap <buffer> <silent>  u:call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"i")gi
inoremap <buffer> <silent> <NL> u=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
inoremap <buffer> \ro :LuaOutputMethod 
inoremap <buffer> \rd :LuaDirectRun 
inoremap <buffer> \rse :LuaExecutable 
inoremap <buffer> \rsc :LuaCompilerExec 
inoremap <buffer> <silent> \rs :call Lua_Settings(0)
inoremap <buffer> <silent> \cfr u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment","i")
inoremap <buffer> <silent> \cfb u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment, big","i")
inoremap <buffer> <silent> \cfi u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.file description","i")
inoremap <buffer> <silent> \cfu u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.function description","i")
inoremap <buffer> <silent> \cb u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.shebang","i")
inoremap <buffer> <silent> \cke u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.keyword comments","i")
inoremap <buffer> <silent> \cma u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.macros","i")
inoremap <buffer> <silent> \cd u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.date","i")
inoremap <buffer> <silent> \sfr u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, range","i")
inoremap <buffer> <silent> \sfi u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, in","i")
inoremap <buffer> <silent> \sw u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.while","i")
inoremap <buffer> <silent> \sr u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.repeat","i")
inoremap <buffer> <silent> \sif u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, end","i")
inoremap <buffer> <silent> \sie u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, else","i")
inoremap <buffer> <silent> \sei u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.elseif","i")
inoremap <buffer> <silent> \sel u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.else","i")
inoremap <buffer> <silent> \sb u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.do block","i")
inoremap <buffer> <silent> \if u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.function definition","i")
inoremap <buffer> <silent> \in u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.inline function definition","i")
inoremap <buffer> <silent> \im u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.metamethod","i")
inoremap <buffer> <silent> \iea u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.argument error","i")
inoremap <buffer> <silent> \iet u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.type error","i")
inoremap <buffer> <silent> \it u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.table constructor","i")
inoremap <buffer> <silent> \il u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library functions","i")
inoremap <buffer> <silent> \iv u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library variables","i")
inoremap <buffer> <silent> \ii u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.iterators","i")
inoremap <buffer> <silent> \iof u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open file","i")
inoremap <buffer> <silent> \iot u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open tmp-file","i")
inoremap <buffer> <silent> \iop u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open pipe","i")
inoremap <buffer> <silent> \ip u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.add to path","i")
inoremap <buffer> <silent> \ot u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class metatable","i")
inoremap <buffer> <silent> \oc u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, constructor","i")
inoremap <buffer> <silent> \ois u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, is object","i")
inoremap <buffer> <silent> \om u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.method","i")
inoremap <buffer> <silent> \fm u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.module","i")
inoremap <buffer> <silent> \fs u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.script","i")
inoremap <buffer> <silent> \xca u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.capture","i")
inoremap <buffer> <silent> \xco u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.collection","i")
inoremap <buffer> <silent> \xcl u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.character classes","i")
inoremap <buffer> <silent> \he u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.English","i")
inoremap <buffer> <silent> \hl u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua function, browser","i")
inoremap <buffer> <silent> \h1 u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 51 function, Vim help","i")
inoremap <buffer> <silent> \h2 u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 52 function, Vim help","i")
inoremap <buffer> <silent> \h3 u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 53 function, Vim help","i")
inoremap <buffer> <silent> \ntl :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,0)
inoremap <buffer> <silent> \ntp :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,1)
inoremap <buffer> <silent> \ntc :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,2)
inoremap <buffer> <silent> \ntr :call mmtemplates#core#ReadTemplates(g:Lua_Templates,"reload","all")
inoremap <buffer> <silent> \ntw :call mmtemplates#wizard#SetupWizard(g:Lua_Templates)
inoremap <buffer> <silent> \nts :call mmtemplates#core#ChooseStyle(g:Lua_Templates,"!pick")
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal autoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=RtagsCompleteFunc
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'lua'
setlocal filetype=lua
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=tcq
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal nomodeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
setlocal nonumber
setlocal numberwidth=4
setlocal omnifunc=
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=8
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'lua'
setlocal syntax=lua
endif
setlocal tabstop=8
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 26 - ((25 * winheight(0) + 29) / 58)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 26
normal! 0
tabnext
edit .exrc
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
1argu
if bufexists(".exrc") | buffer .exrc | else | edit .exrc | endif
balt ~/src/5p
setlocal keymap=
setlocal noarabic
setlocal autoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=RtagsCompleteFunc
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'vim'
setlocal filetype=vim
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=tcq
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal nomodeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
setlocal nonumber
setlocal numberwidth=4
setlocal omnifunc=
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=8
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'vim'
setlocal syntax=vim
endif
setlocal tabstop=8
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 5 - ((4 * winheight(0) + 29) / 58)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 5
normal! 018|
lcd ~/src/5p
tabnext
edit ~/src/5p/lib/serpent.lua
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists("~/src/5p/lib/serpent.lua") | buffer ~/src/5p/lib/serpent.lua | else | edit ~/src/5p/lib/serpent.lua | endif
balt ~/src/5p/lib
let s:cpo_save=&cpo
set cpo&vim
inoremap <buffer> <silent> <C-J> u=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
inoremap <buffer> <silent> <C-D> u:call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"i")gi
nnoremap <buffer> <silent>  :call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"n")
nnoremap <buffer> <silent> <NL> i=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
nnoremap <buffer> \ro :LuaOutputMethod 
vnoremap <buffer> \ro :LuaOutputMethod 
nnoremap <buffer> \rd :LuaDirectRun 
vnoremap <buffer> \rd :LuaDirectRun 
nnoremap <buffer> \rse :LuaExecutable 
vnoremap <buffer> \rse :LuaExecutable 
nnoremap <buffer> \rsc :LuaCompilerExec 
vnoremap <buffer> \rsc :LuaCompilerExec 
nnoremap <buffer> <silent> \rs :call Lua_Settings(0)
vnoremap <buffer> <silent> \rs :call Lua_Settings(0)
nnoremap <buffer> <silent> \cfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment")
vnoremap <buffer> <silent> \cfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment")
nnoremap <buffer> <silent> \cfb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment, big")
vnoremap <buffer> <silent> \cfb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment, big")
nnoremap <buffer> <silent> \cfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.file description")
vnoremap <buffer> <silent> \cfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.file description")
nnoremap <buffer> <silent> \cfu :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.function description")
vnoremap <buffer> <silent> \cfu :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.function description")
nnoremap <buffer> <silent> \cb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.shebang")
vnoremap <buffer> <silent> \cb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.shebang")
nnoremap <buffer> <silent> \cke :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.keyword comments")
vnoremap <buffer> <silent> \cke :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.keyword comments")
nnoremap <buffer> <silent> \cma :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.macros")
vnoremap <buffer> <silent> \cma :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.macros")
nnoremap <buffer> <silent> \cd :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.date")
vnoremap <buffer> <silent> \cd :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.date")
nnoremap <buffer> <silent> \sfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, range")
vnoremap <buffer> <silent> \sfr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, range","v")
nnoremap <buffer> <silent> \sfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, in")
vnoremap <buffer> <silent> \sfi :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, in","v")
nnoremap <buffer> <silent> \sw :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.while")
vnoremap <buffer> <silent> \sw :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.while","v")
nnoremap <buffer> <silent> \sr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.repeat")
vnoremap <buffer> <silent> \sr :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.repeat","v")
nnoremap <buffer> <silent> \sif :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, end")
vnoremap <buffer> <silent> \sif :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, end","v")
nnoremap <buffer> <silent> \sie :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, else")
vnoremap <buffer> <silent> \sie :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, else","v")
nnoremap <buffer> <silent> \sei :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.elseif")
vnoremap <buffer> <silent> \sei :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.elseif")
nnoremap <buffer> <silent> \sel :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.else")
vnoremap <buffer> <silent> \sel :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.else")
nnoremap <buffer> <silent> \sb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.do block")
vnoremap <buffer> <silent> \sb :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.do block","v")
nnoremap <buffer> <silent> \if :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.function definition")
vnoremap <buffer> <silent> \if :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.function definition","v")
nnoremap <buffer> <silent> \in :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.inline function definition")
vnoremap <buffer> <silent> \in :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.inline function definition","v")
nnoremap <buffer> <silent> \im :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.metamethod")
vnoremap <buffer> <silent> \im :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.metamethod","v")
nnoremap <buffer> <silent> \iea :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.argument error")
vnoremap <buffer> <silent> \iea :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.argument error")
nnoremap <buffer> <silent> \iet :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.type error")
vnoremap <buffer> <silent> \iet :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.type error")
nnoremap <buffer> <silent> \it :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.table constructor")
vnoremap <buffer> <silent> \it :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.table constructor","v")
nnoremap <buffer> <silent> \il :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library functions")
vnoremap <buffer> <silent> \il :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library functions")
nnoremap <buffer> <silent> \iv :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library variables")
vnoremap <buffer> <silent> \iv :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library variables")
nnoremap <buffer> <silent> \ii :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.iterators")
vnoremap <buffer> <silent> \ii :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.iterators","v")
nnoremap <buffer> <silent> \iof :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open file")
vnoremap <buffer> <silent> \iof :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open file")
nnoremap <buffer> <silent> \iot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open tmp-file")
vnoremap <buffer> <silent> \iot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open tmp-file")
nnoremap <buffer> <silent> \iop :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open pipe")
vnoremap <buffer> <silent> \iop :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open pipe")
nnoremap <buffer> <silent> \ip :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.add to path")
vnoremap <buffer> <silent> \ip :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.add to path")
nnoremap <buffer> <silent> \ot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class metatable")
vnoremap <buffer> <silent> \ot :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class metatable")
nnoremap <buffer> <silent> \oc :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, constructor")
vnoremap <buffer> <silent> \oc :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, constructor","v")
nnoremap <buffer> <silent> \ois :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, is object")
vnoremap <buffer> <silent> \ois :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, is object")
nnoremap <buffer> <silent> \om :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.method")
vnoremap <buffer> <silent> \om :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.method","v")
nnoremap <buffer> <silent> \fm :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.module")
vnoremap <buffer> <silent> \fm :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.module")
nnoremap <buffer> <silent> \fs :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.script")
vnoremap <buffer> <silent> \fs :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.script")
nnoremap <buffer> <silent> \xca :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.capture")
vnoremap <buffer> <silent> \xca :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.capture","v")
nnoremap <buffer> <silent> \xco :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.collection")
vnoremap <buffer> <silent> \xco :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.collection","v")
nnoremap <buffer> <silent> \xcl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.character classes")
vnoremap <buffer> <silent> \xcl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.character classes")
nnoremap <buffer> <silent> \he :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.English")
vnoremap <buffer> <silent> \he :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.English")
nnoremap <buffer> <silent> \hl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua function, browser")
vnoremap <buffer> <silent> \hl :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua function, browser")
nnoremap <buffer> <silent> \h1 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 51 function, Vim help")
vnoremap <buffer> <silent> \h1 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 51 function, Vim help")
nnoremap <buffer> <silent> \h2 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 52 function, Vim help")
vnoremap <buffer> <silent> \h2 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 52 function, Vim help")
nnoremap <buffer> <silent> \h3 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 53 function, Vim help")
vnoremap <buffer> <silent> \h3 :call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 53 function, Vim help")
nnoremap <buffer> <silent> \ntl :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,0)
vnoremap <buffer> <silent> \ntl :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,0)
nnoremap <buffer> <silent> \ntp :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,1)
vnoremap <buffer> <silent> \ntp :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,1)
nnoremap <buffer> <silent> \ntc :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,2)
vnoremap <buffer> <silent> \ntc :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,2)
nnoremap <buffer> <silent> \ntr :call mmtemplates#core#ReadTemplates(g:Lua_Templates,"reload","all")
vnoremap <buffer> <silent> \ntr :call mmtemplates#core#ReadTemplates(g:Lua_Templates,"reload","all")
nnoremap <buffer> <silent> \ntw :call mmtemplates#wizard#SetupWizard(g:Lua_Templates)
vnoremap <buffer> <silent> \ntw :call mmtemplates#wizard#SetupWizard(g:Lua_Templates)
nnoremap <buffer> <silent> \nts :call mmtemplates#core#ChooseStyle(g:Lua_Templates,"!pick")
vnoremap <buffer> <silent> \nts :call mmtemplates#core#ChooseStyle(g:Lua_Templates,"!pick")
nnoremap <buffer> <silent> <C-J> i=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
nnoremap <buffer> <silent> <C-D> :call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"n")
inoremap <buffer> <silent>  u:call mmtemplates#core#DeleteOptTag('\[-\w*-]\|\[+\w*+]',',',"i")gi
inoremap <buffer> <silent> <NL> u=mmtemplates#core#JumpToTag('<-\w*->\|{-\w*-}\|\[-\w*-]\|<+\w*+>\|{+\w*+}\|\[+\w*+]')
inoremap <buffer> \ro :LuaOutputMethod 
inoremap <buffer> \rd :LuaDirectRun 
inoremap <buffer> \rse :LuaExecutable 
inoremap <buffer> \rsc :LuaCompilerExec 
inoremap <buffer> <silent> \rs :call Lua_Settings(0)
inoremap <buffer> <silent> \cfr u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment","i")
inoremap <buffer> <silent> \cfb u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.frame comment, big","i")
inoremap <buffer> <silent> \cfi u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.file description","i")
inoremap <buffer> <silent> \cfu u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.function description","i")
inoremap <buffer> <silent> \cb u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.shebang","i")
inoremap <buffer> <silent> \cke u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.keyword comments","i")
inoremap <buffer> <silent> \cma u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.macros","i")
inoremap <buffer> <silent> \cd u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Comments.date","i")
inoremap <buffer> <silent> \sfr u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, range","i")
inoremap <buffer> <silent> \sfi u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.for, in","i")
inoremap <buffer> <silent> \sw u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.while","i")
inoremap <buffer> <silent> \sr u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.repeat","i")
inoremap <buffer> <silent> \sif u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, end","i")
inoremap <buffer> <silent> \sie u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.if, else","i")
inoremap <buffer> <silent> \sei u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.elseif","i")
inoremap <buffer> <silent> \sel u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.else","i")
inoremap <buffer> <silent> \sb u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Statements.do block","i")
inoremap <buffer> <silent> \if u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.function definition","i")
inoremap <buffer> <silent> \in u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.inline function definition","i")
inoremap <buffer> <silent> \im u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.metamethod","i")
inoremap <buffer> <silent> \iea u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.argument error","i")
inoremap <buffer> <silent> \iet u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.type error","i")
inoremap <buffer> <silent> \it u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.table constructor","i")
inoremap <buffer> <silent> \il u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library functions","i")
inoremap <buffer> <silent> \iv u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.library variables","i")
inoremap <buffer> <silent> \ii u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.iterators","i")
inoremap <buffer> <silent> \iof u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open file","i")
inoremap <buffer> <silent> \iot u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open tmp-file","i")
inoremap <buffer> <silent> \iop u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.open pipe","i")
inoremap <buffer> <silent> \ip u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Idioms.add to path","i")
inoremap <buffer> <silent> \ot u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class metatable","i")
inoremap <buffer> <silent> \oc u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, constructor","i")
inoremap <buffer> <silent> \ois u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.class, is object","i")
inoremap <buffer> <silent> \om u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Objects.method","i")
inoremap <buffer> <silent> \fm u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.module","i")
inoremap <buffer> <silent> \fs u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Files.script","i")
inoremap <buffer> <silent> \xca u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.capture","i")
inoremap <buffer> <silent> \xco u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.collection","i")
inoremap <buffer> <silent> \xcl u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Regex.character classes","i")
inoremap <buffer> <silent> \he u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.English","i")
inoremap <buffer> <silent> \hl u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua function, browser","i")
inoremap <buffer> <silent> \h1 u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 51 function, Vim help","i")
inoremap <buffer> <silent> \h2 u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 52 function, Vim help","i")
inoremap <buffer> <silent> \h3 u:call mmtemplates#core#InsertTemplate(g:Lua_Templates,"Help.Lua 53 function, Vim help","i")
inoremap <buffer> <silent> \ntl :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,0)
inoremap <buffer> <silent> \ntp :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,1)
inoremap <buffer> <silent> \ntc :call mmtemplates#core#EditTemplateFiles(g:Lua_Templates,2)
inoremap <buffer> <silent> \ntr :call mmtemplates#core#ReadTemplates(g:Lua_Templates,"reload","all")
inoremap <buffer> <silent> \ntw :call mmtemplates#wizard#SetupWizard(g:Lua_Templates)
inoremap <buffer> <silent> \nts :call mmtemplates#core#ChooseStyle(g:Lua_Templates,"!pick")
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal autoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=RtagsCompleteFunc
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'lua'
setlocal filetype=lua
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=tcq
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal nomodeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
setlocal nonumber
setlocal numberwidth=4
setlocal omnifunc=
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=8
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'lua'
setlocal syntax=lua
endif
setlocal tabstop=8
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 57 - ((0 * winheight(0) + 29) / 58)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 57
normal! 07|
lcd ~/src/5p
tabnext 1
set stal=1
badd +1 ~/src/5p/project.lua
badd +1 ~/src/5p/lib/all.lua
badd +0 ~/src/5p/.exrc
badd +1 ~/src/5p/lib/serpent.lua
badd +0 ~/src/5p
badd +0 ~/src/5p/lib
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOS
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
