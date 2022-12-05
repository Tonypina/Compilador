
/* Fecha: 02 / 11 / 2022 */

/* El programa realiza un análisis léxico para un lenguaje definido     */
/* anteriormente, es decir, servirá de primera parte para el compilador */
/* de dicho lenguaje.                                                   */

/*              Autores             */
/* - Piña Rossette Marco Antonio      */
/* - Reyes Mendoza Miriam Guadalupe   */

%{
    /* Cabeceras de utilidad */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    /* Lista Ligada Simple */
    #include "SLL/SLL.h"

    /* Archivo de entrada y salida */
    FILE *yyin;
    FILE *archSal;

    /* Estructura Token */
    typedef struct Token {
        int class;
        int val;
    } Token;
    
    /* Token auxiliar */
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

    /* Tablas basadas en listas ligadas simples */
    SLL* TABLA_PALRESERVADAS;
    SLL* TABLA_IDENTIFICADORES;
    SLL* TABLA_CTESNUMERICAS;
    SLL* TABLA_CTESREALES;
    SLL* TABLA_CTESCADENAS;
    SLL* TABLA_OPRELACIONALES;

    /* Declaración de las funciones que crean tokens */
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

/* Expresiones Regulares */

DIGITO      [0-9]
LETRA       [a-zA-Z]
PALRES      "alternative"|"big"|"evaluate"|"instead"|"large"|"loop"|"make"|"number"|"other"|"real"|"repeat"|"select"|"small"|"step"|"stop"|"symbol"|"throw"
ESPACIO     [" "]
GUION       [-_]

/* Clase 1 */
IDENT       \${LETRA}+

/* Clase 2 */
DECIMAL     [1-9]{DIGITO}*
OCTAL       [Oo][0-7]+
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

/* Función main, abre los archivos e inicializa las tablas */
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

    // Liberación de memoria
    SLL_Delete(&TABLA_PALRESERVADAS);
    SLL_Delete(&TABLA_IDENTIFICADORES);
    SLL_Delete(&TABLA_CTESENTERAS);
    SLL_Delete(&TABLA_CTESNUMERICAS);
    SLL_Delete(&TABLA_CTESREALES);
    SLL_Delete(&TABLA_CTESCADENAS);
    SLL_Delete(&TABLA_OPRELACIONALES);

    fclose(archSal);
    fclose(yyin);

    return 0;
}

/* Imprime las tablas en forma de tuplas ( a, b, c ) */
void imprimirTablas() {
    fprintf(archSal, "\n-------Tabla de Palabras Reservadas--------\n");
    SLL_Print(TABLA_PALRESERVADAS, archSal);
    fprintf(archSal, "\n-------Tabla de Palabras Identificadores--------\n");
    SLL_Print(TABLA_IDENTIFICADORES, archSal);
    fprintf(archSal, "\n-------Tabla de Constantes Enteras--------\n");
    SLL_Print(TABLA_CTESNUMERICAS, archSal);
    fprintf(archSal, "\n-------Tabla de Constantes Numericas--------\n");
    SLL_Print(TABLA_CTESNUMERICAS, archSal);
    fprintf(archSal, "\n-------Tabla de Constantes Reales--------\n");
    SLL_Print(TABLA_CTESREALES, archSal);
    fprintf(archSal, "\n-------Tabla de Constantes Cadenas--------\n");
    SLL_Print(TABLA_CTESCADENAS, archSal);
    fprintf(archSal, "\n-------Tabla de Operadores Relacionales--------\n");
    SLL_Print(TABLA_OPRELACIONALES, archSal);
}

/* Genera token para una palabra reservada */
Token tokenPalabraReservada( char* palabra ) {

    Token aux;

    // Si está en la tabla
    if (SLL_Search(TABLA_PALRESERVADAS, palabra)) {
        aux.class = 0;
        aux.val = TABLA_PALRESERVADAS->cursor->pos;

        return aux;
    }

    // No es palabra reservada
    fprintf(archSal, "ERR: \"%s\" No es una palabra reservada. Se espera $ antes. ", palabra);
    aux.class = -1;
    aux.val = -1;
    return aux;
}

/* Genera token para un identificador */
Token tokenIdentificadores( char* id ) {

    Token token_aux;

    // Si ya existe
    if (SLL_Search(TABLA_IDENTIFICADORES, id)) {

        fprintf(archSal, "ERR: \"%s\" ya existe. ", id);
        token_aux.class = -1;
        token_aux.val = -1;
        return token_aux;
    }

    token_aux.class = 1;
    token_aux.val = SLL_Len(TABLA_IDENTIFICADORES);
    SLL_Insert_back(TABLA_IDENTIFICADORES, SLL_Len(TABLA_IDENTIFICADORES), id, -1);

    return token_aux;
}

/* Genera token de constantes enteras */
Token tokenConstantesNumericas( char* cte ) {

    Token token_aux;

    token_aux.class = 2;
    token_aux.val = SLL_Len(TABLA_CTESENTERAS);
    SLL_Insert_back(TABLA_CTESENTERAS, SLL_Len(TABLA_CTESENTERAS), cte, -1);

    return token_aux;
}

/* Genera token de constantes numericas */
Token tokenConstantesNumericas( char* cte ) {

    Token token_aux;

    token_aux.class = 2;
    token_aux.val = SLL_Len(TABLA_CTESNUMERICAS);
    SLL_Insert_back(TABLA_CTESNUMERICAS, SLL_Len(TABLA_CTESNUMERICAS), cte, -1);

    return token_aux;
}

/* Genera token de constantes reales */
Token tokenConstantesReales( char* cte ) {

    Token token_aux;

    token_aux.class = 3;
    token_aux.val = SLL_Len(TABLA_CTESREALES);
    SLL_Insert_back(TABLA_CTESREALES, SLL_Len(TABLA_CTESREALES), cte, -1);

    return token_aux;
}

/* Genera token de constantes de cadenas */
Token tokenConstantesCadenas( char* cte ) {

    Token token_aux;

    token_aux.class = 4;
    token_aux.val = SLL_Len(TABLA_CTESCADENAS);
    SLL_Insert_back(TABLA_CTESCADENAS, SLL_Len(TABLA_CTESCADENAS), cte, -1);

    return token_aux;
}

/* Genera token de simbolos especiales */
Token tokenSimbolosEspeciales( char* s ) {

    Token token_aux;

    token_aux.class = 5;

    // Se envía el ASCII
    token_aux.val = s[0] + 0;

    return token_aux;
}

/* Genera token de operadores aritméticos */
Token tokenOperadoresAritmeticos( char* s ) {

    Token token_aux;

    token_aux.class = 6;

    // Se envía el ASCII
    token_aux.val = s[0] + 0;

    return token_aux;
}

/* Genra token de operadores relacionales */
Token tokenOperadoresRelacionales( char* s ) {

    Token token_aux;

    if (SLL_Search(TABLA_OPRELACIONALES, s)) {
        token_aux.class = 7;
        token_aux.val = TABLA_OPRELACIONALES->cursor->pos;

        return token_aux;
    }

    // No es operador valido
    fprintf(archSal, "ERR: \"%s\" no es un operador válido. ", s);
    token_aux.class = -1;
    token_aux.val = -1;
    return token_aux;
}

/* Genera token de operadores de asignación */
Token tokenOperadorAsignacion( char* s ) {

    Token token_aux;

    token_aux.class = 8;

    // Se envía el ASCII
    token_aux.val = s[0] + 0;

    return token_aux;
}
