setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
setlocal makeprg=npx\ eslint\ --format\ compact\ --fix\ %
setlocal formatprg=npx\ prettier\ --write\ --parser\ typescript
