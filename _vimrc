set nocompatible

" GUI
colorscheme retrobox
set guifont=Hack\ Nerd\ Font\ Mono:h11
set background=dark
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
set number
set showmode
set notitle

filetype plugin indent on
syntax on

" Editor
set scrolloff=10
set cursorline
set splitbelow
set splitright
set wrap
set nobackup
set noswapfile
set jumpoptions=stack

" Completion
set completeopt=menuone,popup
set pumheight=8

" Indent
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
set cindent

" Searching
set hlsearch
set incsearch
set smartcase

" Netrw
let g:netrw_banner=0

" Keymapping
let mapleader = " "

" C
let c_no_curly_error = 1
let c_functions = 1
let c_function_pointers = 1
let c_comment_strings = 1
let c_gnu = 1
let c_autodoc = 1

" Function

"" Window 
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

"" Tab
nnoremap <silent> [t :tn<CR>
nnoremap <silent> ]t :tp<CR>
nnoremap <silent> [T :tfirst<CR>
nnoremap <silent> ]T :tlast<CR>

"" Buffer
nnoremap <silent> [b :bn<CR>
nnoremap <silent> ]b :bp<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

"" Quickfix
nnoremap <silent> [c :cn<CR>
nnoremap <silent> ]c :cp<CR>
nnoremap <silent> [C :cfirst<CR>
nnoremap <silent> ]C :clast<CR>

"" Yoink
nnoremap <Leader>y "+y
nnoremap <Leader>p "+p
vnoremap <Leader>y "+y
vnoremap <Leader>p "+p

"" Search
nnoremap n nzz
nnoremap N Nzz

"" Misc
map <expr> <F11> &go =~# 's' ? ":se go-=s<CR>" : ":se go+=s<CR>"
inoremap <C-c> <C-[>
nnoremap <C-c> <C-[><cmd>nohlsearch<CR>
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap > >gv 
vnoremap < <gv

" TODO { Fixed
vnoremap ( <Esc>`<i(<Esc>`>a)<Esc>`>v`>f)
vnoremap [ <Esc>`<i[<Esc>`>a]<Esc>`>v`>f]
vnoremap { <Esc>`<i{<Esc>`>a}<Esc>`>v`>f}
vnoremap ) <Esc>`<i(<Esc>`>a)<Esc>`>v`>f)
vnoremap ] <Esc>`<i[<Esc>`>a]<Esc>`>v`>f]
vnoremap } <Esc>`<i{<Esc>`>a}<Esc>`>v`>f}
vnoremap g> <Esc>`<i<<Esc>`>a><Esc>`>v`>f>
vnoremap g< <Esc>`<i<<Esc>`>a><Esc>`>v`>f>
vnoremap g" <Esc>`<i"<Esc>`>a"<Esc>`>v`>f"
vnoremap g' <Esc>`<i'<Esc>`>a'<Esc>`>v`>f'
" TODO }

nnoremap L $
nnoremap H ^
vnoremap L $
vnoremap H ^
onoremap L $
onoremap H ^

nnoremap J mzJ`z

nnoremap <Leader>d <cmd>Ex<CR>
nnoremap <Leader>f :FZF<CR>
