#ifndef MADAFAKASYMTABLE_H
#define MADAFAKASYMTABLE_H

#include <string>
#include <map>
#include "MadafakaSymbol.hpp"
using namespace std;
/**
 * @class SymTable "SymTable.h"
 * 
 * Clase que implementa la tabla de símbolos
 * 
 * @author Gustavo El Khoury <gustavoelkoury@gmail.com>
 * @author Wilmer Bandres <wilmer0593@gmail.com>
 */
 class MadafakaSymTable{
 private:
 	// Hashtable for the symbols
 	std::map<string,MadafakaSymbol*> symbols;

 public:
 	MadafakaSymTable();

 	void insert(MadafakaSymbol& symbol);

 	MadafakaSymbol get(string key);
};

#endif
