%{
/* C++ string header, for string ops below */
#include <string>
/* Implementation of yyFlexScanner */ 
#include "madafaka_scanner.hpp"

/* typedef to make the returns for the tokens shorter */
typedef MC::MC_Parser::token token;

/* define to keep from re-typing the same code over and over */
#define STOKEN( x ) ( new std::string( x ) )

/* define yyterminate as this instead of NULL */
#define yyterminate() return( token::END )

/* msvc2010 requires that we exclude this header file. */
#define YY_NO_UNISTD_H

%}

%option debug 
%option nodefault 
%option yyclass="MC_Scanner" 
%option noyywrap 
%option c++

DIGIT		[0-9]
ID 			[a-z][a-z0-9]*
TOKEN_IF	"ifdafak"
TOKEN_THEN	"thendafak"
TOKEN_BEGIN	"mada"
TOKEN_END	"faka"
TOKEN_PROC	"procedure"
TOKEN_FUNC	"begin"
TOKEN_FOR	"fordafak"
TOKEN_WHILE "whiledafak"

%%


{DIGIT}+	{
				printf( "Entero: %s (%d)\n", yytext,atoi( yytext ) );
			}

{DIGIT}+"."{DIGIT}*		{
	printf( "Flotante: %s (%g)\n", yytext,
	atof( yytext ) );
	}

{TOKEN_IF}|{TOKEN_THEN}|{TOKEN_BEGIN}|{TOKEN_END}|{TOKEN_PROC}|{TOKEN_FUNC}|{TOKEN_FOR} {
	printf( "Palabra clave: %s\n", yytext );
	}

{ID}	{
	printf( "Identificador: %s\n", yytext );
	}

"+"|"-"|"*"|"/"		{
	printf( "An operator: %s\n", yytext );
}   


\'.\' {printf("Esto es un char");}


\"(\\\\|\\\"|[^\\\"])*\" {printf("Esto es una cadena");}


"vdafak" {printf("Tipo void");}


"idafak" {printf("Esto es un tipo int");}


"fdafak" {printf("Esto es el tipo float");}


"cdafak" {printf("Esto es el tipo char");}


"sdafak" {printf("Esto es una cadena");}


"tructdafak" {printf("Esto es un struct");}


"niondafak" {printf("Esto es un union");}


\."!"\. {printf("Paso por referencia");}


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
