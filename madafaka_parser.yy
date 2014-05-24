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
	arbol *bloque_struct;
	string last;
  // Booleano que marca si la compilación va bien. Si no, no se 
  // imprime el árbol
	bool compiled = true;

  // Booleano que indica si han habido errores en el uso de campos de struct
  // o valores de arreglos
  bool structureError = false;
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
%token <strvalue> LPAREN "("
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

/* Tokens for boolean/arithmetic expressions */
%token TRUE "true"
%token FALSE "false"
%token DOT "."

%left OR AND
%nonassoc NOT
%nonassoc LESS LESSEQ GREAT GREATEQ
%left EQ
%left PLUS MINUS
%left TIMES DIVIDE MOD
%left UMINUS

/*extra tokens*/
%token <strvalue> UNKNOWN

/* Nonterminals. I didn't put the union type! */
%type <strvalue> program
%type <strvalue> instruction_list
%type <strvalue> instruction
%type <typevalue> declaration
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
%type <strvalue> typo2
%type <strvalue> if_block
%type <typevalue> array_variable

%type <typevalue> general_expression
%type <typevalue> boolean_expression
%type <typevalue> arithmetic_comparison
%type <typevalue> arithmetic_expression
%type <strvalue> boolean_opr
%type <strvalue> arithmetic_opr
%type <strvalue> comparison_opr

%start program

%%

program:
  declaration_proc START bloque END
  { 
    if (compiled and !lexerror) recorrer(&raiz,0);
    return 0; 
  }
  | error {compiled = false; error(@$,"Something wicked happened");}
  ;

bloque:
	{actual=enterScope(actual);} 
	DECLARATIONS declaration_list DECLARATIONS instruction_list 
	{actual = exitScope(actual);}
  | error {compiled = false; error(@$,"Something wicked happened");}
	;

instruction_list:

  | instruction SEPARATOR instruction_list
  | error {compiled = false; error(@$,"Something wicked happened");}
  ;

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
  | error {compiled = false; error(@$,"Instruccion no valida");}
  ;


declaration_proc:
	
	| procedure_decl SEPARATOR declaration_proc
	;

declaration_list:

	| declaration SEPARATOR declaration_list { $$ = actual;}
  | declaration error declaration_list {compiled = false ; error(@$,"Las declaraciones van separadas por ;");}
	;


declaration:
  // Declaración de una variable o arreglo de variables de tipo primitivo
  typo IDENTIFIER array_variable{ 
		if(!(*actual).estaContenido(*($2))){
      string *s2 = new string(*($2));
      // Chequeamos si es un arreglo
      if (*($3) == "Void"){
        (*actual).insertar(*s2,$1,yyline,frcol,0);
      }
      else{
        ArrayType *nuevotipo = new ArrayType(0,$1);
        (*actual).insertar(*s2,nuevotipo,yyline,frcol,0);
      }
			
		}  
  	else{
  		compiled = false;
  		string errormsg = string("Variable ya declarada en el mismo bloque: ")
  		+ string(*($2));
  		error(@$,errormsg);
  	}
	}

  // Declaración de un struct o union
  | typo2 IDENTIFIER START 
  	{actual = enterScope(actual);}  
	declaration_list END
  	{
      nuevaTabla = actual;
    	actual = exitScope(actual);

    	if(!(*actual).estaContenido(*($2))){
        if (*($1) == "Union"){
          UnionType *newUnion = new UnionType($2,nuevaTabla);
          (*actual).insertar(*($2),newUnion,yyline,frcol,1);
          $$ = newUnion;
        }
        else{
          RecordType *newRecord = new RecordType($2,nuevaTabla);
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
	

  | typo2 error {
	 				compiled = false;
					error(@$,"Nombre de variable no valido");


	  			}

  | typo error {
	  				compiled = false;
					error(@$,"Nombre de variable no valido");
	 			}
  ;

array_variable:
    {$$ = new VoidType();}
| LARRAY arithmetic_expression RARRAY 
    {$$ = new ArrayType(0,new VoidType());}


typo:
  INTEGER {$$ = new IntegerType();}
  | FLOAT {$$ = new FloatType();}
  | CHAR {$$ = new CharType();}
  | STRING {$$ = new StringType();}
  | VOID {$$ = new VoidType();}
  | BOOL {$$ = new BoolType();}
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
  IDENTIFIER LARRAY arithmetic_expression RARRAY
  {
    MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($1),actual);
    string s1 = (*actual).getTipoArray(*($1));
    if(!(*fromSymTable=="Array")){
      compiled = false;
      structureError = true;
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

  | IDENTIFIER LARRAY arithmetic_expression RARRAY 
  {
    MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($1),actual);
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
  }

id_dotlist2:
  IDENTIFIER
  {
    if (!structureError){
      MadafakaType *ptr = buscarVariable(*($1),bloque_struct);
      if(*ptr == "Undeclared"){
        compiled = false;
        structureError = true;
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
  }

  | IDENTIFIER LARRAY arithmetic_expression RARRAY
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
        structureError = true;
        string errormsg = string("La variable no es un arreglo: ")
        + *($1);
        error(@$,errormsg);
      }
    }
  }

  | IDENTIFIER LARRAY arithmetic_expression RARRAY 
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
  }

  | error {error(@$,"Acceso a de strdafak o unidafak de manera incorrecta.");}
  ;

assign:
  IDENTIFIER ASSIGN general_expression{
    MadafakaType *fromSymTable;
    fromSymTable = buscarVariable(*($1),actual);
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
      string message = string("Error en la asignación: se le intenta asignar una expresión de tipo ")
      + string(*($3)) + string("a una variable de tipo ") + string(*($1));
      error(@$,message);
      $$ = new TypeError();
    }
  }									
 | id_dotlist1 ASSIGN general_expression{
    if(*($1) == *($3)){
      // Se asignó correctamente la expresión
      $$ = $3;
    }
    else{
      compiled=false;
      string message = string("Error en la asignación: se le intenta asignar una expresión de tipo ")
      + string(*($3)) + string("a una variable de tipo ") + string(*($1));
      error(@$,message);
      $$ = new TypeError();
    }
 }
									
 ;

// There's a reduce/reduce conflict here, since the parser
// might see the error token, and wouldn't know to reduce
// using an arithmetic or boolean expression. The error
// message is the same in both cases, so "deje así"
general_expression:
  arithmetic_expression {$$ = $1;}
  | boolean_expression {$$ = $1;}
  | error {compiled = false ; error(@$,"Expresión inválida");}  
  ;

// There are 3 shift/reduce conflicts, which occur when the parser
// has encountered a boolean expression, and upon seeing 
//boolean_opr ahead, doesn't know wether to reduce the expression
// already seen, or continue shifting, to increase the size of the 
// expression. Since we want the expression as a whole, rather than
// sets of smaller (component) expressions, we want the parser
// to shift upon conflicts like these, as it does by default. "Deje así"
boolean_expression:
  boolean_expression[left] boolean_opr boolean_expression[right]
  {
    if (*($left) != "Bdafak" || *($right) != "Bdafak") {
      $$ = new TypeError();
    }
    else $$ = new BoolType();
  }
  | LPAREN boolean_expression RPAREN
  {
    $$ = $2;
  }
  | NOT boolean_expression
  {
    $$ = $2;
  }
  | arithmetic_comparison
  {
    $$ = $1;
  }
  | IDENTIFIER
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
        else if(*fromSymTable != "Bdafak"){
          compiled = false;
          string errormsg = 
            string("Variable no declarada de tipo booleano: ")
            + string(*($1));
            error(@$,errormsg);
            $$ = new TypeError();
        }
        else $$ = fromSymTable;
  	}
  | BOOLVALUE {$$ = new BoolType();}
  | id_dotlist1 
  {
    if (*($1) != "Bdafak"){
      compiled = false;
      error(@$,"Error en expresión compuesta");
      $$ = new TypeError();
    }
    else $$ = new BoolType();
  }
  | procedure_invoc 
  {
    if (*($1) != "Bdafak"){
      compiled = false;
      error(@$,"Error en llamada a procedimiento");
      $$ = new TypeError();
    }
    else $$ = new BoolType();
  }
  ;

boolean_opr: AND | OR | EQ
  ;

arithmetic_comparison:
  arithmetic_expression comparison_opr arithmetic_expression
  {
    if (
      // Ambas expresiones son de tipo entero o flotante
      ((*($1) == "Idafak") || (*($1) == "Idafak")) 
      && ((*($3) == "Fdafak") || (*($3) == "Fdafak"))
      ){
      $$ = new BoolType();
    }
    else{
      compiled = false;
      string errormsg = string("Comparación booleana malformada");
      error(@$,errormsg);
      $$ = new TypeError();
    }
  }
  ;

comparison_opr: EQ | LESS | LESSEQ 
  | GREAT | GREATEQ
  ;


// This produces a shift/reduce situation similar to the one stated
// above, with the boolean expressions. As above, we are OK with the
// parser shifting in situations like these. "Deje así"
arithmetic_expression:
  arithmetic_expression[left] arithmetic_opr arithmetic_expression[right]
  {
    $$ = check_and_widen($left,$right);
  }
  | IDENTIFIER {
          MadafakaType *fromSymTable;
          fromSymTable = buscarVariable(*($1),actual);
	  			if(*fromSymTable=="Undeclared" || *fromSymTable == "Function"){
	  				compiled = false;
	  				string errormsg = 
  					string("Variable no declarada, o funcion con el mismo nombre solamente declarada: ")
  					+ string(*($1));
            error(@$,errormsg);
	  			}
          else if (*fromSymTable != "Idafak" && *fromSymTable != "Fdafak"){
            compiled = false;
            string errormsg = 
            string("Variable no numérica en una expresión aritmética: ")
            + string(*($1));
            error(@$,errormsg);
          }
          $$ = fromSymTable;
			}
	| MINUS arithmetic_expression %prec UMINUS
  {
    $$ = $2;
  }
  | LPAREN arithmetic_expression RPAREN
  {
    $$ = $2;
  }
  | INTVALUE{
    $$ = new IntegerType();
  }
  | FLOATVALUE{
    $$ = new FloatType();
  }
  | procedure_invoc
  {
    if (*($1) != "Fdafak" || *($1) != "Idafak"){
      compiled = false;
      error(@$,"Error en llamada a procedimiento");
      $$ = new TypeError();
    }
    else $$ = $1;
  }
  | id_dotlist1
  {
    if (*($1) != "Fdafak" || *($1) != "Idafak"){
      compiled = false;
      error(@$,"Error en expresión compuesta");
    }
  }
  ;


arithmetic_opr: PLUS | MINUS | TIMES | DIVIDE | MOD
  ;

procedure_decl:
  typo IDENTIFIER LPAREN 
  {actual=enterScope(actual);}
  arg_decl_list 
  {
    nuevaTabla = actual;
    actual=exitScope(actual);
  }
  RPAREN START bloque END 
			{
        MadafakaType *fromSymTable;
        fromSymTable = buscarVariable(*($2),actual);
				if(*fromSymTable == "Undeclared"){
					int t1 = yyline;
					int t2 = frcol;
          FunctionType *tipoFuncion = new FunctionType(nuevaTabla,$1);
	  				(*actual).insertar(*($2),tipoFuncion,t1,t2,0);
	  			}
				else{
					error(@$,"Funcion ya declarada anteriormente");
				}
			
	  		}
	  
  ;

procedure_invoc:
  IDENTIFIER LPAREN arg_list RPAREN  
  			{
	  			MadafakaType *fromSymTable;
          fromSymTable = buscarVariable(*($1),actual);
          if(*fromSymTable !="Function"){
            string errormsg = 
              string("Se esta usando una variable como funcion: ")
              + string(*($1));
            error(@$,errormsg);
            compiled = false;
          }
          else if(*fromSymTable == "Undeclared"){
            string errormsg = 
              string("Función no declarada: ")+ string(*($1));
            error(@$,errormsg);
            compiled = false;
          }
          $$ = fromSymTable;
				}
  | IDENTIFIER LPAREN arg_list error {compiled =false; error(@$,"La llamada a una funcion debe terminar con un parentesis");} 

  ;

arg_decl_list:

  | arg_decl arg_decl_list1
  ;

arg_decl_list1:

  | COMMA arg_decl arg_decl_list1
  |  error arg_decl {compiled = false ; error(@$,"Los argumentos deben ir separados por comas");}  
  ;

arg_decl:
  declaration
  | VAR declaration
  ;

arg_list:

  | general_expression arg_list1
  ;

arg_list1:
  
  | COMMA general_expression arg_list1
  | error general_expression {compiled = false ; error(@$,"Los argumentos deben ir separados por comas");}
  ;

write:
  WRITE general_expression
  ;

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
  ;

while_loop:
  WHILE boolean_expression START bloque END
  | WHILE error END {compiled = false ; error(@$,"Bloque while malformado");}
  ;

for_loop:
  FOR LPAREN assign SEPARATOR boolean_expression SEPARATOR assign RPAREN START bloque END
  | FOR error END {compiled = false ; error(@$,"Bloque for malformado");}
  ;


if_block:
  IF boolean_expression START bloque END
  | IF boolean_expression START bloque END ELSE START bloque END
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

