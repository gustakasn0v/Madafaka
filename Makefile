CC    ?= clang
CXX   ?= clang++
 
EXE = madafaka
 
CDEBUG = -g -Wall
 
CXXDEBUG = -g -Wall
 
CSTD = -std=c99
CXXSTD = -std=c++0x
 
CFLAGS = -O0  $(CDEBUG) $(CSTD) 
CXXFLAGS = -O0  $(CXXDEBUG) $(CXXSTD)
 
 
CPPOBJ = main madafaka_driver
SOBJ =  parser lexer estructuras
 
FILES = $(addsuffix .cpp, $(CPPOBJ))
 
OBJS  = $(addsuffix .o, $(CPPOBJ))
 
CLEANLIST =  $(addsuffix .o, $(OBJ)) $(OBJS) \
    			 madafaka_parser.tab.cc madafaka_parser.tab.hh \
				 location.hh position.hh \
			    stack.hh madafaka_parser.output parser.o estructuras.o\
				 lexer.o madafaka_lexer.yy.cc *gch *.o $(EXE)\
 
.PHONY: all
all: madafaka
 
madafaka: $(FILES)
	$(MAKE) $(SOBJ)
	$(MAKE) $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(EXE) $(OBJS) parser.o lexer.o estructuras.o $(LIBS)
 
 
parser: madafaka_parser.yy 
	bison -d -v madafaka_parser.yy
	$(CXX) $(CXXFLAGS) -c -o parser.o madafaka_parser.tab.cc
 
lexer: madafaka_scanner.l
	flex --outfile=madafaka_lexer.yy.cc  $<
	$(CXX)  $(CXXFLAGS) -c madafaka_lexer.yy.cc -o lexer.o

estructuras: MadafakaTypes.hpp MadafakaTypes.cpp
	$(CXX) $(CXXFLAGS) -c MadafakaTypes.cpp -o estructuras.o
 
.PHONY: clean
clean:
	rm -rf $(CLEANLIST)
