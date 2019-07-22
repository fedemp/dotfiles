syntax on
filetype plugin indent on

set clipboard^=unnamedplus

set path=.,,

set gdefault
set ignorecase
set smartcase
set number

set list
set listchars=tab:¬\ ,extends:›,precedes:‹,nbsp:·,trail:·
set showbreak=↪

set cursorline
set foldmethod=indent

set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
set wildignore+=*/min/*,*/vendor/*,*/node_modules/*,*/bower_components/*
set inccommand=nosplit
set diffopt+=internal,algorithm:patience
set diffopt+=iwhiteall

nnoremap <Space> :
nnoremap <BS> <C-^>
nnoremap <C-P> :FZF<CR>
nnoremap U <c-r>
nnoremap <c-w>_ :sp<cr>
nnoremap <c-w><bar> :vsp<cr>
nnoremap gb :buffers<CR>:b<Space>
nnoremap gsb :buffers<CR>:sb<Space>
nnoremap <Tab> :bnext<cr>
nnoremap <S-Tab> :bprevious<cr>

autocmd FileType help nnoremap q :q<cr>

let g:javascript_plugin_flow = 1
