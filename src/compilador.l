/* Fecha: 02 / 11 / 2022 */

/* El programa realiza un análisis léxico y sintáctico para un lenguaje definido     */
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

    /* Clases para los tokens (No magic numbers) */
    enum CLASS{
        CLASS_0,
        CLASS_1,
        CLASS_2,
        CLASS_3,
        CLASS_4,
        CLASS_5,
        CLASS_6,
        CLASS_7,
        CLASS_8
    };

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
    int atoms_i = 0;

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

            fprintf(archSal, "\n-------Lista de Tokens--------\n");
            fflush(archSal);

            yylex();

            fprintf(archSal, "\n-------Cadena de Átomos--------\n");
            fprintf(archSal, "%s\n", atoms);
            fflush(archSal);

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

    fflush(archSal);

    fprintf(archSal, "\n-------Tabla de Palabras Reservadas--------\n");
    SLL_Print(TABLA_PALRESERVADAS, archSal);
    fflush(archSal);
    
    fprintf(archSal, "\n-------Tabla de Palabras Identificadores--------\n");
    SLL_Print(TABLA_IDENTIFICADORES, archSal);
    fflush(archSal);
    
    fprintf(archSal, "\n-------Tabla de Operadores Relacionales--------\n");
    SLL_Print(TABLA_OPRELACIONALES, archSal);
    fflush(archSal);

    fprintf(archSal, "\n-------Tabla de Constantes Reales--------\n");
    SLL_Print(TABLA_CTESREALES, archSal);
    fflush(archSal);
    
    fprintf(archSal, "\n-------Tabla de Constantes Cadenas--------\n");
    SLL_Print(TABLA_CTESCADENAS, archSal);
    fflush(archSal);
    
    fprintf(archSal, "\n-------Cadena de Átomos--------\n");
    fprintf(archSal, "%s", atoms);
    fflush(archSal);
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
        aux.class = CLASS_0;
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
    token_aux.class = CLASS_1;

    // Si ya existe
    if (SLL_Search(TABLA_IDENTIFICADORES, id)) {

        fprintf(archSal, "ERR: \"%s\" ya existe. \n", id);
        token_aux.val = TABLA_OPRELACIONALES->cursor->pos;
        atoms = append(atoms, IDENT_ATOM); 
        return token_aux;
    }

    token_aux.val = SLL_Len(TABLA_IDENTIFICADORES);

    atoms = append(atoms, IDENT_ATOM);

    SLL_Insert_back(TABLA_IDENTIFICADORES, SLL_Len(TABLA_IDENTIFICADORES), id, IDENT_ATOM);

    return token_aux;
}

/* Genera token de constantes numericas */
Token tokenConstantesNumericas( char* cte ) {

    Token token_aux;

    token_aux.class = CLASS_2;

    if (cte[0] == 'o' || cte[0] == 'O')
        cte[0] = '0';

    token_aux.val = atoi(cte);
    // token_aux.val = cte[0] + 0;

    atoms = append(atoms, CTENUM_ATOM);

    SLL_Insert_back(TABLA_CTESNUMERICAS, SLL_Len(TABLA_CTESNUMERICAS), cte, CTENUM_ATOM);

    return token_aux;
}

/* Genera token de constantes reales */
Token tokenConstantesReales( char* cte ) {

    Token token_aux;

    token_aux.class = CLASS_3;
    token_aux.val = SLL_Len(TABLA_CTESREALES);

    atoms = append(atoms, CTEREA_ATOM);

    SLL_Insert_back(TABLA_CTESREALES, SLL_Len(TABLA_CTESREALES), cte, CTEREA_ATOM);

    return token_aux;
}

/* Genera token de constantes de cadenas */
Token tokenConstantesCadenas( char* cte ) {

    Token token_aux;

    token_aux.class = CLASS_4;
    token_aux.val = SLL_Len(TABLA_CTESCADENAS);

    atoms = append(atoms, CTECAD_ATOM);

    SLL_Insert_back(TABLA_CTESCADENAS, SLL_Len(TABLA_CTESCADENAS), cte, CTECAD_ATOM);

    return token_aux;
}

/* Genera token de simbolos especiales */
Token tokenSimbolosEspeciales( char* s ) {

    Token token_aux;

    token_aux.class = CLASS_5;

    // Se envía el ASCII
    token_aux.val = s[0] + 0;

    atoms = strcat(atoms, s);

    return token_aux;
}

/* Genera token de operadores aritméticos */
Token tokenOperadoresAritmeticos( char* s ) {

    Token token_aux;

    token_aux.class = CLASS_6;

    // Se envía el ASCII
    token_aux.val = s[0] + 0;

    atoms = strcat(atoms, s);

    return token_aux;
}

/* Genra token de operadores relacionales */
Token tokenOperadoresRelacionales( char* s ) {

    Token token_aux;

    if (SLL_Search(TABLA_OPRELACIONALES, s)) {
        token_aux.class = CLASS_7;
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

    token_aux.class = CLASS_8;

    // Se envía el ASCII
    token_aux.val = s[0] + 0;

    atoms = strcat(atoms, s);

    return token_aux;
}

void rechaza( char* esperado ) {

    printf("Compilador -> ERR: POS: %d, se esperaba %s\n", atoms_i, esperado);
}

/*Funciones Analizador*/
/*1*/
bool Program() {

    if (Func()) {
        if (OtraFunc()) {
            printf("Programa compilado\n\n");
            return true;
        }
    }

    printf("El programa no compiló\n\n");
    return false;
}

/*2 - 3*/
bool OtraFunc() {

    if (Func()) {
        OtraFunc();
        return true;
    }

    return true;
}

/*4*/
bool Func() {
    
    if (Tipo()){

        if (*atoms == 'i') {
            atoms++;
            atoms_i++;

            if (*atoms == '(') {
                atoms++;
                atoms_i++;
                Param();

                if (*atoms == ')') {
                    atoms++;
                    atoms_i++;

                    if (*atoms == '{') {
                        atoms++;
                        atoms_i++;
                        Cuerpo();

                        if (*atoms == '}') {
                            atoms++;
                            atoms_i++;
                            return true;

                        } else {
                            rechaza("}");
                        }

                    } else {
                        rechaza("{");
                    }

                } else {
                    rechaza(")");
                }

            } else {
                rechaza("(");
            }

        } else {
            rechaza("i");
        }

    } else {
        // printf("Se esperaba el tipo de la función.\n");
    }

    return false;
}

/*5 - 6*/
bool Param() {
    if (Tipo()) {

        if (*atoms == 'i') {
            atoms++;
            atoms_i++;
            OtroParam();
            return true;

        } else {
            rechaza("i");
        }
    }

    return false;
}


/*7 - 8*/
bool OtroParam() {

    if (*atoms == ',') {
        atoms++;
        atoms_i++;

        if (Tipo()) {

            if (*atoms == 'i') {
                atoms++;
                atoms_i++;
                OtroParam();
                return true;

            } else {
                rechaza("i");
            }     
        } else {
            rechaza(",");
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
            

            if (*atoms == ';') {
                atoms++;
                atoms_i++;
                return true;
            
            } else {
                rechaza(";");
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
        atoms_i++;
        return true;

    } else {
        rechaza("b | g | # | y | x");
    }

    return false;
}

/*18*/
bool K() {
    

    if (*atoms == 'i') {
        atoms++;
        atoms_i++;
        Q();
        return true;

    } else {
        rechaza("i");
    }

    return false;
}

/*19 - 21*/
bool Q() {
    

    if (*atoms == '=') {
        atoms++;
        atoms_i++;
        if (N()) {
            C();
            return true;
        
        }

    } else if (*atoms == ',') {
        atoms++;
        atoms_i++;
        if (K()) {
            return true;
        }

    } else {
        rechaza("= | ,");
        return false;
    }
}

/*22 - 24*/
bool N() {
    

    if (
        *atoms == 'n' ||
        *atoms == 'r' ||
        *atoms == 's'
    ) {
        atoms++;
        atoms_i++;
        return true;

    } else {
        rechaza("n | r | s");
    }

    return false;
}

/*25 - 26*/
bool C() {
    

    if (*atoms == ',') {
        atoms++;
        atoms_i++;
        if (K()) {
            return true;
        }
    }

    return false;
}


/*Sentencia de Asignacion*/
/*27*/
bool A() {
    

    if (*atoms == 'i') {
        atoms++;
        atoms_i++;

        if (*atoms == '=') {
            atoms++;
            atoms_i++;
            if (AP()) {
                

                if (*atoms == ';') {
                    atoms++;
                    atoms_i++;
                    return true;

                } else {
                    rechaza(";");
                }
            }
        } else {
            rechaza("=");
        }

    } else {
        rechaza("i");
    }

    return false;
}

/*28 - 29*/
bool AP() {
    

    if (*atoms == 's') {
        atoms++;
        atoms_i++;
        return true;
    
    } else if (E()) {
        return true;
    
    }
    rechaza("s");
    return false;
}


/*Expresion Aritmetica*/
/*30*/
bool E() {
    if (T()) {
        EP();
        return true;
    } else {

        // printf("Error, expresión incorrecta.\n");
    }

    return false;
}

/*31 - 33*/
bool EP() {
    

    if (*atoms == '+' ||
        *atoms == '-'
    ) {
        atoms++;
        atoms_i++;
        if (T()) {
            EP();
            return true;
        }

    } else {
        rechaza("+ | -");
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
    

    if (*atoms == '*' ||
        *atoms == '/' ||    
        *atoms == '\\' ||    
        *atoms == '%' ||    
        *atoms == '^'
    ) {
        atoms++;
        atoms_i++;
        if (F()) {
            TP();
            return true;
        }

    }
    rechaza("* | / | \\ | % | ^");
    return false;
}


/*41 - 44*/
bool F() {
    

    if (*atoms == '(') {
        atoms++;
        atoms_i++;
        if (E()) {
            

            if (*atoms == ')') {
                atoms++;
                atoms_i++;
                return true;
            
            } else {
                rechaza(")");
            }
        }

    } else if (*atoms == 'i' ||
               *atoms == 'n' ||
               *atoms == 'r'
    ) {
        atoms++;
        atoms_i++;
        return true;
    
    } else {
        if (Llama()) {
            return true;
        }
    }

    rechaza("( | i | n | r");

    return false;
}


/*Expresion Relacional*/
/*46 - 49*/
bool R() {
    
    
    if (*atoms == 'i') {
        atoms++;
        atoms_i++;
        if (RP()) {
            if (V()) {
                return true;
            }
        }
    }
    
    else if (*atoms == 'n') {
        atoms++;
        atoms_i++;
        if (RP()) {
            if (VP()) {
                return true;
            }
        }
    }
    
    else if (*atoms == 'r') {
        atoms++;
        atoms_i++;
        if (RP()) {
            if (VPP()) {
                return true;
            }
        }
    }
    
    else if (*atoms == 's') {
        atoms++;
        atoms_i++;
        if (RP()) {
            if (VPPP()) {
                return true;
            }
        }
    }

    rechaza("i | n | r | s");

    return false;
}

/*50 - 55*/
bool RP() {
    

    if (
        *atoms == '>' ||
        *atoms == '<' ||
        *atoms == 'l' ||
        *atoms == 'e' ||
        *atoms == 'd' ||
        *atoms == 'u'
    ) {
        atoms++;
        atoms_i++;
        return true;
    }

    rechaza("< | > | l | e | d | u");
    return false;
}

/*56 - 59*/
bool V() {
    

    if (
        *atoms == 'i' ||
        *atoms == 'n' ||
        *atoms == 'r' ||
        *atoms == 's'
    ) {
        atoms++;
        atoms_i++;
        return true;
    }

    rechaza("i | n | r | s");
    return false;
}

/*60 - 61*/
bool VP() {
    

    if (
        *atoms == 'i' ||
        *atoms == 'n'
    ) {
        atoms++;
        atoms_i++;
        return true;
    }

    rechaza("i | n");
    return false;
}

/*62 - 63*/
bool VPP() {
    

    if (
        *atoms == 'i' ||
        *atoms == 'r'
    ) {
        atoms++;
        atoms_i++;
        return true;
    }

    rechaza("i | r");
    return false;
}

/*64 - 65*/
bool VPPP() {
    

    if (
        *atoms == 'i' ||
        *atoms == 's'
    ) {
        atoms++;
        atoms_i++;
        return true;
    }

    rechaza("i | s");
    return false;
}


/*Proposiciones*/
/*66 - 73*/
bool P() {
    
    if (A()) {
        return true;

    } else if (I()) {
        return true;

    } else if (H()) {
        return true;

    } else if (W()) {
        return true;

    } else if (J()) {
        return true;

    } else if (Llama()) {
        return true;

    } else if (Devuelve()) {
        return true;

    } else if (*atoms == 'c') {
        atoms++;
        atoms_i++;

        if (*atoms == ';') {
            atoms++;
            atoms_i++;
            return true;
        }
    }

    rechaza("c | ;");
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
    

    if (*atoms == 'w') {
        atoms++;
        atoms_i++;

        if (*atoms == '(') {
            atoms++;
            atoms_i++;

            if (R()) {
                

                if (*atoms == ')') {
                    atoms++;
                    atoms_i++;

                    if (*atoms == 'm') {
                        atoms++;
                        atoms_i++;

                        if (*atoms == '{') {
                            atoms++;
                            atoms_i++;
                            ListaP();

                            if (*atoms == '}') {
                                atoms++;
                                atoms_i++;
                                return true; 

                            } else {
                                rechaza("}");
                            }

                        } else {
                            rechaza("{");
                        }

                    } else {
                        rechaza("m");
                    }

                } else {
                    rechaza(")");
                }
            }

        } else {
            rechaza("(");
        }
    
    } else {
        rechaza("w");
    }

    return false;
}


/*Sentencia Evaluate*/
/*77*/
bool I() {
    

    if (*atoms == 'f') {
        atoms++;
        atoms_i++;

        if (*atoms == '(') {
            atoms++;
            atoms_i++;

            if (R()) {
                

                if (*atoms == ')') {
                    atoms++;
                    atoms_i++;
                    ListaP();

                    if (IP()) {
                        

                        if (*atoms == ':') {
                            atoms++;
                            atoms_i++;
                            return true;

                        } else {
                            rechaza(":");
                        }
                    }

                } else {
                    rechaza(")");
                }
            
            }

        } else {
            rechaza("(");
        }

    } else {
        rechaza("f");
    }

    return false;
}


/*78 - 79*/
bool IP() {
    

    if (*atoms == 't') {
        atoms++;
        atoms_i++;
        ListaP();
        return true;
    }

    rechaza("t");
    return false;
}


/*Sentencia Repeat*/
/*80*/
bool J() {
    

    if (*atoms == 'j') {
        atoms++;
        atoms_i++;

        if (*atoms == '(') {
            atoms++;
            atoms_i++;

            if (Y()) {

                if (X()) {

                    if (Z()) {
                        

                        if (*atoms == '{') {
                            atoms++;
                            atoms_i++;

                            ListaP();

                            if (*atoms == '}') {
                                atoms++;
                                atoms_i++;
                                return true;

                            } else {
                                rechaza("}");
                            }

                        } else {
                            rechaza("{");
                        }
                    }
                }
            }

        } else {
            rechaza("(");
        }

    } else {
        rechaza("j");
    }

    return false;
}

/*81 - 82*/
bool Y() {
     

    if (*atoms == 'i') {
        atoms++;
        atoms_i++;

        if (*atoms == '=') {
            atoms++;
            atoms_i++;

            if (E()) {

                if (*atoms == ';') {
                    atoms++;
                    atoms_i++;
                    return true;
                } else {
                    rechaza(";");
                }
            }

        } else {
            rechaza("=");
        }

    } else if (*atoms == ';') {
        atoms++;
        atoms_i++;
        return true;

    } else {
        rechaza("i | ;");
    }

    return false;
}

/*83 - 84*/
bool X() {
    if (R()) {
        
        if (*atoms == ';') {
            atoms++;
            atoms_i++;
            return true;
        }

    } else if (*atoms == ';') {
        atoms++;
        atoms_i++;
        return true;

    }

    rechaza(";");
    return false;
}

/*85 - 86*/
bool Z() {
    

    if (*atoms == 'i') {
        atoms++;
        atoms_i++;

        if (*atoms == '=') {
            atoms++;
            atoms_i++;

            if (E()) {

                if (*atoms == ')') {
                    atoms++;
                    atoms_i++;
                    return true;
                
                } else {
                    rechaza(")");
                }
            }

        } else {
            rechaza("=");
        }
    
    } else {
        rechaza("i");
    }

    return false;
}


/*Sentencia Select*/
/*87*/
bool H() {
    

    if (*atoms == 'h') {
        atoms++;
        atoms_i++;

        if (*atoms == '(') {
            atoms++;
            atoms_i++;

            if (*atoms == 'i') {
                atoms++;
                atoms_i++;

                if (*atoms == ')') {
                    atoms++;
                    atoms_i++;

                    if (*atoms == '{') {
                        atoms++;
                        atoms_i++;
                        CP();
                        OP();

                        if (*atoms == '}') {
                            atoms++;
                            atoms_i++;
                            return true;
                        
                        } else {
                            rechaza("}");
                        }

                    } else {
                        rechaza("{");
                    }

                } else {
                    rechaza(")");
                }

            } else {
                rechaza("i");
            }

        } else {
            rechaza("(");
        }

    } else {
        rechaza("h");
    }

    return false;
}

/*88 - 89*/
bool CP() {
    

    if (*atoms == 'a') {
        atoms++;
        atoms_i++;

        if (*atoms == 'n') {
            atoms++;
            atoms_i++;

            if (*atoms == ':') {
                atoms++;
                atoms_i++;

                ListaP();
                U();
                CP();
                return true;

            } else {
                rechaza(":");
            }   
        } else {
            rechaza("n");
        }
    } else {
        rechaza("a");
    }

    return false;
}

/*90 - 91*/
bool OP() {
    

    if (*atoms == 'o') {
        atoms++;
        atoms_i++;

        if (*atoms == ':') {
            atoms++;
            atoms_i++;

            ListaP();
            return true;
               
        } else {
            rechaza(":");
        }
    } else {
        rechaza("o");
    }

    return false;
}

/*92 - 93*/
bool U() {
    

    if (*atoms == 'q') {
        atoms++;
        atoms_i++;
        return true;
    } else {
        rechaza("q");
    }

    return false;
}


/*Sentencia Throw*/
/*94*/
bool Devuelve() {
    

    if (*atoms == 'z') {
        atoms++;
        atoms_i++;

        if (*atoms == '(') {
            atoms++;
            atoms_i++;
            Valor();

            if (*atoms == ')') {
                atoms++;
                atoms_i++;

                if (*atoms == ';') {
                    atoms++;
                    atoms_i++;
                    return true;

                } else {
                    rechaza(";");
                }

            } else {
                rechaza(")");
            }

        } else {
            rechaza("(");
        }
        
    } else {
        rechaza("z");
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
    

    if (*atoms == '[') {
        atoms++;
        atoms_i++;

        if (*atoms == 'i') {
            atoms++;
            atoms_i++;

            if (*atoms == '(') {
                atoms++;
                atoms_i++;
                
                Arg();

                if (*atoms == ')') {
                    atoms++;
                    atoms_i++;

                    if (*atoms == ']') {
                        atoms++;
                        atoms_i++;
                        return true;

                    } else {
                        rechaza("]");
                    }

                } else {
                    rechaza(")");
                }

            } else {
                rechaza("(");
            }

        } else {
            rechaza("i");
        }

    } else {
        rechaza("[");
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
    

    if (*atoms == ',') {
        atoms++;
        atoms_i++;

        V();
        otroArg();

        return true;

    } else {
        rechaza(",");
    }

    return false;   
}