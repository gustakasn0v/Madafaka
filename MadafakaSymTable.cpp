#include <string>
#include <map>
#include "MadafakaSymbol.hpp"

#include "MadafakaSymTable.hpp"
using namespace std;
/**
 * @class SymTable "SymTable.h"
 * 
 * Clase que implementa la tabla de símbolos
 * 
 * @author Gustavo El Khoury <gustavoelkoury@gmail.com>
 * @author Wilmer Bandres <wilmer0593@gmail.com>
 */
MadafakaSymTable::MadafakaSymTable():symbols() {}

void MadafakaSymTable::insert(MadafakaSymbol& symbol){
	symbols[symbol.getName()]=&symbol;
}

MadafakaSymbol MadafakaSymTable::get(string key){
	return *symbols[key];
}