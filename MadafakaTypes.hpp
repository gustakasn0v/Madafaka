#ifndef MADAFAKATYPES_H
#define MADAFAKATYPES_H

#include <string>
#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <new>
#include <utility>
#include <set>
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
  MadafakaType(){}
  bool operator==(MadafakaType &rhs);
  bool operator==(string &rhs);
  bool operator==(const char* word);
  std::ostream &operator<<(std::ostream &os);
  void print();
};

class IntegerType: public MadafakaType{
  static IntegerType *singleton_instance;
 public:
  IntegerType();
  static IntegerType *instance();
};

//IntegerType *IntegerType::singleton_instance = NULL;

class FloatType: public MadafakaType{
  static FloatType *singleton_instance;
 public:
  FloatType();
  static FloatType *instance();
};

//FloatType *FloatType::singleton_instance = NULL;

class StringType: public MadafakaType{
  static StringType *singleton_instance;
 public:
  StringType();
  static StringType *instance();
};

//StringType *StringType::singleton_instance = NULL;

class CharType: public MadafakaType{
  static CharType *singleton_instance;
 public:
  CharType();
  static CharType *instance();
};

//CharType *CharType::singleton_instance = NULL;

class BoolType: public MadafakaType{
  static BoolType *singleton_instance;
 public:
  BoolType();
  static BoolType *instance();
};

//BoolType *BoolType::singleton_instance = NULL;

class ArrayType: public MadafakaType{
  int lower,upper;
  MadafakaType *type;
 public:
  ArrayType(int, int, MadafakaType*);
};

//ArrayType *ArrayType::singleton_instance = NULL;

class VoidType: public MadafakaType{
  static VoidType *singleton_instance;
 public:
  VoidType();
  static VoidType *instance();
};

//VoidType *VoidType::singleton_instance = NULL;


class TypeError: public MadafakaType{
  static TypeError *singleton_instance;
 public:
  TypeError();
  static TypeError *instance();
};

//TypeError *TypeError::singleton_instance = NULL;

class Undeclared: public MadafakaType{
  static Undeclared *singleton_instance;
 public:
  Undeclared();
  static Undeclared *instance();
};

//Undeclared *Undeclared::singleton_instance = NULL;

// Cosas de estructuras.h

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
      map<string,int> arguments;
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

 
class RecordType: public MadafakaType{
private:
  arbol* SymTable;
  string *symbolName;
 public:
  RecordType(){}
  RecordType(string*, arbol*);
  bool operator==(RecordType &rhs);
  arbol* getSymTable();
};

class UnionType: public MadafakaType{
private:
  arbol* SymTable;
  string *symbolName;
 public:
  UnionType(string*, arbol*);
  bool operator==(UnionType &rhs);
  arbol* getSymTable();
};

class FunctionType: public MadafakaType{
  arbol *args;
  MadafakaType *result;
 public:
  FunctionType(arbol*,MadafakaType*);
};

#endif