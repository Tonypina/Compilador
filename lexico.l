%{
    // Código en C
    #include <stdio.h>
    #include <string.h>
}%

FILE *archEnt;

//Estructura para definir palabras reservadas {palabra,valor,atomo}
struct palabrasR{
  char palabra[10];
  int valor;
  char atomo;
}
palReservada[17] = {{"ALTERNATIVE",0,'a'},
                    {"BIG",1,'b'},
                    {"EVALUATE",2,'c'},
                    {"INSTEAD",3,'d'},
                    {"LARGE",4,'e'},
                    {"LOOP",5,'f'},
                    {"MAKE",6,'g'},
                    {"NUMBER",7,'h'},
                    {"OTHER",8,'i'},
                    {"REAL",9,'j'},
                    {"REPEAT",10,'k'},
                    {"SELECT",11,'l'},
                    {"SMALL",12,'m'},
                    {"STEP",13,'n'},
                    {"STOP",14,'o'},
                    {"SYMBOL",15,'p'},
                    {"THROW",16,'q'}
};

DIGITO      [0-9]
LETRA       [a-zA-Z]
ESPACIO     [" "]
GUION       [-_]

%%
main (int argc, char *argv[]) {
    yyin = fopen(argv[1],"r");
    archSal = fopen("Entrada.txt","w");
    yylex();
    fclose(archEnt);
}
