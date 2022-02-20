setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
setlocal makeprg=npx\ eslint\ --format\ compact\ --fix\ %
set formatprg=npx\ prettier\ --write

if exists("loaded_matchit")
  let b:match_ignorecase = 0
  let s:jsx_match_words = '(:),\[:\],{:},<:>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(/\@<!>\|$\):<\@<=/\1>'
  let b:match_words = exists('b:match_words')
    \ ? b:match_words . ',' . s:jsx_match_words
    \ : s:jsx_match_words
endif
