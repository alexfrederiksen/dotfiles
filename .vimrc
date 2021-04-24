filetype plugin on
syntax on

" Tell vim to actually use the full color potential of kitty (or whatever
" editor I'm using
set termguicolors

call plug#begin(stdpath('data') . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tikhomirov/vim-glsl'
Plug 'lervag/vimtex'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'guns/vim-sexp'
Plug 'luochen1990/rainbow'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'baskerville/vim-sxhkdrc'

call plug#end()
" Set some a pretty cool colorscheme (actually custom scheme now)  

" Some nice indenting settings for things in general
set sw=4
set ts=4
set sts=4
set et

" Nice for writing really long lines in Latex code
set breakindent

" Actually does a proper word wrap
set wrap linebreak

" Pretty cool to have line numbers
set number

" Some really good c++ indentation settings 
set cinoptions=g2,h2,N-s

" VimTex configuration
let g:vimtex_view_general_viewer='zathura'
let g:vimtex_compiler_latexmk = {
        \ 'backend' : 'jobs',
        \ 'background' : 1,
        \ 'build_dir' : '.latex',
        \ 'callback' : 1,
        \ 'continuous' : 1,
        \ 'executable' : 'latexmk',
        \ 'hooks' : [],
        \ 'options' : [
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

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
set statusline^=%#CursorCol#
set statusline+=\ %f%m\ 
set statusline+=%#LineNr#
set statusline+=%=
set statusline+=%#PmenuSel#
set statusline+=[%{coc#status()}%{get(b:,'coc_current_function','')}]
set statusline+=%#LineNr#
set statusline+=\ %l:%c\ 

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

" Syntax color map
map <F10> :LspCxxHlCursorSym<CR>
map <F9> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Mapping for navigating long lines (typically useful in Latex)
nnoremap j gj
nnoremap k gk

" Mapping for navigating open buffers
nnoremap U :b 

" Mapping for switching between header and source files
nnoremap <silent><nowait> <space>w :CocCommand clangd.switchSourceHeader<CR>

" Setup some mappings for sending chicken code to a named pipe (that is read
" from the repl)
vnoremap sk :w >> /tmp/.repl<CR>
nmap sk vaf:w >> /tmp/.repl<CR>
nmap s( :RainbowToggle<CR>

" vim-sexp internal mappings
let g:sexp_mappings = {
    \ 'sexp_outer_list':                'af',
    \ 'sexp_inner_list':                'if',
    \ 'sexp_outer_top_list':            'aF',
    \ 'sexp_inner_top_list':            'iF',
    \ 'sexp_outer_string':              'as',
    \ 'sexp_inner_string':              'is',
    \ 'sexp_outer_element':             'ae',
    \ 'sexp_inner_element':             'ie',
    \ 'sexp_move_to_prev_bracket':      '(',
    \ 'sexp_move_to_next_bracket':      ')',
    \ 'sexp_move_to_prev_element_head': '<M-b>',
    \ 'sexp_move_to_next_element_head': '<M-w>',
    \ 'sexp_move_to_prev_element_tail': 'g<M-e>',
    \ 'sexp_move_to_next_element_tail': '<M-e>',
    \ 'sexp_flow_to_prev_close':        '<M-[>',
    \ 'sexp_flow_to_next_open':         '<M-]>',
    \ 'sexp_flow_to_prev_open':         '<M-{>',
    \ 'sexp_flow_to_next_close':        '<M-}>',
    \ 'sexp_flow_to_prev_leaf_head':    '<M-S-b>',
    \ 'sexp_flow_to_next_leaf_head':    '<M-S-w>',
    \ 'sexp_flow_to_prev_leaf_tail':    '<M-S-g>',
    \ 'sexp_flow_to_next_leaf_tail':    '<M-S-e>',
    \ 'sexp_move_to_prev_top_element':  '[[',
    \ 'sexp_move_to_next_top_element':  ']]',
    \ 'sexp_select_prev_element':       '[e',
    \ 'sexp_select_next_element':       ']e',
    \ 'sexp_indent':                    '==',
    \ 'sexp_indent_top':                '=-',
    \ 'sexp_round_head_wrap_list':      'so',
    \ 'sexp_round_tail_wrap_list':      'sO',
    \ 'sexp_square_head_wrap_list':     '<LocalLeader>[',
    \ 'sexp_square_tail_wrap_list':     '<LocalLeader>]',
    \ 'sexp_curly_head_wrap_list':      '<LocalLeader>{',
    \ 'sexp_curly_tail_wrap_list':      '<LocalLeader>}',
    \ 'sexp_round_head_wrap_element':   'si',
    \ 'sexp_round_tail_wrap_element':   'sI',
    \ 'sexp_square_head_wrap_element':  '<LocalLeader>e[',
    \ 'sexp_square_tail_wrap_element':  '<LocalLeader>e]',
    \ 'sexp_curly_head_wrap_element':   '<LocalLeader>e{',
    \ 'sexp_curly_tail_wrap_element':   '<LocalLeader>e}',
    \ 'sexp_insert_at_list_head':       '<LocalLeader>h',
    \ 'sexp_insert_at_list_tail':       '<LocalLeader>l',
    \ 'sexp_splice_list':               'sW',
    \ 'sexp_convolute':                 '<LocalLeader>?',
    \ 'sexp_raise_list':                '<LocalLeader>o',
    \ 'sexp_raise_element':             '<LocalLeader>O',
    \ 'sexp_swap_list_backward':        '<M-k>',
    \ 'sexp_swap_list_forward':         '<M-j>',
    \ 'sexp_swap_element_backward':     '<M-h>',
    \ 'sexp_swap_element_forward':      '<M-l>',
    \ 'sexp_emit_head_element':         'shl',
    \ 'sexp_emit_tail_element':         'slh',
    \ 'sexp_capture_prev_element':      'shh',
    \ 'sexp_capture_next_element':      'sll',
    \ }

let g:rainbow_conf = {
  \	'guifgs': ['#b3e7dc', '#a6b401', '#eff67b', '#fa5457'],
  \	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
  \	'guis': ['bold'],
  \	'cterms': [''],
  \	'operators': '_,_',
  \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
  \ }

colorscheme gruvbox

" Set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_active = 0 

" Make the matching parentheses actually visible
hi MatchParen guibg=yellow guifg=#000000
" Make background transparent (if not already)
" hi Normal guibg=NONE ctermbg=NONE

