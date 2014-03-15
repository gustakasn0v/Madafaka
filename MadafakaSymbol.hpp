#ifndef MADAFAKASYMBOL_H
#define MADAFAKASYMBOL_H

#include <string>

#ifndef estructuras
	#define estructuras
	#include"estructuras.h"
#endif

using namespace std;
/**
 * @class SymTable "SymTable.h"
 * 
 * Clase que representa un símbolo del Lenguaje Madafaka
 * 
 * @author Gustavo El Khoury <gustavoelkoury@gmail.com>
 * @author Wilmer Bandres <wilmer0593@gmail.com>
 */

// Here is the type definition for the Madafaka Language


class MadafakaSymbol{
private:
 	// Name of the Symbol
 	string name;
 	// Value of the symbol
 	MadafakaTypes value;

 	MadafakaSymbol() {}

public:
 	MadafakaSymbol(string&  n, int val);

 	MadafakaSymbol(string const& n, float val);

 	MadafakaSymbol(string const& n, char val);

 	MadafakaSymbol(string const& n, string *val);

 	string getName() { return name; }
};

#endif
