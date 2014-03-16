#ifndef vectores
	#define vectores
	#include<vector>
#endif

#ifndef MADAFAKASYMTABLE_H
	#include"MadafakaSymTable.hpp"
#endif

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
		MadafakaSymTable *contenido;

		public:

		arbol():{papa=contenido=NULL;}
		arbol(arbol *p,arbol *cont) : papa(p),contenido(cont){}

		void addHijo(arbol *);
		void setPapa(arbol *);
		MadafakaSymTable * getContenido();

		


	};
