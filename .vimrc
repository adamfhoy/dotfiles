" =======================================================
" General Settings
" =======================================================

" Use Vim defaults
set nocompatible

" Pathogen load
execute pathogen#infect()

" Turn on syntax highlighting
syntax on
filetype plugin on
filetype indent on

" UI Settings
syntax enable           " Enable syntax processing
set nowrap              " Show lines in a single line without wrapping
set showmatch           " Show closing parens and brackets
set number              " Enable line numbers on left side
set nocursorline        " Cursorline underlines the current line
set showcmd             " Show size of block selected
set ruler               " Show line and column number
set wildmenu            " Autocomplete commands with C-N and C-P scrolling
set noerrorbells        " Disable beeps
set scrolloff=5         " Keep 5 lines above or below cursor when scrolling
set sidescroll=1        " Keep lines around cursor for horizontal scrolling
set sidescrolloff=10    " Set horizontal scroll offset to 10
set title               " Change terminal title to filename

" Colorscheme Settings
" Currently configured using base16-vim.git
" https://github.com/chriskempson/base16
" Alternatively use built-in colorscheme darkblue
set background=dark
colorscheme base16-default-dark

" Spaces and  Tabs
set tabstop=4                   " Make tabs 4 chars wide
set shiftwidth=4                " Allow < and > to indent regions in visual mode
set autoindent                  " Use indent from current line when starting new line
set smarttab                    " Use shiftwidth setting when at beginning of line
set expandtab                   " Insert spaces instead of /t
set softtabstop=4               " Make bs delete 4 characters (i.e. removes a tab)
set backspace=indent,eol,start  " Allow normal backspace behavior in insert mode

" Search settings
set ignorecase          " Case insensitive search
set smartcase           " Override ignore case if search contains upper case
set hlsearch            " Highlight places where the pattern is found
set incsearch           " Show search result as characters are input

" When editing file, make screen display the name of the file being edited
" Enabled by default.
let g:SetTitleEnabled = 1
function! SetTitle()
  if exists("g:SetTitleEnabled") && g:SetTitleEnabled && $TERM =~ "^screen"
    let l:title = 'vi: '.expand('%:t')

    if (l:title != 'vi: __Tag_List__')
      let l:truncTitle = strpart(l:title, 0, 15)
      silent exe '!echo -e -n "\033k' . l:truncTitle . '\033\\"'
    endif
  endif
endfunction

" Run it every time the buffer is changed
autocmd BufEnter,BufFilePost * call SetTitle()

" Git Settings
autocmd Filetype gitcommit setlocal spell textwidth=72

" Tmux settings
" allow cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Mapped keys
let mapleader="\<Space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader><Leader> V
map q: :q

" Remap F5 to strip trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" =======================================================
" Language Specific Settings
" =======================================================

" Python Specific Settings
" Pymode Settings
" let g:pymode=0
" let g:pymode_lint_checkers=['pylint', 'pyflakes', 'mccabe']
" let g:pymode_debug=1
" let g:pymode_rope=0
" let g:pymode_trim_whitespaces=0
