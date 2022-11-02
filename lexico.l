%{
    // Código en C
    #include <stdio.h>
    #include <string.h>
    FILE *archEnt;
    FILE *archSal;

    typedef struct Tupla {
        char* str;
        char atom;
    } Tupla;

    typedef struct Token {
        int class;
        char val;
    } Token;

    Tupla palabrasReservadas[] = {
        {"alternative", 'a'},
        {"big", 'b'},
        {"evaluate", 'c'},
        {"instead", 'd'},
        {"large", 'e'},
        {"loop", 'f'},
        {"make", 'g'},
        {"number", 'h'},
        {"other", 'i'},
        {"real", 'j'},
        {"repeat", 'k'},
        {"select", 'l'},
        {"small", 'm'},
        {"step", 'n'},
        {"stop", 'o'},
        {"symbol", 'p'},
        {"throw", 'q'}
    };

    Token tokenPalabraReservada(char* palabra);
%}


/* Estructura para definir palabras reservadas {palabra,valor,atomo} */
DIGITO      [0-9]
ENTERO      {DIGITO}+
PALRES      alternative|big|evaluate|instead|large|loop|make|number|other|real|repeat|select|small|step|stop|symbol|throw
LETRA       [a-zA-Z]
ESPACIO     [" "]
GUION       [-_]

/* Clase 0 */

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

{PALRES}   {printf("%s", yytext);}

%%

int main (int argc, char *argv[]) {
    
    yyin = fopen(argv[1],"r");
    archSal = fopen("Entrada.txt","w");
    yylex();
    fclose(archEnt);

    return 0;
}

Token tokenPalabraReservada( char* palabra ) {

    Token aux;

    for (int i = 0; i < (*(&palabrasReservadas + 1) - palabrasReservadas); i++) {

        if ( !strcmp(palabra, palabrasReservadas[i].str) ) {
            printf("Es una palabra reservada: %s", palabra);
            aux.class = 0;
            aux.val = (char)i;
            return aux;
        }
    }

    // No es palabra reservada
    aux.class = -1;
    aux.val = -1;
    return aux;
}