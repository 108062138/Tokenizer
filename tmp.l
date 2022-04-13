%{
#include<stdio.h>
#include<string.h>
#include"tokenList.h"
char dest[600] = "";
int debugFlag = 0;//1 for debug, and 0 for produce 
int lineCnt = 0;
int firstLine=1;//1 for first, otherwise 0
int sourceOn = 1;
int tokenOn = 1;
%}
%x MULTIPLELINECOMMENT
%x SINGLELINECOMMENT
%x STRING 
MCOMMENTR ("*/")
COMMENT ("//")
MACRO ("NULL"|"__COUNTER__"|"__LINE__"|"INT_MAX"|"INT_MIN"|"CHAR_MAX"|"CHAR_MIN"|"MAX"|"MIN")
ASCII1 (" "|"!"|"\\\""|"#"|"$"|"%"|"&"|"\\\'"|"("|")"|"*"|"+"|","|"-"|"."|"/"|"0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|":"|";"|"<"|"="|">"|"\\\?"|"?")
ASCII2 ("@"|"A"|"B"|"C"|"D"|"E"|"F"|"G"|"H"|"I"|"J"|"K"|"L"|"M"|"N"|"O"|"P"|"Q"|"R"|"S"|"T"|"U"|"V"|"W"|"X"|"Y"|"Z"|"["|"\\"|"]"|"^"|"_")
ASCII3 ("`"|"a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|"i"|"j"|"k"|"l"|"m"|"n"|"o"|"p"|"q"|"r"|"s"|"t"|"u"|"v"|"w"|"x"|"y"|"z"|"{"|"|"|"}"|"~")
ESC ("\\a"|"\\b"|"\\e"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"|"\\\\"|"\\\'"|"\\\""|"\\\?"|"\\nnn"|"\\xhh..."|"\\uhhhh"|"\\Uhhhhhhhh")
KEYWORD ("for"|"do"|"while"|"break"|"continue"|"if"|"else"|"return"|"struct"|"switch"|"case"|"default"|"void"|"int"|"double"|"float"|"char"|"const"|"signed"|"unsigned"|"short"|"long")
PUNC (":"|";"|","|"."|"["|"]"|"("|")"|"{"|"}")
NUMBER ("0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9")
LOWERCASE ("a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|"i"|"j"|"k"|"l"|"m"|"n"|"o"|"p"|"q"|"r"|"s"|"t"|"u"|"v"|"w"|"x"|"y"|"z")
UPPERCASE ("A"|"B"|"C"|"D"|"E"|"F"|"G"|"H"|"I"|"J"|"K"|"L"|"M"|"N"|"O"|"P"|"Q"|"R"|"S"|"T"|"U"|"V"|"W"|"X"|"Y"|"Z")
TWOOP ("++"|"--"|"<="|">="|"=="|"!="|"&&"|"||")
ONEOP ("+"|"-"|"*"|"/"|"%"|"<"|">"|"!"|"&"|"|"|"=")
UNDERLINE ("_")
%%
(\-{NUMBER}+)|({NUMBER}+)|(\+{NUMBER}+)  {
    if(firstLine==1){
        printf("#integer:%s", yytext);
        firstLine=0;
    }else 
        printf("\n#integer:%s", yytext);
    strcat(dest,yytext);
}
(\+([0-9]+\.[0-9]*))|([0-9]+\.[0-9]*)|(\-([0-9]+\.[0-9]*)|(\.[0-9]+)|(\+\.[0-9]+)|(\-\.[0-9]+))  {
    if(firstLine==1){
            printf("#f");
            printf("loat:%s", yytext);
            firstLine=0;
    }else {
        printf("\n#f");
        printf("loat:%s", yytext);
    }
    strcat(dest,yytext);
}
"#pragma"([[:space:]]|'\t')+"source"([[:space:]]|'\t')+"on"   {
    sourceOn=1;
    strcat(dest,yytext);
}
"#pragma"([[:space:]]|'\t')+"source"([[:space:]]|'\t')+"off"   {
    sourceOn=0;
    strcat(dest,yytext);
}
"#pragma"([[:space:]]|'\t')+"token"([[:space:]]|'\t')+"on"   {
    tokenOn=1;
    strcat(dest,yytext);
}
"#pragma"([[:space:]]|'\t')+"token"([[:space:]]|'\t')+"off"   {
    tokenOn=0;
    strcat(dest,yytext);
}
"/*"    {
    strcat(dest,yytext);
    BEGIN MULTIPLELINECOMMENT;
}
<MULTIPLELINECOMMENT>\n {
    lineCnt++;
    if(sourceOn==1){
        if(firstLine==1){
            printf("%d:%s", lineCnt,dest);
            firstLine = 0;
        }else{
            printf("\n%d:%s", lineCnt,dest);
        }
    }
    strcpy(dest,"");
}
<MULTIPLELINECOMMENT>"*/"    {
    strcat(dest,yytext);
    BEGIN 0;
}
<MULTIPLELINECOMMENT>.  {
    strcat(dest,yytext);
}

{COMMENT} {
    strcat(dest,yytext);
    BEGIN SINGLELINECOMMENT;    
}
<SINGLELINECOMMENT>\n {
    lineCnt++;
    if(sourceOn==1){
        if(firstLine==1){
            printf("%d:%s", lineCnt,dest);
            firstLine = 0;
        }else{
            printf("\n%d:%s", lineCnt,dest);
        }
    }
    strcpy(dest,"");
    BEGIN 0;
}
<SINGLELINECOMMENT>. {
    strcat(dest,yytext);
}
\'{ESC}|{NUMBER}\'   {
    printf("at line %d, token: %s~~\n",lineCnt,yytext);
    if(tokenOn==1){
        if(firstLine==1){
                printf("#c");
                printf("har:%s ESCNUM", yytext);
                firstLine=0;
        }else {
            printf("\n#c");
            printf("har:%s", yytext);
        }
    }
    strcat(dest,yytext);
}
\'{ASCII1}|{ASCII2}|{ASCII3}\'  {
    printf("at line %d, token: %s...\n",lineCnt,yytext);
    if(tokenOn==1){
        if(firstLine==1){
                printf("#c");
                printf("har:%s", yytext);
                firstLine=0;
        }else {
            printf("\n#c");
            printf("har:%s", yytext);
        }
    }
    strcat(dest,yytext);
}

{TWOOP} {
    if(tokenOn==1){
        if(firstLine==1){
            firstLine=0;
            printf("#op:%s",yytext);
        }else {
            printf("\n#op:%s",yytext);
        }
    }
    strcat(dest,yytext);
}

{ONEOP} {
    if(tokenOn==1){
        if(firstLine==1){
            firstLine=0;
            printf("#op:%s",yytext);
        }else {
            printf("\n#op:%s",yytext);
        }
    }
    strcat(dest,yytext);
}

{KEYWORD} {
    if(tokenOn==1){
        if(firstLine==1){
            firstLine=0;
            printf("#key:%s",yytext);
        }else {
            printf("\n#key:%s",yytext);
        }
    }
    strcat(dest,yytext);
}


{PUNC}    {
    if(tokenOn==1){
        if(firstLine==1){
            firstLine=0;
            printf("#punc:%s",yytext);
        }else {
            printf("\n#punc:%s",yytext);
        }
    }
    strcat(dest,yytext);
}
{MACRO}   {
    if(tokenOn==1){
        if(firstLine==1){
            firstLine=0;
            printf("#macro:%s",yytext);
        }else {
            printf("\n#macro:%s",yytext);
        }
    }
    strcat(dest,yytext);
}
({KEYWORD})+({LOWERCASE}|{UPPERCASE}|{UNDERLINE}|{KEYWORD}|{NUMBER})+  {
    if(tokenOn==1){
        if(firstLine==1){
            firstLine=0;
            printf("#id:%s",yytext);
        }else {
            printf("\n#id:%s",yytext);
        }
    }
    strcat(dest,yytext);
}

({LOWERCASE}|{UPPERCASE}|{UNDERLINE})+({KEYWORD}|{LOWERCASE}|{UPPERCASE}|{UNDERLINE}|{NUMBER})*   {
    if(tokenOn==1){
        if(firstLine==1){
            firstLine=0;
            printf("#id:%s",yytext);
        }else {
            printf("\n#id:%s",yytext);
        }
    }
    strcat(dest,yytext);
}

\"  {
    if(tokenOn==1){
        if(firstLine==1){
            firstLine=0;
            printf("#string:%s",yytext);
        }else {
            printf("\n#string:%s",yytext);
        }
    }
    strcat(dest,yytext);
    BEGIN STRING;
}
<STRING>.   {
    if(tokenOn==1){
        printf("%s",yytext);
    }
    strcat(dest,yytext);
}
<STRING>\"   {
    if(tokenOn==1){
        printf("%s",yytext);
    }
    strcat(dest,yytext);
    BEGIN 0;
}
\n {
    lineCnt++;
    if(sourceOn==1){
        if(firstLine==1){
            printf("%d:%s", lineCnt,dest);
            firstLine = 0;
        }else{
            printf("\n%d:%s", lineCnt,dest);
        }
    }
    strcpy(dest,"");
}

\t|" " {
    strcat(dest,yytext);
}

. {
    strcat(dest,yytext);
}
%%

int main(int argc, char* argv[]){
    yylex();
    printf("\n");
    return 0;
}


