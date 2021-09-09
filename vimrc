"VIMRC

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

call minpac#add('tpope/vim-vinegar')
call minpac#add('moll/vim-bbye')
call minpac#add('ctrlpvim/ctrlp.vim')
call minpac#add('itchyny/lightline.vim')

call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-commentary')

call minpac#add('mattn/emmet-vim')

call minpac#add('prettier/vim-prettier')

call minpac#add('neoclide/coc.nvim')

"call minpac#add('sheerun/vim-polyglot')
call minpac#add('Glench/Vim-Jinja2-Syntax')
call minpac#add('pangloss/vim-javascript')
call minpac#add('MaxMEllon/vim-jsx-pretty')
call minpac#add('HerringtonDarkholme/yats.vim') "typescript
call minpac#add('elixir-editors/vim-elixir')
call minpac#add('mhinz/vim-mix-format')
"===============================================================================
"MAPPINGS
imap jk <esc>
imap kj <esc>
imap <C-s> <esc>:w<cr>

nmap 0 ^

" Move up and down by visible lines if current line is wrapped
nmap j gj
nmap k gk

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

"===============================================================================
"SETTINGS
colorscheme jummidark

set re=0
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
"===============================================================================
"COMMANDS
command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()

"===============================================================================
"AUTOCOMMANDS
autocmd Filetype help nnoremap <buffer> q :q<CR>
autocmd Filetype qf nnoremap <buffer> q :q<CR>


au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm,*.njk set ft=jinja

"===============================================================================
"COC
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

if has('nvim-0.4.0') || has('patch-8.2.0750')
	nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
