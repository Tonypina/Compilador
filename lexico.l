%{
    // Código en C
    #include <stdio.h>
    #include <string.h>
    
    FILE *archEnt;
%}

DIGITO      [0-9]
LETRA       [a-zA-Z]
ESPACIO     [" "]
GUION       [-_]
PALRES      ALTERNATIVE|BIG|EVALUATE|INSTEAD|LARGE|LOOP|MAKE|NUMBER|OTHER|REAL|REPEAT|SELECT|SMALL|STEP|STOP|SYMBOL|THROW

%%
main (int argc, char *argv[]) {
    yyin = fopen(argv[1],"r");
    archSal = fopen("Entrada.txt","w");
    yylex();
    fclose(archEnt);
}
