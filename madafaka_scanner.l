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
TOKEN_IF	"if"
TOKEN_THEN	"then"
TOKEN_BEGIN	"mada"
TOKEN_END	"faka"
TOKEN_PROC	"procedure"
TOKEN_FUNC	"begin"

%%


{DIGIT}+	{
				printf( "An integer: %s (%d)\n", yytext,atoi( yytext ) );
			}

{DIGIT}+"."{DIGIT}*		{
	printf( "A float: %s (%g)\n", yytext,
	atof( yytext ) );
	}

{TOKEN_IF}|{TOKEN_THEN}|{TOKEN_BEGIN}|{TOKEN_END}|{TOKEN_PROC}|{TOKEN_FUNC} {
	printf( "A keyword: %s\n", yytext );
	}

{ID}	{
	printf( "An identifier: %s\n", yytext );
	}

"+"|"-"|"*"|"/"		{
	printf( "An operator: %s\n", yytext );
}   

"{"[^}\n]*"}"     /* eat up one-line comments */

[ \t\n]+	     /* eat up whitespace */

.				printf( "Unrecognized character: %s\n", yytext );

%%