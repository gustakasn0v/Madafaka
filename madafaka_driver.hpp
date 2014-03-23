#ifndef __MADAFAKADRIVER_HPP__
#define __MADAFAKADRIVER_HPP__ 1
 
#include <string>
#include "madafaka_scanner.hpp"
#include "madafaka_parser.tab.hh"
#include "estructuras.h" 
namespace Madafaka{
 
class Madafaka_Driver{
public:
   Madafaka_Driver() : chars(0),
                 words(0),
                 lines(0),
                 uppercase(0),
                 lowercase(0),
                 parser( NULL ),
                 scanner( NULL ){};
 
   virtual ~Madafaka_Driver();
 
   void parse( const char *filename );
    /*
   void add_upper();
   void add_lower();
   void add_word( const std::string &word );
   void add_newline();
   void add_char();
 */
   std::ostream& print(std::ostream &stream);
private:
   int chars;
   int words;
   int lines;
   int uppercase;
   int lowercase;
   Madafaka::Madafaka_Parser *parser;
   Madafaka::Madafaka_Scanner *scanner;
};
 
} /* end namespace MC */
#endif /* END __MADAFAKADRIVER_HPP__ */
