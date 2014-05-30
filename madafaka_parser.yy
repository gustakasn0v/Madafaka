/* Use the LALR1 parser skeleton */
%skeleton "lalr1.cc"

/* This project requires version 2.5 of Bison, as it comes with Debian 7 */
%require  "2.5"

%defines 
/* Use a particular namespace and parser class */ 
%define namespace "Madafaka"
%define parser_class_name "Madafaka_Parser"


/* Debug-enabled parser */
%debug
%code requires{
   #ifndef MADAFAKATYPES_H
    #include "MadafakaTypes.hpp"
   #endif
   namespace Madafaka {
      class Madafaka_Driver;
      class Madafaka_Scanner;
   }
}

/* Pass the custom Driver and Scanner we made to the lexer and parser */
%lex-param   { Madafaka_Scanner  &scanner  }
%parse-param { Madafaka_Scanner  &scanner  }

%lex-param   { Madafaka_Driver  &driver  }
%parse-param { Madafaka_Driver  &driver  }


/* token types */
%union {  
   std::string *strvalue;
   int intvalue;
   float floatvalue;
   bool boolvalue;
   char charvalue;
   MadafakaType *typevalue;
   arbol *symboltreevalue;
}


%code{
   #include <iostream>
   #include <cstdlib>
   #include <fstream>
   
   /* include for all driver functions */
   #include "madafaka_driver.hpp"

   /* Position tracking variables from Flex */
   extern int yyline, frcol, tocol;

   /* If there was a Lexycal error, this will be set to true by Flex */
   extern bool lexerror;

   //int yylex(Madafaka::Madafaka_Parser::semantic_type*);
   /* this is silly, but I can't figure out a way around */
   static int yylex(Madafaka::Madafaka_Parser::semantic_type *yylval,
                    Madafaka::Madafaka_Parser::location_type*,
                    Madafaka::Madafaka_Scanner  &scanner,
                    Madafaka::Madafaka_Driver   &driver);

   /*Incluyendo estructuras auxiliares*/  
	arbol raiz;
 	arbol *actual = &raiz;
  arbol *nuevaTabla;
	arbol *ant;
	arbol *bloque_struct;
	string last;
  // Booleano que marca si la compilación va bien. Si no, no se 
  // imprime el árbol
	bool compiled = true;
	int os = 1; //valor para indicar el offset hacia arriba
		    // o hacia abajo
  
	int var =0;//Valor que indica si una variable esta siendo
		  //pasada por valor o referencia
		  //si es 0 es por valor
		    
  // Booleano que indica si han habido errores en el uso de campos de struct
  // o valores de arreglos
  bool structureError = false;

  // Entero que almacena la posición del argumento para el que se está checkeando el tipo
  int argpos=0;

  // Firma de la función invocada, para revisar la firma de los argumentos
  // También sirver para heredar la firma de la función al final de la regla
  // de declaración de función, para insertar la firma en la table
  FunctionType *procType;

  // Booleano que indica que se han revisado los argumentos de las invocaciones
  // a funciones, y que todo va bien
  bool invocation_ok;
}

/* Until whe have an AST, every nonterminal symbol with semantic meaning
  will remain with string value */

/* Reserved words and its tokens */
%token <strvalue> START "mada"
%token <strvalue> END "faka"
%token <strvalue> IDENTIFIER "variable_identifier"
%token <strvalue> SEPARATOR ";"
%token <strvalue> ASSIGN "="
%token <strvalue> COMMA ","
%token <strvalue> RPAREN ")"
%token <strvalue> COMMENT "??"
%token <strvalue> DECLARATIONS "@@"

/* Primitive and composite data types */
%token <strvalue> INTEGER "idafak"
%token <strvalue> STRUCT "strdafak"
%token <strvalue> CHAR "cdafak"
%token <strvalue> STRING "sdafak"
%token <strvalue> FLOAT "fdafak"
%token <strvalue> BOOL "bdafak"
%token <strvalue> VOID "vdafak"
%token <strvalue> FOR "fordafak"
%token <strvalue> WHILE "whiledafak"
%token <strvalue> BREAK "madabreak"
%token <strvalue> IF "ifdafak"
%token <strvalue> ELSE "else"
%token <strvalue> READ "rdafak"
%token <strvalue> WRITE "wdafak"
%token <strvalue> VAR "var"
%token <strvalue> UNION "unidafak"

/* Tokens for constant expresions (eg. 42, "blah", 3.8) */
%token <intvalue> INTVALUE "int_value"
%token <floatvalue> FLOATVALUE "float_value"
%token <boolvalue> BOOLVALUE "boolean_value"
%token <strvalue> STRVALUE "string_value"
%token <charvalue> CHARVALUE "char_value"
%token <strvalue> LARRAY "["
%token <strvalue> RARRAY "]"
%token DOT "."

//%token OR AND PLUS MINUS LESS LESSEQ GREAT GREATEQ TIMES DIVIDE MOD EQ UMINUS NOT LPAREN

/* Tokens for boolean/arithmetic expressions */
%left OR AND PLUS MINUS LESS LESSEQ GREAT GREATEQ
%left TIMES DIVIDE MOD
%left EQ
%left UMINUS

%nonassoc NOT
%nonassoc LPAREN

/*extra tokens*/
%token <strvalue> UNKNOWN

/* Nonterminals. I didn't put the union type! */
%type <strvalue> program
%type <strvalue> instruction_list
%type <strvalue> instruction
%type <typevalue> declaration
%type <typevalue> declaration1
%type <typevalue> declaration11
%type <typevalue> declaration2
%type <typevalue> arg_decl
//%type <typevalue> initial_str

%type <symboltreevalue> arg_decl_list
%type <symboltreevalue> arg_decl_list1
%type <symboltreevalue> declaration_list
%type <typevalue> id_dotlist1
%type <typevalue> id_dotlist2
%type <typevalue> assign
%type <strvalue> procedure_decl  
%type <typevalue> procedure_invoc
%type <strvalue> write
%type <strvalue> read
%type <strvalue> while_loop
%type <strvalue> for_loop
%type <typevalue> typo
%type <typevalue> typoBase
%type <strvalue> typo2
%type <strvalue> if_block
%type <typevalue> array_variable
%type <typevalue> general_expression
%type <typevalue> expression
%type <typevalue> arithmetic_comparison
%type <typevalue> variable

%start program

%%

program:
  //Regla para definir un programa
  START bloque END
  { 
    if (compiled and !lexerror) recorrer(&raiz,0);
    return 0; 
  }
  | error {compiled = false; error(@$,"Something wicked happened");}
  ;

//Regla que define un bloque del programa, que consta de 
//una lista de Declaraciones e instrucciones
bloque:
	{actual=enterScope(actual);} 
	DECLARATIONS declaration_list DECLARATIONS instruction_list 
	{actual = exitScope(actual);}
  | error {compiled = false; error(@$,"Something wicked happened");}
	;

//regla que define una lista de instrucciones
instruction_list:

  | instruction SEPARATOR instruction_list
  | instruction error instruction_list {compiled = false; error(@$,"Las declaraciones van separadas por ;");}
  ;

//Regla que define como esta conformada una sola instruccion
instruction:
  assign 
  | procedure_invoc
  | write
  | read
  | while_loop
  | BREAK
  | for_loop
  | if_block
  | START bloque END
  | error {compiled = false; error(@$,"Instruccion no valida");} //Instruccion no valida
  ;

//lista de declaraciones
declaration_list:

	| declaration SEPARATOR declaration_list { $$ = actual;}
  | declaration error declaration_list {compiled = false ; error(@$,"Las declaraciones van separadas por ;");}
	;


declaration11:
  // Declaración de una variable o arreglo de variables de tipo primitivo
  typoBase IDENTIFIER array_variable{ 
      //verifica si la variable esta declarada
      if(!(*actual).estaContenido(*($2))){
      string *s3 = new string(*($2));
      string s2 = to_string(argpos);
      // Chequeamos si es un arreglo
      
      if (*($3) == "Void"){
        (*actual).insertar(s2,$1,yyline,frcol,0);
        (*actual).insertar(*s3,$1,yyline,frcol,0);
        if(os>0){
	  (*actual).setOffset(*s3,(*actual).getBase());
	  (*actual).addBase(($1)->tam *os);
	}
	else{
	  (*actual).addBase(($1)->tam *os);
	  (*actual).setOffset(*s3,(*actual).getBase());
	}
        //cout << $1->tam << endl;
      }
      else{
        ArrayType *nuevotipo = new ArrayType($3->tam * $1->tam,$1);
        (*actual).insertar(s2,nuevotipo,yyline,frcol,0);
        (*actual).insertar(*s3,nuevotipo,yyline,frcol,0);
        if(os>0){
	  (*actual).setOffset(*s3,(*actual).getBase());
	  (*actual).addBase(($1)->tam *os * $3->tam);
	}
	else{
	  (*actual).addBase(($1)->tam * $3->tam * os);
	  (*actual).setOffset(*s3,(*actual).getBase());
	}
	}
			
      }  
  	else{
  		compiled = false;
  		string errormsg = string("Variable ya declarada en el mismo bloque: ")
  		+ string(*($2));
  		error(@$,errormsg);
  	}
  }
  | error {compiled = false; error(@$,"Variable debe ser pasada por referencia");}
;
	
declaration1:
  // Declaración de una variable o arreglo de variables de tipo primitivo
  typo IDENTIFIER array_variable{ 
      if(!(*actual).estaContenido(*($2))){
      string *s2 = new string(*($2));
      // Chequeamos si es un arreglo
      
      if (*($3) == "Void"){
        (*actual).insertar(*s2,$1,yyline,frcol,0);
        if(os>0){
    //Atualizacines de offset
	  (*actual).setOffset(*s2,(*actual).getBase());
	  (*actual).addBase(($1)->tam *os);
	}
	else{
	  (*actual).addBase(($1)->tam *os);
	  (*actual).setOffset(*s2,(*actual).getBase());
	}
        //cout << $1->tam << endl;
      }
      else{
        //Actualizaciones de offset
        ArrayType *nuevotipo = new ArrayType($3->tam * $1->tam,$1);
        (*actual).insertar(*s2,nuevotipo,yyline,frcol,0);
        if(os>0){
	  (*actual).setOffset(*s2,(*actual).getBase());
	  (*actual).addBase(($1)->tam *os * $3->tam);
	}
	else{
    //Actualizacion de offset
	  (*actual).addBase(($1)->tam * $3->tam * os);
	  (*actual).setOffset(*s2,(*actual).getBase());
	}
	}
			
      }  
  	else{
  		compiled = false;
  		string errormsg = string("Variable ya declarada en el mismo bloque: ")
  		+ string(*($2));
  		error(@$,errormsg);
  	}
  }
;

//declaracion de un struct o un union
declaration2:
  typo2 IDENTIFIER START 
  	{actual = enterScope(actual);}  
	declaration_list END
  	{
      nuevaTabla = actual;
    	actual = exitScope(actual);
	    nuevaTabla->var = false;
      //Verifica si este tipo de estructura o union ya esta contenido
    	if(!(*actual).estaContenido(*($2))){
        if (*($1) == "Union"){
          UnionType *newUnion = new UnionType($2,nuevaTabla);
          newUnion->tam = (*nuevaTabla).getBase();
          (*actual).insertar(*($2),newUnion,yyline,frcol,1);
          $$ = newUnion;
        }
        else{
          RecordType *newRecord = new RecordType($2,nuevaTabla);
          newRecord->tam = (*nuevaTabla).getBase();
          (*actual).insertar(*($2),newRecord,yyline,frcol,1);
          $$ = newRecord;
        }  
      }  
    	else{
    		compiled = false;
    		string errormsg = string("Variable ya declarada en el mismo bloque: ")
    		+ string(*($2));
    		error(@$,errormsg);
		}

	}
    ;

// initial_str:

//   | declaration2 SEPARATOR initial_str;
  
    
declaration:
  // Declaración de una variable o arreglo de variables de tipo primitivo
   declaration1
  // Declaración de un struct o union
  | declaration2
  | procedure_decl
	

  | typo2 error {
	 				compiled = false;
					error(@$,"Nombre de variable no valido");


	  			}

  | typo error {
	  				compiled = false;
					error(@$,"Nombre de variable no valido");
	 			}
  ;

//Verifica si una variable es un arreglo o no
array_variable:
    {$$ = new VoidType();}
| LARRAY INTVALUE RARRAY 
    {$$ = new ArrayType($2,new VoidType());}


//Define los tipos bases en MadafakaLanguage
typoBase:
  INTEGER {$$ = new IntegerType();}
  | FLOAT {$$ = new FloatType();}
  | CHAR {$$ = new CharType();}
  | STRING {$$ = new StringType();}
  | VOID {$$ = new VoidType();}
  | BOOL {$$ = new BoolType();}
  ;

//Define todo los tipos posibles del lenguaje
typo:
  typoBase {$$=$1;}
  | IDENTIFIER {
      MadafakaType *fromSymTable;
      fromSymTable = buscarVariable(*($1),actual);
      if((*fromSymTable)=="Union" || (*fromSymTable)=="Struct"){
        $$ = fromSymTable;
      }
      else{
        compiled=false;
        string errormsg = string("Tipo compuesto no declarado: ")+ string(*($1));
        error(@$,errormsg);
      }
  }
  ;

typo2:
	UNION {$$ = new string("union");}
	| STRUCT {$$ = new string("struct");}
	;



// Producciones que se encargan del acceso a campos del struct o union
id_dotlist1:
  IDENTIFIER LARRAY INTVALUE RARRAY
  {
    MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($1),actual);
    string s1 = (*actual).getTipoArray(*($1));
    if(!(*fromSymTable=="Array")){
      compiled = false;
      string errormsg = string("La variable no es un arreglo o es un arreglo de una estructura anidada: ")
      + *($1);
      error(@$,errormsg);
      $$ = new TypeError();
    }
    else{
      ArrayType *miarreglo = (ArrayType *) fromSymTable;
      $$ = miarreglo->type;
    }
  }

  | IDENTIFIER LARRAY INTVALUE RARRAY 
  {
    MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($1),actual);
    //Verifica si el arreglo es un arreglo de tipos anidados
    //y actualiza el bloque del struct para seguir verificando en los accesos a campos
    if(*fromSymTable=="Array"){
      ArrayType *miarreglo = (ArrayType *)fromSymTable;
      MadafakaType *tipoarray =  miarreglo->type;
      if ((*tipoarray == "Union")){
        UnionType *miunion = (UnionType *) tipoarray;
        bloque_struct = miunion->SymTable;
      }
      else if (*tipoarray == "Struct"){
        RecordType *mirecord = (RecordType *) tipoarray;
        bloque_struct = mirecord->SymTable;
      }
      else{
        compiled = false;
        structureError = true;
        string errormsg = string("La variable no es un arreglo de una estructura anidada: ")
        + *($1);
        error(@$,errormsg);
      }
    }
    else{
      compiled = false;
      structureError = true;
      string errormsg = string("La variable no es un arreglo: ")
      + *($1);
      error(@$,errormsg);
    }
  }
    DOT id_dotlist2
  {
    if (!structureError) $$ = $id_dotlist2;
    else $$ = new TypeError();
    structureError = false;
  }

  | IDENTIFIER 
  {
    MadafakaType *s =  buscarVariable(*($1),actual);
    if(!((*s)=="Struct") && !((*s)=="Union")){
      compiled = false;
      structureError = true;
      string errormsg = string("La variable no es de tipo strdafak o unidafak: ")
      + *($1);
      error(@$,errormsg);
    }
    else{
      if ((*s == "Union")){
        UnionType *miunion = (UnionType *) s;
        bloque_struct = miunion->SymTable;
      }
      else if (*s == "Struct"){
        RecordType *mirecord = (RecordType *) s;
        bloque_struct = mirecord->SymTable;
      }
    }
  } 
  DOT id_dotlist2
  {
    if (!structureError) $$ = $id_dotlist2;
    else $$ = new TypeError();
    structureError = false;
  }

id_dotlist2:
  IDENTIFIER
  {
    if (!structureError){
      MadafakaType *ptr = buscarVariable(*($1),bloque_struct);
      if(*ptr == "Undeclared"){
        compiled = false;        
        string errormsg = string("Campo no contenido en la estructura: ")
        + *($1);
        error(@$,errormsg);
        $$ = new TypeError();
      }
      else{
        $$ = ptr;
      }
    }
    else $$ = new TypeError();
  }

  | IDENTIFIER 
  {
    if(!structureError){
      MadafakaType *s =  buscarVariable(*($1),bloque_struct);
      if(!((*s)=="Struct") && !((*s)=="Union")){
        compiled = false;
        structureError = true;
        string errormsg = string("La variable no es de tipo strdafak o unidafak: ")
        + *($1);
        error(@$,errormsg);
      }
      else{
        if ((*s == "Union")){
          UnionType *miunion = (UnionType *) s;
          bloque_struct = miunion->SymTable;
        }
        else if (*s == "Struct"){
          RecordType *mirecord = (RecordType *) s;
          bloque_struct = mirecord->SymTable;
        }
      }  
    }
  }
  DOT id_dotlist2[right]
  {
    if (!structureError) $$ = $right;
    else $$ = new TypeError();
    structureError = false;
  }

  | IDENTIFIER LARRAY INTVALUE RARRAY
  {
    if (!structureError){
      MadafakaType *fromSymTable;
      fromSymTable = buscarVariable(*($1),bloque_struct);
      if(*fromSymTable=="Array"){
        ArrayType *miarreglo = (ArrayType *)fromSymTable;
        MadafakaType *tipoarray =  miarreglo->type;
        $$ = tipoarray;
      }
      else{
        compiled = false;
        string errormsg = string("La variable no es un arreglo: ")
        + *($1);
        error(@$,errormsg);
      }
    }
  }

  | IDENTIFIER LARRAY INTVALUE RARRAY 
  {
    if (!structureError){
      MadafakaType *fromSymTable;
      fromSymTable = buscarVariable(*($1),bloque_struct);
      if(*fromSymTable=="Array"){
        ArrayType *miarreglo = (ArrayType *)fromSymTable;
        MadafakaType *tipoarray =  miarreglo->type;
        if ((*tipoarray == "Union")){
          UnionType *miunion = (UnionType *) tipoarray;
          bloque_struct = miunion->SymTable;
        }
        else if (*tipoarray == "Struct"){
          RecordType *mirecord = (RecordType *) tipoarray;
          bloque_struct = mirecord->SymTable;
        }
        else{
          compiled = false;
          structureError = false;
          string errormsg = string("La variable no es un arreglo de estructura anidada: ")
          + *($1);
          error(@$,errormsg);
        }
      }
      else{
        compiled = false;
        structureError = true;
        string errormsg = string("La variable no es un arreglo: ")
        + *($1);
        error(@$,errormsg);
      }
    }
  }
  DOT id_dotlist2[right]
  {
    if (!structureError) $$ = $right;
    else $$ = new TypeError();
    structureError = false;
  }

  | error {error(@$,"Acceso a de strdafak o unidafak de manera incorrecta.");}
  ;

//Regla que define una asignacion
assign:
  IDENTIFIER ASSIGN STRVALUE
  {
    MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($1),actual);
    //verifica si esta declarada la variable
    if((*fromSymTable)=="Undeclared"){
      compiled=false;
      string errormsg = string("Variable no declarada: ")+ string(*($1));
      error(@$,errormsg);
      $$ = new TypeError();
    }
    else if(*fromSymTable != "Sdafak"){
      compiled=false;
      string errormsg = string("Asignación de string a variable que no es de tipo sdafak: ")+ string(*($1));
      error(@$,errormsg);
      $$ = new TypeError();
    }
    else $$ = new StringType();
  }

  | IDENTIFIER ASSIGN expression{
    MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($1),actual);
    //verifica si esta declarada la variable
  	if((*fromSymTable)=="Undeclared"){
  		compiled=false;
  		string errormsg = string("Variable no declarada: ")+ string(*($1));
  		error(@$,errormsg);
      $$ = new TypeError();
  	}
    else if(*fromSymTable == *($3)){
      // Se asignó correctamente la expresión
      $$ = $3;
    }
    else{
      compiled=false;
      string message;
      if (*($3) != "TypeError"){
        message = string("Error en la asignación: se le intenta asignar una expresión de tipo ")
        + string(*($3));
        message += string(" a una variable de tipo ") + string(*($1));
        error(@$,message);
      }
      $$ = new TypeError();
    }
  }									
 | id_dotlist1 ASSIGN expression{ //asignaciones para campos en structs o unions
    if(*($1) == *($3)){
      // Se asignó correctamente la expresión
      $$ = $3;
    }
    else{
      compiled=false;
      string message;
      if (*($3) != "TypeError"){
        message = string("Error en la asignación: se le intenta asignar una expresión de tipo ")
        + string(*($3));
        message += string(" a una variable de tipo ") + string(*($1));
        error(@$,message);
      }    
      $$ = new TypeError();
    }
 }								
 ;

// There's a reduce/reduce conflict here, since the parser
// might see the error token, and wouldn't know to reduce
// using an arithmetic or boolean expression. The error
// message is the same in both cases, so "deje así"
expression:
  general_expression
  {
    if (*($1) == "TypeError"){
      compiled = false;
      error(@$,"Expresión malformada");
      $$ = new TypeError();
    }
    else $$ = $1;
  }
  ;

//Define todas las posibles expresiones validas en un lenguaje,
//ya sea arimetica o booleana
general_expression:
  general_expression[leftBool] AND general_expression[rightBool]
  {
    string errormsg;
    $$ = checkBooolean(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }

  | general_expression[leftBool] OR general_expression[rightBool]
  {
    string errormsg;
    $$ = checkBooolean(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }

  | general_expression[leftArithmetic] PLUS general_expression[rightArithmetic]
  {
    string errormsg;
    $$ = checkArithmetic(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }

  | general_expression[leftArithmetic] MINUS general_expression[rightArithmetic]
  {
    string errormsg;
    $$ = checkArithmetic(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }

  | general_expression[leftArithmetic] TIMES general_expression[rightArithmetic]
  {
    string errormsg;
    $$ = checkArithmetic(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }

  | general_expression[leftArithmetic] DIVIDE general_expression[rightArithmetic]
  {
    string errormsg;
    $$ = checkArithmetic(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }

  | general_expression[leftArithmetic] MOD general_expression[rightArithmetic]
  {
    string errormsg;
    $$ = checkArithmetic(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }

  | LPAREN general_expression RPAREN
  {
    $$ = $2;
  }

  | NOT general_expression
  {
    //si no es booleano, la expresion que acompania al NOT, entonces 
    //Hay error de tipo
    if (*($2) != "Bdafak") {
      compiled = false;
      string errormsg = 
      string("Se intentó aplicar un operador booleano a una expresión ");
      if (*($2) != "TypeError"){
        errormsg+=string("malformada");
      }
      else{
        errormsg+=string("de tipo ")+string(*($2));
      }
      error(@$,errormsg);
    }
    else $$ = $2;
  }

  | MINUS general_expression %prec UMINUS
  {
    //Verifica si la expresion precedida por el signo -, es de tipo numerico
    if (*($2) != "Fdafak" && *($2) != "Idafak") {
      compiled = false;
      string errormsg = 
      string("Se intentó aplicar un operador aritmético a una expresión ");
      if (*($2) != "TypeError"){
        errormsg+=string("malformada");
      }
      else{
        errormsg+=string("de tipo ")+string(*($2));
      }
      error(@$,errormsg);
    }
    else $$ = $2;
  }

  | arithmetic_comparison
  {
    $$ = $1;
  }

  | variable
  {
    $$ = $1;
  }

  | BOOLVALUE
  {
    $$ = new BoolType();
  }

  | INTVALUE{
    $$ = new IntegerType();
  }

  | FLOATVALUE{
    $$ = new FloatType();
  }

  | id_dotlist1 
  {
    $$ = $1;
  }
  | procedure_invoc 
  {
    $$ = $1;
  }
  ;

//Verifica si una variable esta declarada y retorna su tipo
variable:
  IDENTIFIER
  {
    MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($1),actual);
    if(*fromSymTable =="Undeclared" || *fromSymTable == "Function" ){
      compiled = false;
      string errormsg = 
        string("Variable no declarada, o funcion con el mismo nombre solamente declarada: ")
        + string(*($1));
        error(@$,errormsg);
        $$ = new TypeError();
    }
    else $$ = fromSymTable;
  }

//Define una comparacion aritmetica
arithmetic_comparison:
  general_expression EQ general_expression
  {
    string errormsg;
    $$ = checkComparison(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }

  | general_expression LESS general_expression
  {
    string errormsg;
    $$ = checkComparison(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }
  ;

  | general_expression LESSEQ general_expression
  {
    string errormsg;
    $$ = checkComparison(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }
  ;

  | general_expression GREAT general_expression
  {
    string errormsg;
    $$ = checkComparison(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }
  ;

  | general_expression GREATEQ general_expression
  {
    string errormsg;
    $$ = checkComparison(errormsg,$1,$3);
    if (*($$) == "TypeError") error(@$,errormsg);
  }
  ;

//Regla para la definicion de procedimientos
procedure_decl:
  typo IDENTIFIER LPAREN 
  {ant=actual;actual=enterScope(actual);os=-1;argpos=0;}
  arg_decl_list 
  {
    nuevaTabla = actual;
    os=1;
    actual->addBase(-actual->getBase());
    MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($2),actual);
    if(*fromSymTable == "Undeclared"){
      int t1 = yyline;
      int t2 = frcol;
      FunctionType *tipoFuncion = new FunctionType(nuevaTabla,$1);
      if (argpos == 0) (*tipoFuncion).noargs = 0;
      argpos = 0;
		(*actual).insertar(*($2),tipoFuncion,t1,t2,0);
  }
    else{
	     error(@$,"Funcion ya declarada anteriormente");
    }
  }
  RPAREN START bloque END 
	{
    MadafakaType *fromSymTable = buscarVariable(*($2),actual);
    FunctionType *tipoFuncion = (FunctionType *) fromSymTable;
    pair<int,int> ubicacion = (*actual).getUbicacion(*($2));
    (*(tipoFuncion->args)).borrarMapaContenido(*($2));
    actual=exitScope(actual);
    if (ubicacion != make_pair(-1,-1)){
      (*actual).insertar(*($2),tipoFuncion,ubicacion.first,ubicacion.second,0);
    }

    
	}
  ;

//Define la invocacin de una funcion,
// y verifica que los tipos de los argumentos que le son pasados
// son del tipo correcto
procedure_invoc:
  IDENTIFIER
  {
		MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($1),actual);
    if(*fromSymTable == "Undeclared"){
      string errormsg = string("Función no declarada: ")+ string(*($1));
      error(@$,errormsg);
      compiled = false;
      invocation_ok = false;
    }
    else if(*fromSymTable !="Function"){
      string errormsg = 
        string("Se esta usando una variable como funcion: ")
        + string(*($1));
      error(@$,errormsg);
      compiled = false;
      invocation_ok = false;
    }
    else{
      procType = ((FunctionType *)fromSymTable);
      argpos = 0;
    }
	}
  LPAREN arg_list RPAREN
  {
    if (structureError){
      $$ = new TypeError();
    }
    else {
      MadafakaType *fromSymTable;
      fromSymTable = buscarVariable(*($1),actual);
      $$ = fromSymTable;
    }
    structureError = false;
  }
  ;


//define una lista de argumentos declarados para una funcion
arg_decl_list:
  
  | arg_decl arg_decl_list1 {$$=actual;}
  ;

arg_decl_list1:
  {$$=actual;}
  | COMMA {argpos++;}arg_decl arg_decl_list1 {$$=actual;}
  |  error arg_decl {compiled = false ; error(@$,"Los argumentos deben ir separados por comas");}  
  ;

//Define la declaracio nde una variable
arg_decl:
  declaration11 
  | {var=1;}VAR declaration11 {var=0;}
  ;

arg_list:
  {
    if (!(*procType).noargs){
      invocation_ok = false;
    }
  }
  | expression
  {
    if (invocation_ok){
      MadafakaType *supposedType=(*procType).get_argument(argpos);
      MadafakaType *realType = ($1);
      if (*supposedType != *realType ) {
        compiled = false;
        invocation_ok = false;
        string errormsg = 
        string("Se pasó un argumento de tipo ") + string(*realType)
        + string(" pero se esperaba de tipo ") + string(*supposedType);
        error(@$,errormsg);
      }
      else argpos++;
    }
  }
  arg_list1
  ;

arg_list1:
  
  | COMMA expression arg_list1
  {
    if (invocation_ok){
      MadafakaType *supposedType=(*procType).get_argument(argpos);
      MadafakaType *realType = ($2);
      if (*supposedType != *realType ) {
        compiled = false;
        invocation_ok = false;
        string errormsg = 
        string("Se pasó un argumento de tipo ") + string(*realType)
        + string(" pero se esperaba de tipo ") + string(*supposedType);
        error(@$,errormsg);
      }
      else argpos++;
    }
  }

  | error expression {compiled = false ; error(@$,"Los argumentos deben ir separados por comas");}
  ;


//Define la funcion write
write:
  WRITE expression
  | WRITE STRVALUE
  ;

//Define la funcion read para el lenguaje
read:
  READ IDENTIFIER 
	{
    MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($2),actual);
		if(*fromSymTable=="Undeclared" || *fromSymTable == "Function"){
  		compiled = false;
  		string errormsg = string("Variable no declarada: ")
  		+ string(*($2));
  		error(@$,errormsg);
    }
  }

  | READ id_dotlist1
  ;

//Define una iteracion while del lenguaje
while_loop:
  WHILE expression START bloque END
  {
    if (*($2) != "Bdafak"){
      compiled = false;
      error(@$,"Error en la condición del while");
    }
  }

  | WHILE error END {compiled = false ; error(@$,"Bloque while malformado");}
  ;


//Define una iteracion for del lenguaje
for_loop:
  FOR LPAREN assign SEPARATOR expression SEPARATOR assign RPAREN START bloque END
  {
    if (*($5) != "Bdafak"){
      compiled = false;
      error(@$,"Error en la condición del for");
    }
  }

  | FOR error END {compiled = false ; error(@$,"Bloque for malformado");}
  ;

//Define una isntruccion if para el lenguaje
if_block:
  IF expression START bloque END
  {
    if (*($2) != "Bdafak"){
      compiled = false;
      error(@$,"Error en la condición del if");
    }
  }

  | IF expression START bloque END ELSE START bloque END
  {
    if (*($2) != "Bdafak"){
      compiled = false;
      error(@$,"Error en la condición del if");
    }
  }

  | IF error END {compiled = false ; error(@$,"Bloque if malformado");}
  ;

%%


void Madafaka::Madafaka_Parser::error( const location_type&,const string& err_message)
{
     fprintf(stderr, "Linea: %d Columna: %d-%d: ", yyline, frcol, tocol);
     std::cerr << err_message << "\n";
     compiled=false;
}

/* include for access to scanner.yylex */
#include "madafaka_scanner.hpp"
static int yylex(Madafaka::Madafaka_Parser::semantic_type *yylval,
                 Madafaka::Madafaka_Parser::location_type*,
                 Madafaka::Madafaka_Scanner  &scanner,
                 Madafaka::Madafaka_Driver   &driver)
{
   return( scanner.yylex(yylval) );
}