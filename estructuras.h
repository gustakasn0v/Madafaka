
#include<vector>
#include<string>
#include<map>
using namespace std;
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
		map<string,string> contenido;

		public:
		arbol(){papa=NULL;contenido.clear();}
		arbol(arbol *p,arbol *cont) : papa(p){contenido.clear();}

		void addHijo(arbol *);
		void setPapa(arbol *);
		arbol *getPapa();
		void insertar(string ,string );
		int estaContenido(string &);
		string tipoVar(string &);
	};

	arbol raiz;
	arbol *actual = &raiz;

	/* Funcion que retornara el tipo de la variable
	que se esta consultando,
	en caso de que no exista se retornara la cadena vacia*/

	string buscarVariable(string);
