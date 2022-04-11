%{
#include<stdio.h>
#include<string.h>
#include"tokenList.h"
char dest[600] = "";
int debugFlag = 0;//1 for debug, and 0 for produce 
int lineCnt = 0;
int firstLine=1;//1 for first, otherwise 0
int state;
int sourceOn = 1;
int tokenOn = 1;
%}
%x SINGLELINECOMMENT
%x MULTIPLELINECOMMENT
%x SINGLEQUO
MACRO ("NULL"|"__COUNTER__"|"__LINE__"|"INT_MAX"|"INT_MIN"|"CHAR_MAX"|"CHAR_MIN"|"MAX"|"MIN")
PUNC (":"|";"|","|"."|"["|"]"|"("|")"|"{"|"}")
ESC ("\\a"|"\\b"|"\\e"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"|"\\\\"|"\\\'"|"\\\""|"\\\?"|"\\nnn"|"\\xhh..."|"\\uhhhh"|"\\Uhhhhhhhh")
LOWERCASE ("a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|"i"|"j"|"k"|"l"|"m"|"n"|"o"|"p"|"q"|"r"|"s"|"t"|"u"|"v"|"w"|"x"|"y"|"z")
UPPERCASE ("A"|"B"|"C"|"D"|"E"|"F"|"G"|"H"|"I"|"J"|"K"|"L"|"M"|"N"|"O"|"P"|"Q"|"R"|"S"|"T"|"U"|"V"|"W"|"X"|"Y"|"Z")
NUMBER ("0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9")

ASCII1 (" "|"!"|"\\\""|"#"|"$"|"%"|"&"|"\\\'"|"("|")"|"*"|"+"|","|"-"|"."|"/"|"0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|":"|";"|"<"|"="|">"|"\\\?"|"?")
ASCII2 ("@"|"A"|"B"|"C"|"D"|"E"|"F"|"G"|"H"|"I"|"J"|"K"|"L"|"M"|"N"|"O"|"P"|"Q"|"R"|"S"|"T"|"U"|"V"|"W"|"X"|"Y"|"Z"|"["|"\\"|"]"|"^"|"_")
ASCII3 ("`"|"a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|"i"|"j"|"k"|"l"|"m"|"n"|"o"|"p"|"q"|"r"|"s"|"t"|"u"|"v"|"w"|"x"|"y"|"z"|"{"|"|"|"}"|"~")
COMMENT ("//")
TWOOP ("++"|"--"|"<="|">="|"=="|"!="|"&&"|"||")
ONEOP ("+"|"-"|"*"|"/"|"%"|"<"|">"|"!"|"&"|"|"|"=")
KEYWORD ("for"|"do"|"while"|"break"|"continue"|"if"|"else"|"return"|"struct"|"switch"|"case"|"default"|"void"|"int"|"double"|"float"|"char"|"const"|"signed"|"unsigned"|"short"|"long")
MCOMMENT ("*/")
UNDERLINE ("_")
LSTARCOMMENT ("/*")
RSTARCOMMENT ("*/")
%%
(\-{NUMBER}+)|({NUMBER}+)|(\+{NUMBER}+)  {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                if(debugFlag==1)printf("HERE~~\n");
                break;
            default:
                if(firstLine==1){
                        printf("#integer:%s", yytext);
                        firstLine=0;
                }else 
                    printf("\n#integer:%s", yytext);
        }
    }
    strcat(dest,yytext);
}
(\+([0-9]+\.[0-9]*))|([0-9]+\.[0-9]*)|(\-([0-9]+\.[0-9]*)|(\.[0-9]+)|(\+\.[0-9]+)|(\-\.[0-9]+))  {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                if(firstLine==1){
                        printf("#f");
                        printf("loat:%s", yytext);
                        firstLine=0;
                }else {
                    printf("\n#f");
                    printf("loat:%s", yytext);
                }
        }
    }
    strcat(dest,yytext);
}
"#pragma"([[:space:]]|'\t')+"source"([[:space:]]|'\t')+"on"   {
    switch(state){
        case STRING:
            printf("%s", yytext);
            break;
        case SCOMMENT:
        case MCOMMENT:
            break;
        default:
            sourceOn = 1;
            break;
    }
    strcat(dest,yytext);
}
"#pragma"([[:space:]]|'\t')+"source"([[:space:]]|'\t')+"off"   {
    switch(state){
        case STRING:
            printf("%s", yytext);
            break;
        case SCOMMENT:
        case MCOMMENT:
            break;
        default:
            sourceOn = 0;
            break;
    }
    strcat(dest,yytext);
}
"#pragma"([[:space:]]|'\t')+"token"([[:space:]]|'\t')+"on"   {
    switch(state){
        case STRING:
            printf("%s", yytext);
            break;
        case SCOMMENT:
        case MCOMMENT:
            break;
        default:
            tokenOn = 1;
            break;
    }
    strcat(dest,yytext);
}
"#pragma"([[:space:]]|'\t')+"token"([[:space:]]|'\t')+"off"   {
    switch(state){
        case STRING:
            printf("%s", yytext);
            break;
        case SCOMMENT:
        case MCOMMENT:
            break;
        default:
            tokenOn = 0;
            break;
    }
    strcat(dest,yytext);
}
"/*"    {
    if(tokenOn==1){
        if(debugFlag==1)printf("\nMEET LSTAR~~~\n");
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                state=MCOMMENT;
                if(debugFlag==1)printf("\nSTART MUL. LINE COMMENT!\n");
                if(firstLine==1){
                    if(firstLine==1){
                        firstLine=0;
                    }
                }
        }
    }
    strcat(dest,yytext);
}
"*//"    {
    if(tokenOn==1){
        if(debugFlag==1){
            printf("\nMEET RSTAR~~~\n");
            printf("\nat RSTAR, currentState = %d and the process str = %s\n", state, yytext);
        }
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
                break;
            case MCOMMENT:
                if(debugFlag==1)printf("END MUL. LINE COMMENT\n");
                state=NONE;
                break;
            default:
                if(firstLine==1){
                    firstLine=0;
                    printf("#op:*");
                    state= SCOMMENT;
                }else {
                    printf("\n#op:*");
                    state= SCOMMENT;
                }
        }
    }
    strcat(dest,yytext);
}
"*/"    {
    if(tokenOn==1){
        if(debugFlag==1){
            printf("\nMEET RSTAR~~~\n");
            printf("\nat RSTAR, currentState = %d and the process str = %s\n", state, yytext);
        }
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
                break;
            case MCOMMENT:
                if(debugFlag==1)printf("END MUL. LINE COMMENT\n");
                state=NONE;
                break;
            default:
                if(firstLine==1){
                    firstLine=0;
                    printf("#op:*");
                    printf("\n#op:/");
                }else {
                    printf("\n#op:*");
                    printf("\n#op:/");
                }
        }
    }
    strcat(dest,yytext);
}

{COMMENT} {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s",yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                if(debugFlag==1)printf("START SINGLE LINE COMMENT\n");
                state=SCOMMENT;
        }
    }
    strcat(dest,yytext);
}
{ESC} {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                if(debugFlag)printf("UNDEF BEHAVIOR\n");
        }
    }
    strcat(dest,yytext);
}
\"  {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s",yytext);
                state=NONE;
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                state=STRING;
                if(firstLine==1){
                    firstLine=0;
                    printf("#string:%s",yytext);
                }else {
                    printf("\n#string:%s",yytext);
                }
        }
    }
    strcat(dest,yytext);
}
\'  {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s",yytext);
                state=NONE;
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            case CHAR:
                printf("NOTHING~~~~\n");
            default:
                state=CHAR;
                if(firstLine==1){
                    firstLine=0;
                    printf("#cha");printf("r:%s",yytext);
                }else {
                    printf("\n#cha");printf("r:%s",yytext);
                }
        }
    }
    strcat(dest,yytext);
}
\'({ASCII1}|{ASCII2}|{ASCII3}|{ESC})\'  {
    if(tokenOn==1){
        if(debugFlag==1)printf("\nat right CHAR, currentState = %d and the process str = %s\n", state, yytext);
        switch(state){
            case STRING:
                printf("%s",yytext);
                state=NONE;
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                state=NONE;
                if(firstLine==1){
                    firstLine=0;
                    printf("#c");
                    printf("har:%s",yytext);
                }else {
                    printf("\n#c");
                    printf("har:%s",yytext);
                }
                if(debugFlag==1)printf("FAIL INPUT:%s~~~\n", yytext);
        }
    }
    strcat(dest,yytext);
}

{TWOOP} {
    if(tokenOn==1){
        if(debugFlag==1)printf("\nat 2op, currentState = %d and the process str = %s\n", state, yytext);
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                if(firstLine==1){
                    firstLine=0;
                    printf("#op:%s",yytext);
                }else {
                    printf("\n#op:%s",yytext);
                }
        }
    }
    strcat(dest,yytext);
}

{ONEOP} {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                if(firstLine==1){
                    firstLine=0;
                    printf("#op:%s",yytext);
                }else {
                    
                    printf("\n#op:%s",yytext);
                }
        }
    }
    strcat(dest,yytext);
}

{KEYWORD} {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                if(firstLine==1){
                    firstLine=0;
                    printf("#key:%s",yytext);
                }else {
                    printf("\n#key:%s",yytext);
                }
        }
    }
    strcat(dest,yytext);
}


{PUNC}    {
    if(tokenOn==1){
        if(debugFlag==1)printf("\nat punc, currentState = %d and the process str = %s\n", state, yytext);
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                if(firstLine==1){
                    firstLine=0;
                    printf("#punc:%s",yytext);
                }else {
                    printf("\n#punc:%s",yytext);
                }
        }
    }
    strcat(dest,yytext);
}
{MACRO}   {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                if(firstLine==1){
                    firstLine=0;
                    printf("#macro:%s",yytext);
                }else {
                    printf("\n#macro:%s",yytext);
                }
        }
    }
    strcat(dest,yytext);
}



({KEYWORD})+({LOWERCASE}|{UPPERCASE}|{UNDERLINE}|{KEYWORD}|{NUMBER})+  {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                if(firstLine==1){
                    firstLine=0;
                    printf("#id:%s",yytext);
                }else {
                    printf("\n#id:%s",yytext);
                }
        }
    }
    strcat(dest,yytext);
}

({LOWERCASE}|{UPPERCASE}|{UNDERLINE})+({KEYWORD}|{LOWERCASE}|{UPPERCASE}|{UNDERLINE}|{NUMBER})*   {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
                break;
            default:
                if(firstLine==1){
                    firstLine=0;
                    printf("#id:%s",yytext);
                }else {
                    printf("\n#id:%s",yytext);
                }
        }
    }
    strcat(dest,yytext);
}

\n {
    if(state!=3)state=NONE;
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
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
            default:
                break;
        }
    }
    strcat(dest,yytext);
}

. {
    if(tokenOn==1){
        switch(state){
            case STRING:
                printf("%s", yytext);
                break;
            case SCOMMENT:
            case MCOMMENT:
            default:
                break;
        }
    }
    strcat(dest,yytext);
}
%%

int main(int argc, char* argv[]){
    state = NONE;
    yylex();
    printf("\n");
    return 0;
}