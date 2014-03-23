#ifndef __MADAFAKASCANNER_HPP__
#define __MADAFAKASCANNER_HPP__ 1
 
#if ! defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif
 
#undef YY_DECL
#define YY_DECL int Madafaka::Madafaka_Scanner::yylex()
 
#include "madafaka_parser.tab.hh"
 
namespace Madafaka{
 
class Madafaka_Scanner : public yyFlexLexer{
	public:
		Madafaka_Scanner(std::istream *in) : 
			yyFlexLexer(in),
			yylval( NULL ){};
			
		int yylex(Madafaka::Madafaka_Parser::semantic_type *lval){
			yylval = lval;
			return( yylex() );
		}

	private:
		/* hide this one from public view */
		int yylex();
		/* yyval ptr */
		Madafaka::Madafaka_Parser::semantic_type *yylval;
		};
		 
} /* end namespace Madafaka */	
#endif /* END __MADAFAKASCANNER_HPP__ */
 
