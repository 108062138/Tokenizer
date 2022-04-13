compile: scanner.l tokenList.h
	flex scanner.l
	gcc -o scanner lex.yy.c -lfl
	./scanner < ./testcases/keyidTest.c  > MYOUTPUT.txt
	golden_scanner <  ./testcases/keyidTest.c > GOLDENOUTPUT.txt
	diff MYOUTPUT.txt GOLDENOUTPUT.txt
all: 
	compile
