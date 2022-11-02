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
    
    /* Clase 0 */
    /* Estructura para definir palabras reservadas {palabra,valor,token} */
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


DIGITO      [0-9]
PALRES      alternative|big|evaluate|instead|large|loop|make|number|other|real|repeat|select|small|step|stop|symbol|throw
LETRA       [a-zA-Z]
ESPACIO     [" "]
GUION       [-_]

/* Clase 1 */
IDENT       $[LETRA]+;

/* Clase 2 */
DECIMAL     [1-9](DIGITO)*;
OCTAL       (O-o)[0-7]*;
ENTERO      (DECIMAL|OCTAL);

/* Clase 3 */
REAL        (DECIMAL)+[.](DIGITO)+;

/* Clase 4 */


/* Clase 5 */
SIMESPECIALES   ("["|"]"|"("|")"|"{"|"}"|","|":"|";");

/* Clase 6 */
OPARIMETICOS    ("+"|"-"|"*"|"/"|"%"|"\"|"^");


/* Clase 7 */
OPRELACIONES;


/* Clase 8 */

/* Palabras reservadas */

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