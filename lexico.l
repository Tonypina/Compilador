%{
    // Código en C
    #include <stdio.h>
    #include <string.h>
    FILE *yyin;
    FILE *archSal;

    typedef struct Tupla {
        int val;
        char* atom;
    } Tupla;

    typedef struct Token {
        int class;
        char atom;
    } Token;
    
    /* Clase 0 */
    /* Estructura para definir palabras reservadas {palabra,valor} */
    Tupla PALRESERVADAS[] = {
        {0, "alternative"},
        {1, "big"},
        {2, "evaluate"},
        {3, "instead"},
        {4, "large"},
        {5, "loop"},
        {6, "make"},
        {7, "number"},
        {8, "other"},
        {9, "real"},
        {10, "repeat"},
        {11, "select"},
        {12, "small"},
        {13, "step"},
        {14, "stop"},
        {15, "symbol"},
        {16, "throw"}
    };

    /* Clase 7 */
    Tupla OPRELACIONALES[] = {
        {0, "<"},
        {1, ">"},
        {2, "<="},
        {3, ">="},
        {4, "=="},
        {5, "!="}
    };

    Token tokenPALRESERVADA(char* palabra);
%}


DIGITO      [0-9]
PALRES      alternative|big|evaluate|instead|large|loop|make|number|other|real|repeat|select|small|step|stop|symbol|throw
LETRA       [a-zA-Z]
ESPACIO     [" "]
GUION       [-_]

/* Clase 1 */
IDENT       $[LETRA]+

/* Clase 2 */
DECIMAL     [1-9](DIGITO)*;
OCTAL       (O-o)[0-7]*;
ENTERO      (DECIMAL|OCTAL);

/* Clase 3 */
REAL        (DECIMAL)+[.](DIGITO)+;

/* Clase 4 */
CARACTER    ([LETRA]|"!"|"""|"#"|"$"|"%"|"&"|"/"|"("|")"|"="|"?"|"¡"|"/"|"*"|"-"|"+"|"¬"|">"|"<"|"¿"|"¬"|"°"|"@");
COMILLAS    (""");
COMILLA     ("'");
CADENAS     (([COMILLAS][CARACTER]+[COMILLAS]")|([COMILLA][CARACTER][COMILLA]));


/* Clase 5 */
SIMESPECIAL    ("["|"]"|"("|")"|"{"|"}"|","|":"|";");

/* Clase 6 */
OPARIMETICOS    ("+"|"-"|"*"|"/"|"%"|"\"|"^");


/* Clase 8 */
OPASIGNACION    ("=");

%%

{IDENT}    fprintf(archSal, "Es un identificador: %s", yytext);
{PALRES}   printf("%s", yytext);

%%

int main (int argc, char *argv[]) {
    
    yyin = fopen(argv[1],"r");
    archSal = fopen("Salida.txt","w");
    yylex();
    fclose(archSal);

    return 0;
}

Token crearToken( char* palabra, const int TIPO ) {

}

Token tokenPalabraReservada( char* palabra ) {

    Token aux;

    for (int i = 0; i < (*(&PALRESERVADAS + 1) - PALRESERVADAS); i++) {

        if ( !strcmp(palabra, PALRESERVADAS[i].atom) ) {
            printf("Es una palabra reservada: %s", palabra);
            aux.class = 0;
            aux.atom = (char)i;
            return aux;
        }
    }

    // No es palabra reservada
    aux.class = -1;
    aux.atom = -1;
    return aux;
}
