vim9script

# TOC:
# 1. Settings
# 2. Mappings
# 3. Plugins
#    - Misc
#    - Buffers and Tabs
#    - File Tree
#    - Tim Pope
#    - Testing
#    - Language Support
#    - LSP & Completion
#    - AI
#    - Status Line


##############################################################################
# 1. SETTINGS
##############################################################################
g:mapleader = "\<Space>"

colorscheme jummidark
syntax on                            # Enable syntax highlighting

set colorcolumn=+1                   # Highlight where the text width ends
set directory=$HOME/.vim/swp//       # Set the swap file directory
set hidden                           # Allow buffer change w/o saving
set hlsearch                         # Highlight search results
set laststatus=2                     # Show status line
set nocompatible                     # Don't maintain compatibilty with Vi.
set number                           # Display line numbers beside buffer
set re=0                             # Use syntax highlighting in regex
set sessionoptions+=tabpages,globals # Saves tab names
set shiftround                       # Round indent to a multiple of 'shiftwidth'
set shiftwidth=2                     # Number of spaces to use for indent and unindent
set smarttab                         # Tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set splitbelow                       # Open new horizontal splits underneath
set splitright                       # Open new vertical splits to the right
set tabstop=2                        # The visible width of tabs
set textwidth=120                    # Make it obvious where 120 characters is

# Set the colors to 256
if !has("gui_running")
	set t_Co=256
endif

# Quit help and quickfix windows with q
autocmd Filetype help nnoremap <buffer> q :q<CR>
autocmd Filetype qf nnoremap <buffer> q :q<CR>

##############################################################################
# 2. MAPPINGS
##############################################################################
imap jk <esc>
imap kj <esc>

# In insert mode, pressing <C-s> will save the file
imap <C-s> <esc>:w<cr>

# 0 goes to first character, not 0th column
nmap 0 ^

# Move up and down by visible lines if current line is wrapped
nmap j gj
nmap k gk

# Stop starting macros all the time on accident
nnoremap Q q
nnoremap q <Nop>

# Source (reload) your vimrc
nmap <leader>so :source $MYVIMRC<cr>

# Pre-populate a split command with the current directory
nmap <leader>v :vnew <C-r>=escape(expand("%:p:h"), ' ') . '/'<cr>

# Move visual selection up or down a line
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

# Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

# Shortcut for closing buffers
nnoremap <Leader>q :Bdelete<CR>

##############################################################################
# 3. PLUGINS
##############################################################################

##############################################################################
# [Minpac](https://github.com/k-takata/minpac)
# Minpac is a minimal package manager for Vim 8 (and Neovim). This uses the 
# packages feature and the jobs feature which have been newly added on Vim 8.
# 
##############################################################################
packadd minpac
call minpac#init()

command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()
command! PackStatus call minpac#status()

## Misc

# [JummiDark](https://github.com/jcherven/jummidark.vim)
# It's just a vim colorscheme forked from original work by kamykn's dark-theme.vim.
call minpac#add("jcherven/jummidark.vim")

# [Vim-RipGrep](https://github.com/jremmen/vim-ripgrep)
call minpac#add('jremmen/vim-ripgrep')

# [VimEasyAlign](https://github.com/junegunn/vim-easy-align)
# A simple, easy-to-use Vim alignment plugin.
call minpac#add("junegunn/vim-easy-align")
# Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
# Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

# [Emmet-vim](https://github.com/mattn/emmet-vim)
# emmet-vim is a vim plug-in which provides support for expanding abbreviations similar to emmet.
call minpac#add("mattn/emmet-vim")

## Buffers and Tabs

# [Vim-Startify](https://github.com/mhinz/vim-startify)
# The fancy start screen for Vim.
call minpac#add("mhinz/vim-startify")
g:startify_change_to_dir = 0
g:startify_bookmarks = [
	{ "v": "~/.vimrc" }
]
nmap <silent> <leader>s :Startify<CR>

# [Vim-Bbye](https://github.com/moll/vim-bbye)
# Bbye allows you to do delete buffers (close files) without closing your windows or messing up your layout.
call minpac#add("moll/vim-bbye")

# [Taboo](https://github.com/gcmt/taboo.vim)
# Taboo aims to ease the way you set the vim tabline. In addition, Taboo provides fews useful 
# utilities for renaming tabs.
call minpac#add("gcmt/taboo.vim")

# [CtrlP](https://github.com/ctrlpvim/ctrlp.vim)
# Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
call minpac#add('ctrlpvim/ctrlp.vim')
g:ctrlp_working_path_mode = "ra"
g:ctrlp_user_command = "ag %s -l --hidden --nocolor -g ''" # Make CtrlP use ag for listing the files
g:ctrlp_use_caching = 0
g:ctrlp_custom_ignore = {
	dir:  "\v[\/]\.git$"
}

## File Tree

# [NERDTree](https://github.com/preservim/nerdtree)
# The NERDTree is a file system explorer for the Vim editor. Using this plugin, users 
# can visually browse complex directory hierarchies, quickly open files for reading 
# or editing, and perform basic file system operations.
#
call minpac#add("preservim/nerdtree")
# [NerdTreeBufferOps](https://github.com/PhilRunninger/nerdtree-buffer-ops)
# This is a NERDTree plugin that highlights all visible nodes that are open in Vim.
# It also maps a key w to close (wipeout) the buffer associated with the current node.
call minpac#add("PhilRunninger/nerdtree-buffer-ops")
g:NERDTreeWinPos = "right"
nnoremap - :NERDTreeFind<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
# " Allow vim To close if only nerdtree left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

## Tim Pope

# [Commentary](https://github.com/tpope/vim-commentary)
# Comment stuff out. Use gcc to comment out a line (takes a count), gc to comment out the 
# target of a motion (for example, gcap to comment out a paragraph), gc in visual mode to 
# comment out the selection, and gc in operator pending mode to target a comment. You can 
# also use it as a command, either with a range like :7,17Commentary, or as part of a :global 
# invocation like with :g/TODO/Commentary. That's it.
call minpac#add("tpope/vim-commentary")
# [Fugitive](https://github.com/tpope/vim-fugitive)
# Fugitive is the premier Vim plugin for Git. Or maybe it's the premier Git plugin for Vim?
call minpac#add("tpope/vim-fugitive")
# [Projectionist](https://github.com/tpope/vim-projectionist)
# Projectionist provides granular project configuration using "projections". 
call minpac#add("tpope/vim-projectionist")
# [Repeat](https://github.com/tpope/vim-repeat)
# If you've ever tried using the . command after a plugin map, you were likely disappointed 
# to discover it only repeated the last native command inside that map, rather than the map 
# as a whole. That disappointment ends today. Repeat.vim remaps . in a way that plugins can 
# tap into it.
call minpac#add("tpope/vim-repeat")
# [Rhurbarb](https://github.com/tpope/vim-rhubarb)
# If fugitive.vim is the Git, rhubarb.vim is the Hub. 
call minpac#add("tpope/vim-rhubarb")
# [Surround](https://github.com/tpope/vim-surround)
# Surround.vim is all about "surroundings": parentheses, brackets, quotes, XML tags, and 
# more. The plugin provides mappings to easily delete, change and add such surroundings in 
# pairs.
call minpac#add("tpope/vim-surround")
# [Unimpaired](https://github.com/tpope/vim-unimpaired)
# Much of unimpaired.vim was extracted from my vimrc when I noticed a pattern: complementary 
# pairs of mappings. 
call minpac#add("tpope/vim-unimpaired")

## Testing

# [Vim-Test](https://github.com/vim-test/vim-test)
# A Vim wrapper for running tests on different granularities.
call minpac#add("vim-test/vim-test")
# VimTest mappings
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

## Language Support

# TODO: Document and pair down

call minpac#add("Glench/Vim-Jinja2-Syntax")
call minpac#add("elixir-editors/vim-elixir")
call minpac#add("leafOfTree/vim-svelte-plugin")
call minpac#add("hashivim/vim-terraform")
call minpac#add("wuelnerdotexe/vim-astro")
g:astro_typescript = "enable"
# call minpac#add('pangloss/vim-javascript')
# call minpac#add('MaxMEllon/vim-jsx-pretty')
# call minpac#add('HerringtonDarkholme/yats.vim') #typescript

## LSP & Completion

# [Vim-LSP](https://github.com/prabirshrestha/vim-lsp)
# Async Language Server Protocol plugin for vim8 and neovim.
call minpac#add("prabirshrestha/vim-lsp")
g:lsp_semantic_enabled = 1
# Format and then save if the buffer is changed
nmap qq :LspDocumentFormatSync<CR>:update<CR>
# Format on save (TODO: Not working)
# autocmd BufWritePre <buffer> LspDocumentFormatSync
# Useful for debugging vim-lsp:
# g:lsp_log_verbose = 1
# g:lsp_log_file = expand('~/vim-lsp.log')
# [ALE](https://github.com/dense-analysis/ale)
# ALE (Asynchronous Lint Engine) is a plugin providing linting (syntax checking and semantic errors) 
# in NeoVim 0.2.0+ and Vim 8.0+ while you edit your text files, and acts as a Vim Language Server Protocol client.
call minpac#add("dense-analysis/ale")
# [Vim-LSP-ALE](https://github.com/rhysd/vim-lsp-ale)
# vim-lsp-ale is a Vim plugin for bridge between vim-lsp and ALE. Diagnostics results received by 
# vim-lsp are shown in ALE's interface.
call minpac#add("rhysd/vim-lsp-ale")
# [Vim-LSP-Settings](https://github.com/mattn/vim-lsp-settings) 
# Language Servers are not easy to install. Visual Studio Code provides easy ways to 
# install and update Language Servers and Language Server Client. This plugin provides 
# the same feature for Vim.
# call minpac#add('mattn/vim-lsp-settings')
call minpac#add("jHwls/vim-lsp-settings", {"branch": "fix/update-elixir-ls-url"})
g:lsp_settings_filetype_elixir = ["lexical"]
# [Vim-Healthcheck](https://github.com/rhysd/vim-healthcheck)
# vim-healthcheck is a polyfill plugin for Vim to use a health-check feature in Neovim. Neovim's 
# health-check feature is a minimal framework to help with troubleshooting user configuration. 
# vim-healthcheck provides the same feature for Vim.
call minpac#add("rhysd/vim-healthcheck")
# [Supertab](https://github.com/ervandew/supertab)
# Supertab is a vim plugin which allows you to use <Tab> for all your insert completion 
# needs (:help ins-completion).
call minpac#add("ervandew/supertab")
# Set the default completion type to omni completion
g:SuperTabDefaultCompletionType = "<c-x><c-o>"

# Configure [Lexical](https://github.com/lexical-lsp/lexical) as the elixir language server
if executable("elixir")
	augroup lsp_lexical
	autocmd!
	autocmd User lsp_setup call lsp#register_server({ name: "lexical", cmd: (server_info) => "/Users/jhwls/repos/lexical-lsp/lexical/_build/dev/rel/lexical/start_lexical.sh", allowlist: ["elixir", "eelixir"] })
	autocmd FileType elixir setlocal omnifunc=lsp#complete
	autocmd FileType eelixir setlocal omnifunc=lsp#complete
	augroup end
endif


## AI

# [Copilot](https://github.com/github/copilot.vim)
# GitHub Copilot provides autocomplete-style suggestions from an AI pair programmer as you code.
call minpac#add("github/copilot.vim")
g:copilot_enabled = 1
g:copilot_no_tab_map = v:true
inoremap <C-c>] <Plug>(copilot-next)
inoremap <C-c>[ <Plug>(copilot-previous)
nmap <leader>cc <Plug>(copilot-suggest)
nnoremap <silent> <leader>cp :Copilot panel<CR>
# Accept the current suggestion via <C-F>
imap <silent><script><expr> <C-F> copilot#Accept("\<CR>")
# Toggle Copilot in the current buffer
nnoremap <leader>co :let b:copilot_enabled = !b:copilot_enabled<CR>:echo b:copilot_enabled<CR>
# Close the panel with q
autocmd BufRead,BufNewFile copilot.vim nnoremap <buffer> q :q<CR>

## Status Line

# [Lightline](https://github.com/itchyny/lightline.vim)
# A light and configurable statusline/tabline plugin for Vim.
call minpac#add("itchyny/lightline.vim")

g:lightline = {
	component_type: {
		linter_checking: "right",
		linter_infos: "right",
		linter_warnings: "warning",
		linter_errors: "error",
		linter_ok: "right",
	},
	active: {
		right: [
			["linter_checking", "linter_errors", "linter_warnings", "linter_infos", "linter_ok"],
			["lineinfo"],
			["percent"],
			["fileformat", "fileencoding", "filetype"] 
		] 
	}
}

# [Lightline Ale](https://github.com/maximbaz/lightline-ale)
# This plugin provides ALE indicator for the lightline vim plugin.
call minpac#add("maximbaz/lightline-ale")

g:lightline#ale#indicator_checking = "~"

g:lightline.component_expand = {
	linter_checking: "lightline#ale#checking",
	linter_infos: "lightline#ale#infos",
	linter_warnings: "lightline#ale#warnings",
	linter_errors: "lightline#ale#errors",
	linter_ok: "lightline#ale#ok",
}
