%{
    // Código en C
    #include <stdio.h>
    #include <string.h>

    #define MAX_IDENTIFICADORES 1000

    FILE *yyin;
    FILE *archSal;

    typedef struct Tupla {
        int val;
        char* atom;
    } Tupla;

    typedef struct Id {
        int pos;
        char* name;
        int type;
    } Id;

    typedef struct Token {
        int class;
        int val;
    } Token;
    
    Token a;
    /* Clase 0 */
    /* Estructura para definir palabras reservadas {palabra,valor} */
    Tupla TABLA_PALRESERVADAS[] = {
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
    Tupla TABLA_OPRELACIONALES[] = {
        {0, "<"},
        {1, ">"},
        {2, "<="},
        {3, ">="},
        {4, "=="},
        {5, "!="}
    };

    Id TABLA_IDENTIFICADORES[MAX_IDENTIFICADORES] = {-1, 0, 0};

    Token tokenPalabraReservada(char* palabra);
    Token tokenIdentificadores(char* id);
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

{IDENT}    {a = tokenIdentificadores(yytext); fprintf(archSal, "(%i, %i)\n", a.class, a.val);}
{PALRES}   {a = tokenPalabraReservada(yytext); fprintf(archSal, "(%i, %i)\n", a.class, a.val);}

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
        fclose(yyin);
    }

    return 0;
}


Token tokenPalabraReservada( char* palabra ) {

    Token aux;

    for (int i = 0; i < (*(&TABLA_PALRESERVADAS + 1) - TABLA_PALRESERVADAS); i++) {

        if ( !strcmp(palabra, TABLA_PALRESERVADAS[i].atom) ) {
            aux.class = 0;
            aux.val = i;
            return aux;
        }
    }

    // No es palabra reservada
    printf("Error léxico.\n");
    return aux;
}

Token tokenIdentificadores( char* id ) {

    Token token_aux;
    Id id_aux;

    int ultimo;

    for ( int i = 0; i < MAX_IDENTIFICADORES; i++ ) {
        
        if ( TABLA_IDENTIFICADORES[i].pos == -1 ) {
            ultimo = i;
            break;
        }

        if ( !strcmp(id, TABLA_IDENTIFICADORES[i].name) ) {

            token_aux.class = -1;
            token_aux.val = -1;

            return token_aux; // Ya existe el id
        }
    }
    
    id_aux.pos = ultimo;
    id_aux.name = id;
    id_aux.type = -1;

    TABLA_IDENTIFICADORES[ultimo] = id_aux;

    token_aux.class = 1;
    token_aux.val = ultimo;

    return token_aux;
}