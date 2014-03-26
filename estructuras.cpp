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

vector<arbol*> arbol::getHijos(){
	return hijos;
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

map<string,string> arbol::getContenido(){
	return contenido;
}

string buscarVariable(string var, arbol *actual){
         arbol *aux = actual;
         while(aux!=NULL){
             if((*aux).estaContenido(var)) return (*aux).tipoVar(var);
             aux = (*aux).getPapa();
         }
         return "";
}


arbol *enterScope(arbol *actual){
	arbol *nuevo = new arbol;
	(*actual).addHijo(nuevo);
	actual = nuevo;
	return actual;
}

arbol *exitScope(arbol *actual){
	actual = (*actual).getPapa();
	return actual;
}


void recorrer(arbol *a, int nivel){
	map<string, string> vars = (*a).getContenido();
	vector<arbol *> h = (*a).getHijos();
	string s = "";
	for(int i=0;i<nivel;i++) s+='\t';
	
	cout << s << "Abriendo anidamiento"<<endl<<endl;

	
	for(map<string,string>::iterator it = vars.begin();it!=vars.end();it++){
		cout << s+"\t" << it->first << " es de tipo " << it->second << endl << endl;
	}

	for(int i =0;i<h.size();i++){
		recorrer(h[i],nivel+1);
	}
	cout << s << "Cerrando anidamiendo" << endl<<endl;

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
