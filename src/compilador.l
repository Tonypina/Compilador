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
    

    #define IDENT_ATOM  'i'
    #define CTENUM_ATOM 'n'
    #define CTEREA_ATOM 'r'
    #define CTECAD_ATOM 's'
    #define IGUAL_ATOM  '='

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

    char PALRESERVADAS_ATOMS[] = {
        'a',
        'b',
        'f',
        't',
        'g',
        'w',
        'm',
        '#',
        'o',
        'x',
        'j',
        'h',
        'p',
        'c',
        'q',
        'y',
        'z'
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
    
    char OPRELACIONALES_ATOMS[] = {
        '<',
        '>',
        '|',
        'u',
        'e',
        'd'
    };

    /* Tablas basadas en listas ligadas simples */
    SLL* TABLA_PALRESERVADAS;
    SLL* TABLA_IDENTIFICADORES;
    SLL* TABLA_CTESNUMERICAS;
    SLL* TABLA_CTESREALES;
    SLL* TABLA_CTESCADENAS;
    SLL* TABLA_OPRELACIONALES;

    /* Declaración de la cadena de átomos */
    char* atoms = "";

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

    bool Program();
    bool OtraFunc();
    bool Func();
    bool Param();
    bool OtroParam();
    bool Cuerpo();
    bool Decl();
    bool D();
    bool Tipo();
    bool K();
    bool Q();
    bool N();
    bool C();
    bool A();
    bool AP();
    bool E();
    bool EP();
    bool T();
    bool TP();
    bool F();
    bool R();
    bool RP();
    bool V();
    bool VP();
    bool VPP();
    bool VPPP();
    bool P();
    bool ListaP();
    bool W();
    bool I();
    bool IP();
    bool J();
    bool Y();
    bool X();
    bool Z();
    bool H();
    bool CP();
    bool OP();
    bool U();
    bool Devuelve();
    bool Valor();
    bool Llama();
    bool Arg();
    bool otroArg();
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
OPASIGNACION    "="


/*Conjuntos de seleccion*/


/*Definición de expresiones regulares para componentes léxicos*/

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
                SLL_Insert_back(TABLA_PALRESERVADAS, i, PALRESERVADAS[i], PALRESERVADAS_ATOMS[i]);
            }

            for (int i = 0; i < (*(&OPRELACIONALES + 1) - OPRELACIONALES)+1; i++) {
                SLL_Insert_back(TABLA_OPRELACIONALES, i, OPRELACIONALES[i], OPRELACIONALES_ATOMS[i]);
            }

            SLL_MakeEmpty(TABLA_IDENTIFICADORES);
            SLL_MakeEmpty(TABLA_CTESNUMERICAS);
            SLL_MakeEmpty(TABLA_CTESREALES);
            SLL_MakeEmpty(TABLA_CTESCADENAS);

            yylex();
                    
            Program();
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
    fprintf(archSal, "\n-------Tabla de Constantes Enteras--------\n");
    SLL_Print(TABLA_CTESNUMERICAS, archSal);
    fprintf(archSal, "\n-------Tabla de Constantes Reales--------\n");
    SLL_Print(TABLA_CTESREALES, archSal);
    fprintf(archSal, "\n-------Tabla de Constantes Cadenas--------\n");
    SLL_Print(TABLA_CTESCADENAS, archSal);
    fprintf(archSal, "\n-------Tabla de Operadores Relacionales--------\n");
    SLL_Print(TABLA_OPRELACIONALES, archSal);
    fprintf(archSal, "\n-------Cadena de Átomos--------\n");
    fprintf(archSal, "%s", atoms);
}

char* append(const char * str, char c)
{
    char* new_string = malloc(strlen(str)+2);  // add 2 to make room for the character we will append and the null termination character at the end
    if (new_string) {
        strcpy(new_string, str);
        new_string[strlen(new_string)] = c;
    }
    return new_string;
}

/* Genera token para una palabra reservada */
Token tokenPalabraReservada( char* palabra ) {

    Token aux;

    // Si está en la tabla
    if (SLL_Search(TABLA_PALRESERVADAS, palabra)) {
        aux.class = 0;
        aux.val = TABLA_PALRESERVADAS->cursor->pos;

        atoms = append(atoms, TABLA_PALRESERVADAS->cursor->atom);

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

    atoms = append(atoms, IDENT_ATOM);

    SLL_Insert_back(TABLA_IDENTIFICADORES, SLL_Len(TABLA_IDENTIFICADORES), id, IDENT_ATOM);

    return token_aux;
}

/* Genera token de constantes numericas */
Token tokenConstantesNumericas( char* cte ) {

    Token token_aux;

    token_aux.class = 2;
    token_aux.val = SLL_Len(TABLA_CTESNUMERICAS);

    atoms = append(atoms, CTENUM_ATOM);

    SLL_Insert_back(TABLA_CTESNUMERICAS, SLL_Len(TABLA_CTESNUMERICAS), cte, CTENUM_ATOM);

    return token_aux;
}

/* Genera token de constantes reales */
Token tokenConstantesReales( char* cte ) {

    Token token_aux;

    token_aux.class = 3;
    token_aux.val = SLL_Len(TABLA_CTESREALES);

    atoms = append(atoms, CTEREA_ATOM);

    SLL_Insert_back(TABLA_CTESREALES, SLL_Len(TABLA_CTESREALES), cte, CTEREA_ATOM);

    return token_aux;
}

/* Genera token de constantes de cadenas */
Token tokenConstantesCadenas( char* cte ) {

    Token token_aux;

    token_aux.class = 4;
    token_aux.val = SLL_Len(TABLA_CTESCADENAS);

    atoms = append(atoms, CTECAD_ATOM);

    SLL_Insert_back(TABLA_CTESCADENAS, SLL_Len(TABLA_CTESCADENAS), cte, CTECAD_ATOM);

    return token_aux;
}

/* Genera token de simbolos especiales */
Token tokenSimbolosEspeciales( char* s ) {

    Token token_aux;

    token_aux.class = 5;

    // Se envía el ASCII
    token_aux.val = s[0] + 0;

    atoms = strcat(atoms, s);

    return token_aux;
}

/* Genera token de operadores aritméticos */
Token tokenOperadoresAritmeticos( char* s ) {

    Token token_aux;

    token_aux.class = 6;

    // Se envía el ASCII
    token_aux.val = s[0] + 0;

    atoms = strcat(atoms, s);

    return token_aux;
}

/* Genra token de operadores relacionales */
Token tokenOperadoresRelacionales( char* s ) {

    Token token_aux;

    if (SLL_Search(TABLA_OPRELACIONALES, s)) {
        token_aux.class = 7;
        token_aux.val = TABLA_OPRELACIONALES->cursor->pos;

        atoms = append(atoms, TABLA_OPRELACIONALES->cursor->atom);

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

    atoms = strcat(atoms, s);

    return token_aux;
}


/*Funciones Analizador*/
/*1*/
bool Program() {

    if (Func()) {
        if (OtraFunc()) {
            printf("El programa compiló\n\n");
            return true;
        }
    }

    printf("Error de parser\n\n");
}

/*2 - 3*/
bool OtraFunc() {

    if (Func()) {
        OtraFunc();
        return true;
    }

    return false;
}

/*4*/
bool Func() {
    
    if (Tipo()){

        if (*atoms == 'i') {
            atoms++;

            if (*atoms == '(') {
                atoms++;
                Param();

                if (*atoms == ')') {
                    atoms++;

                    if (*atoms == '{') {
                        atoms++;
                        Cuerpo();

                        if (*atoms == '}') {
                            atoms++;
                            return true;

                        } else {
                            printf("Error, se esperaba }\n");
                        }

                    } else {
                        printf("Error, se esperaba {\n");
                    }

                } else {
                    printf("Error, se esperaba )\n");
                }

            } else {
                printf("Error, se esperaba (\n");
            }

        } else {
            printf("Error, se esperaba un identificador.\n");
        }

    } else {
        printf("Se esperaba el tipo de la función.\n");
    }

    return false;
}

/*5 - 6*/
bool Param() {
    if (Tipo()) {

        if (*atoms == 'i') {
            atoms++;
            OtroParam();
            return true;

        } else {
            printf("Error, se esperaba un identificador.\n");
        }
    }

    return false;
}


/*7 - 8*/
bool OtroParam() {

    if (*atoms == ',') {
        atoms++;

        if (Tipo()) {

            if (*atoms == 'i') {
                atoms++;
                OtroParam();
                return true;

            } else {
                printf("Error, se esperaba un identificador.\n");
            }     
        } else {
            printf("Error, se esperaba el tipo de dato.\n");
        }
    }

    return false;
}

/*9*/
bool Cuerpo() {

    Decl();
    ListaP();
}

/*10 - 11*/
bool Decl() {
    if (D()) {
        Decl();
        return true;
    }

    return false;
}

/*Sentencia Declarativa*/
/*12*/
bool D() {
    if (Tipo()) {
        if (K()) {
            // atoms++;

            if (*atoms == ';') {
                atoms++;
                return true;
            
            } else {
                printf("Error, se esperaba ;\n");
            }
        }
    }

    return false;
}

/*13 - 17*/
bool Tipo() {

    if (*atoms == 'b' ||
        *atoms == 'g' ||
        *atoms == '#' ||
        *atoms == 'y' ||
        *atoms == 'x' ) {
        
        atoms++;
        return true;

    } else {
        printf("Error, se esperaba un tipo de dato válido.\n");
    }

    return false;
}

/*18*/
bool K() {
    // atoms++;

    if (*atoms == 'i') {
        atoms++;
        Q();
        return true;

    } else {
        printf("Error, se esperaba un identificador.\n");
    }

    return false;
}

/*19 - 21*/
bool Q() {
    // atoms++;

    if (*atoms == '=') {
        atoms++;
        if (N()) {
            C();
            return true;
        
        } else  {
            printf("Error, se esperaba un valor.\n");
        }

    } else if (*atoms == ',') {
        atoms++;
        if (K()) {
            return true;
        }

    } else {
        return false;
    }
}

/*22 - 24*/
bool N() {
    // atoms++;

    if (
        *atoms == 'n' ||
        *atoms == 'r' ||
        *atoms == 's'
    ) {
        atoms++;
        return true;

    } else {
        printf("Error, se esperaba un valor para el dato.\n");
    }

    return false;
}

/*25 - 26*/
bool C() {
    // atoms++;

    if (*atoms == ',') {
        atoms++;
        if (K()) {
            return true;
        }
    }

    return false;
}


/*Sentencia de Asignacion*/
/*27*/
bool A() {
    // atoms++;

    if (*atoms == 'i') {
        atoms++;

        if (*atoms == '=') {
            atoms++;
            if (AP()) {
                // atoms++;

                if (*atoms == ';') {
                    atoms++;
                    return true;

                } else {
                    printf("Error, se esperaba un ;\n");
                }
            }
        } else {
            printf("Error, se esperaba un =\n");
        }

    } else {
        printf("Error, se esperaba un identificador.\n");
    }

    return false;
}

/*28 - 29*/
bool AP() {
    // atoms++;

    if (*atoms == 's') {
        atoms++;
        return true;
    
    } else if (E()) {
        return true;
    
    }

    return false;
}


/*Expresion Aritmetica*/
/*30*/
bool E() {
    if (T()) {
        EP();
        return true;
    } else {

        printf("Error, expresión incorrecta.\n");
    }

    return false;
}

/*31 - 33*/
bool EP() {
    // atoms++;

    if (*atoms == '+' ||
        *atoms == '-'
    ) {
        atoms++;
        if (T()) {
            EP();
            return true;
        }
    }

    return false;
}

/*34*/
bool T() {
    if (F()) {
        TP();
        return true;
    }

    return false;
}

/*35 - 40*/
bool TP() {
    // atoms++;

    if (*atoms == '*' ||
        *atoms == '/' ||    
        *atoms == '\\' ||    
        *atoms == '%' ||    
        *atoms == '^'
    ) {
        atoms++;
        if (F()) {
            TP();
            return true;
        }

    } else {
        printf("Error, se esperaba un operador aritmetico.\n");
    }

    return false;
}


/*41 - 44*/
bool F() {
    // atoms++;

    if (*atoms == '(') {
        atoms++;
        if (E()) {
            // atoms++;

            if (*atoms == ')') {
                atoms++;
                return true;
            
            } else {
                printf("Error, se esperaba )\n");
            }
        }

    } else if (*atoms == 'i' ||
               *atoms == 'n' ||
               *atoms == 'r'
    ) {
        atoms++;
        return true;
    
    } else {
        if (Llama()) {
            return true;
        }
    }

    return false;
}


/*Expresion Relacional*/
/*46 - 49*/
bool R() {
    // atoms++;
    
    if (*atoms == 'i') {
        atoms++;
        if (RP()) {
            if (V()) {
                return true;
            }
        }
    }
    
    else if (*atoms == 'n') {
        atoms++;
        if (RP()) {
            if (VP()) {
                return true;
            }
        }
    }
    
    else if (*atoms == 'r') {
        atoms++;
        if (RP()) {
            if (VPP()) {
                return true;
            }
        }
    }
    
    else if (*atoms == 's') {
        atoms++;
        if (RP()) {
            if (VPPP()) {
                return true;
            }
        }
    }

    return false;
}

/*50 - 55*/
bool RP() {
    // atoms++;

    if (
        *atoms == '>' ||
        *atoms == '<' ||
        *atoms == 'l' ||
        *atoms == 'e' ||
        *atoms == 'd' ||
        *atoms == 'u'
    ) {
        atoms++;
        return true;
    }

    return false;
}

/*56 - 59*/
bool V() {
    atoms++;

    if (
        *atoms == 'i' ||
        *atoms == 'n' ||
        *atoms == 'r' ||
        *atoms == 's'
    ) {
        atoms++;
        return true;
    }

    return false;
}

/*60 - 61*/
bool VP() {
    // atoms++;

    if (
        *atoms == 'i' ||
        *atoms == 'n'
    ) {
        atoms++;
        return true;
    }

    return false;
}

/*62 - 63*/
bool VPP() {
    // atoms++;

    if (
        *atoms == 'i' ||
        *atoms == 'r'
    ) {
        atoms++;
        return true;
    }

    return false;
}

/*64 - 65*/
bool VPPP() {
    // atoms++;

    if (
        *atoms == 'i' ||
        *atoms == 's'
    ) {
        atoms++;
        return true;
    }

    return false;
}


/*Proposiciones*/
/*66 - 73*/
bool P() {
    if (*atoms == 'i') {
        atoms++;
        A();
        return true;

    } else if (*atoms == 'f') {
        atoms++;
        I();
        return true;

    } else if (*atoms == 'h') {
        atoms++;
        H();
        return true;

    } else if (*atoms == 'w') {
        atoms++;
        W();
        return true;

    } else if (*atoms == 'j') {
        atoms++;
        J();
        return true;

    } else if (*atoms == '[') {
        atoms++;
        Llama();
        return true;

    } else if (*atoms == 'z') {
        atoms++;
        Devuelve();
        return true;

    } else if (*atoms == 'c') {
        atoms++;

        if (*atoms == ';') {
            atoms++;
            return true;

        } else {
            printf("Error, se esperaba un ;\n");

        }
    }

    return false;
}


/* Lista de 0 más proposiciones*/
/*74 - 75*/
bool ListaP() {
    if (P()) {
        ListaP();
        return true;
    }

    return false;
}


/*Sentencia Loop*/
/*76*/
bool W() {
    // atoms++;

    if (*atoms == 'w') {
        atoms++;

        if (*atoms == '(') {
            atoms++;

            if (R()) {
                // atoms++;

                if (*atoms == ')') {
                    atoms++;

                    if (*atoms == 'm') {
                        atoms++;

                        if (*atoms == '{') {
                            atoms++;
                            ListaP();

                            if (*atoms == '}') {
                                atoms++;
                                return true; 

                            } else {
                                printf("Error, se esperaba un }\n");
                            }

                        } else {
                            printf("Error, se esperaba un {\n");
                        }

                    } else {
                        printf("Error, se esperaba un m\n");
                    }

                } else {
                    printf("Error, se esperaba un )\n");
                }
            }

        } else {
            printf("Error, se esperaba un (\n");
        }
    
    } else {
        printf("Error, se esperaba un while\n");
    }

    return false;
}


/*Sentencia Evaluate*/
/*77*/
bool I() {
    // atoms++;

    if (*atoms == 'f') {
        atoms++;

        if (*atoms == '(') {
            atoms++;

            if (R()) {
                // atoms++;

                if (*atoms == ')') {
                    atoms++;
                    ListaP();

                    if (IP()) {
                        // atoms++;

                        if (*atoms == ':') {
                            atoms++;
                            return true;

                        } else {
                            printf("Error, se esperaba un :\n");
                        }
                    }

                } else {
                    printf("Error, se esperaba )\n");
                }
            
            }

        } else {
            printf("Error, se esperaba un (\n");
        }

    } else {
        printf("Error, se esperaba una f\n");
    }
}


/*78 - 79*/
bool IP() {
    // atoms++;

    if (*atoms == 't') {
        atoms++;
        ListaP();
        return true;
    }

    return false;
}


/*Sentencia Repeat*/
/*80*/
bool J() {
    // atoms++;

    if (*atoms == 'j') {
        atoms++;

        if (*atoms == '(') {
            atoms++;

            if (Y()) {

                if (X()) {

                    if (Z()) {
                        // atoms++;

                        if (*atoms == '{') {
                            atoms++;

                            ListaP();

                            if (*atoms == '}') {
                                atoms++;
                                return true;

                            } else {
                                printf("Error, se esperaba un }\n");
                            }

                        } else {
                            printf("Error, se esperaba un {\n");
                        }
                    }
                }
            }

        } else {
            printf("Error, se esperaba un (\n");
        }

    } else {
        printf("Error, se esperaba un j\n");
    }

    return false;
}

/*81 - 82*/
bool Y() {
    // atoms++; 

    if (*atoms == 'i') {
        atoms++;

        if (*atoms == '=') {
            atoms++;

            if (E()) {
                return true;
            }

        } else {
            printf("Error, se esperaba un =\n");
        }

    } else if (*atoms == ';') {
        atoms++;
        return true;

    } else {
        printf("Error, se esperaba un i o ;\n");
    }

    return false;
}

/*83 - 84*/
bool X() {
    if (R()) {
        // atoms++;

        if (*atoms == ';') {
            atoms++;
            return true;
        }
    } else if (*atoms == ';') {
        atoms++;
        return true;

    } else {
        printf("Error, se esperaba un ;\n");
    }

    return false;
}

/*85 - 86*/
bool Z() {
    // atoms++;

    if (*atoms == 'i') {
        atoms++;

        if (*atoms == '=') {
            atoms++;

            if (E()) {

                if (*atoms == ')') {
                    atoms++;
                    return true;
                
                } else {
                    printf("Error, se esperaba un )\n");
                }
            }

        } else {
            printf("Error, se esperaba un =\n");
        }
    
    } else {
        printf("Error, se esperaba un i\n");
    }

    return false;
}


/*Sentencia Select*/
/*87*/
bool H() {
    // atoms++;

    if (*atoms == 'h') {
        atoms++;

        if (*atoms == ')') {
            atoms++;

            if (*atoms == 'i') {
                atoms++;

                if (*atoms == ')') {
                    atoms++;

                    if (*atoms == '{') {
                        atoms++;
                        CP();
                        OP();

                        if (*atoms == '}') {
                            atoms++;
                            return true;
                        
                        } else {
                            printf("Error, se esperaaba un }\n");
                        }

                    } else {
                        printf("Error, se esperaba un {\n");
                    }

                } else {
                    printf("Error, se esperaba un )\n");
                }

            } else {
                printf("Error, se esperaba un i\n");
            }

        } else {
            printf("Error, se esperaba un (\n");
        }

    } else {
        printf("Error, se esperaba un h\n");
    }
}

/*88 - 89*/
bool CP() {
    // atoms++;

    if (*atoms == 'a') {
        atoms++;

        if (*atoms == 'n') {
            atoms++;

            if (*atoms == ':') {
                atoms++;

                ListaP();
                U();
                CP();
                return true;

            } else {
                printf("Error, se esperaba un :\n");
            }   
        } else {
            printf("Error, se esperaba una n\n");
        }
    } else {
        printf("Error, se esperaba una a\n");
    }

    return false;
}

/*90 - 91*/
bool OP() {
    // atoms++;

    if (*atoms == 'o') {
        atoms++;

        if (*atoms == ':') {
            atoms++;

            ListaP();
            return true;
               
        } else {
            printf("Error, se esperaba un :\n");
        }
    } else {
        printf("Error, se esperaba una o\n");
    }

    return false;
}

/*92 - 93*/
bool U() {
    // atoms++;

    if (*atoms == 'q') {
        atoms++;
        return true;
    } else {
        printf("Error, se esperaba un q\n");
    }

    return false;
}


/*Sentencia Throw*/
/*94*/
bool Devuelve() {
    // atoms++;

    if (*atoms == 'z') {
        atoms++;

        if (*atoms == '(') {
            atoms++;
            Valor();

            if (*atoms == ')') {
                atoms++;

                if (*atoms == ';') {
                    atoms++;
                    return true;

                } else {
                    printf("Error, se esperaba un ;\n");
                }

            } else {
                printf("Error, se esperaba un )\n");
            }

        } else {
            printf("Error, se esperaba un (\n");
        }
        
    } else {
        printf("Error, se esperaba un z\n");
    }

    return false;
}

/*95 - 96*/
bool Valor() {
    return V();
}

/*Llama a una funcion*/
/*97*/
bool Llama() {
    // atoms++;

    if (*atoms == '[') {
        atoms++;

        if (*atoms == 'i') {
            atoms++;

            if (*atoms == '(') {
                atoms++;
                
                Arg();

                if (*atoms == ')') {
                    atoms++;

                    if (*atoms == ']') {
                        atoms++;
                        return true;

                    } else {
                        printf("Error, se esperaba un ]\n");
                    }

                } else {
                    printf("Error, se esperaba un )\n");
                }

            } else {
                printf("Error, se esperaba un (\n");    
            }

        } else {
            printf("Error, se esperaba un identificador\n");
        }

    } else {
        printf("Error, se esperaba un [\n");
    }

    return false;
}

/*98 - 99*/
bool Arg() {
    V();
    otroArg();

    return true;
}

/*100 - 101*/
bool otroArg() {
    // atoms++;

    if (*atoms == ',') {
        atoms++;
        
        V();
        otroArg();

        return true;

    } else {
        printf("Error, se esperaba un ,\n");
    }

    return false;   
}