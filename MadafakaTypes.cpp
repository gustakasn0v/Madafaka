#include <string>
#include <iostream>
#ifndef MADAFAKATYPES_H
#include "MadafakaTypes.hpp"
#endif
using namespace std;
/**
 * @class MadafakaTypes "MadafakaTypes.h"
 * 
 * Implementación de las clases del Sistema de Tipos
 * 
 * @author Gustavo El Khoury <gustavoelkoury@gmail.com>
 * @author Wilmer Bandres <wilmer0593@gmail.com>
 */


IntegerType *IntegerType::singleton_instance = NULL;
FloatType *FloatType::singleton_instance = NULL;
StringType *StringType::singleton_instance = NULL;
CharType *CharType::singleton_instance = NULL;
BoolType *BoolType::singleton_instance = NULL;
VoidType *VoidType::singleton_instance = NULL;
TypeError *TypeError::singleton_instance = NULL;
Undeclared *Undeclared::singleton_instance = NULL;


void MadafakaType::print(){
		cout << "Tipo: " << name;
		return;
}

bool MadafakaType::operator==(MadafakaType &rhs){
    return name==rhs.name;
}

bool MadafakaType::operator==(const char* word){
    return name==string(word);
}

std::ostream& MadafakaType::operator<<(std::ostream &os) { 
    return os << name;
}

IntegerType::IntegerType(){
 		name = "Idafak";
 	};

IntegerType* IntegerType::instance(){
 	if (!singleton_instance)
        	singleton_instance = new IntegerType();
       	return singleton_instance;
 	};

FloatType::FloatType(){
 		name = "Fdafak";
};
FloatType* FloatType::instance(){
 		if (!singleton_instance)
        	singleton_instance = new FloatType();
       	return singleton_instance;
 	};

StringType::StringType(){
 		name = "Sdafak";
};

StringType* StringType::instance(){
 		if (!singleton_instance)
        	singleton_instance = new StringType();
       	return singleton_instance;
 	};

CharType::CharType(){
 		name = "Cdafak";
};
CharType* CharType::instance(){
 		if (!singleton_instance)
        	singleton_instance = new CharType();
       	return singleton_instance;
};


BoolType::BoolType(){
    name = "Cdafak";
};
BoolType* BoolType::instance(){
    if (!singleton_instance)
          singleton_instance = new BoolType();
        return singleton_instance;
};


VoidType::VoidType(){
    name = "Void";
};
VoidType* VoidType::instance(){
    if (!singleton_instance)
          singleton_instance = new VoidType();
        return singleton_instance;
};

RecordType::RecordType(string *symname, arbol *newfields){    
    name = "Struct";
    symbolName = symname;
    SymTable = newfields;
};

// Equivalencia por nombre en los records y unions
bool RecordType::operator==(RecordType &rhs){
    return (symbolName==rhs.symbolName);
}

arbol* RecordType::getSymTable(){
     return SymTable;
};

UnionType::UnionType(string *symname, arbol *newfields){
    name = "Union";
    symbolName = symname;
    SymTable = newfields;
    SymTable = new arbol();
};

bool UnionType::operator==(UnionType &rhs){
    return (symbolName==rhs.symbolName);
}

arbol* UnionType::getSymTable(){
     return SymTable;
};

ArrayType::ArrayType(int lo, int up, MadafakaType *t){
    name = "Array";
    lower = lo;
    upper = up;
    type = t;
};

FunctionType::FunctionType(arbol *arguments,MadafakaType *returntype){
    name = "Function";
    args = arguments;
    result = returntype;
};

TypeError::TypeError(){
    name = "Type Error";
};
TypeError* TypeError::instance(){
    if (!singleton_instance)
          singleton_instance = new TypeError();
        return singleton_instance;
};

Undeclared::Undeclared(){
    name = "Undeclared";
};
Undeclared* Undeclared::instance(){
    if (!singleton_instance)
          singleton_instance = new Undeclared();
        return singleton_instance;
};


// Cosas de estructuras.cpp

void arbol::addHijo(arbol *hijo)
{ (*hijo).setPapa(this);
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
  MadafakaType *valor = contenido[0];
  if(contenido.count(s)==0){
    contenido[s]=tipo;
    ubicacion[s] = make_pair(fila,col);
    if(si)
      bloque[s] = hijos.size()-1;
  }
}

MadafakaType* arbol::tipoVar(string &var){
  if(contenido.count(var))
    return contenido[var];
  if(papa!=NULL)
    return (*papa).tipoVar(var);
  return NULL;
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

 /*void arbol::esArray(string &var){
  string t = contenido[var];
  arrays[var]=t;
  contenido[var]="array"; 
 }*/

string arbol::getTipoArray(string &var){
  if(arrays.count(var))
    return arrays[var];
  if(papa!=NULL)
    return (*papa).getTipoArray(var);
  return "";
}



MadafakaType *buscarVariable(string var, arbol *actual){
         arbol *aux = actual;
         while(aux!=NULL){
             if((*aux).estaContenido(var)) return (*aux).tipoVar(var);
             aux = (*aux).getPapa();
         }
         Undeclared* t = new Undeclared();
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
    //  int t = bloques[it->first];
    //  recorrer(h[t],nivel+1);
    //  ya.insert(t);
    // }
    string tmp1 = it->first;
    // if(it->second == "array" && ((*a).getTipoArray(tmp1)=="strdafak"\
    //             || (*a).getTipoArray(tmp1)=="unidafak")){
    //  int t = bloques[tmp1];
    //  recorrer(h[t],nivel+1);
    //  ya.insert(t);

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
