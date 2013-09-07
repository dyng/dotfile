" vi不兼容 {{{
set nocompatible
" }}}

" 载入插件 {{{
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'mileszs/ack.vim'
Bundle 'gvirus/auto_mkdir'
Bundle 'gvirus/bufexplorer.zip'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'vim-scripts/mru.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'thinca/vim-quickrun'
Bundle 'gvirus/CommentReader'
Bundle 'sjl/gundo.vim'
Bundle 'tsaleh/vim-matchit'
Bundle 'vim-scripts/Tagbar'
"Bundle 'fholgado/minibufexpl.vim'
Bundle 'Shougo/neocomplcache'
"Bundle 'Shougo/neosnippet'
"Bundle 'scrooloose/syntastic'
Bundle 'vim-scripts/Rename'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-easytags'
Bundle 'xolox/vim-session'
Bundle 'godlygeek/tabular'
Bundle 'Lokaltog/vim-powerline'
"Bundle 'vim-scripts/VimIM'
Bundle 'tpope/vim-fugitive'
Bundle 'gvirus/YankRing.vim'
Bundle 'mattn/zencoding-vim'
Bundle 'vim-scripts/sudo.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'SirVer/ultisnips'
" Bundle 'terryma/vim-multiple-cursors'

" 语言特定插件
Bundle 'pangloss/vim-javascript'
"Bundle 'tpope/vim-markdown'
Bundle 'me-vlad/python-syntax.vim'
Bundle 'tangledhelix/vim-octopress'

" 颜色方案
Bundle 'altercation/vim-colors-solarized'
" }}}

" 基本配置 {{{
" 编码相关 {{{
set encoding=utf-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set fileencodings=ucs-bom,utf-8,sjis,cp936,gb18030,big5,euc-jp,euc-kr,latin1
" }}}

" 缩进相关 {{{
set magic
set ruler            "标尺信息
set autoindent
set tabstop=8
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
set display=lastline "显示最多行，不用@@
" }}}

" 搜索相关 {{{
set incsearch
set ignorecase
set smartcase
nnoremap <expr> n v:searchforward ? "n" : "N"
nnoremap <expr> N v:searchforward ? "N" : "n"
" }}}

" 显示相关 {{{
set backspace=indent,eol,start
set guioptions= "无菜单、工具栏
set hlsearch
set showmatch   "显示匹配的括号
set laststatus=2

set list
set listchars=tab:>\ ,trail:-
autocmd FileType git*,help setlocal nolist

" 颜色主题
if has("gui_running")
    colorscheme solarized
else
    colorscheme torte
endif
" }}}

" 缓冲区相关 {{{
set hidden "自动隐藏缓冲区
" }}}

" 编程环境 {{{
syntax on
filetype plugin indent on
set modeline                 "因为debian基于安全原因把modeline禁用了
set completeopt=longest,menu "自动补全命令时候使用菜单式匹配列表  
set wildmenu
" }}}

" 补全快捷键 {{{
if has("gui_running")
    "补全时空格接受匹配+空格
    inoremap <Space> <C-R>=pumvisible() ? "\<lt>C-Y>\<lt>Space>" : "\<lt>Space>"<CR>
    "补全时Enter接收匹配
    inoremap <Enter> <C-R>=pumvisible() ? "\<lt>C-Y>" : "\<lt>Enter>"<CR>
    "补全时Esc结束补全
    inoremap <Esc> <C-R>=pumvisible() ? "\<lt>C-E>" : "\<lt>Esc>"<CR>
endif
" }}}

" 设置Map {{{
let mapleader = ','
" 行首行尾移动
noremap H ^
noremap L $
inoremap <Home> <C-O>g^
inoremap <End>  <c-O>g$
" 快速翻页
nnoremap <Space> <C-D>
vnoremap <Space> <C-D>
" 复制至行尾
nnoremap Y y$
" 长行移动
nnoremap <Down>      gj
nnoremap <Up>        gk
inoremap <Down> <C-R>=pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"<CR>
inoremap <Up>   <C-R>=pumvisible() ? "\<lt>Up>" : "\<lt>C-O>gk"<CR>
" 窗口间移动
nnoremap <silent> <C-H> :wincmd h<CR>
nnoremap <silent> <C-J> :wincmd j<CR>
nnoremap <silent> <C-K> :wincmd k<CR>
nnoremap <silent> <C-L> :wincmd l<CR>
" 分割窗口时跳转到旧窗口
nnoremap <silent> <C-W>s :wincmd s\|wincmd j<CR>
nnoremap <silent> <C-W>v :wincmd v\|wincmd l<CR>
" 关闭搜索高亮
nnoremap <silent> <F2>      :nohlsearch<CR>
inoremap <silent> <F2> <C-O>:nohlsearch<CR>
" 快速添加替换命令
cnoremap <Leader>s %s###cg<Left><Left><Left>
" Win风格复制粘贴
xnoremap <C-C> "+y
nnoremap <C-Q> "+p
inoremap <C-Q> <C-R>+
cnoremap <C-Q> <C-R>+
" Shell风格的命令行
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-h> <BackSpace>
" Quickfix模式
nnoremap <leader>n :cnext<CR>
nnoremap <leader>p :cprevious<CR>
nnoremap <leader>w :cwindow<CR>
" 纠正拼写错误
cab Q q
cab Qa qa
cab W w
cab Wq wq
cab Wa wa
cab X x
" }}}
"
" }}}

" 插件配置 {{{
" neocomplcache {{{
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_ignore_case = 0
let g:neocomplcache_enable_smart_case = 0
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_auto_delimiter = 1
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
function! s:MiniSuperTab()
    if pumvisible()
        return "\<C-n>"
    else
        return "\<Tab>"
    endif
endfunction
inoremap <expr><Tab> <SID>MiniSuperTab()
" 补全时空格接受匹配+空格
inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() . "<Space>" : "<Space>"
" 补全时Enter接收匹配
inoremap <expr><Enter> pumvisible() ? neocomplcache#close_popup() : "\<Enter>"
" 补全时Esc结束补全
inoremap <expr><Esc>   pumvisible() ? neocomplcache#cancel_popup() : "\<Esc>"
" }}}

" UltiSnips {{{
let g:UltiSnipsNoPythonWarning     = 1
let g:UltiSnipsExpandTrigger       = "<C-O><C-O>"
let g:UltiSnipsListSnippets        = "<C-O>"
let g:UltiSnipsJumpForwardTrigger  = "<C-J>"
let g:UltiSnipsJumpBackwardTrigger = "<C-K>"
" }}}

" Nerdtree {{{
nnoremap <silent> gn :NERDTreeFind<CR>
nnoremap <silent> gN :NERDTree<CR>
let NERDTreeShowBookmarks = 1
let NERDTreeIgnore = ['\.pyc', '\~$', '\.swo$', '\.swp$']
let NERDTreeQuitOnOpen = 1
let NERDTreeBookmarksFile = $HOME.'/.vim-infos/NERDTreeBookmarks'
" }}}

" VimIM {{{
let g:vimim_map="no-gi"
" }}}

" BufExplorer {{{
" let g:BufNumLimit = 1  # 是否自动关闭LRU Buffer. 1: 是 2: 否
" let g:MaxBufNum = 8    # 设定最大Buffer数. 默认: 8
function! s:InvokeBE()
    if v:count == 0
        exec "BufExplorer"
    else
        exec "buffer " . v:count
    endif
endfunction
nnoremap <silent><expr> <CR> &buftype != '' ? "<CR>" : ":<C-U>call <SID>InvokeBE()<CR>"
" }}}

" ctrlp {{{
nnoremap <silent> gl :CtrlP<CR>
nnoremap <silent> gL :exec 'CtrlP ' . getcwd()<CR>
nnoremap <silent> gm :CtrlPMRU<CR>
nnoremap <silent> go :CtrlPMixed<CR>
let g:ctrlp_mruf_max = 800
let g:ctrlp_mruf_case_sensitive = 0
let g:ctrlp_switch_buffer = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.neocon$\|\.git$\|\.hg$\|\.svn$',
  \ 'file': '\.exe$\|\.so$\|\.dll$\|\.sw[po]$',
  \ 'link': '',
  \ }
function! s:AutoClearCacheForNew()
    if !filereadable(expand("<afile>:p"))
        exec "CtrlPClearCache"
    endif
endfunction
function! s:AutoClearCacheForChanged()
    exec "CtrlPClearCache"
endfunction
augroup CtrlPExtension
  autocmd BufWritePre,FileWritePre * call <SID>AutoClearCacheForNew()
  autocmd FileChangedShellPost * call <SID>AutoClearCacheForChanged()
augroup END
" }}}

" yankring {{{
let g:yankring_map_dot = 0
let g:yankring_min_element_length = 2
if has('win32')
    let g:yankring_history_dir = $HOME.'\_vim-infos\'
else
    let g:yankring_history_dir = $HOME.'/.vim-infos/'
endif
nnoremap <silent> gy :YRShow<CR>
" }}}

" gundo {{{
let g:gundo_close_on_revert = 1
nnoremap <silent> <leader>u :GundoToggle<CR>
" }}}

" zen-coding {{{
" }}}

" EasyMotion {{{
let g:EasyMotion_leader_key = 'z'
" }}}

" Tabular {{{
nnoremap <silent> <leader>= :Tabularize /=<CR>
vnoremap <silent> <leader>= :Tabularize /=<CR>
nnoremap <silent> <leader>: :Tabularize /:<CR>
vnoremap <silent> <leader>: :Tabularize /:<CR>
nnoremap <silent> <leader>> :Tabularize /=><CR>
vnoremap <silent> <leader>> :Tabularize /=><CR>
" }}}

" Fugitive {{{
nnoremap <silent> gs :Gstatus<CR>
" }}}

" Vundle {{{
nnoremap <leader>v :BundleList<CR>
" }}}

" Tagbar {{{
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_autoclose = 1
let g:tagbar_sort = 0
function! s:InvokeTB()
    if bufname("%") != "__Tagbar__"
        let s:previous_bufname = bufname("%")
        exec "TagbarOpen fj"
    else
        silent let s:previous_window = bufwinnr(s:previous_bufname)
        exec s:previous_window . "wincmd w"
    endif
endfunction
nnoremap <silent> gb :call <SID>InvokeTB()<CR>
" }}}

" Session {{{
if has('win32')
    let g:session_directory = $HOME . '\_vim-infos\vim-session'
else
    let g:session_directory = $HOME . '/.vim-infos/vim-session'
endif
let g:session_autoload = 'prompt'
let g:session_autosave = 'yes'
let g:session_command_aliases = 1
let g:session_default_to_last = 1
cab sessionopen SessionOpen
cab sessionclose SessionClose
cab sessionsave SessionSave
cab sessiondelete SessionDelete
" }}}

" MRU {{{
if has('win32')
    let MRU_File = $HOME.'\_vim-infos\vim_mru_files'
else
    let MRU_File = $HOME.'/.vim-infos/vim_mru_files'
endif
let MRU_Add_Menu = 0
nnoremap <silent>gm :MRU<CR>
" }}}

" Quickrun {{{
if !exists('g:quickrun_config')
    let g:quickrun_config = {}
endif
let g:quickrun_config['c'] = {
\ 'type': 'c/gcc',
\ 'command': 'gcc',
\ 'exec': ['%c %o %s -o %s:p:r', '%s:p:r %a'],
\ 'tempfile': '%{tempname()}.c',
\ 'hook/sweep/files': '%S:p:r',
\ 'cmdopt': '-std=c99 -Wall'
\ }
" }}}

" CommentReader {{{
let g:creader_session_file = $HOME.'/.vim-infos/vim_creader_session'
nnoremap <F8> :CRtoggle<CR>
" }}}

" vim-repeat {{{
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
" }}}

" Powerline {{{
set t_Co=256
let g:Powerline_symbols = 'compatible'
" }}}

" NERDCommenter {{{
let g:NERDSpaceDelims = 1
nmap gc <Plug>NERDCommenterToggle
vmap gc <Plug>NERDCommenterToggle
nmap gC <Plug>NERDCommenterSexy
vmap gC <Plug>NERDCommenterSexy
" }}}

" python-syntax {{{
let python_highlight_builtin_objs  = 1
let python_highlight_builtin_funcs = 1
let python_highlight_exceptions    = 1
let python_print_as_function       = 1
" }}}

" easytags {{{
let g:easytags_dynamic_files = 1
let g:easytags_by_filetype = '~/.tags/'
let g:easytags_file = '~/.tags/default'
" }}}

" ack.vim {{{
let g:ackhighlight = 1
if executable('ag')
  let g:ackprg = "ag --nocolor --nogroup --column"
elseif executable('ack-grep')
  let g:ackprg = "ack-grep --nocolor --nogroup --column"
elseif executable('ack')
  let g:ackprg = "ack --nocolor --nogroup --column"
endif
cab ack Ack
" }}}

" }}}

" vim: set foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
