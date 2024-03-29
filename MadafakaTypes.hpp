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

/*
 Nota: los comentarios que explican el significado de cada funcion
	estan en el archivo .cpp
 */

class MadafakaType{
 public:
  int tam;
  bool var;
  string name;
  MadafakaType(){}
  bool operator==(MadafakaType &rhs);
  bool operator!=(MadafakaType &rhs);
  bool operator==(const char* word);
  bool operator!=(const char* word);
  operator string() const;
  friend std::ostream& operator<<(std::ostream &os,MadafakaType const &var);
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
 public:
  int size;
  MadafakaType *type;
  ArrayType(int, MadafakaType*);
};

//ArrayType *ArrayType::singleton_instance = NULL;

class VoidType: public MadafakaType{
  static VoidType *singleton_instance;
 public:
  VoidType();
  static VoidType *instance();
};

//VoidType *VoidType::singleton_instance = NULL;


class RefType: public MadafakaType{
  static RefType *singleton_instance;
 public:
  RefType();
  static RefType *instance();
  MadafakaType *ref;
};



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

MadafakaType* check_and_widen(MadafakaType *left, MadafakaType *right);

MadafakaType *checkBooolean(string &errormsg,MadafakaType *leftBool,MadafakaType *rightBool);

MadafakaType *checkArithmetic(string &errormsg,MadafakaType *leftBool,MadafakaType *rightBool);

MadafakaType *checkComparison(string &errormsg,MadafakaType *leftBool,MadafakaType *rightBool);


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
      map<string,int> tams;
      map<string,int> offset;
      map<string,pair<int,int> > ubicacion;
      map<string,int> bloque;
      map<string,int> arguments;
      map<string,string> arrays;
      int base;
      int base2;//representa la base en negativo
		//se utiliza para las funciones
		//donde el negativo representan el offset en
		//la pila

    public:
      bool var;
      arbol(){papa=NULL;contenido.clear();ubicacion.clear();base=0;var=true;}
      arbol(arbol *p,arbol *cont) : papa(p){contenido.clear();base=0;var=true;}
      void addHijo(arbol *);
      void setPapa(arbol *);
      vector<arbol *> getHijos();
      arbol *getPapa();
      void insertar(string ,MadafakaType*, int, int, int);
      int estaContenido(string &);
      MadafakaType *tipoVar(string &);
      map<string,MadafakaType*> getMapaContenido();
      pair<int,int> getUbicacion(string&);
      map<string,pair<int,int> > getMapaUbicacion();
      map<string,int> getBloque();
      arbol *hijoEnStruct(string &);
      void esArray(string &);
      string getTipoArray(string &);
      int getTam(string &);
      int getBase();
      void addBase(int);
      void setOffset(string &, int);
      int getOffset(string &);
      void borrarMapaContenido(string &);
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
  string *symbolName;
 public:
  arbol* SymTable;
  RecordType(){}
  RecordType(string*, arbol*);
  bool operator==(RecordType &rhs);
  arbol* getSymTable();
};

class UnionType: public MadafakaType{
private:
  string *symbolName;
 public:
  arbol* SymTable;
  UnionType(string*, arbol*);
  bool operator==(UnionType &rhs);
  arbol* getSymTable();
};

class FunctionType: public MadafakaType{
  MadafakaType *result;
 public:
  arbol *args;
  bool noargs;
  FunctionType(arbol*,MadafakaType*);
  MadafakaType* get_argument(int position);
};

#endif
