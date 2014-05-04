#ifndef estructuras
	#include"estructuras.h"
#endif
#include<iostream>

//using namespace std;
void arbol::addHijo(arbol *hijo)
{	(*hijo).setPapa(this);
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


void arbol::insertar(string s,MadafakaType *tipo,int fila, int col, int si){
	if(contenido.count(s)==0){
		contenido[s]=tipo;
		ubicacion[s] = make_pair(fila,col);
		if(si)
			bloque[s] = hijos.size()-1;
	}
}

MadafakaType* arbol::tipoVar(string &var){
	return contenido[var];
}

map<string,MadafakaType*> arbol::getContenido(){
	return contenido;
}

map<string,pair<int,int> > arbol::getUbicacion(){
	return ubicacion;
}

map<string,int> arbol::getBloque(){
	return bloque;
}


arbol *arbol::hijoEnStruct(string &s){
	int t = bloque[s];
	return hijos[t];
}

// void arbol::esArray(string &var){
// 	string t = contenido[var];
// 	arrays[var]=t;
// 	contenido[var]="array";	
// }

string arbol::getTipoArray(string &var){
	if(arrays.count(var))
		return arrays[var];
	return "";
}



MadafakaType *buscarVariable(string var, arbol *actual){
         arbol *aux = actual;
         while(aux!=NULL){
             if((*aux).estaContenido(var)) return (*aux).tipoVar(var);
             aux = (*aux).getPapa();
         }
         TypeError* t = new TypeError();
         return t;
}


arbol *buscarBloque(string var, arbol *actual){
		arbol *aux = actual;
		while(aux!=NULL){
             if((*aux).estaContenido(var)) return aux;
             aux = (*aux).getPapa();
        }
		return aux;
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
	map<string, MadafakaType*> vars = (*a).getContenido();
	map<string,pair<int,int> > ubic = (*a).getUbicacion();
	map<string,int> bloques = (*a).getBloque();
	vector<arbol *> h = (*a).getHijos();
	set<int> ya;
	string s = "";
	for(int i=0;i<nivel;i++) s+='\t';
	
	cout << s << "Abriendo anidamiento"<<endl<<endl;

	
	for(map<string,MadafakaType*>::iterator it = vars.begin();it!=vars.end();it++){
		cout << s+"\t" << it->first << " es de tipo " << it->second << endl << endl;
		pair<int,int> p = ubic[it->first];
		int t1 = p.first;
		int t2 = p.second;
		cout << s+"\t" << "Ubicacion, fila: " << t1 << ", columna: "<<t2<<endl<<endl;
		// if(it->second == "strdafak" || it->second=="unidafak"){
		// 	int t = bloques[it->first];
		// 	recorrer(h[t],nivel+1);
		// 	ya.insert(t);
		// }
		string tmp1 = it->first;
		// if(it->second == "array" && ((*a).getTipoArray(tmp1)=="strdafak"\
		// 						 || (*a).getTipoArray(tmp1)=="unidafak")){
		// 	int t = bloques[tmp1];
		// 	recorrer(h[t],nivel+1);
		// 	ya.insert(t);

		// }
	}

	for(int i =0;i<h.size();i++){
		if(!ya.count(i))
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
