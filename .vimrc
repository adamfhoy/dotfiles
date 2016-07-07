set nocompatible

" Pathogen load
execute pathogen#infect()
syntax on
filetype plugin indent on

" UI Settings
syntax enable           " Enable syntax processing
set nowrap              " Show lines in a single line without wrapping
set showmatch           " Show closing parens and brackets
set number            " Enable line numbers on left side
set nocursorline        " Cursorline underlines the current line
set showcmd             " Show size of block selected
set ruler               " Show line and column number
set wildmenu            " Autocomplete commands with C-N and C-P scrolling
set noerrorbells        " Disable beeps
set scrolloff=5         " Keep 5 lines above or below cursor when scrolling
set sidescroll=1        " Keep lines around cursor for horizontal scrolling
set sidescrolloff=10    " Set horizontal scroll offset to 10
set title               " Change terminal title to filename

" colorscheme
" Currently configured using base16-vim.git
" https://github.com/chriskempson/base16
set background=dark
colorscheme base16-default-dark

" Spaces and  Tabs for Python
set tabstop=4           " Make tabs 4 chars wide
set shiftwidth=4        " Allow < and > to indent regions in visual mode
set autoindent          " Use indent from current line when starting new line
set smarttab            " Use shiftwidth setting when at beginning of line
set expandtab           " Insert spaces instead of /t
set softtabstop=4       " Make bs delete 4 characters (i.e. removes a tab)
set backspace=indent,eol,start  " Allow normal backspace behavior in insert mode

" Git Settings
autocmd Filetype gitcommit setlocal spell textwidth=72

" Pymode Settings
let g:pymode=0
let g:pymode_debug=1
let g:pymode_rope=0
let g:pymode_trim_whitespaces=0

" Search settings
set ignorecase          " Case insensitive search
set smartcase           " Override ignore case if search contains upper case
set hlsearch            " Highlight places where the pattern is found
set incsearch           " Show search result as characters are input

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
