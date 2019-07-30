set hidden
set number
set clipboard^=unnamedplus
set gdefault
set ignorecase
set smartcase
set cursorline
set list
set foldmethod=indent
set nofoldenable " Use `zi`
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
set wildignore+=*/min/*,*/vendor/*,*/node_modules/*,*/bower_components/*
set inccommand=nosplit
set diffopt+=internal,algorithm:patience
set diffopt+=iwhiteall
set path=.,**

" coc.vim specific
set cmdheight=1
set updatetime=300
set shortmess+=c
" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

let g:javascript_plugin_flow = 1

function! MyHighlights() abort
    highlight Comment cterm=italic gui=italic
    hi MatchParen ctermbg=NONE guibg=NONE cterm=italic gui=italic
endfunction
augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

colorscheme apprentice

nnoremap <Space> :
nnoremap <C-P> :FZF<CR>
nnoremap U <c-r>
nnoremap gb :buffers<CR>:b<Space>
nnoremap Q :bd
