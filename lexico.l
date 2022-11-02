%{
    // Código en C
    #include <stdio.h>
    #include <string.h>
    FILE *archEnt;

    typedef struct Tupla {
        char* str;
        char atom;
    };

    typedef struct Token {
        int class;
        char val;
    };

    Tupla palabrasReservadas[] = {
        {"alternative", 'a'},
        {"big", 'b'}
        {"evaluate", 'c'}
        {"instead", 'd'}
        {"large", 'e'}
        {"loop", 'f'}
        {"make", 'g'}
        {"number", 'h'}
        {"other", 'i'}
        {"real", 'j'}
        {"repeat", 'k'}
        {"select", 'l'}
        {"small", 'm'}
        {"step", 'n'}
        {"stop", 'o'}
        {"symbol", 'p'}
        {"throw", 'q'}
    };
%}


/* Estructura para definir palabras reservadas {palabra,valor,atomo} */
DIGITO      [0-9]
ENTERO      {DIGITO}+
LETRA       [a-zA-Z]
ESPACIO     [" "]
GUION       [-_]

/* Clase 0 */
PALRES      alternative|big|evaluate|instead|large|loop|make|number|other|real|repeat|select|small|step|stop|symbol|throw

/* Clase 1 */
IDENT       $[LETRA]+;

/* Clase 2 */
/* ENTERO  */

/* Clase 3 */

/* Clase 4 */

/* Clase 5 */

/* Clase 6 */

/* Clase 7 */

/* Clase 8 */

%%

{PARLES}   {tokenPalabraReservada(yytext);}

%%

Token tokenPalabraReservada( char* palabra ) {
    
    for (int i = 0; i < (*(&palabrasReservadas + 1) - palabrasReservadas); i++) {

        if ( !strcmp(palabra, palabrasReservadas[i].str) )
            return {0, (char)i};
    }

    // No es palabra reservada
    return {-1, -1};
}

int main (int argc, char *argv[]) {
    
    yyin = fopen(argv[1],"r");
    archSal = fopen("Entrada.txt","w");
    yylex();
    fclose(archEnt);

    return 0;
}
