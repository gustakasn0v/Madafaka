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
}


%code{
   #include <iostream>
   #include <cstdlib>
   #include <fstream>
   
   /* include for all driver functions */
   #include "madafaka_driver.hpp"

   /* Position tracking variables from Flex */
   extern int yyline, frcol, tocol;

   //int yylex(Madafaka::Madafaka_Parser::semantic_type*);
   /* this is silly, but I can't figure out a way around */
   static int yylex(Madafaka::Madafaka_Parser::semantic_type *yylval,
                    Madafaka::Madafaka_Parser::location_type*,
                    Madafaka::Madafaka_Scanner  &scanner,
                    Madafaka::Madafaka_Driver   &driver);

   /*Incluyendo estructuras auxiliares*/
	#include "estructuras.h"
	arbol raiz;
 	arbol *actual = &raiz;
	arbol *bloque_struct;
	string last;
	bool compiled = true;
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

/* Primitive and composite data types */
%token <strvalue> INTEGER "idafak"
%token <strvalue> STRUCT "strdafak"
%token <strvalue> CHAR "cdafak"
%token <strvalue> STRING "sdafak"
%token <strvalue> FLOAT "fdafak"
%token <strvalue> VOID "vdafak"
%token <strvalue> FOR "fordafak"
%token <strvalue> WHILE "whiledafak"
%token <strvalue> IF "ifdafak"
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

%left OR
%left AND
%nonassoc NOT
%nonassoc LESS LESSEQ GREAT GREATEQ
%left EQ
%left PLUS MINUS
%left TIMES DIVIDE MOD

/*extra tokens*/
%token <strvalue> UNKNOWN

/* Nonterminals. I didn't put the union type! */
%type <strvalue> program
%type <strvalue> instruction_list
%type <strvalue> instruction
%type <strvalue> declaration
%type <strvalue> declaration_list
%type <strvalue> id_dotlist1
%type <strvalue> id_dotlist2
%type <strvalue> assign
%type <strvalue> procedure_decl  
%type <strvalue> procedure_invoc
%type <strvalue> write
%type <strvalue> read
%type <strvalue> while_loop
%type <strvalue> for_loop
%type <strvalue> typo
%type <strvalue> typo2
%type <strvalue> if_block

%start program

/*
Since expressions get their value from the SymTable,
this will be commented out to avoid type clash warnings

%type <boolvalue> boolean_expression
%type <boolvalue> arithmetic_comparison
%type <strvalue> arithmetic_expression
%type <strvalue> boolean_opr
%type <strvalue> arithmetic_opr
%type <strvalue> comparison_opr
*/

%%

program:
  
  declaration_proc START bloque END

  { 
    if (compiled) recorrer(&raiz,0);
    return 0; 
  }
  ;

bloque:
	{actual=enterScope(actual);} 
	declaration_list instruction_list 
	{actual = exitScope(actual);}
	;

instruction_list:

  | instruction SEPARATOR instruction_list
  | instruction error instruction_list {compiled = false ; error(@$,"Las instrucciones deben ir separadas por comas");}
  ;

instruction:
  assign
  | procedure_invoc
  | write
  | read
  | while_loop
  | for_loop
  | if_block
  | START bloque END
  | error {compiled = false; error(@$,"Instruccion no valida");}
  ;


declaration_proc:
	
	| procedure_decl SEPARATOR declaration_proc
	;

declaration_list:
	
	| declaration SEPARATOR declaration_list
  | declaration error declaration_list {compiled = false ; error(@$,"Las declaraciones van separadas por ;");}
	;


declaration:
  typo IDENTIFIER { 
	  				if(!(*actual).estaContenido(*($2))){
	  					string *s1 = new string(*($1));
	  					string *s2 = new string(*($2));
						(*actual).insertar(*s2,*s1,yyline,frcol,0);
						last = *($2);
	  				}  
					else{
						compiled = false;
						error(@$,"Variable ya declarada en el mismo bloque");
					}
				}
  | typo2 IDENTIFIER START 
  	{actual = enterScope(actual);}  
	declaration_list 
  	{
		actual = exitScope(actual);
		last = *($2);
		if(!(*actual).estaContenido(*($2))){
			string *s1 = new string(*($1));
			string *s2 = new string(*($2));
			(*actual).insertar(*s2,*s1,yyline,frcol,1);
	  	}  
		else{
			compiled = false;
			error(@$,"Variable ya declarada en el mismo bloque");
		}

	}
	END 
  | typo2 error {
	 				compiled = false;
					error(@$,"Nombre de variable no valido");


	  			}
  | typo error {
	  				compiled = false;
					error(@$,"Nombre de variable no valido");
	 			}
  ;

declaration2:
	declaration LARRAY arithmetic_expression RARRAY 
	{
		(*actual).esArray(last);
	}

	| error {compiled = false; error(@$,"Error de declaracion de arreglo");}
		
  ;


id_dotlist1:
	IDENTIFIER 
	{
		string s =  buscarVariable(*($1),actual);

		if(s!="strdafak" && s!="unidafak"){
			compiled = false;
			error(@$,"La variable no es de tipo strdafak o unidafak.");
		}
		else{
			bloque_struct = buscarBloque(*($1),actual);
			bloque_struct = (*bloque_struct).hijoEnStruct(*($1));
		}
	} 
	DOT id_dotlist2;

id_dotlist2:
	IDENTIFIER
	{

		if(!(*bloque_struct).estaContenido(*($1))){
			compiled = false;
			error(@$,"Campo no contenido en la estructura.");
		}

	}

  | IDENTIFIER 
  	{
		string s = "";

		if((*bloque_struct).estaContenido(*($1))){
			s = (*bloque_struct).tipoVar(*($1));
		}

		if(s!="unidafak" && s!="strdafak"){
			compiled = false;
			error(@$,"El campo no es de tipo strdafak o unidafak");
		}
		else{
			bloque_struct = (*bloque_struct).hijoEnStruct(*($1));
		}

	}
    DOT 
	id_dotlist2;
  | error {error(@$,"Acceso a de strdafak o unidafak de manera incorrecta.");}


typo:
  INTEGER
  | FLOAT
  | CHAR
  | STRING
  | VOID
  | error {compiled = false; ; error(@$,"Tipo no valido");}
  ;

typo2:
	UNION
	| STRUCT
	| error {compiled = false; error(@$,"Tipo no valido");}
	;

assign:
  IDENTIFIER ASSIGN general_expression{
	  									if(buscarVariable(*($1),actual)==""){
											error(@$,"Variable no declarada");
										}
	  								}
									
 | id_dotlist1 ASSIGN general_expression
									
 ;

// There's a reduce/reduce conflict here, since the parser
// might see the error token, and wouldn't know to reduce
// using an arithmetic or boolean expression. The error
// message is the same in both cases, so "deje así"
general_expression:
  arithmetic_expression
  | boolean_expression
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
  boolean_expression boolean_opr boolean_expression
  | LPAREN boolean_expression RPAREN
  | NOT boolean_expression
  | IDENTIFIER
  | id_dotlist1
  | arithmetic_comparison
  ;

boolean_opr: AND | OR | EQ
	| error {compiled = false; error(@$,"Operador booleano no valido");}
  ;

arithmetic_comparison:
  arithmetic_expression comparison_opr arithmetic_expression 
  ;

comparison_opr: EQ | LESS | LESSEQ 
  | GREAT | GREATEQ
  | error {compiled = false; error(@$,"Operador de comparacion no valido");}
  ;


// This produces a shift/reduce situation similar to the one stated
// above, with the boolean expressions. As above, we are OK with the
// parser shifting in situations like these. "Deje así"
arithmetic_expression:
  arithmetic_expression arithmetic_opr arithmetic_expression
  | IDENTIFIER {
	  			string aux = buscarVariable(*($1),actual);
	  			if(aux=="" || aux == "funcion"){
	  				compiled = false;
					error(@$,"Variable no declarada, o funcion con el mismo nombre solamente declarada");
	  			}
			}
			
  | INTVALUE
  | FLOATVALUE
  | procedure_invoc
  | id_dotlist1
  ;


arithmetic_opr: PLUS | MINUS | TIMES | DIVIDE | MOD
  ;

procedure_decl:
  typo IDENTIFIER LPAREN arg_decl_list RPAREN START bloque END 
			{
				if(buscarVariable(*($1),actual)==""){
					string s = "funcion";
					int t1 = yyline;
					int t2 = frcol;
	  				(*actual).insertar(*($2),s,t1,t2,0);
	  			}
				else{
					error(@$,"Funcion ya declarada anteriormente");
				}
			
	  		}
	  
  ;

procedure_invoc:
  IDENTIFIER LPAREN arg_list RPAREN  
  			{
	  			string s = "funcion";
				string p = buscarVariable(*($1),actual);
	  			if(p!=s && p!=""){
	  				error(@$,"Se esta usando una variable como funcion");
					compiled = false;
	  			}
				else if(p==""){
					error(@$,"Funcion no declarada");
					compiled = false;

				}
				
			}
  | IDENTIFIER LPAREN arg_list error {compiled =false; error(@$,"La llamada a una funcion debe terminar con un parentesis");} 

  ;

arg_decl_list:
  arg_decl
  | arg_list COMMA arg_decl
  | arg_list error arg_decl {compiled = false ; error(@$,"Los argumentos deben ir separados por comas");}  
  ;

arg_decl:
  declaration
  | VAR declaration
  ;


arg_list:
  general_expression COMMA
  | arg_list COMMA general_expression COMMA 
  | arg_list error general_expression COMMA {compiled = false ; error(@$,"Los argumentos deben ir separados por comas");}
  ;

write:
  WRITE general_expression
  ;

read:
  READ IDENTIFIER 
  		{
			string s = buscarVariable(*($2),actual);
	  		if(s=="" || s == "funcion"){
				compiled = false;
				error(@$,"Variable no declarada");
			}
			
			
		}
 | READ id_dotlist1
  ;

while_loop:
  WHILE boolean_expression START bloque END
  | WHILE error {compiled = false ; error(@$,"Bloque while malformado");}
  ;

for_loop:
  FOR LPAREN assign COMMA boolean_expression COMMA assign RPAREN START bloque END
  | FOR error {compiled = false ; error(@$,"Bloque for malformado");}
  ;


if_block:
  IF boolean_expression START bloque END
  | IF error {compiled = false ; error(@$,"Bloque if malformado");}
  ;

%%


void Madafaka::Madafaka_Parser::error( const location_type&,const string& err_message)
{
     //fprintf(stderr, "Linea: %d Columna: %d: ", bla.begin.line+1, bla.begin.column);
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

