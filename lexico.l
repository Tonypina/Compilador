%{
    // Código en C
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "SLL/SLL.h"

    FILE *yyin;
    FILE *archSal;

    typedef struct Token {
        int class;
        int val;
    } Token;
    
    Token a;
    /* Clase 0 */
    /* Estructura para definir palabras reservadas {palabra,valor} */
    char* PALRESERVADAS[] = {
        "alternative",
        "big",
        "evaluate",
        "instead",
        "large",
        "loop",
        "make",
        "number",
        "other",
        "real",
        "repeat",
        "select",
        "small",
        "step",
        "stop",
        "symbol",
        "throw"
    };

    /* Clase 7 */
    char* OPRELACIONALES[] = {
        "<",
        ">",
        "<=",
        ">=",
        "==",
        "!="
    };

    
    SLL* TABLA_PALRESERVADAS;
    SLL* TABLA_IDENTIFICADORES;
    SLL* TABLA_CTESNUMERICAS;
    SLL* TABLA_CTESREALES;
    SLL* TABLA_CTESCADENAS;
    SLL* TABLA_OPRELACIONALES;

    Token tokenPalabraReservada(char* palabra);
    Token tokenIdentificadores(char* id);
    Token tokenConstantesNumericas(char* cte);
    Token tokenConstantesReales(char* cte);
    Token tokenConstantesCadenas(char* cte);
    Token tokenSimbolosEspeciales(char* s);
    Token tokenOperadoresAritmeticos(char* s);
    Token tokenOperadoresRelacionales(char* s);
    Token tokenOperadorAsignacion(char* s);

    void imprimirTablas();
    char* recortarCadena(char* s);
%}


DIGITO      [0-9]
LETRA       [a-zA-Z]
PALRES      "alternative"|"big"|"evaluate"|"instead"|"large"|"loop"|"make"|"number"|"other"|"real"|"repeat"|"select"|"small"|"step"|"stop"|"symbol"|"throw"
ESPACIO     [" "]
GUION       [-_]

/* Clase 1 */
IDENT       \${LETRA}+{DIGITO}*

/* Clase 2 */
DECIMAL     [1-9]{DIGITO}*
OCTAL       [Oo][0-7]*
ENTERO      {DECIMAL}|{OCTAL}

/* Clase 3 */
REAL        {DIGITO}+[.]{DIGITO}+

/* Clase 4 */
CARACTER    '[^\n"']+'
CADENAS     \"[^\n"']+\"


/* Clase 5 */
SIMESPECIAL    "["|"]"|"("|")"|"{"|"}"|","|":"|";"

/* Clase 6 */
OPARITMETICOS   "+"|"*"|"/"|"%"|"\\"|"^"|"-"

/* Clase 7 */
OPRELACIONALES  "<"|">"|"<="|">="|"=="|"!="

/* Clase 8 */
OPASIGNACION    [=]

%%

{PALRES}         {a = tokenPalabraReservada(strdup(yytext)); fprintf(archSal, "(%i, %i)\n", a.class, a.val);}
{IDENT}          {a = tokenIdentificadores(strdup(yytext)); fprintf(archSal, "(%i, %i)\n", a.class, a.val);}
{ENTERO}         {a = tokenConstantesNumericas(strdup(yytext)); fprintf(archSal, "(%i, %i)\n", a.class, a.val);}
{REAL}           {a = tokenConstantesReales(strdup(yytext)); fprintf(archSal, "(%i, %i)\n", a.class, a.val);}
{CADENAS}        {a = tokenConstantesCadenas(strdup(yytext)), fprintf(archSal, "(%i, %i)\n", a.class, a.val);}
{CARACTER}       {a = tokenConstantesCadenas(strdup(yytext)), fprintf(archSal, "(%i, %i)\n", a.class, a.val);}
{SIMESPECIAL}    {a = tokenSimbolosEspeciales(strdup(yytext)); fprintf(archSal, "(%i, %i)\n", a.class, a.val);}
{OPARITMETICOS}  {a = tokenOperadoresAritmeticos(strdup(yytext)); fprintf(archSal, "(%i, %i)\n", a.class, a.val);}
{OPRELACIONALES} {a = tokenOperadoresRelacionales(strdup(yytext)); fprintf(archSal, "(%i, %i)\n", a.class, a.val);}
{OPASIGNACION}   {a = tokenOperadorAsignacion(strdup(yytext)); fprintf(archSal, "(%i, %i)\n", a.class, a.val);}

"{"[^}\n]*"}"     /* Excluye una linea de comentarios */
[ \t\n] {;}       /* Excluye los espacios en blanco */

%%

int main (int argc, char *argv[]) {

    if ( (yyin = fopen(argv[1], "rt")) == NULL ) {
        printf("No se pudo abrir el archivo de entrada.\n");
        return 1;
    } else {

        if ( (archSal = fopen("Salida.txt","w")) == NULL ) {
            printf("No se pudo abrir el archivo de salida.\n");
            fclose(yyin);
            return 1;
        } else {

            TABLA_PALRESERVADAS = SLL_New();
            TABLA_IDENTIFICADORES = SLL_New();
            TABLA_CTESNUMERICAS = SLL_New();
            TABLA_CTESREALES = SLL_New();
            TABLA_CTESCADENAS = SLL_New();
            TABLA_OPRELACIONALES = SLL_New();

            for (int i = 0; i < (*(&PALRESERVADAS + 1) - PALRESERVADAS)+1; i++) {
                SLL_Insert_back(TABLA_PALRESERVADAS, i, PALRESERVADAS[i], -1);
            }

            for (int i = 0; i < (*(&OPRELACIONALES + 1) - OPRELACIONALES)+1; i++) {
                SLL_Insert_back(TABLA_OPRELACIONALES, i, OPRELACIONALES[i], -1);
            }

            SLL_MakeEmpty(TABLA_IDENTIFICADORES);
            SLL_MakeEmpty(TABLA_CTESNUMERICAS);
            SLL_MakeEmpty(TABLA_CTESREALES);
            SLL_MakeEmpty(TABLA_CTESCADENAS);

            yylex();
        }
    }

    imprimirTablas();

    fclose(archSal);
    fclose(yyin);

    return 0;
}

void imprimirTablas() {
    fprintf(archSal, "\n-------Tabla de Palabras Reservadas--------\n");
    SLL_Print(TABLA_PALRESERVADAS, archSal);
    fprintf(archSal, "\n-------Tabla de Palabras Identificadores--------\n");
    SLL_Print(TABLA_IDENTIFICADORES, archSal);
    fprintf(archSal, "\n-------Tabla de Constantes Enteras--------\n");
    SLL_Print(TABLA_CTESNUMERICAS, archSal);
    fprintf(archSal, "\n-------Tabla de Constantes Reales--------\n");
    SLL_Print(TABLA_CTESREALES, archSal);
    fprintf(archSal, "\n-------Tabla de Constantes Cadenas--------\n");
    SLL_Print(TABLA_CTESCADENAS, archSal);
    fprintf(archSal, "\n-------Tabla de Operadores Relacionales--------\n");
    SLL_Print(TABLA_OPRELACIONALES, archSal);
}

Token tokenPalabraReservada( char* palabra ) {

    Token aux;

    if (SLL_Search(TABLA_PALRESERVADAS, palabra)) {
        aux.class = 0;
        aux.val = TABLA_PALRESERVADAS->cursor->pos;

        return aux;
    }

    // No es palabra reservada
    printf("No es una palabra reservada.\n");
    return aux;
}

Token tokenIdentificadores( char* id ) {

    Token token_aux;

    if (SLL_Search(TABLA_IDENTIFICADORES, id)) {

        printf("Identificador Repetido.");

        return token_aux;
    }

    token_aux.class = 1;
    token_aux.val = SLL_Len(TABLA_IDENTIFICADORES);
    SLL_Insert_back(TABLA_IDENTIFICADORES, SLL_Len(TABLA_IDENTIFICADORES), id, -1);

    return token_aux;
}

Token tokenConstantesNumericas( char* cte ) {

    Token token_aux;

    token_aux.class = 2;
    token_aux.val = SLL_Len(TABLA_CTESNUMERICAS);
    SLL_Insert_back(TABLA_CTESNUMERICAS, SLL_Len(TABLA_CTESNUMERICAS), cte, -1);

    return token_aux;
}

Token tokenConstantesReales( char* cte ) {

    Token token_aux;

    token_aux.class = 3;
    token_aux.val = SLL_Len(TABLA_CTESREALES);
    SLL_Insert_back(TABLA_CTESREALES, SLL_Len(TABLA_CTESREALES), cte, -1);

    return token_aux;
}

Token tokenConstantesCadenas( char* cte ) {

    Token token_aux;

    token_aux.class = 4;
    token_aux.val = SLL_Len(TABLA_CTESCADENAS);
    SLL_Insert_back(TABLA_CTESCADENAS, SLL_Len(TABLA_CTESCADENAS), cte, -1);

    return token_aux;
}

Token tokenSimbolosEspeciales( char* s ) {

    Token token_aux;

    token_aux.class = 5;
    token_aux.val = s[0] + 0;

    return token_aux;
}

Token tokenOperadoresAritmeticos( char* s ) {

    Token token_aux;

    token_aux.class = 6;
    token_aux.val = s[0] + 0;

    return token_aux;
}

Token tokenOperadoresRelacionales( char* s ) {

    Token aux;

    if (SLL_Search(TABLA_OPRELACIONALES, s)) {
        aux.class = 7;
        aux.val = TABLA_OPRELACIONALES->cursor->pos;

        return aux;
    }

    // No es palabra reservada
    printf("Error léxico.\n");
    return aux;
}

Token tokenOperadorAsignacion( char* s ) {

    Token token_aux;

    token_aux.class = 8;
    token_aux.val = s[0] + 0;

    return token_aux;
}
