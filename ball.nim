https://github.com/rnowley/nim-ncurses/blob/master/ncurses.nim

proc strcmp(a, b: cstring): cint {.header: "<lncurses.h>".}

echo "Hello World!"
