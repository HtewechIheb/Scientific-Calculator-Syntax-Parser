%{
	#include "calc.tab.h"
	void yyerror(char* s);
%}

letter	[a-zA-Z]
digit	[0-9]
integer	{digit}+
whitespace [ \t\n]
litterals [+-=;]

%%
"print"	{ return print; }
"exit"	{ return exit_command; }
{letter}	{ yylval.id = yytext[0]; return identifier; }
{integer}	{ yylval.num = atoi(yytext); return number; }
{whitespace}	;
{litterals}	{ return yytext[0]; }
.	{ yyerror("Unexpected character: "); ECHO; }

%%

int yywrap(void) {
	return 1;
}