#include<vector>
#include<string>
#include<map>
#include<new>
#include<utility>
#include<set>
#include"MadafakaTypes.cpp"
using namespace std;
#ifndef estructuras
	#define estructuras

	union MadafakaTypes{
	     int intValue;
	     float floatValue;
	     char charValue;
	     string *stringValue;
	};

	//clase que representa el arbol de SymTable
	class arbol{
		private:
			arbol *papa;
			vector<arbol *> hijos;
			map<string,MadafakaType*> contenido;
			map<string,pair<int,int> > ubicacion;
			map<string,int> bloque;
			map<string,string> arrays;

		public:
			arbol(){papa=NULL;contenido.clear();ubicacion.clear();}
			arbol(arbol *p,arbol *cont) : papa(p){contenido.clear();}
			void addHijo(arbol *);
			void setPapa(arbol *);
			vector<arbol *> getHijos();
			arbol *getPapa();
			void insertar(string ,MadafakaType*, int, int, int);
			int estaContenido(string &);
			MadafakaType *tipoVar(string &);
			map<string,MadafakaType*> getContenido();
			map<string,pair<int,int> > getUbicacion();
			map<string,int> getBloque();
			arbol *hijoEnStruct(string &);
			void esArray(string &);
			string getTipoArray(string &);
	};

	/* Funcion que retornara el tipo de la variable
	que se esta consultando,
	en caso de que no exista se retornara la cadena vacia*/

	MadafakaType *buscarVariable(string, arbol *);

	arbol *buscarBloque(string, arbol *);

	arbol *enterScope(arbol *);

	arbol *exitScope(arbol *);

	void recorrer(arbol *, int);

#endif
