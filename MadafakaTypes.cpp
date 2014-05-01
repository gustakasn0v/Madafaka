#include <string>
#include <iostream>
#include "MadafakaTypes.hpp"
using namespace std;
/**
 * @class MadafakaTypes "MadafakaTypes.h"
 * 
 * Implementación de las clases del Sistema de Tipos
 * 
 * @author Gustavo El Khoury <gustavoelkoury@gmail.com>
 * @author Wilmer Bandres <wilmer0593@gmail.com>
 */

void MadafakaType::print(){
		cout << "Tipo: " << name;
		return;
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

TypeError::TypeError(){
    name = "Error de tipos";
};
TypeError* TypeError::instance(){
    if (!singleton_instance)
          singleton_instance = new TypeError();
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


RecordType::RecordType(string newname){
 		name = newname;
};

// RecordType::getRecordTable(){
//  		return RecordTable;
// };
