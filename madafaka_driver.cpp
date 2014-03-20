#include <cctype>
#include <fstream>
#include <cassert>
 
#include "madafaka_driver.hpp"
 
Madafaka::Madafaka_Driver::~Madafaka_Driver(){ 
   delete(scanner);
   scanner = NULL;
   delete(parser);
   parser = NULL;
}
 
void 
Madafaka::Madafaka_Driver::parse( const char *filename )
{
   assert( filename != NULL );
   std::ifstream in_file( filename );
   if( ! in_file.good() ) exit( EXIT_FAILURE );
   
   delete(scanner);
   try
   {
      scanner = new Madafaka::Madafaka_Scanner( &in_file );
   }
   catch( std::bad_alloc &ba )
   {
      std::cerr << "Failed to allocate scanner: (" <<
         ba.what() << "), exiting!!\n";
      exit( EXIT_FAILURE );
   }
   
   delete(parser); 
   try
   {
      parser = new Madafaka::Madafaka_Parser( (*scanner) /* scanner */, 
                                  (*this) /* driver */ );
   }
   catch( std::bad_alloc &ba )
   {
      std::cerr << "Failed to allocate parser: (" << 
         ba.what() << "), exiting!!\n";
      exit( EXIT_FAILURE );
   }
   const int accept( 0 );
   if( parser->parse() != accept )
   {
      std::cerr << "Parse failed!!\n";
   }
}


/*
Here will go some AST methods, right now they don't exist
Some examples:

MC::MC_Driver::add_upper()
{ 
   uppercase++; 
   chars++; 
   words++; 
}
 
void 
MC::MC_Driver::add_lower()
{ 
   lowercase++; 
   chars++; 
   words++; 
}
 
void 
MC::MC_Driver::add_word( const std::string &word )
{
   words++; 
   chars += word.length();
   for(const char &c : word ){
      if( islower( c ) )
      { 
         lowercase++; 
      }
      else if ( isupper( c ) ) 
      { 
         uppercase++; 
      }
   }
}
 
void 
MC::MC_Driver::add_newline()
{ 
   lines++; 
   chars++; 
}
 
void 
MC::MC_Driver::add_char()
{ 
   chars++; 
}
 
*/
std::ostream& 
Madafaka::Madafaka_Driver::print( std::ostream &stream )
{
   stream << "Uppercase: " << uppercase << "\n";
   stream << "Lowercase: " << lowercase << "\n";
   stream << "Lines: " << lines << "\n";
   stream << "Words: " << words << "\n";
   stream << "Characters: " << chars << "\n";
   return(stream);
}