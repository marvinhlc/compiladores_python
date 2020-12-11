%{
#include "tabsim.h"
#include "y.tab.h"
#include <string.h>
simbolo *t;
%}
%%
"print"		{return PRINT;}
"int"           {return INTEGER;}
"string"        {return STRING;}
"begin"         {entrarBloque();return BEGIN;}
"end"           {salirBloque();return END;}
"exit"		{return EXIT_COMMAND;}
[a-z]		{yylval = *yytext - 'a'; return ID;}
[0-9]		{yylval = atoi(yytext); return INTEGER;}

[-+()=/*;,]	{ return *yytext; }	/* operadores */ 
[{]             { return *yytext;}
[}]             { return *yytext;}
[ \t]       	; /* espacios en blanco */
[\n]		{yylineno++;}
.		yyerror("caracter no valido");
%%
int yywrap(void) {
    return 1;
}
