#include"estructuras.h"

#ifndef MADAFAKASYMTABLE_H
	#include"MadafakaSymTable.hpp"
#endif


arbol::addHijo(arbol *hijo){
	(*hijo).setPapa(this);
	hijos.push_back(hijo);
}

arbol::setPapa(arbol *padre){
	papa=padre;
}

arbol::getContenido(){
	return contenido;
}
