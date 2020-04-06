"" Set leader key early in rc
let mapleader=","

" Use the vim-plug plugin manager: https://github.com/junegunn/vim-plug
" Remember to run :PlugInstall when loading this vimrc for the first time, so
" vim-plug downloads the plugins listed.
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'

Plug 'tpope/vim-fugitive'

Plug 'junegunn/rainbow_parentheses.vim'
Plug 'rafi/awesome-vim-colorschemes'

Plug 'OmniSharp/omnisharp-vim'
Plug 'w0rp/ale'
Plug 'tpope/vim-unimpaired'

Plug 'janko/vim-test'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'SirVer/ultisnips'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
if executable('ctags')
    Plug 'prabirshrestha/asyncomplete-tags.vim'
    Plug 'ludovicchabant/vim-gutentags'
endif
call plug#end()


"" PLUGIN - asyncomplete and friends - setting up async language servers
"" Set logging files for debugging this
"let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand('~/vim-lsp.log')
let g:asyncomplete_log_file = expand('~/asyncomplete.log')
"
"" async language servers and sources
" Buffer - max size currently set at 5M
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
            \ 'name': 'buffer',
            \ 'whitelist': ['*'],
            \ 'blacklist': ['cs', 'python'],
            \ 'completor': function('asyncomplete#sources#buffer#completor'),
            \ 'config': {
            \    'max_buffer_size': 5000000,
            \  },
            \ }))
let g:asyncomplete_buffer_clear_cache = 0
" Tags + GutenTags - max size currently set at 5M
if executable('ctags')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
                \ 'name': 'tags',
                \ 'whitelist': ['c'],
                \ 'completor': function('asyncomplete#sources#tags#completor'),
                \ 'config': {
                \    'max_file_size': 5000000,
                \  },
                \ }))
    " Gutentags project root directory has a file named 'configure.bat' (all
    " biomeme c projects have this for versioning)
    let g:gutentags_project_root = ['configure.bat']
    " Don't add the defaults, otherwise it does all .git directories and
    " screws up our submodules
    let g:gutentags_add_default_project_roots = 0
    " Don't tag cmock generated files, or else we'll jump to fake stuff
    let g:gutentags_ctags_exclude = ['build', 'vendor']
    " 'gd' for go to first tag (matches shortcut for python and omnisharp go-to-definition"
    autocmd FileType c nnoremap <silent> gd <c-]>
endif
" Ultisnips snippets
" Ensure snippets are in the same place across platforms
let g:UltiSnipsSnippetDirectories = ['~/.vim/ultisnips']
" need the expand trigger to be different than the asyncomplete trigger to avoid conflicts
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
            \ 'name': 'ultisnips',
            \ 'whitelist': ['*'],
            \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
            \ }))

" async complete setup
let g:asyncomplete_auto_popup = 1
imap <c-space> <Plug>(asyncomplete_force_refresh)
imap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"imap <expr> <cr>    pumvisible() ? "\<C-cr>" : "\<cr>"
imap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"


" LSP - language server protocol - server setup
" Python - via the LSP pyls
if executable('pyls')
    " requires the language server - get via 'pip install python-language-server'
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python'],
                \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> rn <plug>(lsp-rename)
    nmap <buffer> pk <plug>(lsp-peek-definition)
    nmap <buffer> pk <plug>(lsp-peek-definition)
    nmap <buffer> dc <plug>(lsp-hover)
    nmap <Leader><Space> <plug>(lsp-code-action)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END



"" PLUGIN - Omnisharp

" Note: this is required for the plugin to work
filetype indent plugin on

" Use the stdio OmniSharp-roslyn server
let g:OmniSharp_server_stdio = 1

" Set the type lookup function to use the preview window instead of echoing it
"let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 5

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview' if you
" don't want to see any documentation whatsoever.
set completeopt=longest,menuone,preview

" Fetch full documentation during omnicomplete requests.
" By default, only Type/Method signatures are fetched. Full documentation can
" still be fetched when you need it with the :OmniSharpDocumentation command.
"let g:omnicomplete_fetch_full_documentation = 1

" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=10

" Update semantic highlighting after all text changes
" let g:OmniSharp_highlight_types = 3
" Update semantic highlighting on BufEnter and InsertLeave
let g:OmniSharp_highlight_types = 2

augroup omnisharp_commands
    autocmd!

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>

    " Remap omnisharp intellisense complete (c-x c-o) to tab
    autocmd FileType cs inoremap <expr> <Tab> pumvisible() ? '<C-n>' :
			    \ getline('.')[col('.')-2] =~# '[[:alnum:].-_#$]' ? '<C-x><C-o>' : '<Tab>'

    " run tests
    autocmd FileType cs nnoremap<buffer> <Leader>t :OmniSharpRunTest<cr>
    autocmd FileType cs nnoremap<buffer> <Leader>a :OmniSharpRunTestsInFile<cr>

    " Contextual code actions (uses fzf, CtrlP or unite.vim when available)
    autocmd FileType cs nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
    " Run code actions with text selected in visual mode to extract method
    autocmd FileType cs xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

    " Rename with dialog
    autocmd FileType cs nnoremap <Leader>nm :OmniSharpRename<CR>
    autocmd FileType cs nnoremap <F2> :OmniSharpRename<CR>
    " Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
    command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

    autocmd FileType cs nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

    " Start the omnisharp server for the current solution
    autocmd FileType cs nnoremap <Leader>ss :OmniSharpStartServer<CR>
    autocmd FileType cs nnoremap <Leader>sp :OmniSharpStopServer<CR>
    autocmd FileType cs nnoremap <Leader>sr :OmniSharpRestartServer<CR>

    " Enable snippet completion
    let g:OmniSharp_want_snippet=1
augroup END


"" PLUGIN - ALE
" my enabled linters
let g:ale_linters = {
            \   'python': ['flake8', 'pyls'],
            \   'c': [],
            \   'cpp': [],
            \   'cs': ['OmniSharp'],
            \   'javascript': ['eslint'],
            \   'typescript': ['eslint'],
            \}
" my enabled fixers
let g:ale_fixers = {
            \   'python': ['autopep8'],
            \   'javascript': ['prettier'],
            \   'typescript': ['prettier'],
            \}
nmap <silent> <C-u> <Plug>(ale_next_wrap)
nmap <silent> <S-u> <Plug>(ale_previous_wrap)
nmap <Leader>l :ALELint<cr>
nmap <Leader>fx :ALEFix<cr>
" use quickfix list
let g:ale_set_quickfix = 1
" and have the list open if there are errors
let g:ale_open_list = 1
" do the linting less often (will now only be on save)
let g:ale_lint_on_text_changed = 'never'
"let g:ale_lint_on_insert_leave = 0


"" PLUGIN - NERDTree
" ctrl-n opens the tree
map <c-n> :NERDTreeToggle<cr>


"" PLUGIN - fzf
" add Fzf namespace to all commands
let g:fzf_command_prefix = 'Fzf'
" ctrl-p for fzf files (just like old ctrl-p plugin)
nnoremap <silent> <c-p> :FzfFiles<cr>
" and using ctrl-g for only file in current Git repo
nnoremap <silent> <c-g> :FzfGFiles<cr>
" ctrl f for History, give recent files
nnoremap <silent> <c-f> :FzfHistory<cr>
" <leader>gg for ripgrep (rg) grep of project
nnoremap <silent> <leader>gg :FzfRg<Space>
" <leader>gl for git log (Commits is the command)
nnoremap <silent> <leader>gl :FzfCommits<cr>
" <leader>gl for git log only of file in buffer (BCommits is the command)
nnoremap <silent> <leader>glb :FzfBCommits<cr>
" <ctrl-r> for history of commands ran in vim (like terminal ctrl-r)
nnoremap <silent> <c-r> :FzfHistory:<cr>

" Clean up fzf statusline
augroup fzf
    autocmd!
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
                \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END


"" PLUGIN - vim-test
let test#python#runner = 'pytest'
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>a :TestFile<CR>

"" testing
augroup ceedling_testing_override
    autocmd!
    autocmd FileType c nnoremap <Leader>t :call RunCeedlingTest()<CR>
augroup END

function! RunCeedlingTest()
  :!ceedling clean test:%:t
endfunction



"" NON PLUGIN STUFF
" reload vimrc on save
augroup vimrc
    autocmd!
    autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

" ==== Typing
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab		" makes tab actually spaces
" set to 2 spaces for .js
augroup js_tab_override
    autocmd!
    autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" ==== Controls
" remap redo to shift-r (from ctrl-r) so that ctrl-r can be fzf history
nnoremap <S-r> :redo<cr>

" Delete buffer with leader
nnoremap <Leader>b :bd<CR>
" Escape with jk mashing
inoremap jk <Esc>
inoremap kj <Esc>
inoremap jj <Esc>
inoremap kk <Esc>
inoremap Jj <Esc>
inoremap Jk <Esc>
inoremap JK <Esc>
inoremap JJ <Esc>
" searches are case-insensitive, unless they contain upper-case:
set ignorecase
set smartcase

"" Control hjkl for pane naviation
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

"" shift hl for pane width resizing
nmap <silent> <S-h> 5<c-w>>
nmap <silent> <S-l> 5<c-w><

"" Pane resizing
set winheight=8
set winminheight=8
set winheight=40
set winwidth=8
:silent! set winminwidth=8
:silent! set winminheight=8
set winwidth=85

"" setup relative numbering
set rnu

"" higlight searches
set hlsearch

" autosaving
:au FocusLost * silent! :wa

" trim whitespace
function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction
augroup trim_whitespace
    autocmd!
    autocmd InsertLeave    * :call TrimWhiteSpace()
augroup END

" Line completion shortcut
imap <c-l> <c-x><c-l>

"" Folding
set foldnestmax=2
" c sharp (c#, cs), c
augroup custom_folding
    autocmd!
    au FileType cs,c set omnifunc=syntaxcomplete#Complete
    au FileType cs,c set foldmethod=marker
    au FileType python set foldmethod=indent
    au FileType cs,c set foldmarker={,}
    au FileType cs,c set foldtext=substitute(getline(v:foldstart),'{.*','{...}',)
    au FileType cs set foldlevelstart=2
    au FileType c set foldlevelstart=0
augroup END
" space toggles fold in current area
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

"" Colors!
colorscheme apprentice

augroup custom_filetypes
    autocmd!
    "" Treat .config files like XML
    au BufNewFile, BufRead *.config set filetype=xml
    "" Treat .h files as .c (default is .cpp)
    au BufNewFile, BufRead *.h set filetype=c
augroup END

" Close the help window (this can apply to alot of other things too, but omni is where I'm using it now)
nmap <Leader>pc :pc<CR>

"" Default window size for gvim
if has("gui_running")
    set lines=50 columns=195
endif
