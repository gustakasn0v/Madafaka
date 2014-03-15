%{
#include<stdio.h>
#include "madafaka_scanner.hpp"

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
TOKEN_ARGREF	".!."
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
TOKEN_COMMENT	"--"
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


{DIGIT}+				{
							yylval.intvalue = atoi(yytext);
							return token::INTVALUE;
						}


{DIGIT}+"."{DIGIT}*		{
							yylval.floatvalue = atof(yytext);
							return token::FLOATVALUE;
						}


{TOKEN_IF}				{return token::IF;}


{TOKEN_THEN}			{return token::THEN;}


{TOKEN_BEGIN}			{return token::BEGIN;}


{TOKEN_END}				{return token::END;}


{TOKEN_ARGREF}			{return token::REF;}


{TOKEN_FOR}				{return token::FOR;}


{TOKEN_WHILE}			{return token::WHILE;}


{TOKEN_LESS}			{return token::LESS;}


{TOKEN_LESSEQ}			{return token::LESSEQ;}


{TOKEN_GREAT}			{return token::GREAT;}


{TOKEN_GREATEQ}			{return token::GREATEQ;}


{TOKEN_PLUS}			{return token::PLUS;}


{TOKEN_MINUS}			{return token::MINUS;}


{TOKEN_TIMES}			{return token::TIMES;}


{TOKEN_DIVIDE}			{return token::DIVIDE;}


{TOKEN_MOD}				{return token::MOD;}


{TOKEN_AND}				{return token::AND;}


{TOKEN_OR}				{return token::OR;}


{TOKEN_NOT}				{return token::NOT;}  


{TOKEN_EQ} 				{return token::EQ;}	


{TOKEN_ASSIGN} 			{return token::ASSIGN;}



\'.\' 		{
				yylval.charvalue = yytext[0];
				return (token::CHARVALUE);
			}


\"(\\\\|\\\"|[^\\\"])*\" {
							yylval->strvalue = new std::string(yytext);
							return (token::STRVALUE);
						}


{TOKEN_VOID} {return (token::VOID);}


{TOKEN_INT} {return (token::INTEGER);}


{TOKEN_FLOAT} {return (token::FLOAT);}


{TOKEN_CHAR} { return (token::CHAR);}


{TOKEN_STRING} {return (token::STRING);}


{TOKEN_STRUCT} {return (token::STRUCT);}


{TOKEN_UNION} 	{return (token::UNION);}


{TOKEN_SEPARATOR} {return (token::SEPARATOR);}


{TOKEN_LPAREN} 	{return (token::LPAREN);}


{TOKEN_RPAREN} 	{return (token::RPAREN);}


{TOKEN_TRUE}	{
					yylval.boolvalue = 1;
					return (token::BOOLVALUE);
				}


{TOKEN_FALSE}	{
					yylval.boolvalue = 0;
					return (token::BOOLVALUE);
				}



\."!"\. 		{return (token::REF);}


{TOKEN_COMMENT}[^\n]* {
						return (token::COMMENT);
					  }


{ID}			{
					yylval->strvalue = new std::string(yytext);
					return (token::IDENTIFIER);
				}


"{"[^}\n]*"}"     /* eat up one-line comments */


[ \t\n]+	     /* eat up whitespace */


.				{return (token::UNKOWN);}


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
