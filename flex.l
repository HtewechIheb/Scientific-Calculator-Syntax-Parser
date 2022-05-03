%{
	#include "calc.tab.h"
	void yyerror(char* s);
%}

letter	[a-zA-Z]
digit	[0-9]
integer	[+|-]?{digit}+
whitespace [ \t\n]
litterals [=;]

%%
"print"	{ return PRINT_COMMAND; }
"exit"	{ return EXIT_COMMAND; }
{letter}	{ yylval.id = yytext[0]; return IDENTIFIER; }
{integer}	{ yylval.num = atoi(yytext); return NUMBER; }
{whitespace}	;
{litterals}	{ return yytext[0]; }
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return MULTIPLY; }
"/" { return DIVIDE; }
"^" { return POWER; }
"(" { return OPEN_BRACKET; }
")" { return CLOSE_BRACKET; }
"sin" { return SIN; }
"cos" { return COS; }
"tan" { return TAN; }
"exp" { return EXP; }
"log" { return LOG; }
"sqrt" { return SQRT; }
.	{ yyerror("Unexpected character: "); ECHO; }
%%

int yywrap(void) {
	return 1;
}