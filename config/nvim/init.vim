set number
set clipboard^=unnamedplus
set gdefault
set smartcase
set cursorline
set list
set foldmethod=indent
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
set wildignore+=*/min/*,*/vendor/*,*/node_modules/*,*/bower_components/*
set inccommand=nosplit
set diffopt+=internal,algorithm:patience
set diffopt+=iwhiteall
set path=.,**

let g:javascript_plugin_flow = 1

colorscheme apprentice

nnoremap <Space> :
nnoremap <C-P> :FZF<CR>
nnoremap U <c-r>
nnoremap gb :buffers<CR>:b<Space>
