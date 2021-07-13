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

" TODO XXX make a command
" redir => m | silent registers | redir END | put=m

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
  if !exists('g:vscode')
  set number
  endif

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
      let opt = opt . "-w -B --strip-trailing-cr "
    endif
    silent execute "!diff -a --binary " . opt . v:fname_in . " " . v:fname_new .
                \  " > " . v:fname_out
  endfunction
" }

" plugins  config {
  " plugins are managed with vim-plug
  call plug#begin('~/.vim/plugged')

  " solarized color scheme
  Plug 'iCyMind/NeoSolarized' " {
    let g:neosolarized_italic = 1
  " }

  " to use % to go to matching opening/closing tag/char
  Plug 'vim-scripts/matchit.zip'

  " fancy statusline
  if !exists('g:vscode')
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-airline/vim-airline' " {
    " do not show default mode
    set noshowmode
    " display buffers list
    let g:airline#extensions#tabline#enabled = 1
    " Do not use the hunks (+0 ~0 -0 stuff in the branch indicator)
    let g:airline#extensions#hunks#enabled = 0
    " disable the ascii scrollbar
    let g:airline#extensions#scrollbar#enabled = 0
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
  endif

  " surround a selected block of text
  Plug 'tpope/vim-surround'

  " show changed lines in the left bar
  if !exists('g:vscode')
  Plug 'mhinz/vim-signify' " {
    " let g:signify_update_on_bufenter=0
  " }
  endif

  " " webapi and emmet for simpler xml editing
  " if !exists('g:vscode')
  " Plug 'mattn/webapi-vim'
  " Plug 'mattn/emmet-vim'
  " endif

  if !exists('g:vscode') && has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  " Installed modules
  " :TSInstall python
  endif
  " snippets and auto-completion (TODO: tune default configuration)
  if !exists('g:vscode')
  Plug 'neoclide/coc.nvim', {'branch': 'release'} " {
    " disable warnings when using old vim
    let g:coc_disable_startup_warning = 1

    " TextEdit might fail if hidden is not set.
    set hidden

    " Some servers have issues with backup files, see #649.
    set nobackup
    set nowritebackup

    " " Give more space for displaying messages.
    " set cmdheight=2

    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300

    " Don't pass messages to |ins-completion-menu|.
    set shortmess+=c

    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved.
    if has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      set signcolumn=number
    else
      set signcolumn=yes
    endif

    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
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
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif

    " Make <CR> auto-select the first completion item and notify coc.nvim to
    " format on enter, <cr> could be remapped by other vim plugin
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder.
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Applying codeAction to the selected region.
    " Example: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Apply AutoFix to problem on the current line.
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Map function and class text objects
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Remap <C-f> and <C-b> for scroll float windows/popups.
    if has('nvim-0.4.0') || has('patch-8.2.0750')
      nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
      inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
      vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif

    " Use CTRL-S for selections ranges.
    " Requires 'textDocument/selectionRange' support of language server.
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)

    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')

    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Add (Neo)Vim's native statusline support.
    " NOTE: Please see `:h coc-status` for integrations with external plugins that
    " provide custom statusline: lightline.vim, vim-airline.
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Mappings for CoCList
    " Show all diagnostics.
    nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions.
    nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
    " Show commands.
    nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document.
    nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
    " Search workspace symbols.
    nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list.
    nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

    " generic coc extensions
    Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'} "{
      " use with snippets
      Plug 'honza/vim-snippets'
    " }

    " language specific coc extensions
    Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
    Plug 'fannheyward/coc-texlab', {'do': 'yarn install --frozen-lockfile'}
    " link emmet with autocompletion.
    " TODO XXX FIXME: removed as it does not currently integrate custom snippets
    " Plug 'neoclide/coc-emmet', {'do': 'yarn install --frozen-lockfile'}
  " }
  endif

  " highlight word under cursor
  if !exists('g:vscode')
  Plug 'dominikduda/vim_current_word'
  endif

  " highlight colors
  if has('nvim') && !exists('g:vscode')
  Plug 'norcalli/nvim-colorizer.lua'
  endif

  " eases sharing and following editor configuration conventions
  Plug 'editorconfig/editorconfig-vim' ", {'on_event':['BufNewFile', 'BufReadPost', 'BufFilePost']}

  " auto closes braces and such
  Plug 'jiangmiao/auto-pairs' " {
  let g:AutoPairsMapCR = 0
  " }

  " show the undo tree in an easier to use form
  if !exists('g:vscode')
  Plug 'mbbill/undotree', {'on':'UndotreeToggle'} " {
    let g:undotree_SetFocusWhenToggle=1
    nnoremap <silent> <leader>uu :UndotreeToggle<CR>
  " }
  endif

  " file browser
  if !exists('g:vscode')
  " Plug 'ryanoasis/vim-devicons'
  Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'} " {
    " let g:NERDTreeShowHidden = 1
    let g:NERDTreeMinimalUI = 1
    let NERDTreeIgnore=['\.git','\.hg']
    nnoremap <silent> <leader>ee :NERDTreeToggle<CR>
  " }
  endif

  " functions and symbols bar
  if !exists('g:vscode')
  Plug 'majutsushi/tagbar', {'on':'TagbarToggle'} " {
    nnoremap <silent> <leader>tt :TagbarToggle<CR>
  " }
  endif

  " show indent levels
  if !exists('g:vscode')
  if has('nvim')
  Plug 'lukas-reineke/indent-blankline.nvim'
    let g:indent_blankline_show_first_indent_level = v:false
    " let g:indent_blankline_char = '|'
    let g:indent_blankline_use_treesitter = v:true
    let g:indent_blankline_show_current_context = v:true
  " Plug 'Yggdroot/indentLine'
    " let g:indentLine_defaultGroup = 'SpecialKey'
  else
  Plug 'nathanaelkane/vim-indent-guides' " {
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_auto_colors = 0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#586e75 ctermbg=240
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#839496 ctermbg=244
  " }
  endif
  endif

  " xml tag closing, in vscode use auto close tag and auto rename tag
  if !exists('g:vscode')
  Plug 'sukima/xmledit'
  endif
  if !exists('g:vscode')
  Plug 'ryanoasis/vim-devicons'
  endif
  " finish loading
  call plug#end()
" }

  " if !exists('g:vscode')
  " " load custom emmet snippets for emmet-vim ('mattn/emmet-vim')
  " " TODO FIXME: the substitution works if there is no snippet with //
  " let emmet_without_comments = substitute(join(readfile(expand('~/emmet1snippets.json')), "\n"), '//[^\r\n]*', '', 'g')
  " let g:user_emmet_settings = webapi#json#decode(emmet_without_comments)
  " endif


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

" display stuff {
  " enable auto indent and colorized syntax
  filetype plugin indent on
  syntax enable
  set termguicolors
  " let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  " let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  color NeoSolarized
  " background is autodetected by vim
  " set background=dark

  " enable colorizer for all file types
  if has('nvim') && !exists('g:vscode')
  lua require'colorizer'.setup()
  endif
  " highlight current word and copies using the same color as vscode
  " {
    hi CurrentWord guibg=#054150
    hi CurrentWordTwins guibg=#054150
  " }


  " Treesitter stuff
  if has('nvim') && !exists('g:vscode')
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
EOF
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
  endif

" change the terminal title to reflect the filename
  set title

  " vim background redraw bugfix
  if !has('nvim')
    let &t_ut=''
  endif
" }
