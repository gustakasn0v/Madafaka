%{
#include<stdio.h>
#include"madafaka_scanner.hpp"

typedef Madafaka::Madafaka_Parser::token token;

%}

%option yylineno
%option c++
%option yyclass="Madafaka_Scanner"

DIGIT			[0-9]
ID 				[a-z][a-z0-9]*
TOKEN_IF		"ifdafak"
TOKEN_THEN		"thendafak"
TOKEN_BEGIN		"mada"
TOKEN_END		"faka"
TOKEN_ARGREF	"var"
TOKEN_FOR		"fordafak"
TOKEN_WHILE 	"whiledafak"
TOKEN_VOID		"vdafak"
TOKEN_INT		"idafak"
TOKEN_FLOAT		"fdafak"
TOKEN_CHAR		"cdafak"
TOKEN_STRING	"sdafak"
TOKEN_STRUCT	"strdafak"
TOKEN_UNION		"unidafak"
TOKEN_ASSIGN	"="
TOKEN_WRITE		"wdafak"
TOKEN_READ		"rdafak"
TOKEN_IN		"in"
TOKEN_SEPARATOR ";"
TOKEN_AND		"and"
TOKEN_OR		"or"
TOKEN_NOT		"not"
TOKEN_COMMENT	"fakafaka"
TOKEN_LPAREN	"("
TOKEN_RPAREN	")"
TOKEN_MINUS		"-"
TOKEN_EQ		"=="
TOKEN_TIMES 	"*"
TOKEN_DIVIDE 	"/"
TOKEN_MOD 		"%"
TOKEN_PLUS 		"+"
TOKEN_GREAT 	">"
TOKEN_GREATEQ 	">="
TOKEN_LESS 		"<"
TOKEN_LESSEQ 	"<="
TOKEN_TRUE		"true"
TOKEN_FALSE		"false"

%%


{DIGIT}+				{printf( "Entero: %s\n", yytext);}


{DIGIT}+"."{DIGIT}*		{printf( "Flotante: %s (%g)\n", yytext);}


{TOKEN_IF}				{return token::IF;}
{TOKEN_THEN}			{return token::THEN;}
{TOKEN_BEGIN}			{return token::BEGIN;}
{TOKEN_END}				{return token::END;}
{TOKEN_ARGREF}			{return token::VAR;}
{TOKEN_FOR}				{return token::FOR;}
{TOKEN_WHILE}			{printf( "Palabra clave: %s\n", yytext ); return token::WHILE}
{TOKEN_LESS}
{TOKEN_LESSEQ}
{TOKEN_GREAT}
{TOKEN_GREATEQ}
{TOKEN_PLUS}
{TOKEN_MINUS}
{TOKEN_TIMES}
{TOKEN_DIVIDE}
{TOKEN_AND}
{TOKEN_OR}
{TOKEN_NOT}		{printf( "An operator: %s\n", yytext );}  


{TOKEN_EQ} {printf("Esto es una igualdad\n");}	

{TOKEN_ASSIGN} {printf("Esto es una asignacion\n");}





\'.\' {printf("Esto es un char");}


\"(\\\\|\\\"|[^\\\"])*\" {printf("Esto es una cadena");}


{TOKEN_VOID} {printf("Tipo void");}


{TOKEN_INT} {printf("Esto es un tipo int");}


{TOKEN_FLOAT} {printf("Esto es el tipo float");}


{TOKEN_CHAR} {printf("Esto es el tipo char");}


{TOKEN_STRING} {printf("Esto es una cadena");}


{TOKEN_STRUCT} {printf("Esto es un struct");}


{TOKEN_UNION} {printf("Esto es un union");}


{TOKEN_SEPARATOR} {printf("Esto es un ;");}


{TOKEN_LPAREN} {printf("Parentesis izquierdo\n");}


{TOKEN_RPAREN} {printf("Parentesis derecho\n");}


{TOKEN_TRUE}	{printf("Booleano\n");}


{TOKEN_FALSE}	{printf("Booleano \n");}


\[{DIGIT}+\] {printf("Dimension de un arreglo");}


\."!"\. {printf("Paso por referencia");}


{TOKEN_COMMENT} {printf("Esto es un comentario\n");}


{ID}	{printf( "Identificador: %s\n", yytext );}


"{"[^}\n]*"}"     /* eat up one-line comments */


[ \t\n]+	     /* eat up whitespace */


.				printf( "Unrecognized character: %s\n", yytext );

%%

void main(int argc, char **argv){
	   ++argv, --argc;  /* skip over program name */
	      if ( argc > 0 )
			       yyin = fopen( argv[0], "r" );
				      else
						       yyin = stdin;
							        
									   yylex();
}

yywrap() { }
