#ifndef estructuras
	#include"estructuras.h"
#endif
#include<iostream>

//using namespace std;
void arbol::addHijo(arbol *hijo){
	(*hijo).setPapa(this);
	hijos.push_back(hijo);
}

void arbol::setPapa(arbol *padre){
	papa=padre;
}

arbol *arbol::getPapa(){
	return papa;
}

int arbol::estaContenido(string &s){
	return contenido.count(s);
}

void arbol::insertar(string s,string tipo){
	if(contenido.count(s)==0)
		contenido[s]=tipo;
}

string arbol::tipoVar(string &var){
	return contenido[var];
}


string buscarVariable(string var){
         arbol *aux = actual;
         while(aux!=NULL){
             if((*aux).estaContenido(var)) return (*aux).tipoVar(var);
             aux = (*aux).getPapa();
         }
         return "";
}


void enterScope(){
	arbol *nuevo = new arbol;
	(*actual).addHijo(nuevo);
	actual = nuevo;
}

void exitScope(){
	actual = (*actual).getPapa();
}


/* main de prueba del archivo
int main(){
	string s = "bla1";
	(*actual).insertar(s,"strin");
	enterScope();
	enterScope();
	cout << buscarVariable(s) << endl;
}

*/
