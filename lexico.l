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
LETRA       [a-zA-Z]
ESPACIO     [" "]
GUION       [-_]

/* Clase 0 */

/* Clase 1 */
IDENT       $[LETRA]+;

/* Clase 2 */
DECIMAL     [1-9](DIGITO)*;
OCTAL       (O-o)[0-7]*;
ENTERO      (DECIMAL|OCTAL);

/* Clase 3 */
REAL        (DECIMAL)+[.](DIGITO)+

/* Clase 4 */


/* Clase 5 */


/* Clase 6 */


/* Clase 7 */


/* Clase 8 */


/* Palabras reservadas */

ALTERNATIVE "alternative"
BIG         "big"
EVALUATE    "evaluate"
INSTEAD     "instead"
LARGE       "large"
LOOP        "loop"
MAKE        "make"
NUMBER      "number"
OTHER       "other"
REAL        "real"
REPEAT      "repeat"
SELECT      "select"
SMALL       "small"
STEP        "step"
STOP        "stop"
SYMBOL      "symbol"
THROW       "throw"

%%

{ALTERNATIVE}   {tokenPalabraReservada(yytext);}
{BIG}           {tokenPalabraReservada(yytext);}
{EVALUATE}      {tokenPalabraReservada(yytext);}
{INSTEAD}       {tokenPalabraReservada(yytext);}
{LARGE}         {tokenPalabraReservada(yytext);}
{LOOP}          {tokenPalabraReservada(yytext);}
{MAKE}          {tokenPalabraReservada(yytext);}
{NUMBER}        {tokenPalabraReservada(yytext);}
{OTHER}         {tokenPalabraReservada(yytext);}
{REAL}          {tokenPalabraReservada(yytext);}
{REPEAT}        {tokenPalabraReservada(yytext);}
{SELECT}        {tokenPalabraReservada(yytext);}
{SMALL}         {tokenPalabraReservada(yytext);}
{STEP}          {tokenPalabraReservada(yytext);}
{STOP}          {tokenPalabraReservada(yytext);}
{SYMBOL}        {tokenPalabraReservada(yytext);}
{THROW}         {tokenPalabraReservada(yytext);}

%%

Token tokenPalabraReservada( char* palabra ) {
    
    for (int i = 0; i < (*(&palabrasReservadas + 1) - palabrasReservadas); i++) {

        if ( !strcmp(palabra, palabrasReservadas[i].str) )
            return {0, (char)i};
    }
}

int main (int argc, char *argv[]) {
    
    yyin = fopen(argv[1],"r");
    archSal = fopen("Entrada.txt","w");
    yylex();
    fclose(archEnt);

    return 0;
}
