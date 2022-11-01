%{
    // Código en C
    #include <stdio.h>
    #include <string.h>
}%

DIGITO      [0-9]
LETRA       [a-zA-Z]
ESPACIO     [" "]
GUION       [-_]

%%
int main () {
    yylex();
    return 0;
}
