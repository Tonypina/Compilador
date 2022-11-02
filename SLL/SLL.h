
#ifndef  SLL_INC
#define  SLL_INC

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include <string.h>

/**
 * @brief Estructura del Nodo
 * 
 */
typedef struct Node
{
	int pos;
	char* name;
	int type;
	struct Node* next;
} Node;

/**
 * @brief Lista Ligada Simple
 * 
 */
typedef struct SLL
{
	Node* first;
	Node* last;
	Node* cursor;
	size_t len;
} SLL;

SLL*   SLL_New();
void   SLL_Delete(       SLL** this );
bool   SLL_Insert_back(  SLL* this, int pos, char* name, int type );
bool   SLL_Insert_front( SLL* this, int pos, char* name, int type );
bool   SLL_Insert_after( SLL* this, int pos, char* name, int type );
bool   SLL_Remove_front( SLL* this, int* pos_back, char* name_back, int* type_back );
bool   SLL_PeekFront(    SLL* this, int* pos_back, char* name_back, int* type_back );
bool   SLL_PeekBack(     SLL* this, int* pos_back, char* name_back, int* type_back );
size_t SLL_Len(          SLL* this );
bool   SLL_IsEmpty(      SLL* this );
void   SLL_MakeEmpty(    SLL* this );
void   SLL_Cursor_first( SLL* this );
void   SLL_Cursor_last(  SLL* this );
void   SLL_Cursor_next(  SLL* this );
bool   SLL_FindIf(       SLL* this, char* key );
bool   SLL_Search(       SLL* this, char* key );
void   SLL_Print(	     SLL* this, FILE* out );

#endif   /* ----- #ifndef SLL_INC  ----- */
