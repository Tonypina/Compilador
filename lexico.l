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
    /* Estructura para definir palabras reservadas {palabra,valor} */
    Tupla palabrasReservadas[] = {
        {"alternative", '0'},
        {"big", '1'},
        {"evaluate", '2'},
        {"instead", '3'},
        {"large", '4'},
        {"loop", '5'},
        {"make", '6'},
        {"number", '7'},
        {"other", '8'},
        {"real", '9'},
        {"repeat", '10'},
        {"select", '11'},
        {"small", '12'},
        {"step", '13'},
        {"stop", '14'},
        {"symbol", '15'},
        {"throw", '16'}
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
CARACTER    ([LETRA]|"!"|"""|"#"|"$"|"%"|"&"|"/"|"("|")"|"="|"?"|"¡"|"/"|"*"|"-"|"+"|"¬"|">"|"<"|"¿"|"¬"|"°"|"@");
CADENAS     (("[CARACTER]+")|('[CARACTER]'));


/* Clase 5 */
SIMESPECIALES   ("["|"]"|"("|")"|"{"|"}"|","|":"|";");

/* Clase 6 */
OPARIMETICOS    ("+"|"-"|"*"|"/"|"%"|"\"|"^");


/* Clase 7 */
Tupla OPRELACIONALES[] = {
        {"<", '0'},
        {">", '1'},
        {"<=", '2'},
        {">=", '3'},
        {"==", '4'},
        {"!=", '5'}
    };


/* Clase 8 */
OPASIGNACION    ("=");

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
