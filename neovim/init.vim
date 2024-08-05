" Before lazy.nvim {{{
" python provider
let g:python3_host_prog = 'python3'

" set mapleader
let mapleader = ","
" }}}

" Load Plugins {{{
lua <<EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.api.nvim_echo({{ "Installing lazy.nvim...", "WarningMsg" }}, true, {})
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  vim.api.nvim_echo({{ "Installing lazy.nvim complete", "WarningMsg" }}, true, {})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim"
        }
    },
    "neovim/nvim-lspconfig",
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        }
    },
    {
        "hrsh7th/vim-vsnip",
        dependencies = {
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip-integ",
            "rafamadriz/friendly-snippets",
        }
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
            },
            "nvim-telescope/telescope-fzy-native.nvim",
            "smartpde/telescope-recent-files",
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui",
            "rcarriga/cmp-dap",
            "jay-babu/mason-nvim-dap.nvim",
        }
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "jay-babu/mason-null-ls.nvim",
        }
    },
    "nvim-lualine/lualine.nvim",
    "kevinhwang91/nvim-bqf",
    "RRethy/vim-illuminate",
    "andymass/vim-matchup",
    {
        "dyng/vim-bookmarks",
        dependencies = {
            "tom-anders/telescope-vim-bookmarks.nvim",
        }
    },
    "akinsho/toggleterm.nvim",
    "sheerun/vim-polyglot",
    "Shatur/neovim-session-manager",
    "stevearc/dressing.nvim",
    "gbprod/yanky.nvim",
    "dyng/vim-auto-save",
    "NvChad/nvim-colorizer.lua",
    {
        "github/copilot.vim",
        dependencies = {
            { "CopilotC-Nvim/CopilotChat.nvim", branch = "canary" },
        }
    },
    "kosayoda/nvim-lightbulb",
    "chrisgrieser/nvim-early-retirement",
    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
      }
    },
    {
      "linux-cultist/venv-selector.nvim",
      branch = "regexp",
    },
    {
      'stevearc/aerial.nvim',
      dependencies = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-tree/nvim-web-devicons"
      },
    },
    "nvim-treesitter/nvim-treesitter-context",
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewFileHistory" },
    },
    "lewis6991/gitsigns.nvim",
    "numToStr/Comment.nvim",
    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      opts = {
        check_ts = true,
      }
    },

    -- old vim plugins
    "dyng/auto_mkdir",
    "easymotion/vim-easymotion",
    "mbbill/undotree",
    "machakann/vim-sandwich",
    "junegunn/vim-easy-align",
    { dir = "~/Dropbox/Projects/CtrlSF" },
    "tpope/vim-fugitive",
    "mg979/vim-visual-multi",
    {
      "inkarkat/vim-mark",
      dependencies = {
        "inkarkat/vim-ingo-library",
      }
    },
    "AndrewRadev/linediff.vim",
    "vim-scripts/ReloadScript",
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- Language Specific Plugins
    { dir = "~/Dropbox/Projects/dejava.vim" },
    "simrat39/rust-tools.nvim",

    -- Colorschemes
    "tomasr/molokai",
    "marko-cerovac/material.nvim",
    "navarasu/onedark.nvim",
    "projekt0n/github-nvim-theme",

    -- Documents
    "yianwillis/vimcdoc",
}

require("lazy").setup(plugins)
EOF
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

colorscheme onedark

" Font
if has('gui_macvim')
    set guifont=Inconsolata\ Nerd\ Font\ Mono:h16
elseif exists("g:gui_vimr")
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
" }}}

" Syntax {{{
syntax on
filetype plugin indent on
set modeline                 "modeline is by default disabled on Debian
set completeopt=menu,menuone,noselect
set wildmenu
" }}}

" Terminal {{{
tnoremap <A-q> <C-\><C-n>
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
" }}}

" Maps {{{
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
vnoremap <silent> Yr :source \| redraw \| echo 'executed!'<CR>
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
" split window at right side
set splitright

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
    exec "set undodir=" . stdpath('data') . "/undodir"
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
let s:rootmarkers = ['.git', '.svn', '.hg']

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

" BufWipeout {{{
" Wipe all deleted (unloaded & unlisted) or all unloaded buffers
function! BufWipeout(listed) abort
    let l:buffers = filter(getbufinfo(), {_, v -> !v.loaded && (!v.listed || a:listed)})
    if !empty(l:buffers)
        execute 'bwipeout' join(map(l:buffers, {_, v -> v.bufnr}))
    endif
endfunction
command! -bar -bang BufWipeout call BufWipeout(<bang>0)
" }}}
" }}}

" Custom FileType Config {{{
" golang
autocmd FileType go setlocal tabstop=4 shiftwidth=4 nolist noexpandtab

" lua
autocmd FileType lua setlocal shiftwidth=2

" java
autocmd FileType java let $JAVA_HOME = '/usr/local/var/jenv/versions/19'
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

" vim-rsi {{{
inoremap        <C-A> <C-O>^
inoremap   <C-X><C-A> <C-A>
cnoremap        <C-A> <Home>
cnoremap   <C-X><C-A> <C-A>

inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
cnoremap        <C-B> <Left>

inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"

inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"

inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
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

" neo-tree {{{
lua <<EOF
require('neo-tree').setup {
  close_if_last_window = true,
  enable_diagnostics = false,
  window = {
    width = 30,
    mappings = {
      ["<space>"] = "none",
      ["e"] = "toggle_node",
    },
  },
  filesystem = {
    group_empty_dirs = true,
    use_libuv_file_watcher = true,
    follow_current_file = {
      enabled = true,
    },
  },
}
EOF
nnoremap <silent> gn :Neotree reveal<cr>
nnoremap <silent> gN :Neotree dir=.<cr>
" }}}

" Telescope {{{
lua << EOF
require('telescope').setup{
    defaults = {
        path_display = { 'filename_first' },
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
        },
        recent_files = {
            ignore_patterns = {},
        },
    },
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('fzy_native')
require("telescope").load_extension("recent_files")
EOF
nnoremap <silent><C-P> <cmd>lua require("telescope.builtin").find_files({ cwd = vim.fn.ProjectRoot() })<cr>
nnoremap <silent>gp <cmd>lua require("telescope.builtin").find_files()<cr>
" nnoremap <silent>gm <cmd>lua require("telescope.builtin").oldfiles()<cr>
nnoremap <silent>gm <cmd>lua require("telescope").extensions.recent_files.pick()<cr>
nnoremap <silent>gb <cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>
nnoremap <silent>gB <cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<cr>
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
nnoremap <silent> gsb :Git blame<CR>
autocmd FileType fugitiveblame nmap <buffer> q gq
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

" {{{ lsp-config & mason
lua <<EOF
-- Mappings
local bufopts = { noremap=true, silent=true }
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
vim.keymap.set({'n', 'v'}, 'ef', function() vim.lsp.buf.format { async = false } end, bufopts)
vim.keymap.set('n', 'ern', vim.lsp.buf.rename, bufopts)

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason").setup({
    log_level = vim.log.levels.DEBUG
})
require("mason-lspconfig").setup({
    handlers = {
        function (server_name)
            require("lspconfig")[server_name].setup {
                capabilities = capabilities,
            }
        end,
        -- using rust-tools.nvim
        ["rust_analyzer"] = function ()
            local rt = require("rust-tools")
            rt.setup {
                server = {
                    on_attach = function(client, bufnr)
                        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
                    end,
                    settings = {
                        ["rust-analyzer"] = {
                            procMacro = {
                                enable = true,
                            },
                        },
                    },
                    capabilities = capabilities,
                },
                dap = {
                    adapter = {
                        type = "server",
                        port = "${port}",
                        host = "127.0.0.1",
                        executable = {
                            command = "codelldb",
                            args = { "--port", "${port}" },
                        },
                    },
                },
            }
        end
    }
})
EOF
" }}}

" nvim-cmp {{{
lua << EOF
-- Setup nvim-cmp.
local cmp = require'cmp'
cmp.setup({
  preselect = cmp.PreselectMode.Item,
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

-- cmp-dap
cmp.setup({
  enabled = function()
    return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt'
      or require("cmp_dap").is_dap_buffer()
  end,
})
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
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
  auto_install = true,
  highlight = {
    enable = true,
  },
  matchup = {
    enable = true,
  },
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
set_dap_keymap('n', '<up>', require'dap'.step_back)
set_dap_keymap('n', '<down>', require'dap'.step_over)
set_dap_keymap('n', '<right>', require'dap'.step_into)
set_dap_keymap('n', '<left>', require'dap'.step_out)
set_dap_keymap('n', 'J', require'dap'.continue)
set_dap_keymap('n', 'C', require'dap'.run_to_cursor)
set_dap_keymap('n', '<C-c>', require'dap'.terminate)
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

" mason-nvim-dap {{{{
lua <<EOF
require ('mason-nvim-dap').setup({
  handlers = {
    function(config)
      require('mason-nvim-dap').default_setup(config)
    end,
    python = function(config)
      config.adapters = {
        type = "executable",
        command = "python3",
        args = {
          "-m",
          "debugpy.adapter",
        },
      }
      table.insert(config.configurations, {
        type = "python",
        request = "launch",
        name = "Python: Launch with Arguments",
        program = "${file}",
        console = 'integratedTerminal',
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " ")
        end,
      })
      require('mason-nvim-dap').default_setup(config)
    end,
  },
})
EOF
" }}}}

" nvim-dap-ui {{{{
lua << EOF
local dap, dapui = require("dap"), require("dapui")
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    edit = "m",
    expand = "e",
    open = "<cr>",
  },
  layouts = {
    {
      position = "left",
      size = 40,
      elements = {
        { id = "stacks", size = 0.4 },
        { id = "breakpoints", size = 0.3 },
        { id = "watches", size = 0.3 },
      },
    },
    {
      position = "bottom",
      size = 0.3,
      elements = {
        { id = "scopes", size = 0.5 },
        { id = "console", size = 0.5 },
      },
    },
  },
  controls = {
    enabled = true,
    element = "console",
  },
})
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
set_dap_keymap({'n', 'v'}, 'V', dapui.eval)
set_dap_keymap('n', 'R', function() dapui.float_element('repl') end)
EOF
" }}}}

" dap-go {{{{
autocmd FileType go nnoremap <buffer><silent> gun <Cmd>lua require('dap-go').debug_test()<CR>
lua << EOF
require('dap-go').setup()
EOF
" }}}}
" }}}

" none-ls & mason-null-ls {{{
lua << EOF
require("mason-null-ls").setup({
    ensure_installed = {
        "golangci-lint",
        "black",
        "prettierd",
        "stylua",
    },
    automatic_installation = false,
    handlers = {},
})
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- Anything not supported by mason.
    },
})
EOF
" }}}

" vim-illuminate {{{
augroup illuminate_augroup
    autocmd!
    autocmd VimEnter * hi! link IlluminatedWordText MatchParen
    autocmd VimEnter * hi! link IlluminatedWordRead MatchParen
    autocmd VimEnter * hi! link IlluminatedWordWrite MatchParen
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
    filetypes_denylist = {
        'NvimTree',
        'copilot-chat',
    },
})
EOF
" }}}

" vim-matchup {{{
let g:matchup_matchparen_offscreen = { 'method': 'status' }
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
vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = "SessionSavePost",
  callback = function()
    require("venv-selector").deactivate()
  end,
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

" copilot.vim {{{
let g:copilot_no_tab_map = v:true
let g:copilot_assume_mapped = v:true
let g:copilot_filetypes = {
    \ 'markdown': v:true,
    \ 'dap-repl': v:false,
    \ }
inoremap <silent><script><expr> <C-E> <SID>CopilotAccept("\<End>")
inoremap <silent><script><expr> <Right> <SID>CopilotAccept("\<Right>")
imap <silent> <C-]> <Plug>(copilot-next)
function s:CopilotAccept(fallback) abort
    let s = copilot#GetDisplayedSuggestion()
    return !empty(s.text) ? copilot#Accept("") : a:fallback
endfunction
" }}}

" CopilotChat.nvim {{{
lua <<EOF
require("CopilotChat").setup {
    auto_follow_cursor = false,
    auto_insert_mode = true,
    show_help = false,
    window = {
        layout = 'float',
        width = 0.8,
        height = 0.8,
    },
    mappings = {
        submit_prompt = {
            normal = '<CR>',
            insert = '<CR>'
        },
        reset = {
            normal = '',
            insert = '<C-l>'
        },
        accept_diff = {
            normal = '',
            insert = ''
        },
    },
}
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'copilot-chat',
    callback = function()
        vim.keymap.set('n', 'A', function()
            vim.cmd.normal('G$')
            vim.cmd('startinsert!')
        end, { silent = true, buffer = true })
    end
})
EOF
nnoremap <silent> <A-'> :CopilotChatToggle<CR>
inoremap <silent> <A-'> <C-O>:CopilotChatToggle<CR>
vnoremap <silent> <A-'> :CopilotChatExplain<CR>
" }}}

" nvim-lightbulb {{{
lua <<EOF
require("nvim-lightbulb").setup({
  sign = {
      enabled = false,
  },
  virtual_text = {
      enabled = true,
  },
  autocmd = {
      enabled = true
  },
  ignore = {
      actions_without_kind = true,
  }
})
EOF
" }}}

" toggleterm.nvim {{{
lua <<EOF
require("toggleterm").setup({
  open_mapping = '<A-/>',
  direction = 'float',
})
EOF
command! TermFloat 1ToggleTerm direction=float
command! TermBelow 1ToggleTerm size=20 direction=horizontal
" }}}

" nvim-early-retirement {{{
lua <<EOF
require("early-retirement").setup({
  retirementAgeMins = 20,
  minimumBufferNum = 20,
})
EOF
" }}}

" noice.nvim {{{
lua <<EOF
require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = false, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
})
EOF
" }}}

" neotest {{{
lua <<EOF
local neotest = require("neotest")
neotest.setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
  },
})
vim.keymap.set('n', 'gto', function() neotest.output.open({ enter = true }) end, { noremap = true })
vim.keymap.set('n', 'gtn', neotest.run.run, { noremap = true })
vim.keymap.set('n', 'gtf', function() neotest.run.run(vim.fn.expand("%")) end, { noremap = true })
vim.keymap.set('n', 'gun', function() neotest.run.run({ strategy = "dap" }) end, { noremap = true })
EOF
" }}}

" venv-selector {{{
lua <<EOF
require("venv-selector").setup()
EOF
" }}}

" aerial {{{
lua <<EOF
require("aerial").setup({
  nav = {
    preview = false,
    keymaps = {
      ["<Left>"] = "actions.left",
      ["<Right>"] = "actions.right",
      ["<Esc>"] = "actions.close",
      ["q"] = "actions.close",
    },
  },
})
vim.keymap.set("n", "ga", "<cmd>AerialNavOpen<CR>")
vim.keymap.set("n", "gA", "<cmd>AerialToggle!<CR>")
EOF
" }}}

" nvim-treesitter-context {{{
lua <<EOF
require("treesitter-context").setup {
  separator = "━",
}
EOF
" }}}

" diffview.nvim {{{
nnoremap <silent> gsh :DiffviewFileHistory<CR>
autocmd FileType DiffviewFileHistory nnoremap <buffer><silent> q :DiffviewClose<cr>
" }}}

" gitsigns {{{
lua <<EOF
require("gitsigns").setup {
}
EOF
" }}}

" Comment.nvim {{{
lua <<EOF
require('Comment').setup({
  padding = true,
  mappings = {
    basic = false,
    extra = false,
  },
})
vim.keymap.set('n', 'ec', '<Plug>(comment_toggle_linewise_current)')
vim.keymap.set('n', 'eC', '<Plug>(comment_toggle_blockwise_current)')
vim.keymap.set('x', 'ec', '<Plug>(comment_toggle_linewise_visual)')
vim.keymap.set('x', 'eC', '<Plug>(comment_toggle_blockwise_visual)')
EOF
" }}}
" }}}

" vim: set foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
