#include <string>
#include "MadafakaSymbol.h"

#include "MadafakaSymTable.h"
using namespace std;

int main(){
	string test("123");
	float test2 = 1.0;
	MadafakaSymbol *b = new MadafakaSymbol(test,test2);
}