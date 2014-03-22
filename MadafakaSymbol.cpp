#include <string>

#include "MadafakaSymbol.hpp"

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
 
MadafakaSymbol::MadafakaSymbol(string const& n, int val): name(n), value() {
	value.intValue = val;
}

MadafakaSymbol::MadafakaSymbol(string const& n, float val): name(n), value() {
	value.floatValue = val;
}

MadafakaSymbol::MadafakaSymbol(string const& n, char val): name(n), value() {
	value.charValue = val;
}

MadafakaSymbol::MadafakaSymbol(string const& n, string *val): name(n), value() {
	value.stringValue = val;
}

