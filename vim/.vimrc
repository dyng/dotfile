"vi不兼容
set nocompatible

""""""""""""""""""""""""""""""""""""""""
" 载入插件
""""""""""""""""""""""""""""""""""""""""
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

Bundle 'mileszs/ack.vim'
Bundle 'G-virus/auto_mkdir'
Bundle 'G-virus/AutoTag'
Bundle 'G-virus/bufexplorer.zip'
Bundle 'wincent/Command-T'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'sjl/gundo.vim'
Bundle 'tsaleh/vim-matchit'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'mru.vim'
Bundle 'Shougo/neocomplcache'
Bundle 'rename.vim'
"Bundle 'garbas/vim-snipmate'
"Bundle 'tsaleh/vim-supertab'
Bundle 'tpope/vim-surround'
Bundle 'godlygeek/tabular'
Bundle 'taglist.vim'
Bundle 'Lokaltog/vim-powerline'
Bundle 'VimIM'
Bundle 'G-virus/YankRing.vim'
Bundle 'mattn/zencoding-vim'

""""""""""""""""""""""""""""""""""""""""
" 基本配置
""""""""""""""""""""""""""""""""""""""""

"编码相关
set encoding=utf-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set fileencodings=ucs-bom,utf-8,sjis,cp936,gb18030,big5,euc-jp,euc-kr,latin1

"缩进相关
set magic
set ruler            "标尺信息
set autoindent
set tabstop=8
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
set display=lastline "显示最多行，不用@@

"搜索相关
set incsearch
set ignorecase
set smartcase

"显示相关
set backspace=indent,eol,start
set guioptions= "无菜单、工具栏
set hlsearch
set showmatch   "显示匹配的括号
if has("gui_running")
    colorscheme molokai
else
    colorscheme torte
endif

"缓冲区相关
set hidden "自动隐藏缓冲区

"编程环境
syntax on
filetype plugin indent on
set modeline                 "因为debian基于安全原因把modeline禁用了
set completeopt=longest,menu "自动补全命令时候使用菜单式匹配列表  
set wildmenu

"补全快捷键
if has("gui_running")
    "补全时空格接受匹配+空格
    inoremap <Space> <C-R>=pumvisible() ? "\<lt>C-Y>\<lt>Space>" : "\<lt>Space>"<CR>
    "补全时Enter接收匹配
    inoremap <Enter> <C-R>=pumvisible() ? "\<lt>C-Y>" : "\<lt>Enter>"<CR>
    "补全时Esc结束补全
    inoremap <Esc> <C-R>=pumvisible() ? "\<lt>C-E>" : "\<lt>Esc>"<CR>
endif

"设置mapleader
let mapleader = ','

"行首行尾移动
noremap H ^
noremap L $
inoremap <Home> <C-O>g^
inoremap <End>  <c-O>g$
"快速翻页
nnoremap <Space> <C-D>
"复制至行尾
nnoremap Y y$
"长行移动
nnoremap <Down>      gj
nnoremap <Up>        gk
inoremap <Down> <C-R>=pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"<CR>
inoremap <Up>   <C-R>=pumvisible() ? "\<lt>Up>" : "\<lt>C-O>gk"<CR>
"窗口间移动
nnoremap <silent> <C-H> :wincmd h<CR>
nnoremap <silent> <C-J> :wincmd j<CR>
nnoremap <silent> <C-K> :wincmd k<CR>
nnoremap <silent> <C-L> :wincmd l<CR>
"分割窗口时跳转到旧窗口
nnoremap <silent> <C-W>s :wincmd s\|wincmd j<CR>
nnoremap <silent> <C-W>v :wincmd v\|wincmd l<CR>
"关闭搜索高亮
nmap <silent> <F2>      :nohlsearch<CR>
imap <silent> <F2> <C-O>:nohlsearch<CR>
"快速添加替换命令
cmap <Leader>s %s###cg<Left><Left><Left>
"Win风格复制粘贴
xmap <C-C> "+y
nmap <C-Q> "+p
imap <C-Q> <C-R>+
cmap <C-Q> <C-R>+
"Shell风格的命令行
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-h> <BackSpace>
"Quickfix模式
nnoremap <leader>c :cnext<CR>
nnoremap <leader>z :cprevious<CR>
nnoremap <leader>x :cwindow<CR>
"纠正拼写错误
cab Q q
cab Qa qa
cab W w
cab Wq wq
cab Wa wa

""""""""""""""""""""""""""""""""""""""""
" 插件配置
""""""""""""""""""""""""""""""""""""""""

"neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_ignore_case = 0
let g:neocomplcache_enable_smart_case = 0
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

function! s:MiniSuperTab()
    if pumvisible()
        return "\<C-n>"
    elseif neocomplcache#sources#snippets_complete#expandable()
        return "\<Plug>(neocomplcache_snippets_expand)"
    else
        return "\<Tab>"
    endif
endfunction
imap <expr><tab> <SID>MiniSuperTab()

"SuperTab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabMappingForward = '<s-tab>'
let g:SuperTabMappingBackward = '<tab>'

"VimIM
let g:vimim_map="no-gi"

"Taglist
let Tlist_Exit_OnlyWindow = 1
let Tlist_Show_One_File = 1

let s:previous_window = 1
function! InvokeTL()
    if bufname("%") != "__Tag_List__"
        let s:previous_window = winnr()
        exec "TlistOpen"
    else
        exec s:previous_window . "wincmd w"
    endif
endfunction
nnoremap <silent>gl :call InvokeTL()<CR>

"MRU
if has('win32')
    let MRU_File = $VIM.'\vimfiles\bundle\mru.vim\_vim_mru_files'
else
    let MRU_File = $HOME.'/.vim/bundle/mru.vim/.vim_mru_files'
endif
let MRU_Add_Menu = 0
nnoremap <silent>gm :MRU<CR>

"BufExplorer
function! InvokeBE()
    if v:count == 0
        exec "BufExplorer"
    else
        exec "buffer " . v:count
    endif
endfunction
nnoremap <silent><expr> <CR> &buftype != '' ? "<CR>" : ":<C-U>call InvokeBE()<CR>"

"minibufexplorer

"Command-T
nnoremap <silent> gc :CommandT<CR>
nnoremap <silent> gC :exec 'CommandT ' . @c<CR>
augroup CommandTExtension
  autocmd!
  autocmd FocusGained * CommandTFlush
  autocmd BufWritePost * CommandTFlush
augroup END

"yankring
let g:yankring_min_element_length = 2
if has('win32')
    let g:yankring_history_dir = $VIM.'\vimfiles\bundle\YankRing.vim'
else
    let g:yankring_history_dir = $HOME.'/.vim/bundle/YankRing.vim'
endif
nnoremap <silent> gy :YRShow<CR>

"gundo
let g:gundo_right = 1
let g:gundo_close_on_revert = 1
nnoremap <silent> gG :GundoToggle<CR>

"zen-coding
let g:user_zen_leader_key = '<C-Z>'

"EasyMotion
let g:EasyMotion_leader_key = 'z'

"Tabular
nnoremap <silent> <leader>= :Tabularize /=<CR>
vnoremap <silent> <leader>= :Tabularize /=<CR>
nnoremap <silent> <leader>: :Tabularize /:<CR>
vnoremap <silent> <leader>: :Tabularize /:<CR>
nnoremap <silent> <leader>> :Tabularize /=><CR>
vnoremap <silent> <leader>> :Tabularize /=><CR>

" AutoTag
let g:autotagStopAt = $HOME.'/Project/\w+' "Python Regex