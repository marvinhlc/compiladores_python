%{
#include "tabsim.h"
#include "y.tab.h"
#include <string.h>
simbolo *t;
int yylineno = 1;
%}
%%
"print"		{return PRINT;}
"def"		{return DEF;} 
"if"		{entrarBloque();return IF;}
"else"		{entrarBloque();return ELSE;}
"exit"		{return EXIT_COMMAND;}
[a-z]		{yylval = *yytext - 'a'; return ID;}
[0-9]		{yylval = atoi(yytext); return INTEGER;}

[-+()=/*:;]	{ return *yytext; }	/* operadores */ 
[ \t]       	; /* espacios en blanco */
[\n]		{yylineno++;}
.		yyerror("caracter no valido");
%%
int yywrap(void) {
    return 1;
}
