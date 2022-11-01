%{
    // Código en C
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    
    FILE *archEnt;
%}

DIGITO      [0-9]
ENTERO      {DIGITO}+
LETRA       [a-zA-Z]
ESPACIO     [" "]
GUION       [-_]
PALRES      ALTERNATIVE|BIG|EVALUATE|INSTEAD|LARGE|LOOP|MAKE|NUMBER|OTHER|REAL|REPEAT|SELECT|SMALL|STEP|STOP|SYMBOL|THROW

//Clase 0

//Clase 1
IDENT       $[LETRA]+;

//Clase 2
ENTERO      

//Clase 3

//Clase 4

//Clase 5

//Clase 6

//Clase 7

//Clase 8

%%
main (int argc, char *argv[]) {
    yyin = fopen(argv[1],"r");
    archSal = fopen("Entrada.txt","w");
    yylex();
    fclose(archEnt);
}
