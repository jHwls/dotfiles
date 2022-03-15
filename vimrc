"VIMRC
set directory=$HOME/.vim/swp/

let mapleader = "\<Space>"

" Make CtrlP use ag for listing the files
let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
let g:ctrlp_use_caching = 0
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.git$',
	\ }

"===============================================================================
"PLUGINS
packadd minpac
call minpac#init()

call minpac#add('jcherven/jummidark.vim')

call minpac#add('christoomey/vim-tmux-navigator')

call minpac#add('tpope/vim-vinegar')
call minpac#add('moll/vim-bbye')
call minpac#add('ctrlpvim/ctrlp.vim')
call minpac#add('itchyny/lightline.vim')
call minpac#add('maximbaz/lightline-ale')

call minpac#add('mhinz/vim-startify')
call minpac#add('gcmt/taboo.vim')

call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-projectionist')

call minpac#add('mattn/emmet-vim')

call minpac#add('dense-analysis/ale')

call minpac#add('Glench/Vim-Jinja2-Syntax')
call minpac#add('pangloss/vim-javascript')
call minpac#add('MaxMEllon/vim-jsx-pretty')
call minpac#add('HerringtonDarkholme/yats.vim') "typescript
call minpac#add('elixir-editors/vim-elixir')
call minpac#add('leafOfTree/vim-svelte-plugin')

call minpac#add('vim-test/vim-test')

call minpac#add('mhinz/vim-mix-format')
let g:mix_format_on_save = 1
"===============================================================================
"MAPPINGS
imap jk <esc>
imap kj <esc>
imap <C-s> <esc>:w<cr>

nmap ww :w<CR>


" 0 goes to first character, not 0th column
nmap 0 ^

" Move up and down by visible lines if current line is wrapped
nmap j gj
nmap k gk

" Stop starting macros all the time on accident
nnoremap Q q
nnoremap q <Nop>

" Tabedit your vimrc. Type space, v, r in sequence to trigger
nmap <leader>vr :tabedit $MYVIMRC<cr>

" Source (reload) your vimrc. Type space, s, o in sequence to trigger
nmap <leader>so :source $MYVIMRC<cr>

" Pre-populate a split command with the current directory
nmap <leader>v :vnew <C-r>=escape(expand("%:p:h"), ' ') . '/'<cr>

" Inserts a new line below the current one without entering insert mode
nmap oo o<Esc>k

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>

" Shortcut for closing buffers
nnoremap <Leader>q :Bdelete<CR>

" VimTest mappings
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Projectionist mapping
nnoremap <C-s> :A<cr>

" Line split regex shortcuts
nnoremap <C-f> <Nop>
nnoremap <C-f>p :s/<Bar>/\r<Bar>/g<CR> =[[
nnoremap <C-f>c :s/,/,\r/g<CR>=[[
nnoremap <C-f>f :s/\([,\(]\)/\1\r/g<CR>=a %i<CR><Esc> $
"===============================================================================
"SETTINGS
colorscheme jummidark

" Enable syntax highlighting
syntax on

" Enables filetype detection, loads ftplugin, and loads indent
filetype plugin indent on

set re=0
set laststatus=2				" Show status line
set nocompatible				" Don't maintain compatibilty with Vi.
set textwidth=80				" Make it obvious where 80 characters is
set colorcolumn=+1
set number							" Display line numbers beside buffer
set hidden							" Allow buffer change w/o saving
set hlsearch

set smarttab						" Tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=2						" The visible width of tabs
set shiftwidth=2				" Number of spaces to use for indent and unindent
set shiftround					" Round indent to a multiple of 'shiftwidth'

set splitright					" Open new vertical splits to the right
set splitbelow					" Open new horizontal splits underneath

set sessionoptions+=tabpages,globals " Saves tab names
"===============================================================================
"COMMANDS
command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()

"===============================================================================
"AUTOCOMMANDS
autocmd Filetype help nnoremap <buffer> q :q<CR>
autocmd Filetype qf nnoremap <buffer> q :q<CR>

au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm,*.njk set ft=jinja

"autocmd BufWritePost *.exs silent :!mix format %
"autocmd BufWritePost *.ex silent :!mix format %

"===============================================================================
"ALE
" Required, explicitly enable Elixir LS
let g:ale_linters = {}
let g:ale_linters.elixir = ['elixir-ls', 'credo']

let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_fixers.javascript = ['eslint', 'prettier']
let g:ale_fixers.html = ['prettier']
let g:ale_fixers["jinja.html"] = ['prettier']
let g:ale_fixers.scss = ['stylelint']
let g:ale_fixers.css = ['stylelint']
let g:ale_fixers.elixir = ['mix_format']

let g:ale_sign_column_always = 1
let g:ale_elixir_credo_strict = 1

" Required, tell ALE where to find Elixir LS
let g:ale_elixir_elixir_ls_release = expand("~/repos/elixir-ls/rel")

" Optional, configure as-you-type completions
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1

" Use tab for autocomplete match selection
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" : "\<TAB>"

nnoremap dt :ALEGoToDefinition<cr>
nnoremap df :ALEFix<cr>
nnoremap K :ALEHover<cr>

"===============================================================================
"LIGHTLINE
if !has('gui_running')
  set t_Co=256
endif

let g:lightline = {}

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }

let g:lightline.active = {
      \ 'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
      \ [ 'lineinfo' ],
	    \ [ 'percent' ],
	    \ [ 'fileformat', 'fileencoding', 'filetype'] ] }
