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

%code{
   #include <iostream>
   #include <cstdlib>
   #include <fstream>
   
   /* include for all driver functions */
   #include "madafaka_driver.h"

   /* this is silly, but I can't figure out a way around */
   static int yylex(Madafaka::Madafaka_Parser::semantic_type *yylval,
                    Madafaka::Madafaka_Scanner  &scanner,
                    Madafaka::Madafaka_Driver   &driver);
}

/* token types */
%union values {  
   std::string *strvalue;
   int intvalue;
   float floatvalue;
   bool boolvalue;
   char charvalue;
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
%token <strvalue> LPAREN "("
%token <strvalue> RPAREN ")"
%token <strvalue> PROC
$token <strvalue> FUNC
%token COMMENT

/* Primitive and composite data types */
%token <strvalue> INTEGER
%token <strvalue> STRUCT
%token <strvalue> CHAR
%token <strvalue> STRING
%token <strvalue> FLOAT
%token <strvalue> VOID
%token <strvalue> FOR
%token <strvalue> WHILE
%token <strvalue> IF
%token <strvalue> READ
%token <strvalue> WRITE
%token <strvalue> VAR
%token <strvalue> UNION

/* Tokens for constant expresions (eg. 42, "blah", 3.8) */
%token <intvalue> INTVALUE
%token <floatvalue> FLOATVALUE
%token <boolvalue> BOOLVALUE
%token <strvalue> STRVALUE
%token <charvalue> CHARVALUE

/* Tokens for boolean/arithmetic expressions */
%token TRUE
%token FALSE

%left OR
%left AND
%nonassoc NOT
%nonassoc LESS LESSEQ GREAT GREATEQ
%left EQ
%left PLUS MINUS
%left TIMES DIVIDE MOD

/*extra tokens*/
%token <strvalue> REF ".!."
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
  BEGIN instruction_list END {$$ = $instruction_list; }
  ;

instruction_list:
  instruction SEPARATOR
  | instruction_list instruction SEPARATOR
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
  | if_block
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

comparison_opr: EQ | LESS | LESSEQ 
  | GREAT | GREATEQ
  ;

arithmetic_expression:
  arithmetic_expression arithmetic_opr arithmetic_expression
  | IDENTIFIER
  | INTVALUE
  | FLOATVALUE
  ;


arithmetic_opr: PLUS | MINUS | TIMES | DIVIDE | MOD

procedure_decl:
  type IDENTIFIER LPAREN arg_decl_list RPAREN
  ;

procedure_invoc:
  IDENTIFIER LPAREN arg_list RPAREN  
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
  FOR LPAREN assign COMMA boolean_expression COMMA assign RPAREN instruction_list


if_block:
  IF boolean_expression BEGIN instruction_list END


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

