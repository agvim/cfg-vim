" Modeline and Notes {
" vim: set sw=2 sts=2 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"   vimrc based on https://github.com/bling/dotvim
" }

" misc stuff {
  set nocompatible

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
      call mkdir(expand(a:path), "p")
    endif
  endfunction " }

  " shell fixes {
    if $SHELL =~ '/fish$'
      " VIM expects to be run from a POSIX shell.
      set shell=sh
    endif
    " use pipes
    set noshelltemp
  " }

  " grep with ag
  if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
  endif

  " vim file/folder management {
    let s:cache_dir = '/tmp/$USER/vimcache'

    " persistent undo
    if exists('+undofile')
      set undofile
      let &undodir = s:get_cache_dir('undo')
    endif

    " swap files
    let &directory = s:get_cache_dir('swap')
    " set noswapfile

    call EnsureExists(s:cache_dir)
    call EnsureExists(&undodir)
    call EnsureExists(&directory)
  " }

  " folding {
    set foldenable
    set foldmethod=syntax
    set foldlevelstart=99
    " fold xml based on syntax
    let g:xml_syntax_folding=1
  " }

  " no menu items
  set guioptions+=t
  " no toolbar icons
  set guioptions-=T

  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \  exe 'normal! g`"zvzz' |
    \ endif
" }

" Main stuff {
  " use comma as the leader key
  let mapleader = ','

  " mouse!
  set mouse=a
  set mousehide

  " Long line wrapping rulez
  set wrap

  " highlight whitespace
  set list
  set listchars=tab:›\ ,trail:•,extends:❯,precedes:❮
  let &showbreak='↪ '

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
  " line numbers
  set number

  " Force md and markdeep files to be recognized as markdown instead of modula or html files
  au BufRead,BufNewFile *.md,*.md.html set filetype=markdown
  " Less identation for the following file types
  autocmd FileType xml,tex,markdown,docbk,xsd,xslt setlocal shiftwidth=2 softtabstop=2
  " automatically strip trailing whitespace for these file types
  autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql,tex,markdown,docbk,xsd,xslt autocmd BufWritePre <buffer> call StripTrailingWhitespace()
  " python is indentation based folding
  autocmd FileType python setlocal foldmethod=indent

  " searching
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase

  "automatically highlight matching braces/brackets/etc.
  set showmatch

  " use OS clipboard
  if has('clipboard')
    " When possible use + register for copy-paste
    if has('unnamedplus')
      set clipboard=unnamed,unnamedplus
    " On Windows, use * register for copy-paste
    else
      set clipboard=unnamed
    endif
  endif

  " use utf-8 as default encoding
  set encoding=utf-8

  "highlight column 80 and the current line
  set colorcolumn=80
  set cursorline

  " enable vim spellchecker
  set spell

  if has('gui_running')
    " Use Fira code font in gvim. In vim is the term font
    set guifont=Fira\ Code\ 11
  endif
" }

" Diffing {
  " Wrapping also for diffs (copies the wrap setting)
  autocmd FilterWritePre * if &diff | setlocal wrap< | endif

  " Ignore whitespaces and tab differences when diffing and use vertical splits
  set diffopt+=iwhite,vertical
  " Use gnu diffutils as it is more powerful, added options are:
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
  " plugins are managed with vim-plug {
  call plug#begin('~/.vim/plugged')

  " solarized color scheme
  Plug 'iCyMind/NeoSolarized' " {
    let g:neosolarized_italic = 1
  " }

  " to use % to go to matching opening/closing tag/char
  Plug 'vim-scripts/matchit.zip'

  " fancy statusline
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-airline/vim-airline' " {
    " do not show default mode
    set noshowmode
    " display buffers list
    let g:airline#extensions#tabline#enabled = 1
    " Do not use the hunks (+0 ~0 -0 stuff in the branch indicator)
    let g:airline#extensions#hunks#enabled = 0
    " use powerline fonts
    let g:airline_powerline_fonts = 1
    " switch tabs with leader + number
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
  " }

  " surround a selected block of text
  Plug 'tpope/vim-surround'

  " show changed lines in the left bar
  Plug 'mhinz/vim-signify' " {
    let g:signify_update_on_bufenter=0
  " }

  " snippets and auto-completion (TODO: tune default configuration) " {
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " if hidden is not set, TextEdit might fail.
    set hidden

    " Some servers have issues with backup files, see #649
    set nobackup
    set nowritebackup

    " " Better display for messages
    " set cmdheight=2

    " You will have bad experience for diagnostic messages when it's default 4000.
    set updatetime=300

    " don't give |ins-completion-menu| messages.
    set shortmess+=c

    " always show signcolumns
    set signcolumn=yes
    " Use tab for trigger completion with characters ahead and navigate.
    " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
    " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " Or use `complete_info` if your vim support it, like:
    " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)

    " Remap for format selected region
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap for do codeAction of current line
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Create mappings for function text object, requires document symbols feature of languageserver.
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
    nmap <silent> <C-d> <Plug>(coc-range-select)
    xmap <silent> <C-d> <Plug>(coc-range-select)

    " Use `:Format` to format current buffer
    command! -nargs=0 Format :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " use `:OR` for organize import of current buffer
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Add status line support, for integration with other plugin, checkout `:h coc-status`
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Using CocList
    " Show all diagnostics
    nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions
    nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
    " Search workspace symbols
    nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list
    nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

    " generig coc extensions
    Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'} "{
      " use with snippets
      Plug 'honza/vim-snippets'
    " }
    Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}

    " language specific coc extensions
    Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
  " }

  " eases sharing and following editor configuration conventions
  Plug 'editorconfig/editorconfig-vim' ", {'on_event':['BufNewFile', 'BufReadPost', 'BufFilePost']}

  " auto closes braces and such
  Plug 'jiangmiao/auto-pairs'

  " show the undo tree in an easier to use form
  Plug 'mbbill/undotree', {'on':'UndotreeToggle'} " {
    let g:undotree_SetFocusWhenToggle=1
    nnoremap <silent> <leader>uu :UndotreeToggle<CR>
  " }

  " file browser
  Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'} " {
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
  Plug 'majutsushi/tagbar', {'on':'TagbarToggle'} " {
    nnoremap <silent> <leader>tt :TagbarToggle<CR>
  " }

  " show indent levels
  Plug 'nathanaelkane/vim-indent-guides' " {
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_auto_colors = 0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#586e75 ctermbg=240
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#839496 ctermbg=244
  " }

  " xml tag closing
  Plug 'sukima/xmledit'

  " finish loading {
  call plug#end()
" }


" General Key (re)Mappings {
  " screen line scroll
  nnoremap <silent> j gj
  nnoremap <silent> k gk

  " reselect visual block after indent
  vnoremap < <gv
  vnoremap > >gv

  " make Y consistent with C and D (yank until end of line).
  nnoremap Y y$
" }

  " enable auto indent and colorized syntax
  filetype plugin indent on
  syntax enable
  set termguicolors
  " let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  " let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  color NeoSolarized
  set background=dark
  " change the terminal title to reflect the filename
  set title
" }
