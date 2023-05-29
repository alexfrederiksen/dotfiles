call plug#begin(stdpath('data') . '/plugged')

call plug#end()

set termguicolors

set sw=4
set ts=4
set sts=4
set et
set breakindent 
set wrap linebreak
set number

set cinoptions=g2,h2,N-s
set completeopt-=preview

nnoremap j gj
nnoremap k gk

autocmd ColorScheme * highlight NormalFloat guibg=NONE
autocmd ColorScheme * highlight FloatBorder guibg=NONE
autocmd ColorScheme * highlight Normal guibg=NONE
autocmd ColorScheme * highlight LineNr guibg=NONE
autocmd ColorScheme * highlight NonText guibg=NONE
autocmd ColorScheme * highlight EndOfBuffer guibg=NONE
autocmd ColorScheme * highlight VertSplit guibg=NONE

colorscheme gruvbox

filetype indent off

set statusline^=%#SignColumn#
set statusline+=\ %f%m\ 
set statusline+=%#LineNr#
set statusline+=%=
set statusline+=%#LineNr#
set statusline+=\ %l:%c\ 

function! ClangFormat()
  let l:lines = "all"
  pyf /usr/share/clang/clang-format.py
endfunction

nnoremap <C-k><C-d> :call ClangFormat()<CR>
