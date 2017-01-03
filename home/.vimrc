" Modeline and Notes {
" vim: set sw=2 sts=2 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"   Main stuff i like in vim
" }

" detect OS & misc stuff {
  let s:is_windows = has('win32') || has('win64')
  let s:is_cygwin = has('win32unix')
  let s:is_macvim = has('gui_macvim')

  function! s:get_cache_dir(suffix) " {
    return resolve(expand(s:cache_dir . '/' . a:suffix))
  endfunction " }
  function! Preserve(command) " {
    " preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction " }
  function! StripTrailingWhitespace() " {
    call Preserve("%s/\\s\\+$//e")
  endfunction " }
  function! EnsureExists(path) " {
    if !isdirectory(expand(a:path))
      call mkdir(expand(a:path))
    endif
  endfunction " }

  let s:cache_dir = get(g:dotvim_settings, 'cache_dir', '~/.vim/.cache')

  " shell fixes
  if s:is_windows && !s:is_cygwin
    " ensure correct shell in gvim
    set shell=c:\windows\system32\cmd.exe
  endif
  if $SHELL =~ '/fish$'
    " VIM expects to be run from a POSIX shell.
    set shell=sh
  endif
  " use pipes
  set noshelltemp

  " grep with ag
  if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
  endif

  " vim file/folder management {
    " persistent undo
    if exists('+undofile')
      set undofile
      let &undodir = s:get_cache_dir('undo')
    endif

    " backups
    set backup
    let &backupdir = s:get_cache_dir('backup')

    " swap files
    let &directory = s:get_cache_dir('swap')
    set noswapfile

    call EnsureExists(s:cache_dir)
    call EnsureExists(&undodir)
    call EnsureExists(&backupdir)
    call EnsureExists(&directory)

    " folding
    set foldenable                                      "enable folds by default
    set foldmethod=syntax                               "fold via syntax of files
    set foldlevelstart=99                               "open all folds by default
    let g:xml_syntax_folding=1                          "enable xml folding

    " no menu items
    set guioptions+=t
    " no toolbar icons
    set guioptions-=T

    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \  exe 'normal! g`"zvzz' |
      \ endif
  " }
" }

" Main stuff {
  " mouse!
  set mouse=a
  set mousehide

  " Long line wrapping rulez
  set wrap

  " highlight whitespace
  set list
  set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮
  set showbreak='↪ '

  " allow backspacing everything in insert mode
  set backspace=indent,eol,start
  " automatically indent to match adjacent lines
  set autoindent
  " spaces instead of tabs
  set expandtab
  " use shiftwidth to enter tabs
  set smarttab
  " tabstob should be 8 generally because it is the assumed default
  set ts=8
  " indenting should be 4 spaces by default
  set sts=4
  set sw=4

  " trailing whitespace shaeningans are handled by distribution

  " Less identation for the following file types
  autocmd FileType xml,tex,markdown,docbk,xsd,xslt setlocal shiftwidth=2 softtabstop=2
  autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql,tex,markdown,docbk,xsd,xslt autocmd BufWritePre <buffer> call StripTrailingWhitespace()
  autocmd FileType python setlocal foldmethod=indent
  " Force md files to be recognized as markdown instead of modula files
  au BufRead,BufNewFile *.md set filetype=markdown

  " searching
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase
  "automatically highlight matching braces/brackets/etc.
  set showmatch

  " use OS clipboard
  set clipboard=unnamed

  " use utf-8 as default encoding
  set encoding=utf-8

  "highlight column 80 and the current line
  set colorcolumn=80
  set cursorline

  " " Ruler color fix
  " set background=dark

  if has('gui_running')
    " Use Inconsolata font in gvim. In vim is the term font
    set guifont=Inconsolata\ 12
  endif
" }

" Diffing {
  " Wrapping also for diffs (copies the wrap setting)
  autocmd FilterWritePre * if &diff | setlocal wrap< | endif

  " Ignore whitespaces and tab differences when diffing and use vertical splits
  set diffopt+=iwhite,vertical
  " options are:
  " -w : ignore all white space
  " -B : ignore changes whose lines are all blank
  " --strip-trailing-cr : strip trailing carriage return on input
  " -d : try hard to find a smaller set of changes
  set diffexpr=MyDiff()
  " Empower iwhite option to ignore all white space and blank lines
  function MyDiff()
    let opt = ""
    if &diffopt =~ "icase"
      let opt = opt . "-i "
    endif
    if &diffopt =~ "iwhite"
      let opt = opt . "-w -B "
    endif
    silent execute "!diff -a --binary " . opt . v:fname_in . " " . v:fname_new .
                \  " > " . v:fname_out
  endfunction
" }

" plugins  config {
  " dein {
    set nocompatible
    set all& "reset everything to their defaults
    if s:is_windows
      set rtp+=~/.vim
    endif
    " do not download the full plugin's history
    let g:dein#types#git#clone_depth = 1
    set rtp+=~/.vim/bundle/repos/github.com/Shougo/dein.vim
    call dein#begin(expand('~/.vim/bundle/'))
    call dein#add('Shougo/dein.vim')
  " }

  " solarized color schemes
  call dein#add('agvim/vim-colors-solarized') " {
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
  " }

  " to use % to go to matching opening/closing tag/char
  call dein#add('vim-scripts/matchit.zip')

  " fancy statusline
  call dein#add('vim-airline/vim-airline-themes') " {
    set noshowmode
    " display buffers list
    let g:airline#extensions#tabline#enabled = 1
    " Do not use the hunks (+0 ~0 -0 stuff in the branch indicator)
    let g:airline#extensions#hunks#enabled = 0
    " use powerline fonts
    let g:airline_powerline_fonts = 1
    " let g:airline#extensions#tabline#left_sep = ' '
    " let g:airline#extensions#tabline#left_alt_sep = '¦'
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    nmap <leader>1 <Plug>AirlineSelectTab1
    nmap <leader>2 <Plug>AirlineSelectTab2
    nmap <leader>3 <Plug>AirlineSelectTab3
    nmap <leader>4 <Plug>AirlineSelectTab4
    nmap <leader>5 <Plug>AirlineSelectTab5
    nmap <leader>6 <Plug>AirlineSelectTab6
    nmap <leader>7 <Plug>AirlineSelectTab7
    nmap <leader>8 <Plug>AirlineSelectTab8
    nmap <leader>9 <Plug>AirlineSelectTab9
    " fixes
    " " Use hair space to separate ariline symbols to avoid garbage in gvim
    " if !exists('g:airline_symbols')
    "   let g:airline_symbols = {}
    " endif
    " let g:airline_symbols.space = "\ua0"
  " }
  call dein#add('vim-airline/vim-airline')

  " surround a selected block of text
  call dein#add('tpope/vim-surround')

  " async library. maybe not needed?
  " call dein#add('Shougo/vimproc.vim', {'build': 'make'})

  " show changed lines in the left bar
  call dein#add('mhinz/vim-signify') " {
    let g:signify_update_on_bufenter=0
  " }

  " snippets and auto-completion
  call dein#add('honza/vim-snippets')
  call dein#add('Shougo/neocomplete.vim', {'on_i':1}) " {
    let g:neocomplete#enable_at_startup=1
    let g:neocomplete#data_directory=s:get_cache_dir('neocomplete')
  " }

  " speed up folds
  " call dein#add('Konfekt/FastFold') " {
  "   let g:fastfold_savehook = 1
  "   let g:fastfold_fold_command_suffixes = []
  " " }

  " eases sharing and following editor configuration conventions
  call dein#add('editorconfig/editorconfig-vim', {'on_i':1})

  " auto closes braces and such
  call dein#add('jiangmiao/auto-pairs')

  " " another grep option
  " call dein#add('mileszs/ack.vim') " {
  "   if executable('ag')
  "     let g:ackprg = "ag --nogroup --column --smart-case --follow"
  "   endif
  " " }

  " show the undo tree in an easier to use form
  call dein#add('mbbill/undotree', {'on_cmd':'UndotreeToggle'}) " {
    let g:undotree_SetFocusWhenToggle=1
    nnoremap <silent> <leader>uu :UndotreeToggle<CR>
  " }

  " file browser
  call dein#add('scrooloose/nerdtree', {'on_cmd':['NERDTreeToggle','NERDTreeFind']}) " {
    let NERDTreeShowHidden=1
    let NERDTreeQuitOnOpen=0
    let NERDTreeShowLineNumbers=1
    let NERDTreeChDirMode=0
    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.git','\.hg']
    let NERDTreeBookmarksFile=s:get_cache_dir('NERDTreeBookmarks')
    nnoremap <silent> <leader>ee :NERDTreeToggle<CR>
  " }

  " functions and symbols bar
  call dein#add('majutsushi/tagbar', {'on_cmd':'TagbarToggle'}) " {
    nnoremap <silent> <leader>tt :TagbarToggle<CR>
  " }

  " show indent levels
  call dein#add('nathanaelkane/vim-indent-guides') " {
    " let g:indent_guides_start_level=1
    " let g:indent_guides_guide_size=1
    " let g:indent_guides_enable_on_vim_startup=0
    " let g:indent_guides_color_change_percent=3
    let g:indent_guides_auto_colors = 0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#586e75 ctermbg=240
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#839496 ctermbg=244
  " }

  " syntax checks for various file types
  call dein#add('scrooloose/syntastic') " {
    let g:syntastic_error_symbol = '✗'
    let g:syntastic_style_error_symbol = '✠'
    let g:syntastic_warning_symbol = '∆'
    let g:syntastic_style_warning_symbol = '≈'
    " do not run syntastic checks when quitting
    let g:syntastic_check_on_wq = 0
  " }
" }

" Key (re)Mappings {
  " basic {

    " screen line scroll
    nnoremap <silent> j gj
    nnoremap <silent> k gk

    " reselect visual block after indent
    vnoremap < <gv
    vnoremap > >gv

    " make Y consistent with C and D (yank until end of line).
    nnoremap Y y$
  " }

  " " plugins {
  "   " unite
  "   if isdirectory(expand("~/.vim/bundle/unite.vim/"))
  "     " use same keybindings as ctrl-p and buffergator
  "     nnoremap <silent> <c-p> :Unite -start-insert file<CR>
  "     nnoremap <silent> <leader>bb :Unite buffer<CR>
  "   endif
  " " }
" }

" finish loading {
  if exists('g:dotvim_settings.disabled_plugins')
    for plugin in g:dotvim_settings.disabled_plugins
      call dein#disable(plugin)
    endfor
  endif

  call dein#end()
  if dein#check_install()
    call dein#install()
  endif

  autocmd VimEnter * call dein#call_hook('post_source')

  filetype plugin indent on
  syntax enable
  color solarized
" }
