%{
#include <iostream>
#include <cstdio>
#include <cstdlib>

using namespace std;

// Intercepting Flex signatures
extern int yylex();
void yyerror(const char *s);
%}

/* Define types for token values */
%union {
    double fval;
}

/* Tokens and their value associations */
%token <fval> NUMBER
%type <fval> expression

/* Operator Precedence: Lower lines mean higher priority */
%left '+' '-'
%left '*' '/'
%expect 1

%%

calculation:
    /* Empty rule allows pressing Enter on a blank line */
    | calculation line
    ;

line:
    '\n'
    | expression '\n' { cout << "Result: " << $1 << endl; }
    | expression      { cout << "Result: " << $1 << endl; } 
    ;

expression:
    NUMBER                  { $$ = $1; }
    | expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression { 
                                    if ($3 == 0) {
                                        yyerror("Division by zero error!");
                                        $$ = 0;
                                    } else {
                                        $$ = $1 / $3; 
                                    }
                                }
    | '(' expression ')'    { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    cerr << "Calculator Error: " << s << endl;
}

int main() {
    cout << "--- Simple Bison Calculator ---" << endl;
    cout << "Enter expressions (e.g., 4 + 5 * 2) and press Enter:" << endl;
    yyparse();
    return 0;
}