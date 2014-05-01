#ifndef MADAFAKATYPES_H
#define MADAFAKATYPES_H

#include <string>
#include <iostream>
//#include "estructuras.h"
using namespace std;
/**
 * @class MadafakaTypes "MadafakaTypes.h"
 * 
 * Implementación de las clases del Sistema de Tipos
 * 
 * @author Gustavo El Khoury <gustavoelkoury@gmail.com>
 * @author Wilmer Bandres <wilmer0593@gmail.com>
 */
 class MadafakaType{

 	
 public:
  string name;
  MadafakaType();
 	void print();
};

 class IntegerType: public MadafakaType{
 	static IntegerType *singleton_instance;
 public:
  IntegerType();
 	static IntegerType *instance();
};

class FloatType: public MadafakaType{
 	static FloatType *singleton_instance;
 public:
  FloatType();
 	static FloatType *instance();
};

class StringType: public MadafakaType{
 	static StringType *singleton_instance;
 public:
  StringType();
 	static StringType *instance();
};

class CharType: public MadafakaType{
 	static CharType *singleton_instance;
 public:
  CharType();
 	static CharType *instance();
};

class TypeError: public MadafakaType{
  static TypeError *singleton_instance;
 public:
  TypeError();
  static TypeError *instance();
};

class BoolType: public MadafakaType{
 	static BoolType *singleton_instance;
 public:
  BoolType();
 	static BoolType *instance();
};

class RecordType: public MadafakaType{
private:
	//arbol RecordTable;
 public:
 	RecordType(string newname);

 	//arbol getRecordTable();
};
#endif
