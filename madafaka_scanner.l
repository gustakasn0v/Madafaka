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

DIGIT			[0-9]
ID 				[a-z][a-z0-9]*
TOKEN_IF		"ifdafak"
TOKEN_THEN		"thendafak"
TOKEN_BEGIN		"mada"
TOKEN_END		"faka"
TOKEN_PROC		"procedure"
TOKEN_FUNC		"begin"
TOKEN_FOR		"fordafak"
TOKEN_WHILE 	"whiledafak"
TOKEN_VOID		"vdafak"
TOKEN_INT		"idafak"
TOKEN_FLOAT		"fdafak"
TOKEN_CHAR		"cdafak"
TOKEN_STRING	"sdafak"
TOKEN_STRUCT	"strdafak"
TOKEN_UNION		"unidafak"
TOKEN_WRITE		"wdafak"
TOKEN_READ		"rdafak"
TOKEN_IN		"in"
TOKEN_SEPARADOR ";"

%%


{DIGIT}+				{
							yylval.intvalue = atoi(yytext);
							return (token::INTVALUE);
						}


{DIGIT}+"."{DIGIT}*		{
							yylval.floatvalue = atof(yytext);
							return (token::FLOATVALUE);
						}


{TOKEN_IF}				{return ( token::IF );}


{TOKEN_THEN}			{return (token::THEN);}


{TOKEN_BEGIN} 			{return (token::BEGIN);}



{TOKEN_END} 			{return (token::END);}


{TOKEN_PROC} 			{return (token::PROC);}



{TOKEN_FUNC}			{return (token::FUNC);}


{TOKEN_FOR} 			{return (token::FOR);}




"+"						{return (token::PLUS);}


"-"		 				{return (token::MINUS);}


"*" 					{return (token::TIMES);}


"/"						{return (token::DIVIDE);}


"%"						{return (token::MOD);}  


"<"						{return (token::LESS)}

">"						{return (token::GREAT);}

">="					{return (token::GREATEQ);}


"<="					{return (token::LESSEQ);}



\'.\' 					{
							yylval.charvalue = yytext[0];
							return (token::CHARVALUE);
						}


\"(\\\\|\\\"|[^\\\"])*\" {	
							yylval->strvalue = new std::string(yytext);
							return (token::STRVALUE);
							
						}


{TOKEN_VOID} 			{return (token::VOID);}



{TOKEN_INT} 			{return (token::INTEGER);}


{TOKEN_FLOAT} 			{return (token::FLOAT);}


{TOKEN_CHAR} 			{return (token::CHAR);}


{TOKEN_STRING} 			{return (token::STRING);}


{TOKEN_STRUCT} 			{return (token::STRUCT);}


{TOKEN_UNION} 			{return (token::UNION);}


{TOKEN_SEPARADOR} 		{return (token::SEPARATOR);}


"true"					{
							yylval.boolvalue = 1;
							return (token::BOOLVALUE);
						}


"false"  				{
							yylval.boolvalue = 0;
							return (token::BOOLVALUE);
						}


\."!"\. 				{return (token::REF);}


{ID}					{
							yylval->strvalue = new std::string(yytext);
							return (token::IDENTIFIER);
						}


"{"[^}\n]*"}"     /* eat up one-line comments */


[ \t\n]+	     /* eat up whitespace */


.						{return (token::UNKOWN);}

%%

