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
        int val;
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

    Token tokenPalabraReservada(char* palabra);
%}


DIGITO      [0-9]
LETRA       [a-zA-Z]
PALRES      "alternative"|"big"|"evaluate"|"instead"|"large"|"loop"|"make"|"number"|"other"|"real"|"repeat"|"select"|"small"|"step"|"stop"|"symbol"|"throw"
ESPACIO     [" "]
GUION       [-_]

/* Clase 1 */
IDENT       ${LETRA}+

/* Clase 2 */
DECIMAL     [1-9]{DIGITO}*
OCTAL       [Oo][0-7]*
ENTERO      {DECIMAL}|{OCTAL}

/* Clase 3 */
REAL        {DECIMAL}+[.]{DIGITO}+

/* Clase 4 */
CARACTER    '[{LETRA}!"#$%&/|=?¡/*-+¬><¿¬°@]'
CADENAS     "[{LETRA}!"#$%&/|=?¡/*-+¬><¿¬°@]+"


/* Clase 5 */
SIMESPECIAL    ("["|"]"|"("|")"|"{"|"}"|","|":"|";");

/* Clase 6 */
OPARIMETICOS    ("+"|"-"|"*"|"/"|"%"|"\"|"^");

/* Clase 7 */
OPRELACIONALES  ("<"|">"|"<="|">="|"=="|"!=");

/* Clase 8 */
OPASIGNACION    ("=");

%%

{IDENT}    printf("Es un identificador: %s", yytext);
{PALRES}   {Token a = tokenPalabraReservada(yytext); fprintf(archSal, "(%i, %i)", a.class, a.val);}

%%

int main (int argc, char *argv[]) {
    
    if ( (yyin = fopen(argv[1], "rt")) == NULL ) {
        printf("No se pudo abrir el archivo de entrada.\n");
        return 1;
    } else {

        if ( (archSal = fopen("Salida.txt","w")) == NULL ) {
            printf("No se pudo abrir el archivo de salida.\n");
            return 1;
        } else {
            yylex();
        }

        fclose(archSal);
    }

    return 0;
}

Token crearToken( char* palabra, const int TIPO ) {

}

Token tokenPalabraReservada( char* palabra ) {

    Token aux;

    for (int i = 0; i < (*(&PALRESERVADAS + 1) - PALRESERVADAS); i++) {

        if ( !strcmp(palabra, PALRESERVADAS[i].atom) ) {
            aux.class = 0;
            aux.val = i;
            return aux;
        }
    }

    // No es palabra reservada
    aux.class = -1;
    aux.val = -1;
    return aux;
}
