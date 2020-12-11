%{
#include "tabsim.c"
void yyerror(char *);
int yylex(void);
extern simbolo *t;
int sym[26];
%}
%union 	{
	int numero;
	simbolo * ptr_simbolo;
	}
%start programa	
%token <numero> NUMERO
%type <numero> expr sentencia sentencias
%token PRINT EXIT_COMMAND ID INTEGER STRING BEGIN END
%left '+' '-'
%left '*' '/'
%%
programa:
	BEGIN
	     '(' declaraciones ')'
	     '{' sentencias '}'
	END  {;}
        | error ';' { yyerrok; }
	;

declaraciones:
	| declaraciones ',' decl        {;}
	| decl                          {;}
	;

decl:
	tipo ID {
			simbolo *s = buscarEnBloque(t, $2->nombre, level);		     
				if (s==NULL){
					$2->valor=0;					       	
					insertar(&t, $2);
				}
		};

tipo:
	INTEGER                         {;}
	|STRING                         {;}

sentencias: /* cadena vacia */          {;}
	| sentencia sentencia ';'       {;}
	| sentencias programa           {;}
	;

sentencia:
	expr		        {printf("%d\n",$1);}
	| PRINT expr		{printf("%d\n", $2);}
	| EXIT_COMMAND		{exit(EXIT_COMMAND);}
	| ID '=' expr		{
					$$ = $3;
					simbolo *s = buscar(t, $1->nombre);
					s->valor = $3;
				}
	|decl                   {;}
	;

expr:
	NUMERO                  { $$ = $1;}
	| ID			{$$ = $1->valor;}
	| expr '+' expr		{$$ = $1 + $3;}
	| expr '-' expr		{$$ = $1 - $3;}
	| expr '*' expr		{$$ = $1 * $3;}
	| expr '/' expr		{$$ = $1 / $3;}
	|'(' expr ')'           {$$ = $2;}		
	;

%%
void yyerror(char *s){
	extern int yylineno;	//predefinida en lex.c
	extern char *yytext;	//predefinida en lex.c
	printf("Error: %s en simbolo \"%s\" en linea %d \n",s,yytext,yylineno);
	exit(1);
}
void main()
{ 
	t = crear();
	yyparse();
	imprimir(t);
}
