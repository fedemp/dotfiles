if exists("b:current_syntax")
  finish
endif

syntax case ignore

" Zeilennummern
syntax match gwbLineNumber /^\d\+\s/

" GW-BASIC Befehle (Statements, Kommandos)
syntax keyword gwbKeyword PRINT INPUT IF THEN ELSE GOTO GOSUB RETURN FOR TO STEP NEXT WHILE WEND DO LOOP END DIM DATA READ RESTORE DEF FN LET REM CLS STOP ON ERROR RESUME CHAIN CLEAR CLOSE COMMON CONT LPRINT LOCATE POKE PEEK OUT SOUND PLAY RANDOMIZE RUN SYSTEM OPEN PUT GET FIELD WIDTH VIEW WINDOW WRITE NAME KILL FILES SHELL

" GW-BASIC Funktionen
syntax keyword gwbFunction ABS ASC ATN CHR$ COS EXP FIX INT INSTR LEFT$ LEN LOG MID$ RIGHT$ RND SGN SIN SQR STR$ STRING$ TAN VAL SPACE$ TIME$ DATE$ INKEY$ FRE EOF LOC LOF TIMER CINT CSNG CDBL

" GW-BASIC Systemvariablen
syntax keyword gwbVariable ERR ERL

" Zahlen
syntax match gwbNumber "\<\d\+\(\.\d*\)\=\([eE][+-]\=\d\+\)\=\>"

" Zeichenketten
syntax region gwbString start=+"+ skip=+""+ end=+"+

" Kommentare
syntax match gwbComment /REM.*/ contains=gwbTodo
syntax match gwbComment /'.*/ contains=gwbTodo

" Zuweisung der Highlighting-Gruppen
highlight link gwbKeyword Statement
highlight link gwbFunction Function
highlight link gwbVariable Identifier
highlight link gwbNumber Number
highlight link gwbString String
highlight link gwbComment Comment
highlight link gwbLineNumber LineNr

let b:current_syntax = "gwbasic"
