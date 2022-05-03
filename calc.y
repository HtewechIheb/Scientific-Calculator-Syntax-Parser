%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	void yyerror(char* s);
	int yylex();
	int symbols[52];
	int symbolValue(char symbol);
	void updateSymbolValue(char symbol, int value);
%}

%union { int num; char id; }
%start line
%token print
%token exit_command
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <id> assignment

%%

line: assignment ';' {;}
	| exit_command ';' { exit(EXIT_SUCCESS); }
	| print exp ';' { printf("Printing: %d\n", $2); }
	| line assignment ';' {;}
	| line print exp ';' { printf("Printing: %d\n", $3); }
	| line exit_command ';' { exit(EXIT_SUCCESS); };

assignment: identifier '=' exp { updateSymbolValue($1, $3); };

exp: term { $$ = $1; }
	| exp '+' term { $$ = $1 + $3; }
	| exp '-' term { $$ = $1 - $3; };
	
term: number { $$ = $1; }
	| identifier { $$ = symbolValue($1); };
	
%%

int symbolIndex(char symbol){
	int index = -1;
	if(islower(symbol)){
		index = symbol - 'a' + 26;
	}
	else if(isupper(symbol)){
		index = symbol - 'A';
	}
	
	return index;
}

int symbolValue(char symbol) {
	return symbols[symbolIndex(symbol)];
}

void updateSymbolValue(char symbol, int value) {
	symbols[symbolIndex(symbol)] = value;
}

int main(void) {	
	return yyparse();
}

void yyerror(char* s) {
	fprintf(stderr, "Error occurred: %s\n", s);
}
	

	