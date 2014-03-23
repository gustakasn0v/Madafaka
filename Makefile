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
SOBJ =  parser lexer
 
FILES = $(addsuffix .cpp, $(CPPOBJ))
 
OBJS  = $(addsuffix .o, $(CPPOBJ))
 
CLEANLIST =  $(addsuffix .o, $(OBJ)) $(OBJS) \
    			 madafaka_parser.tab.cc madafaka_parser.tab.hh \
				 location.hh position.hh \
			    stack.hh madafaka_parser.output parser.o estructuras.o\
				 lexer.o madafaka_lexer.yy.cc *gch $(EXE)\
 
.PHONY: all
all: madafaka
 
madafaka: $(FILES)
	$(MAKE) $(SOBJ)
	$(MAKE) $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(EXE) $(OBJS) parser.o lexer.o $(LIBS)
 
 
parser: madafaka_parser.yy estructuras.o
	bison -d -v madafaka_parser.yy
	$(CXX) $(CXXFLAGS) -c -o parser.o madafaka_parser.tab.cc
 
lexer: madafaka_scanner.l
	flex --outfile=madafaka_lexer.yy.cc  $<
	$(CXX)  $(CXXFLAGS) -c madafaka_lexer.yy.cc -o lexer.o

estructuras: estructuras.h estructuras.cpp
	$(CXX) -c estructuras.cpp -o estructuras.o
 
.PHONY: clean
clean:
	rm -rf $(CLEANLIST)
