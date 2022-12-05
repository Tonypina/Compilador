
/* Fecha: 06 / 12 / 2022 */

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


/*Conjuntos de seleccion*/
C.S.(1)={bg#yx}
C.S.(2)={bg#yx}
C.S.(3)={-|}
C.S.(4)={bg#yx}
C.S.(5)={bg#yx}
C.S.(6)={)}
C.S.(7)={,}
C.S.(8)={)}
C.S.(9)={i}bg#yxcwfjhz[}
C.S.(10)={i}cwfjhz[}
C.S.(11)={bg#yx}
C.S.(12)={bg#yx}
C.S.(13)={b}
C.S.(14)={g}
C.S.(15)={#}
C.S.(16)={y}
C.S.(17)={x}
C.S.(18)={i}
C.S.(19)={;}
C.S.(20)={=}
C.S.(21)={,}
C.S.(22)={n}
C.S.(23)={r}
C.S.(24)={s}
C.S.(25)={;}
C.S.(26)={,}
C.S.(27)={i}
C.S.(28)={s}
C.S.(29)={(inr[}
C.S.(30)={(inr[}
C.S.(31)={+}
C.S.(32)={-}
C.S.(33)={;)}
C.S.(34)={(inr[}
C.S.(35)={*}
C.S.(36)={/}
C.S.(37)={\}
C.S.(38)={%}
C.S.(39)={^}
C.S.(40)={;)+-}
C.S.(41)={(}
C.S.(42)={i}
C.S.(43)={n}
C.S.(44)={r}
C.S.(45)={[}
C.S.(46)={i}
C.S.(47)={n}
C.S.(48)={r}
C.S.(49)={s}
C.S.(50)={>}
C.S.(51)={<}
C.S.(52)={l}
C.S.(53)={e}
C.S.(54)={d}
C.S.(55)={u}
C.S.(56)={i}
C.S.(57)={n}
C.S.(58)={r}
C.S.(59)={s}
C.S.(60)={n}
C.S.(61)={i}
C.S.(62)={r}
C.S.(63)={i}
C.S.(64)={s}
C.S.(65)={i}
C.S.(66)={i}
C.S.(67)={f}
C.S.(68)={h}
C.S.(69)={w}
C.S.(70)={j}
C.S.(71)={[}
C.S.(72)={z}
C.S.(73)={c}
C.S.(74)={}:taoq}
C.S.(75)={icwfjhz[}
C.S.(76)={w}
C.S.(77)={f}
C.S.(78)={t}
C.S.(79)={:}
C.S.(80)={j}
C.S.(81)={i}
C.S.(82)={;}
C.S.(83)={inrs}
C.S.(84)={;}
C.S.(85)={i}
C.S.(86)={)}
C.S.(87)={h}
C.S.(88)={a}
C.S.(89)={}o}
C.S.(90)={o}
C.S.(91)={}}
C.S.(92)={q}
C.S.(93)={}ao}
C.S.(94)={z}
C.S.(95)={inrs}
C.S.(96)={)}
C.S.(97)={[}
C.S.(98)={)}
C.S.(99)={inrs}
C.S.(100)={,}
C.S.(101)={)}


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
