/* Use the LALR1 parser skeleton */
%skeleton "lalr1.cc"

/* This project requires version 2.5 of Bison, as it comes with Debian 7 */
%require  "2.5"

%defines 
/* Use a particular namespace and parser class */ 
%define api.namespace {Madafaka}
%define parser_class_name {Madafaka_Parser}

/* Debug-enabled parser */
%define parse.trace

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
}

/* token types */
%union {
   std::string *strvalue;
   std::int intvalue;
   std::float floatvalue;
   std::boolean boolvalue;
}

/* Until whe have an AST, every nonterminal symbol with semantic meaning
  will remain with string value */

/* Reserved words and its tokens */
%token <strvalue> BEGIN "mada"
%token <strvalue> END "faka"
%token <strvalue> IDENTIFIER
%token <strvalue> SEPARATOR ";"
%token <strvalue> ASSIGN "="
%token <strvalue> COMMA ","
%token <strvalue> LPAR "("
%token <strvalue> RPAR ")"

/* Primitive and composite data types */
%token <strvalue> INTEGER
%token <strvalue> STRUCT
%token <strvalue> CHAR
%token <strvalue> STRING
%token <strvalue> FLOAT
%token <strvalue> VOID
%token <strvalue> FOR
%token <strvalue> WHILE
%token <strvalue> READ
%token <strvalue> WRITE
%token <strvalue> VAR

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


%%

program:
  BEGIN instruction_list END {$$ = $instruction_list }
  ;

instruction_list:
  instruction SEPARATOR
  | instruction_list instruction SEPARATOR {$$ = $1 ++ $2}
  ;

instruction:
  declaration
  | assign
  | procedure_decl  
  | procedure_invoc
  | write
  | read
  | while_loop
  | for_loop
  ;

declaration:
  type IDENTIFIER
  ;

type:
  INTEGER
  | FLOAT
  | CHAR
  | STRING
  | STRUCT
  | VOID
  ;

assign:
  IDENTIFIER ASSIGN general_expression
  ;

general_expression:
  arithmetic_expression
  | boolean_expression
  ;

arithmetic_expression:
  procedure_invoc
  | IDENTIFIER
  ;

boolean_expression:
  procedure_invoc
  | IDENTIFIER
  ;

procedure_decl:
  type IDENTIFIER LPAR arg_decl_list RPAR
  ;

procedure_invoc:
  IDENTIFIER LPAR arg_list RPAR  
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
  READ IDENTIFIER
  ;

while_loop:
  WHILE boolean_expression instruction_list

for_loop:
  FOR LPAR assign COMMA boolean_expression COMMA assign RPAR instruction_list




%%


void Madafaka::Madafaka_Parser::error( const Madafaka::Madafaka_Parser::location_type &l,
                           const std::string &err_message)
{
   std::cerr << "Error: " << err_message << "\n"; 
}


/* include for access to scanner.yylex */
#include "Madafaka_scanner.hpp"
static int yylex(Madafaka::Madafaka_Parser::semantic_type *yylval,
                 Madafaka::Madafaka_Scanner  &scanner,
                 Madafaka::Madafaka_Driver   &driver)
{
   return( scanner.yylex(yylval) );
}

