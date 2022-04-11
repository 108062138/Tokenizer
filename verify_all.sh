GREEN="\e[1;32m pass^_^ \e[0m";
RED="\e[1;31m failOuO \e[0m";
GREEN='\033[0;32m';
BLUE='\033[0;35m';
RED='\033[0;31m';
END='\033[0m';


for FILE in ./testcases/*;do
flex scanner.l;
gcc -o scanner lex.yy.c -lfl;
./scanner < $FILE > MYOUTPUT.txt;
golden_scanner < $FILE > GOLDENOUTPUT.txt;
DIFF=$(diff MYOUTPUT.txt GOLDENOUTPUT.txt);
if [ "$DIFF" != ""]
then echo -e "${BLUE}${FILE}${END} ${RED}FAIL...OuO${END}";
else echo -e "${BLUE}${FILE}${END} ${GREEN}PASS!\\>_<//${END}";
fi
done
