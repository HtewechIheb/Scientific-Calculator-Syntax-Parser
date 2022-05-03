%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <math.h>
	void yyerror(char* s);
	int yylex();
	int symbols[52];
	double symbolValue(char symbol);
	void updateSymbolValue(char symbol, double value);
%}

%union { double num; char id; }
%start line
%token PRINT_COMMAND EXIT_COMMAND PLUS MINUS MULTIPLY DIVIDE POWER OPEN_BRACKET CLOSE_BRACKET SIN COS TAN EXP LOG SQRT
%token <num> NUMBER
%token <id> IDENTIFIER
%type <num> line exp term
%type <id> assignment

%left PLUS MINUS
%left MULTIPLY DIVIDE
%left POWER

%%

line: assignment ';' {;}
	| EXIT_COMMAND ';' { exit(EXIT_SUCCESS); }
	| PRINT_COMMAND exp ';' { printf("Printing: %.5f\n", $2); }
	| line assignment ';' {;}
	| line PRINT_COMMAND exp ';' { printf("Printing: %.5f\n", $3); }
	| line EXIT_COMMAND ';' { exit(EXIT_SUCCESS); };

assignment: IDENTIFIER '=' exp { updateSymbolValue($1, $3); };

exp: term { $$ = $1; }
	| exp PLUS exp { $$ = $1 + $3; }
	| exp MINUS exp { $$ = $1 - $3; }
	| exp MULTIPLY exp { $$ = $1 * $3; }
	| exp DIVIDE exp { if($3 == 0) { printf("Error occurred: Division by zero. \n"); exit(EXIT_FAILURE); } else $$ =  $1 / $3; }
	| exp POWER exp { $$ = pow($1, $3); }
	| SIN OPEN_BRACKET exp CLOSE_BRACKET { $$ = sin($3); }
	| COS OPEN_BRACKET exp CLOSE_BRACKET { $$ = cos($3); }
	| TAN OPEN_BRACKET exp CLOSE_BRACKET { if(fmod(($3 * 2 / M_PI), 2) != 0) { printf("Error occurred: Tan of kPI with k an odd integer. \n"); exit(EXIT_FAILURE); } else $$ = tan($3); }
	| EXP OPEN_BRACKET exp CLOSE_BRACKET { $$ = exp($3); }
	| LOG OPEN_BRACKET exp CLOSE_BRACKET { if($3 < 0) { printf("Error occurred: Log of non strictly positive number. \n"); exit(EXIT_FAILURE); } $$ = log($3); }
	| SQRT OPEN_BRACKET exp CLOSE_BRACKET { if($3 < 0) { printf("Error occurred: Square root of negative number. \n"); exit(EXIT_FAILURE); } else $$ = sqrt($3); };
	
term: NUMBER { $$ = $1; }
	| IDENTIFIER { $$ = symbolValue($1); };
	
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

double symbolValue(char symbol) {
	return symbols[symbolIndex(symbol)];
}

void updateSymbolValue(char symbol, double value) {
	symbols[symbolIndex(symbol)] = value;
}

int main(void) {	
	return yyparse();
}

void yyerror(char* s) {
	fprintf(stderr, "Error occurred: %s\n", s);
}
	

	