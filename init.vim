call plug#begin(stdpath('data') . '/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
Plug 'nvim-treesitter/playground'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'lervag/vimtex'

call plug#end()

" VimTex configuration
let g:vimtex_view_general_viewer='zathura'
let g:vimtex_compiler_progname = 'nvr'

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

lua << EOF

vim.cmd [[ set termguicolors ]]


-- Some nice indenting settings for things in general
vim.cmd [[ set sw=4 ]]
vim.cmd [[ set ts=4 ]]
vim.cmd [[ set sts=4 ]]
vim.cmd [[ set et ]]

-- Nice for writing really long lines in Latex code
vim.cmd [[ set breakindent ]]

-- Actually does a proper word wrap
vim.cmd [[ set wrap linebreak ]]

-- Pretty cool to have line numbers
vim.cmd [[ set number ]]

-- Some really good c++ indentation settings 
vim.cmd [[ set cinoptions=g2,h2,N-s ]]
vim.cmd [[ set completeopt-=preview ]]

vim.cmd [[nnoremap j gj]]
vim.cmd [[nnoremap k gk]]

vim.cmd [[ set conceallevel=3 ]]

-- vim.cmd [[ set cursorline ]]


-- vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]

vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=#111111]]
vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#111111]]
vim.cmd [[autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE ]]

-- vim.cmd [[autocmd ColorScheme * highlight LspDiagnosticsVirtualTextWarning guifg=Orange guibg=#222222 ctermfg=10 ctermbg=NONE ]]
-- vim.cmd [[autocmd ColorScheme * highlight LspDiagnosticsVirtualTextError guifg=Red guibg=#222222 ctermfg=10 ctermbg=NONE ]]

vim.cmd [[ colorscheme zazen ]]

-- local border = {
--       {"╭", "FloatBorder"},
--       {"─", "FloatBorder"},
--       {"╮", "FloatBorder"},
--       {"│", "FloatBorder"},
--       {"╯", "FloatBorder"},
--       {"─", "FloatBorder"},
--       {"╰", "FloatBorder"},
--       {"│", "FloatBorder"},
-- }

local border = {
      {" ", "FloatBorder"},
      {" ", "FloatBorder"},
      {" ", "FloatBorder"},
      {" ", "FloatBorder"},
      {" ", "FloatBorder"},
      {" ", "FloatBorder"},
      {" ", "FloatBorder"},
      {" ", "FloatBorder"},
}

local lsp_status = require('lsp-status')
lsp_status.config({
  status_symbol = ' ',
  current_function = false
})
lsp_status.register_progress()

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

  -- Setup some borders
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = false,
  underline = true,
  update_in_insert = false,
})

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<C-k><C-d>", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  buf_set_keymap("n", "<F10>", "<cmd>TSHighlightCapturesUnderCursor<CR>", opts)
  buf_set_keymap("n", "<space>w", "<cmd>ClangdSwitchSourceHeader<CR>", opts)

  lsp_status.on_attach(client, bufnr)

end


-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local servers = { "clangd", "cmake" }
-- for _, lsp in ipairs(servers) do
--   nvim_lsp[lsp].setup {
--     on_attach = on_attach,
--     flags = {
--       debounce_text_changes = 150,
--     }
--   }
-- end

nvim_lsp.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = lsp_status.capabilities,
  flags = {
    debounce_text_changes = 150
  }
})

nvim_lsp.clangd.setup({
  handlers = lsp_status.extensions.clangd.setup(),
  on_attach = on_attach,
  capabilities = lsp_status.capabilities,
  flags = {
    debounce_text_changes = 150
  }
})

function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  opts = opts or {}

  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

  local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    print(diagnostic_message)
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
end

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "query" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {  },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

function LinkHighlights(hiMap)
    for from, to in pairs(hiMap) do
        vim.cmd (string.format("hi def link %s %s", from, to))
    end
end

LinkHighlights(
{
    ['TSInclude'] = 'Include',
    ['TSNamespace'] = 'Namespace',
    ['TSPunctBracket'] = 'Delimiter',
    ['TSPunctDelimiter'] = 'Delimiter',
    ['TSVariable'] = 'Variable',
    ['TSFunction'] = 'Function',
    ['TSConstructor'] = 'Function',
    ['TSRepeat'] = 'Keyword',
})

EOF

" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

function! GitStatus()
    if g:git_branch != ''
        return '  ' . g:git_branch . ' '
    else
        return ''
    endif
endfunction

function! GetGitBranch()
    let l:is_git_dir = system('echo -n $(git rev-parse --is-inside-work-tree)')
    let g:git_branch = l:is_git_dir == 'true' ?
        \ system('bash -c "echo -n $(git branch --show-current)"') : ''
endfunction

augroup MyGitBranch
  au!
  au BufEnter * call GetGitBranch()
augroup END

set statusline^=%#SignColumn#
set statusline+=\ %f%m\ 
set statusline+=%#LineNr#\ 
set statusline+=%#DiffChange#
set statusline+=%{GitStatus()}
set statusline+=%#LineNr#
set statusline+=%=
set statusline+=%#DiffAdd#
set statusline+=%{LspStatus()}
set statusline+=%#PmenuSel#
set statusline+=%#LineNr#
set statusline+=\ %l:%c\ 
