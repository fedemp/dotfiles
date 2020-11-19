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
autocmd  FileType dirvish setlocal statusline=%f

function! MyHighlights() abort
    highlight Comment cterm=italic gui=italic

endfunction
augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

set termguicolors
color seoul256-light

nnoremap <Space> :
nnoremap <C-Space> :FZF<CR>
nnoremap U <c-r>
nnoremap gb :buffers<CR>:b<Space>
nnoremap Q :bd

au TermOpen * setlocal nolist nonumber

let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
set listchars+=tab:¬\ ,trail:_
set tabstop=4 shiftwidth=0 softtabstop=4

set shortmess-=F

function! PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call packager#add('justinmk/vim-dirvish')
  call packager#add('romainl/Apprentice.git')
  call packager#add('editorconfig/editorconfig-vim')
  call packager#add('pangloss/vim-javascript')
  call packager#add('NLKNguyen/papercolor-theme')
  call packager#add('tpope/vim-fugitive')
  call packager#add('tpope/vim-sensible.git')
  call packager#add('junegunn/seoul256.vim')
  call packager#add('neoclide/coc.nvim', { 'branch': 'release', 'do': function('InstallCoc') })
  call packager#add('machakann/vim-sandwich')
  call packager#add('leafgarland/typescript-vim')
endfunction

function! InstallCoc(plugin) abort
  call coc#add_extension('coc-eslint', 'coc-tsserver')
endfunction

command! PackagerInstall call PackagerInit() | call packager#install()
command! -bang PackagerUpdate call PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })
command! PackagerClean call PackagerInit() | call packager#clean()
command! PackagerStatus call PackagerInit() | call packager#status()

" Use `[g` and `]g` to navigate diagnostics
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
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

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

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
" set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}\¦
" set statusline+=%#LineNr#
set statusline+=\ %-.50F
set statusline+=\ %m
set statusline+=%=
" set statusline+=%#CursorColumn#
set statusline+=\ %y
" set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
" set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

set title
set titleold
