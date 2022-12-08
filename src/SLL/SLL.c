
#include "SLL.h"
/**
 * @brief Crea un nuevo nodo de la lista
 * 
 * @param _pos Posición del nodo en la lista
 * @param _name Nombre del nodo
 * @param _atom Tipo de dato
 * @return Node* 
 */
static Node* newNode( int _pos, char* _name, char _atom )
{
	Node* n = (Node*) malloc( sizeof( Node ) );
	if( n ){
		n->pos = _pos;
		n->name = _name;
		n->atom = _atom;
		n->next = NULL;
	}
	return n;
}

/**
 * @brief Crea una nueva lista SLL
 * @return Referencia a la nueva lista
 */
SLL* SLL_New()
{
	SLL* list = (SLL*) malloc( sizeof( SLL ) );
	if( list ){
		list->first = NULL;
		list->last = NULL;
		list->cursor = NULL;
		list->len = 0;
	}
	return list;
}

/**
 * @brief Destruye una lista SLL
 * @param this Referencia a un objeto SLL
 * @post La lista se destruyó y no debiera ser utilizado de nuevo
 */
void SLL_Delete( SLL** this )
{
	assert(*this);
	if( *this ){
      // primero borra todos los nodos
		SLL* l = *this;
		while(l->len){
			Node* tmp = l->first->next;
			free( l->first );
			l->first = tmp;
			--l->len;
		}
      // luego borra al propio objeto this
		free(*this);
      // luego hace que this sea NULL
		*this = NULL;
	}
}

/**
 * @brief Indica si la lista está vacía
 * @param this Referencia a un objeto SLL
 * @return true si la lista está vacía; false en cualquier otro caso
 * @pre La lista existe
 */
bool SLL_IsEmpty( SLL* this )
{
	assert( this );

	return (!this->first);
}

/**
 * @brief Inserta en la parte de atrás de la lista
 * 
 * @param this Referencia a la lista misma
 * @param pos Valor de posición que tendrá el nodo
 * @param name Nombre del nodo
 * @param atom Tipo
 * @return true si insertó correctamente
 * @return false si no pudo insertar
 */
bool SLL_Insert_back( SLL* this, int pos, char* name, char atom )
{
	assert( this );

	bool done = false;

	Node* n = newNode( pos, name, atom );
	if( n ){
		done = true;

		if( SLL_IsEmpty( this ) ){
			this->first = this->last = this->cursor = n;
		}
		else{
			this->last->next = n;
			this->last = n;
		}
		++this->len;
	}
	return done;
}

/**
 * @brief Inserta en la parte delantera de la lista
 * 
 * @param this Referencia a la lista misma
 * @param pos Posición del nodo en la lista
 * @param name Nombre del nodo
 * @param atom Tipo
 * @return true Si pudo insertar
 * @return false Si no pudo insertar
 */
bool SLL_Insert_front( SLL* this, int pos, char* name, char atom )
{
	assert(this);
	bool done = false;
	Node* n = newNode(pos, name, atom);
	if(n){
		done = true;
		if(SLL_IsEmpty(this)){
			this->first = this->last = this->cursor = n;
		} else { 
			n->next = this->first;
			this->first = n;
		}
		++this->len;
	}
	return done;
}

/**
 * @brief Inserta después del cursor
 * 
 * @param this Referencia a la misma lista
 * @param pos Posición del nodo
 * @param name Nombre del nodo
 * @param atom Tipo del nodo
 * @return true Si pudo insertar
 * @return false Si no pudo insertar
 */
bool SLL_Insert_after(SLL* this, int pos, char* name, char atom){
	assert(this);
	bool done = false;
	Node* n = newNode(pos, name, atom);
	if(n){
		done = true;
		Node* tmp = this->cursor->next;
		this->cursor->next = n;
		n->next = tmp;
		++this->len;
	}
	return done;
}

/**
 * @brief Saca nodos del frente de la lista
 * 
 * @param this Referencia a la misma lista
 * @param pos_back Valor posición regresado del nodo a sacar
 * @param name_back Valor nombre regresado del nodo a sacar
 * @param atom_back Valor tipo regresado del nodo a sacar
 * @return true Si pudo sacar al nodo de la lista
 * @return false Si no pudo sacar al nodo de la lista
 */
bool SLL_Remove_front( SLL* this, int* pos_back, char* name_back, char* atom_back )
{
	assert( this );

	if( SLL_IsEmpty( this ) ){ return false; }
	*pos_back = this->first->pos;
	name_back = this->first->name;
	*atom_back = this->first->atom;
	//this->first->data = *data_back;
	Node* tmp = this->first->next;
	free( this->first );
	this->first = tmp;
	--this->len;
	return true;
}

/**
 * @brief Devuelve el elemento en el frente de la lista.
 * @param this Referencia a un objeto SLL.
 * @param data_back El valor del elemento en el frente de la lista. No tiene
 * sentido si el valor devuelto por la función es false.
 * @return true si la lista no está vacía; false en caso contrario.
 */
bool SLL_PeekFront( SLL* this, int* pos_back, char* name_back, char* atom_back )
{
	assert(this);
	if (SLL_IsEmpty(this)) {return false;}
	*pos_back = this->first->pos;
	name_back = this->first->name;
	*atom_back = this->first->atom;

	return true;
}

/**
 * @brief Obtiene los valores del último nodo sin sacarlo
 * 
 * @param this Referencia a la misma lista
 * @param pos_back Valor posición del nodo
 * @param name_back Valor nombre del nodo
 * @param atom_back Valor tipo del nodo
 * @return true Si encontró al nodo
 * @return false Si no encontró al nodo
 */
bool SLL_PeekBack( SLL* this, int* pos_back, char* name_back, char* atom_back )
{
	assert(this);
	if (SLL_IsEmpty(this)){ return false;}
	*pos_back = this->last->pos;
	name_back = this->last->name;
	*atom_back = this->last->atom;
	return true;
}

/**
 * @brief Coloca el cursor al inicio de la lista
 * 
 * @param this Referencia a la misma lista
 */
void SLL_Cursor_first( SLL* this )
{
	this->cursor = this->first;
}

/**
 * @brief Coloca el cursor al final de la lista
 * 
 * @param this Referencia a la misma lista
 */
void SLL_Cursor_last( SLL* this )
{
	this->cursor = this->last;
}

/**
 * @brief Vacía la lista sin destruirla
 * @param this Referencia a un objeto SLL
 * @pre La lista existe
 */
void SLL_MakeEmpty( SLL* this )
{
	while(this->len){
		--this->last;
		free(this->last->next);
		--this->len;
	}
}

/**
 * @brief Busca si un elemento está en la lista.
 * @param this Referencia a un objeto SLL.
 * @param key El valor que estamos buscando.
 * @return true si se encontró una coincidencia; false en caso contrario.
 * @post El estado del objeto NO se modifica.
 */
bool SLL_FindIf( SLL* this, char* key )
{
	assert(this);
	bool found = false;
	this->cursor = this->first;
	if (!SLL_IsEmpty(this)){
		for(Node* it = this->first; it->next; it = it->next){
			if ( !strcmp(key, it->name) ){
				found = true;
				break;
			}
		}
	}
	return found;
}

/**
 * @brief Busca si un elemento está en la lista.
 * @param this Referencia a un objeto SLL.
 * @param key El valor que estamos buscando.
 * @return true si se encontró una coincidencia; false en caso contrario.
 * @post Coloca al cursor en el nodo en el que se hubiera encontrado una
 * coincidencia
 */
bool SLL_Search( SLL* this, char* key )
{
	assert( this );

	bool found = false;

	
	if( !SLL_IsEmpty( this ) ){

		for( Node* it = this->first; it != NULL; it = it->next ){
			if( !strcmp(key, it->name) ){
				found = true;
				this->cursor = it;
				break;
			}
		}
	}
	return found;
}

/**
 * @brief Mueve al cursor un elemento a la derecha.
 *
 * @param this Referencia a un objeto SLL
 *
 * @post El cursor NO se mueve si vale NULL
 */
void SLL_Cursor_next( SLL* this )
{
	assert( this );

	if( this->cursor ){
		this->cursor = this->cursor->next;
	}
}

/**
 * @brief Devuelve el número de elementos actualmente en la lista.
 * @param this Referencia a un objeto SLL.
 * @return El número de elementos actualmente en la lista.
 */
size_t SLL_Len( SLL* this )
{
	return this->len;
}

/**
 * @brief Imprime los nodos en forma de tuplas
 * 
 * @param this Referencia a la misma lista
 * @param out Referencia a un archivo de salida
 */
void SLL_Print( SLL* this, FILE* out )
{
	assert( this );
	
	if( !SLL_IsEmpty( this ) ){

		for( Node* it = this->first; it != NULL; it = it->next ){
			fprintf(out, "( %d, %s, %c)\n", it->pos, it->name, it->atom);
		}
	}
}