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
if exists("s:first_init")
    echom 'Plugin manager: vim-plug has not been installed. Try to install...'
    exec '!curl -fL --create-dirs -o ' . s:vimplug_path .
            \ ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    exec 'source ' . fnameescape(s:vimplug_path)
    echom 'Installing vim-plug complete.'
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp' | Plug 'hrsh7th/cmp-buffer' | Plug 'hrsh7th/cmp-path' | Plug 'hrsh7th/nvim-cmp' | Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/vim-vsnip' | Plug 'hrsh7th/cmp-vsnip' | Plug 'hrsh7th/vim-vsnip-integ'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' } | Plug 'nvim-lua/plenary.nvim' | Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'rafamadriz/friendly-snippets'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ahmedkhalf/project.nvim'
Plug 'kevinhwang91/nvim-bqf'
Plug 'rmagatti/auto-session' | Plug 'rmagatti/session-lens'

Plug 'dyng/auto_mkdir'
Plug 'junegunn/fzf'
Plug 'easymotion/vim-easymotion'
Plug 'thinca/vim-quickrun'
Plug 'mbbill/undotree'
Plug 'machakann/vim-sandwich'
Plug 'vim-scripts/Rename'
Plug 'junegunn/vim-easy-align'
Plug '~/Dropbox/Projects/CtrlSF'
Plug '~/Dropbox/Projects/formatiu.vim'
Plug 'tpope/vim-fugitive'
Plug 'mg979/vim-visual-multi'
Plug 'inkarkat/vim-mark' | Plug 'inkarkat/vim-ingo-library'
Plug 'tpope/vim-rsi'
Plug 'tommcdo/vim-exchange'
Plug 'AndrewRadev/linediff.vim'
Plug 'vim-scripts/ReloadScript'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Raimondi/delimitMate'
Plug 'tomtom/tcomment_vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dhruvasagar/vim-table-mode'
Plug 'ludovicchabant/vim-gutentags'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': 'markdown' }
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'skywind3000/vim-terminal-help'
Plug 'Chiel92/vim-autoformat'

" Language Specific Plugins
Plug 'guns/vim-sexp'
Plug '~/Dropbox/Projects/dejava.vim'
Plug 'nathangrigg/vim-beancount'

" Colorschemes
Plug 'tomasr/molokai'
Plug 'w0ng/vim-hybrid'
Plug 'nanotech/jellybeans.vim'
Plug 'joshdick/onedark.vim'
Plug 'ajmwagar/vim-dues'
Plug 'rakr/vim-one'
Plug 'chriskempson/base16-vim'

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
language message zh_CN.UTF-8
" }}}

" Spelling Check {{{
" default setting
set nospell

function! s:InitSpellingCheck(lang)
    setl spell
    exec "setl spelllang=" . a:lang
endfunction

augroup spelling
    autocmd!
    autocmd FileType text,markdown call s:InitSpellingCheck("en_us")
augroup END
" }}}

" Indentation {{{
set magic
set ruler
set autoindent
set tabstop=8
set shiftwidth=4
set softtabstop=4
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
colorscheme onedark

" Font
if has('gui_macvim')
    set guifont=Inconsolata\ Nerd\ Font\ Mono:h17
elseif has("gui_vimr") || exists('g:neovide')
    set guifont=BlexMono\ Nerd\ Font\ Mono:h15
else
    set guifont=Hack:h14
endif

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
autocmd FileType qf nmap <buffer><silent> q :cclose<cr>

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

" Nohlsearch
nnoremap <silent> <F2>      :nohlsearch \| call ClearHighlightLines()<CR>
inoremap <silent> <F2> <C-O>:nohlsearch \| call ClearHighlightLines()<CR>
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
    exec "set undodir='" . stdpath('data') . "\undodir'"
endif

" language of help doc
set helplang=cn
" }}}
" }}}

" Custom Functions {{{
" Highlight current line {{{
function! ToggleHighlightCurrentLine()
    if !exists('b:myhllines')
        let b:myhllines = {}
    endif

    let lnum = line('.')
    if has_key(b:myhllines, lnum)
        silent! call matchdelete(b:myhllines[lnum])
        unlet b:myhllines[lnum]
    else
        let matchid = matchadd('Search', '\%'.lnum.'l')
        let b:myhllines[lnum] = matchid
    endif
endfunction
function! ClearHighlightLines()
    if exists('b:myhllines')
        for value in values(b:myhllines)
            silent! call matchdelete(value)
        endfor
    endif
    let b:myhllines = {}
endfunction
nnoremap <silent> ml :call ToggleHighlightCurrentLine()<CR>
autocmd InsertEnter * call ClearHighlightLines()
"}}}
" }}}

" Custom FileType {{{
augroup customfiletype
    au!
    " Freemark template file
    au BufRead *.ftl set filetype=html
augroup END
"}}}

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
lua <<EOF
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
    },
    git = {
        enable = false
    },
}
EOF
" }}}

" nvim-project {{{
lua << EOF
  require("project_nvim").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
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
          override_file_sorter = true,
          case_mode = "smart_case"
      },
  },
}
require('telescope').load_extension('fzf')
EOF
nnoremap <silent><C-P> <cmd>lua require("telescope.builtin").find_files()<cr>
nnoremap <silent>gm <cmd>lua require("telescope.builtin").oldfiles()<cr>
nnoremap <silent>gM <cmd>lua require('session-lens').search_session()<cr>
nnoremap <silent>gl <cmd>lua require("telescope.builtin").live_grep()<cr>
nnoremap <silent>gb <cmd>lua require("telescope.builtin").current_buffer_tags()<cr>
nnoremap <silent>gB <cmd>lua require("telescope.builtin").tags()<cr>
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
nnoremap <silent> gss :Git status<CR>
nnoremap <silent> gsb :Git blame<CR>
autocmd FileType fugitiveblame nmap <buffer> q gq
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
let g:quickrun_config['perl'] = {
\ 'cmdopt': '-Ilib'
\ }
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
let g:multi_cursor_use_default_mapping = 0

" Default mapping
let g:multi_cursor_next_key='<C-N>'
let g:multi_cursor_prev_key='<C-U>'
let g:multi_cursor_skip_key='<C-X>'
let g:multi_cursor_quit_key='<Esc>'
" }}}

" mark {{{
let g:mw_no_mappings = 1
nmap <silent> mm <Plug>MarkSet
vmap <silent> mm <Plug>MarkSet
nmap <silent> mc <Plug>MarkClear
nmap <silent> mn <Plug>MarkSearchAnyNext
nmap <silent> mN <Plug>MarkSearchAnyPrev
" }}}

" vim-exchange {{{
let g:exchange_no_mappings = 1
nmap cx     <Plug>(Exchange)
nmap cxx    <Plug>(ExchangeLine)
xmap X      <Plug>(Exchange)
nmap <expr> <ESC> exists('b:exchange') ? "<Plug>(ExchangeClear)"  : "\<ESC>"
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
nnoremap <silent> gc :TComment<CR>
vnoremap <silent> gc :TComment<CR>
" }}}

" csv.vim {{{
let g:no_csv_maps = 1
" }}}

" gutentags {{{
set statusline+=%{gutentags#statusline()}
" }}}

" {{{ vim-easy-align
xmap ga <Plug>(EasyAlign)*
nmap ga <Plug>(EasyAlign)*
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
" }}}

" {{{ lsp-config & mason
lua <<EOF
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'ea', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'ef', vim.lsp.buf.formatting, bufopts)
  vim.keymap.set('n', 'ern', vim.lsp.buf.rename, bufopts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

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

" mason {{{
lua <<EOF
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
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-u>'] = cmp.mapping.scroll_docs(4),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
})
EOF
" }}}

" lualine {{{
lua require('lualine').setup()
" }}}

" nvim-bqf {{{
lua << EOF
require('bqf').setup({
    auto_enable = true,
    auto_resize_height = true,
    func_map = {
        openc = '<cr>',
    },
})
EOF
" }}}

" nvim-treesitter {{{
lua << EOF
require('nvim-treesitter.configs').setup({
})
EOF
" }}}

" auto-session {{{
lua << EOF
require('auto-session').setup {
    auto_session_enable_last_session = true,
}
EOF
" }}}

" session-lens {{{
lua << EOF
require('session-lens').setup {
}
EOF
" }}}

" modeline {{{
" vim: set foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
