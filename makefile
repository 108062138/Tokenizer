compile: scanner.l tokenList.h
	flex scanner.l
	gcc -o scanner lex.yy.c -lfl
	./scanner < ./testcases/$(FILE) > MYOUTPUT.txt
	golden_scanner <  ./testcases/$(FILE) > GOLDENOUTPUT.txt
	diff MYOUTPUT.txt GOLDENOUTPUT.txt
all: 
	compile
