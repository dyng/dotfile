" Provider {{{
" python
let g:python3_host_prog = 'python3'
" }}}

" Load Plugins {{{
let s:vimplug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(s:vimplug_path)
    let s:first_init = 1
endif

" Install vim-plug
if exists('s:first_init')
    echom 'Plugin manager: vim-plug has not been installed. Try to install...'
    exec '!curl -fL --create-dirs -o ' . s:vimplug_path .
            \ ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    exec 'source ' . fnameescape(s:vimplug_path)
    echom 'Installing vim-plug complete.'
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'nvim-lua/plenary.nvim'
Plug 'williamboman/mason.nvim'
    \| Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
    \| Plug 'hrsh7th/cmp-buffer'
    \| Plug 'hrsh7th/cmp-path'
    \| Plug 'hrsh7th/cmp-cmdline'
    \| Plug 'hrsh7th/nvim-cmp'
    \| Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/vim-vsnip'
    \| Plug 'hrsh7th/cmp-vsnip'
    \| Plug 'hrsh7th/vim-vsnip-integ'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
    \| Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    \| Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'rafamadriz/friendly-snippets'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kevinhwang91/nvim-bqf'
Plug 'mfussenegger/nvim-dap'
    \| Plug 'rcarriga/nvim-dap-ui'
    \| Plug 'mxsdev/nvim-dap-vscode-js'
    \| Plug 'leoluz/nvim-dap-go'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'RRethy/vim-illuminate'
Plug 'andymass/vim-matchup'
Plug 'dylnmc/synstack.vim'
Plug 'vim-test/vim-test'
Plug 'dyng/vim-bookmarks'
    \| Plug 'tom-anders/telescope-vim-bookmarks.nvim'
Plug 'skywind3000/vim-terminal-help'
Plug 'mhinz/vim-signify'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-dispatch'
Plug 'Shatur/neovim-session-manager'
Plug 'stevearc/dressing.nvim'
Plug 'gbprod/yanky.nvim'
Plug 'dyng/vim-auto-save'
Plug 'NvChad/nvim-colorizer.lua'

Plug 'dyng/auto_mkdir'
Plug 'easymotion/vim-easymotion'
Plug 'thinca/vim-quickrun'
Plug 'mbbill/undotree'
Plug 'machakann/vim-sandwich'
Plug 'junegunn/vim-easy-align'
Plug '~/Dropbox/Projects/CtrlSF'
Plug '~/Dropbox/Projects/formatiu.vim'
Plug 'tpope/vim-fugitive'
Plug 'mg979/vim-visual-multi'
Plug 'inkarkat/vim-mark' | Plug 'inkarkat/vim-ingo-library'
Plug 'tpope/vim-rsi'
Plug 'AndrewRadev/linediff.vim'
Plug 'vim-scripts/ReloadScript'
Plug 'Raimondi/delimitMate'
Plug 'tomtom/tcomment_vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': 'markdown' }

" Language Specific Plugins
Plug '~/Dropbox/Projects/dejava.vim'
Plug 'nathangrigg/vim-beancount'

" Colorschemes
Plug 'tomasr/molokai'
Plug 'marko-cerovac/material.nvim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'navarasu/onedark.nvim'

" Documents
Plug 'yianwillis/vimcdoc'

call plug#end()

" Install all plugins
if exists("s:first_init")
    PlugInstall
endif
" }}}

" Basic Config {{{
" Encoding & Language {{{
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,sjis,cp936,gb18030,big5,euc-jp,euc-kr,latin1
language en_US.UTF-8
" }}}

" Spelling Check {{{
" default setting
set nospell

function! s:SetSpellingCheck(lang)
    setl spell
    exec "setl spelllang=" . a:lang
endfunction

augroup spelling
    autocmd!
    autocmd FileType text,markdown call s:SetSpellingCheck("en_us")
augroup END
" }}}

" Indentation {{{
set magic
set ruler
set autoindent
set shiftwidth=4
set tabstop=8
set smarttab
set expandtab
set display=lastline
" }}}

" Search {{{
set incsearch
set ignorecase
set smartcase
" }}}

" UI {{{
set backspace=indent,eol,start
set guioptions=
set hlsearch
set showmatch
set laststatus=2

set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
autocmd FileType git*,help setlocal nolist

" Colorscheme
set t_Co=256
set background=dark

let g:onedark_config = { 'style': 'darker' }
colorscheme onedark

" Font
if has('gui_macvim')
    set guifont=Inconsolata\ Nerd\ Font\ Mono:h16
elseif has("gui_vimr") || exists('g:neovide') || exists('g:gonvim_running')
    set guifont=BlexMono\ Nerd\ Font\ Mono:h14
else
    set guifont=Hack:h14
endif

" signs
lua << EOF
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
EOF

" macvim {{{
if has('gui_macvim')
    " use option key as meta key in MacVim
    set macmeta
endif
" }}}

" neovide {{{
if exists("g:neovide")
    let g:neovide_input_macos_alt_is_meta = v:true
    let g:neovide_cursor_animation_length = 0
endif
" }}}

" goneovim {{{
if exists('g:gonvim_running')
    GuiMacmeta 1
endif
" }}}
" }}}

" Buffer {{{
set hidden
" }}}

" Syntax {{{
syntax on
filetype plugin indent on
set modeline                 "modeline is by default disabled on Debian
set completeopt=longest,menu,menuone
set wildmenu
" }}}

" Maps {{{
let mapleader = ","

" Move line start and end
noremap H ^
noremap L $
inoremap <Home> <C-O>g^
inoremap <End>  <C-O>g$
" Quick paging
nnoremap <Space> <C-D>
vnoremap <Space> <C-D>
" Copy to line end
nnoremap Y y$
" Cursor move
nnoremap <Down> gj
nnoremap <Up>   gk
inoremap <Down> <C-O>gj
inoremap <Up>   <C-O>gk

" quickfix
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <silent> Q :call ToggleQuickFix()<cr>
autocmd FileType qf nnoremap <buffer><silent> q :quit<cr>

" Tab navigation
nnoremap <silent> <C-Tab> :tabnext<CR>

" Window switch
nnoremap <silent> <C-H> :wincmd h<CR>
nnoremap <silent> <C-J> :wincmd j<CR>
nnoremap <silent> <C-K> :wincmd k<CR>
nnoremap <silent> <C-L> :wincmd l<CR>
" Switching in terminal
tnoremap <silent> <A-h> <C-\><C-N><C-w>h
tnoremap <silent> <A-j> <C-\><C-N><C-w>j
tnoremap <silent> <A-k> <C-\><C-N><C-w>k
tnoremap <silent> <A-l> <C-\><C-N><C-w>l
inoremap <silent> <A-h> <C-\><C-N><C-w>h
inoremap <silent> <A-j> <C-\><C-N><C-w>j
inoremap <silent> <A-k> <C-\><C-N><C-w>k
inoremap <silent> <A-l> <C-\><C-N><C-w>l
nnoremap <silent> <A-h> <C-w>h
nnoremap <silent> <A-j> <C-w>j
nnoremap <silent> <A-k> <C-w>k
nnoremap <silent> <A-l> <C-w>l
" Focus new splited window
nnoremap <silent> <C-W>s :wincmd s\|wincmd j<CR>
nnoremap <silent> <C-W>v :wincmd v\|wincmd l<CR>

" Window resize
nnoremap <silent> <C-Up> <cmd>call <SID>ResponsiveResize('up')<cr>
nnoremap <silent> <C-Down> <cmd>call <SID>ResponsiveResize('down')<cr>
nnoremap <silent> <C-Left> <cmd>call <SID>ResponsiveResize('left')<cr>
nnoremap <silent> <C-Right> <cmd>call <SID>ResponsiveResize('right')<cr>

function s:ResponsiveResize(key) abort
    let [leftmost, topmost, rightmost, bottommost] = s:WinRelpos(winnr())
    if a:key == 'up' || a:key == 'down'
        " assume window is topmost unless bottommost
        if bottommost
            if a:key == 'up'
                resize +3
            else
                resize -3
            endif
        else
            if a:key == 'up'
                resize -3
            else
                resize +3
            endif
        endif
    else
        " assume window is leftmost unless rightmost
        if rightmost
            if a:key == 'left'
                vertical resize +3
            else
                vertical resize -3
            endif
        else
            if a:key == 'left'
                vertical resize -3
            else
                vertical resize +3
            endif
        endif
    endif
endfunction

function! s:WinRelpos(winnr) abort
    let height = &lines
    let width = &columns

    let [row, col] = win_screenpos(a:winnr)
    let win_width = winwidth(a:winnr)
    let win_height = winheight(a:winnr)

    let leftmost = (col <= 1)
    let topmost = (row <= 1)
    let rightmost = (col + win_width + 1 >= width)
    let bottommost = (row + win_height + 1 >= height)

    return [leftmost, topmost, rightmost, bottommost]
endfunction

" Nohlsearch
nnoremap <silent> <F2>      :nohlsearch<CR>
inoremap <silent> <F2> <C-O>:nohlsearch<CR>
" n always look forward && N always look backward
nnoremap <expr> n v:searchforward ? "n" : "N"
nnoremap <expr> N v:searchforward ? "N" : "n"

" Shift lines leftwards or rightwards
vnoremap <expr> > v:count ? ">" : ">gv"
vnoremap <expr> < v:count ? "<" : "<gv"

" copy&paste keys
" mac
vnoremap <D-c> "+y
nnoremap <D-v> "+p
inoremap <D-v> <C-R>+
cnoremap <D-v> <C-R>+
tnoremap <D-v> <C-\><C-N>"+pI
" windows
vnoremap <C-C> "+y
nnoremap <C-Q> "+p
inoremap <C-Q> <C-R>+
cnoremap <C-Q> <C-R>+
" Copy filename
nnoremap <silent> yf :let @+ = expand('%')<CR>
nnoremap <silent> yF :let @+ = expand('%:p')<CR>
" Run current line
nnoremap <silent> yr :exec getline('.') \| echo 'executed!'<CR>
vnoremap <silent> R :source \| echo 'executed!'<CR>
" Shell-style shortcut in command mode
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-h> <BackSpace>

" Auto unfolding
nnoremap n nzv
nnoremap N Nzv

" Correct spell
cab Q q
cab Qa qa
cab W w
cab Wq wq
cab Wa wa
cab X x
" }}}

" Misc {{{
" increase updatetime
set updatetime=100

" disable beeping
set vb t_vb=

" ignore python3 warning
silent! py3 pass

" add keyword '-'
augroup filetyeSpecKeyword
    au!
    au FileType help setl iskeyword+=-
    au FileType vim setl iskeyword+=# iskeyword+=:
augroup END

" persistent undo
if has("persistent_undo")
    exec "set undodir='" . stdpath('data') . "/undodir'"
endif

" language of help doc
set helplang=cn
" }}}
" }}}

" Custom Functions {{{
" VisualSelection {{{
function! VisualSelection()
    if mode()=="v"
        let [line_start, column_start] = getpos("v")[1:2]
        let [line_end, column_end] = getpos(".")[1:2]
    else
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
    end
    if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
        let [line_start, column_start, line_end, column_end] =
        \   [line_end, column_end, line_start, column_start]
    end
    let lines = getline(line_start, line_end)
    if len(lines) == 0
            return ''
    endif
    let lines[-1] = lines[-1][: column_end - 1]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
" }}}

" ProjectRoot {{{
let s:rootmarkers = ['.git', '.svn', '.hg', '.project', '.root']

function ProjectRoot() abort
    let name = expand('%:p')
    return s:find_root(name, s:rootmarkers, 0)
endfunction

function s:find_root(name, markers, strict) abort
    let name = fnamemodify((a:name != '')? a:name : bufname('%'), ':p')
    let finding = ''
    " iterate all markers
    for marker in a:markers
        if marker != ''
            " search as a file
            let x = findfile(marker, name . '/;')
            let x = (x == '')? '' : fnamemodify(x, ':p:h')
            " search as a directory
            let y = finddir(marker, name . '/;')
            let y = (y == '')? '' : fnamemodify(y, ':p:h:h')
            " which one is the nearest directory ?
            let z = (strchars(x) > strchars(y))? x : y
            " keep the nearest one in finding
            let finding = (strchars(z) > strchars(finding))? z : finding
        endif
    endfor
    if finding == ''
        let path = (a:strict == 0)? fnamemodify(name, ':h') : ''
    else
        let path = fnamemodify(finding, ':p')
    endif
    if has('win32') || has('win16') || has('win64') || has('win95')
        let path = substitute(path, '\/', '\', 'g')
    endif
    if path =~ '[\/\\]$'
        let path = fnamemodify(path, ':h')
    endif
    return path
endfunction
" }}}

" EscapeFilename {{{
function EscapeFilename(fname) abort
    return substitute(substitute(a:fname, "[\\/]", "%2F", "g"), " ", "%20", "g")
endfunction
" }}}
" }}}

" Custom FileType Config {{{
" golang
autocmd FileType go setlocal tabstop=4 shiftwidth=4 nolist noexpandtab

" lua
autocmd FileType lua setlocal shiftwidth=2
"}}}

" Inline Plugins {{{
" LastInsert {{{
nnoremap <silent> <C-'> <cmd>call <SID>LastInsertJump()<cr>
augroup lastinsert
    autocmd!
    autocmd InsertLeave * call s:LastInsertSave()
augroup END

let s:LI_PosHist = []
let s:LI_Idx = 0

function s:LastInsertSave() abort
    let pos = getpos('.')
    let pos[0] = bufnr()
    call insert(s:LI_PosHist, pos)
    if len(s:LI_PosHist) > 3
        call remove(s:LI_PosHist, -1)
    endif
endfunction

function s:LastInsertJump() abort
    if len(s:LI_PosHist) == 0
        return
    endif
    let pos = s:LI_PosHist[s:LI_Idx]
    exec 'buffer ' . pos[0]
    call setpos('.', pos)
    let s:LI_Idx = (s:LI_Idx + 1) % len(s:LI_PosHist)
endfunction
" }}}
" }}}

" Plugin Configs {{{
" vim-vsnip {{{
imap <expr> <C-o> vsnip#expandable() ? '<Plug>(vsnip-expand)'    : '<C-o>'
smap <expr> <C-o> vsnip#expandable() ? '<Plug>(vsnip-expand)'    : '<C-o>'
imap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
smap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
imap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
smap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
" }}}

" nvim-tree {{{
nnoremap <silent> gn :NvimTreeFindFile<cr>
nnoremap <silent> gN :NvimTreeOpen .<cr>
lua << EOF
require("nvim-tree").setup{
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "<cr>", action = "edit_no_picker" },
                { key = "U", action = "dir_up" },
            },
        },
    },
    update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = {},
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
        change_dir = {
          enable = false,
        },
    },
    git = {
        enable = true
    },
}
EOF
" }}}

" Telescope {{{
lua << EOF
require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = require('telescope.actions').close,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = false,
            case_mode = "smart_case"
        },
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    },
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('fzy_native')
EOF
nnoremap <silent><C-P> <cmd>lua require("telescope.builtin").find_files({ cwd = vim.fn.ProjectRoot() })<cr>
nnoremap <silent>gm <cmd>lua require("telescope.builtin").oldfiles()<cr>
nnoremap <silent>gb <cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>
nnoremap <silent>gB <cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<cr>
" nnoremap <silent>gB <cmd>lua vim.ui.input({ prompt = 'Query Name' },
"             \ function(q) require("telescope.builtin").lsp_workspace_symbols({ query = q }) end)<cr>
" }}}

" undotree {{{
let g:undotree_SetFocusWhenToggle = 1
nnoremap <silent> <leader>u :UndotreeToggle<CR>
" }}}

" EasyMotion {{{
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj'
let g:EasyMotion_smartcase = 1

nmap f <Plug>(easymotion-s2)
let easymotion_key_map = {
    \ 'zj': '<Plug>(easymotion-j)',
    \ 'zk': '<Plug>(easymotion-k)',
    \ 'zw': '<Plug>(easymotion-w)',
    \ 'zb': '<Plug>(easymotion-b)',
    \ 'zW': '<Plug>(easymotion-W)',
    \ 'zB': '<Plug>(easymotion-B)',
    \ 'ze': '<Plug>(easymotion-e)',
    \ 'zE': '<Plug>(easymotion-E)'
    \ }
for key in keys(easymotion_key_map)
    exec "nmap " . key . " " . easymotion_key_map[key]
    exec "vmap " . key . " " . easymotion_key_map[key]
    exec "omap " . key . " " . easymotion_key_map[key]
endfo
" }}}

" Fugitive {{{
nnoremap <silent> gs  :Git status<CR>
nnoremap <silent> gsb :Git blame<CR>
autocmd FileType fugitiveblame nmap <buffer> q gq
" }}}

" Quickrun {{{
nmap <leader>r <Plug>(quickrun)
" }}}

" CtrlSF {{{
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
nnoremap <silent> <C-F>o :CtrlSFOpen<CR>
nnoremap <silent> <C-F>j :CtrlSFFocus<CR>
let g:ctrlsf_default_view_mode = 'normal'
let g:ctrlsf_compact_position = 'bottom_outside'
let g:ctrlsf_fold_result = 0
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_populate_qflist = 1
let g:ctrlsf_default_root = 'project'
let g:ctrlsf_toggle_map_key = '\t'
let g:ctrlsf_auto_preview = 1
let g:ctrlsf_extra_backend_args = {
    \ 'pt': '--global-gitignore'
    \ }
let g:ctrlsf_auto_focus = {
    \ 'at': 'start'
    \ }
let g:ctrlsf_extra_root_markers = ['.root']

" ignore trailing space
let g:extra_whitespace_ignored_filetypes = ['ctrlsf']

hi ctrlsfFilename guifg=#ffffff guibg=NONE guisp=NONE gui=bold ctermfg=30 ctermbg=NONE cterm=bold
" }}}

" vim-visual-multi {{{
let g:VM_leader = 'M'
let g:VM_maps = {
    \ 'Skip Region': 'x',
    \ 'Add Cursor Up': 'Mk',
    \ 'Add Cursor Down': 'Mj'
    \}
" }}}

" mark {{{
let g:mw_no_mappings = 1
nmap <silent> mm <Plug>MarkSet
vmap <silent> mm <Plug>MarkSet
nmap <silent> mc <Plug>MarkClear
nmap <silent> mn <Plug>MarkSearchAnyNext
nmap <silent> mN <Plug>MarkSearchAnyPrev
" }}}

" linediff {{{
let g:linediff_buffer_type = 'scratch'
vnoremap zd :Linediff<CR>
autocmd User LinediffBufferReady nnoremap <buffer> q :LinediffReset<CR>
" }}}

" delimitMate {{{
let g:delimitMate_expand_cr = 1

" Maps to overwrite custom maps for completion
imap <silent><expr> <Space> pumvisible() ? "\<C-Y>\<Space>" : "<Plug>delimitMateSpace"
imap <silent><expr> <CR>    pumvisible() ? "\<C-Y>\<CR>"    : "<Plug>delimitMateCR"
imap <silent><expr> <BS>    pumvisible() ? "\<BS>"          : "<Plug>delimitMateBS"

" language specific configuration
au FileType clojure let b:delimitMate_quotes = '"'
" }}}

" tComment {{{
let g:tcomment_maps = 0
nnoremap <silent> ec :TComment<CR>
vnoremap <silent> ec :TComment<CR>
" }}}

" csv.vim {{{
let g:no_csv_maps = 1
" }}}

" {{{ vim-easy-align
xmap eg <Plug>(EasyAlign)*
nmap eg <Plug>(EasyAlign)*
" }}}

" {{{ vim-sandwich
runtime macros/sandwich/keymap/surround.vim
" }}}

" {{{ vim-terminal-helper
let g:terminal_key = "<A-/>"
let g:terminal_kill = 1
let g:terminal_close = 1
let g:terminal_pos = "botright"
let g:terminal_height = 20
let g:terminal_cwd = 2
" }}}

" {{{ lsp-config & mason
lua <<EOF
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gr', function() vim.lsp.buf.references { includeDeclaration = false } end, bufopts)
  vim.keymap.set('n', 'ge', vim.diagnostic.setloclist, bufopts)
  vim.keymap.set('n', 'gE', vim.diagnostic.setqflist, bufopts)
  vim.keymap.set('n', 'E', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', 'ea', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set({'n', 'v'}, 'ef', function() vim.lsp.buf.format { async = true } end, bufopts)
  vim.keymap.set('n', 'ern', vim.lsp.buf.rename, bufopts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
    function (server_name)
        require("lspconfig")[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end
})
EOF
" }}}

" nvim-cmp {{{
lua << EOF
-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    matching = {
        disallow_fuzzy_matching = false,
    },
    mapping = {
      ['<TAB>'] = cmp.mapping.select_next_item(),
      ['<Down>'] = cmp.mapping.select_next_item(),
      ['<S-TAB>'] = cmp.mapping.select_prev_item(),
      ['<Up>'] = cmp.mapping.select_prev_item(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ['<C-c>'] = cmp.mapping.abort(),
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!', '%', 'write', 'wall', 'quit', 'qall', 'xit' }
      }
    },
  })
})
EOF
" }}}

" lualine {{{
lua <<EOF
require('lualine').setup({
  sections = {
    lualine_b = {'diff', 'diagnostics'}
  },
})
EOF
" }}}

" nvim-bqf {{{
lua << EOF
require('bqf').setup({
    auto_enable = true,
    func_map = {
        open = 'o',
        openc = '<cr>',
        prevhist = '<c-h>',
        nexthist = '<c-l>',
        pscrollup = '<c-u>',
        pscrolldown = '<c-d>',
    },
    preview = {
        win_height = 999
    },
})
EOF
" }}}

" nvim-treesitter {{{
lua << EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = { "c", "lua", "vim", "go", "javascript", "typescript", "rust", "python" },
  sync_install = false,
  highlight = {
    enable = true,
  }
})
EOF
" }}}

" nvim-dap & relates {{{
" nvim-dap {{{{
lua <<EOF
function set_dap_keymap(mode, key, fn)
    local if_dap_running = function(fn, key)
        -- remap
        local rhs = vim.fn.maparg(key, 'n')
        if rhs ~= '' and not rhs:find('^<') then
            key = rhs
        end
        -- escape special characters
        if key:find('^<') then
            key = "\\"..key
        end
        return function()
            local session = require('dap').session()
            if session and session.filetype == vim.bo.filetype
            then
                fn()
            else
                vim.cmd('execute "normal! '..key..'"')
            end
        end
    end
    local opts = { noremap=true, silent=true }
    vim.keymap.set(mode, key, if_dap_running(fn, key), opts)
end

-- set mapping
vim.keymap.set('n', 'guu', require'dap'.run_last, { silent=true })
vim.keymap.set('n', 'guj', require'dap'.continue, { silent=true })
vim.keymap.set('n', 'B', require'dap'.toggle_breakpoint, { silent=true })
set_dap_keymap('n', '<down>', require'dap'.step_over)
set_dap_keymap('n', '<right>', require'dap'.step_into)
set_dap_keymap('n', '<left>', require'dap'.step_out)
set_dap_keymap('n', 'J', require'dap'.continue)
set_dap_keymap('n', 'R', require'dap'.run_to_cursor)
set_dap_keymap('n', 'T', require'dap'.terminate)
EOF

" commands
command! DapListBreakpoints lua require'dap'.list_breakpoints();vim.cmd('copen')
command! DapClearBreakpoints lua require'dap'.clear_breakpoints()

" sign & highlighting
hi! NvimDapBreakpoint ctermfg=204 guifg=#e06c75
hi! NvimDapBreakpointRejected ctermfg=59 guifg=#5c6370
hi! NvimDapStopped ctermfg=118 guifg=#7ac836
call sign_define('DapBreakpoint', {'text': '●', 'texthl': 'NvimDapBreakpoint'})
call sign_define('DapBreakpointRejected', {'text': '●', 'texthl': 'NvimDapBreakpointRejected'})
call sign_define('DapBreakpointCondition', {'text': '◐', 'texthl': 'NvimDapBreakpoint'})
call sign_define('DapStopped', {'text': '⮕', 'texthl': 'NvimDapStopped'})
" }}}}

" nvim-dap-ui {{{{
nnoremap <M-r> <Cmd>lua require("dapui").float_element("repl")<CR>
nnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>
vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>
lua << EOF
local dap, dapui = require("dap"), require("dapui")
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    expand = "<CR>",
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      position = "left",
      size = 40,
      elements = {
        { id = "stacks", size = 0.4 },
        { id = "scopes", size = 0.3 },
        { id = "watches", size = 0.3 },
      },
    },
    {
      position = "bottom",
      size = 0.25,
      elements = {
        { id = "breakpoints", size = 0.3 },
        { id = "repl", size = 0.7 },
      },
    },
  },
  floating = {
    mappings = {
      close = { "q", "<Esc>" }
    }
  },
  controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  },
})
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
EOF
" }}}}

" dap-vscode-js {{{{
lua << EOF
require("dap-vscode-js").setup({
  debugger_cmd = { "js-debug-adapter" },
  adapters = { 'pwa-node' },
})

for _, language in ipairs({ "typescript", "javascript" }) do
  require("dap").configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require'dap.utils'.pick_process,
        cwd = "${workspaceFolder}",
      }
    }
  end
EOF
" }}}}

" dap-go {{{{
nnoremap <silent> gut <Cmd>lua require('dap-go').debug_test()<CR>
lua << EOF
require('dap-go').setup()
EOF
" }}}}
" }}}

" null-ls {{{
lua << EOF
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.golangci_lint,
    },
})
EOF
" }}}

" vim-illuminate {{{
augroup illuminate_augroup
    autocmd!
    autocmd VimEnter * hi! link IlluminatedWordText Underlined
    autocmd VimEnter * hi! link IlluminatedWordRead Underlined
    autocmd VimEnter * hi! link IlluminatedWordWrite Underlined
augroup END
lua <<EOF
require('illuminate').configure({
    large_file_cutoff = 3000,
    large_file_overrides = {
        providers = {
            'lsp',
            'treesitter',
        },
    },
})
EOF
" }}}

" vim-matchup {{{
let g:matchup_matchparen_offscreen = { 'method': 'popup' }
" }}}

" vim-test {{{
nnoremap gtt <Cmd>TestLast<CR>
nnoremap gtn <Cmd>TestNearest<CR>
nnoremap gtf <Cmd>TestFile<CR>
function! TerminalHelpStrategy(cmd)
    call TerminalSend(a:cmd . "\r")
endfunction
let g:test#custom_strategies = {"thelp": function("TerminalHelpStrategy")}
let g:test#strategy = "dispatch"
" }}}

" vim-bookmarks {{{
let s:bookmark_directory = stdpath('data') . '/vim-bookmarks'
    \| call mkdir(s:bookmark_directory, 'p')
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_display_annotation = 1
let g:bookmark_auto_save_file = s:bookmark_directory . '/default'
let g:bookmark_save_per_working_dir = 1
function! g:BMWorkDirFileLocation()
    return s:bookmark_directory . '/' . EscapeFilename(ProjectRoot())
endfunction
nnoremap ma :BookmarkToggleAndAnnotate<CR>
nnoremap ms :BookmarkShowAll<CR>

lua << EOF
require('telescope').load_extension('vim_bookmarks')
EOF
nnoremap <silent> <C-M> :Telescope vim_bookmarks all<CR>
" }}}

" signify {{{
let g:signify_sign_change = "*"
" }}}

" dispatch.vim {{{
let g:dispatch_no_maps = 1
" }}}

" neovim-session-manager {{{
lua <<EOF
require('session_manager').setup({
  autoload_mode = require('session_manager.config').AutoloadMode.LastSession,
  autosave_ignore_filetypes = {
    'gitcommit',
  },
  autosave_ignore_buftypes = {
    'help',
    'terminal',
  },
  autosave_only_in_session = true,
})
EOF
nnoremap <silent>gM <cmd>SessionManager load_session<cr>
" }}}

" dressing.nvim {{{
lua <<EOF
require('dressing').setup {
    input = {
        start_in_insert = true,
    }
}
EOF
" }}}

" yanky.nvim {{{
lua <<EOF
require("yanky").setup({
  ring = {
    storage = "memory",
  },
  highlight = {
    on_put = false,
    on_yank = false,
  },
})
require("telescope").load_extension("yank_history")
EOF
nnoremap <silent> ey <cmd>Telescope yank_history<cr>
inoremap <silent> <c-y> <cmd>Telescope yank_history<cr>
" }}}

" vim-auto-save {{{
let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_write_all_buffers = 1
" }}}

" nvim-colorizer {{{
lua <<EOF
require 'colorizer'.setup {
    user_default_options = {
        mode = "background"
    }
}
EOF
" }}}
" }}}

" vim: set foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
