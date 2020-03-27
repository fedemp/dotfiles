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
set diffopt+=vertical
set path=.,**

if filereadable("/usr/share/doc/fzf/examples/fzf.vim")
	source /usr/share/doc/fzf/examples/fzf.vim
endif
if filereadable("/usr/share/doc/fzf/fzf.vim")
	source /usr/share/doc/fzf/fzf.vim
endif

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
autocmd! FileType dirvish
autocmd  FileType dirvish set statusline=%f


" coc.vim specific
set cmdheight=1
set updatetime=300
set shortmess+=c
" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

command! -nargs=0 Format :call CocAction('format')

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=auto

function! MyHighlights() abort
    highlight Comment cterm=italic gui=italic
endfunction
augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

set termguicolors
colorscheme apprentice
" set background=light

nnoremap <Space> :
nnoremap <C-P> :FZF<CR>
nnoremap U <c-r>
nnoremap gb :buffers<CR>:b<Space>
nnoremap Q :bd

au TermOpen * setlocal nolist nonumber

let g:lightline = {
      \ 'colorscheme': 'apprentice',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ }

let g:AutoPairsFlyMode = 0

if has("nvim") && exists("&termguicolors") && &termguicolors
  let g:terminal_color_0    = "#1C1C1C"
  let g:terminal_color_8    = "#444444"
  let g:terminal_color_1    = "#AF5F5F"
  let g:terminal_color_9    = "#FF8700"
  let g:terminal_color_2    = "#5F875F"
  let g:terminal_color_10   = "#87AF87"
  let g:terminal_color_3    = "#87875F"
  let g:terminal_color_11   = "#FFFFAF"
  let g:terminal_color_4    = "#5F87AF"
  let g:terminal_color_12   = "#8FAFD7"
  let g:terminal_color_5    = "#5F5F87"
  let g:terminal_color_13   = "#8787AF"
  let g:terminal_color_6    = "#5F8787"
  let g:terminal_color_14   = "#5FAFAF"
  let g:terminal_color_7    = "#6C6C6C"
  let g:terminal_color_15   = "#FFFFFF"
endif

let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
