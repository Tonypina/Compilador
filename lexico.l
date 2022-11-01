%{
    // Código en C
    #include <stdio.h>
    #include <string.h>
}%

// Atómicos
DIGITO      [0-9]
LETRA       [a-zA-Z]
ESPACIO     [" "]
GUION       [-_]

// Palabras reservadas
ALTERNATIVE "alternative"
BIG         "big"
EVALUATE    "evaluate"
INSTEAD     "instead"
LARGE       "large"
LOOP        "loop"
MAKE        "make"
NUMBER      "number"
OTHER       "other"
REAL        "real"
REPEAT      "repeat"
SELECT      "select"
SMALL       "small"
STEP        "step"
STOP        "stop"
SYMBOL      "symbol"
THROW       "return"

%%



%%
typedef struct tupla {
    int val;
    char* str;
}

int main () {
    yylex();
    return 0;
}
