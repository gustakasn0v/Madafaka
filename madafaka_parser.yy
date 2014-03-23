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

	/*#include "estructuras.h"*/

}

/* Pass the custom Driver and Scanner we made to the lexer and parser */

%lex-param   { Madafaka_Scanner  &scanner  }
%parse-param { Madafaka_Scanner  &scanner  }

%lex-param   { Madafaka_Driver  &driver  }
%parse-param { Madafaka_Driver  &driver  }

%code{
   #include <iostream>
   #include <cstdlib>
   #include <fstream>
   
   /* include for all driver functions */
   #include "madafaka_driver.hpp"

   /* this is silly, but I can't figure out a way around */
   static int yylex(Madafaka::Madafaka_Parser::semantic_type *yylval,
                    Madafaka::Madafaka_Scanner  &scanner,
                    Madafaka::Madafaka_Driver   &driver);

   /*Incluyendo estructuras auxiliares*/
	#include "estructuras.h"

}

/* token types */
%union {  
   std::string *strvalue;
   int intvalue;
   float floatvalue;
   bool boolvalue;
   char charvalue;
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
%token <strvalue> COMMENT "fakafaka"

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

/* Tokens for boolean/arithmetic expressions */
%token TRUE "true"
%token FALSE "false"

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
%type <strvalue> assign
%type <strvalue> procedure_decl  
%type <strvalue> procedure_invoc
%type <strvalue> write
%type <strvalue> read
%type <strvalue> while_loop
%type <strvalue> for_loop
%type <strvalue> type
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
  START declaration_proc bloque END { return 0; }
  ;

bloque:
	{ enterScope(); } declaration_list instruction_list /*{exitScope();}*/
	;

instruction_list:
  
  | instruction
  | instruction SEPARATOR instruction_list
  ;

instruction:
  assign
  | procedure_invoc
  | write
  | read
  | while_loop
  | for_loop
  | if_block
  ;


declaration_proc:
	
	| procedure_decl SEPARATOR declaration_proc
	;

declaration_list:
	
	| declaration SEPARATOR declaration_list
	;


declaration:
  type IDENTIFIER /*{ if(buscarVariable($2)==""){
	  					string *s1 = new string(*($1));
	  					string *s2 = new string(*($2));
						insertar(*s2,*s1);
	  				}  
					else{
						//Aqui va el error de variable ya declarada
					}
				}*/
  ;

type:
  INTEGER
  | FLOAT
  | CHAR
  | STRING
  | STRUCT
  | VOID
  | UNION
  ;

assign:
  IDENTIFIER ASSIGN general_expression/* {
	  									if(buscarVariable($1)==""){
											//Error no declarada
										}
	  								}
									*/
  ;

general_expression:
  arithmetic_expression
  | boolean_expression
  ;

boolean_expression:
  boolean_expression boolean_opr boolean_expression
  | LPAREN boolean_expression RPAREN
  | NOT boolean_expression
  | IDENTIFIER
  | arithmetic_comparison
  ;

boolean_opr: AND | OR | EQ
  ;

arithmetic_comparison:
  arithmetic_expression comparison_opr arithmetic_expression 
  ;

comparison_opr: EQ | LESS | LESSEQ 
  | GREAT | GREATEQ
  ;

arithmetic_expression:
  arithmetic_expression arithmetic_opr arithmetic_expression
  | IDENTIFIER /*{if(buscarVariable($1)==""){
	  				//Variable no declarada
	  			}
			}
			*/
  | INTVALUE
  | FLOATVALUE
  ;


arithmetic_opr: PLUS | MINUS | TIMES | DIVIDE | MOD
  ;

procedure_decl:
  type IDENTIFIER LPAREN arg_decl_list RPAREN START bloque END /*{
			if(buscarVariable($1)==""){
					string s = "funcion";
	  				insertar(*($1),s);
	  			}
				else{
					//Variable con el mismo nombre declarada
				}
			
	  }
	  */
  ;

procedure_invoc:
  IDENTIFIER LPAREN arg_list RPAREN  /*{
	  			string s = "funcion";
				string p = buscarVariable($1);
	  			if(p!=s && p!=""){
	  				//La variable no es una funcion
	  			}
				else if(p==""){
					//Funcion no ha sido declarada
				}
			}
			*/
  ;

arg_decl_list:
  arg_decl
  | arg_list COMMA arg_decl
  ;

arg_decl:
  declaration
  | VAR declaration
  ;


arg_list:
  general_expression COMMA
  | arg_list COMMA general_expression COMMA 
  ;

write:
  WRITE general_expression
  ;

read:
  READ IDENTIFIER /*{
	  	if(buscarVariable(*($2))==""){
			//Error variable no declarada en el read
		}
	  }*/
  ;

while_loop:
  WHILE boolean_expression START bloque END
  ;

for_loop:
  FOR LPAREN assign COMMA boolean_expression COMMA assign RPAREN START bloque END
  ;


if_block:
  IF boolean_expression START bloque END
  ;

%%


void Madafaka::Madafaka_Parser::error( Madafaka::location const &bla, const std::string &err_message)
{
   std::cerr << "Error: " << err_message << "\n"; 
}


/* para el otro compilador
void Madafaka::Madafaka_Parser::error( const std::string &err_message)
{
   std::cerr << "Error: " << err_message << "\n"; 
}
*/





/* include for access to scanner.yylex */
#include "madafaka_scanner.hpp"
static int yylex(Madafaka::Madafaka_Parser::semantic_type *yylval,
                 Madafaka::Madafaka_Scanner  &scanner,
                 Madafaka::Madafaka_Driver   &driver)
{
   return( scanner.yylex(yylval) );
}

