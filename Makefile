CC    ?= gcc
CXX   ?= g++
 
EXE = madafaka
 
CDEBUG = -g -Wall
 
CXXDEBUG = -g -Wall
 
CSTD = -std=c99
CXXSTD = -std=c++0x
 
CFLAGS = -O0  $(CDEBUG) $(CSTD) 
CXXFLAGS = -O0  $(CXXDEBUG) $(CXXSTD)
 
 
CPPOBJ = main mc_driver
SOBJ =  parser lexer
 
FILES = $(addsuffix .cpp, $(CPPOBJ))
 
OBJS  = $(addsuffix .o, $(CPPOBJ))
 
CLEANLIST =  $(addsuffix .o, $(OBJ)) $(OBJS) \
    			 mc_parser.tab.cc mc_parser.tab.hh \
				 location.hh position.hh \
			    stack.hh mc_parser.output parser.o \
				 lexer.o mc_lexer.yy.cc $(EXE)\
 
.PHONY: all
all: wc
 
wc: $(FILES)
	$(MAKE) $(SOBJ)
	$(MAKE) $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(EXE) $(OBJS) parser.o lexer.o $(LIBS)
 
 
parser: madafaka_parser.yy
	bison -d -v madafaka_parser.yy
	$(CXX) $(CXXFLAGS) -c -o parser.o madafaka_parser.tab.cc
 
lexer: lexer.l
	flex --outfile=madafaka_lexer.yy.cc  $<
	$(CXX)  $(CXXFLAGS) -c madafaka_lexer.yy.cc -o lexer.o
 
 
.PHONY: clean
clean:
	rm -rf $(CLEANLIST)