%{
#include <iostream>
#include <cstdio>

using namespace std;
%}

%option noyywrap

%%
"int"        { cout << "Line " << yylineno << ": KEYWORD    -> " << yytext << endl; }
"float"      { cout << "Line " << yylineno << ": KEYWORD    -> " << yytext << endl; }
"double"     { cout << "Line " << yylineno << ": KEYWORD    -> " << yytext << endl; }
"char"       { cout << "Line " << yylineno << ": KEYWORD    -> " << yytext << endl; }
"void"       { cout << "Line " << yylineno << ": KEYWORD    -> " << yytext << endl; }

[a-zA-Z_][a-zA-Z0-9_]* { cout << "Line " << yylineno << ": IDENTIFIER -> " << yytext << endl; }

[0-9]+\.[0-9]+          { cout << "Line " << yylineno << ": FLOAT CONST-> " << yytext << endl; }
[0-9]+                  { cout << "Line " << yylineno << ": INT CONST  -> " << yytext << endl; }
\'[a-zA-Z0-9_]\'        { cout << "Line " << yylineno << ": CHAR CONST -> " << yytext << endl; }

"+"          { cout << "Line " << yylineno << ": OPERATOR   -> " << yytext << endl; }
"-"          { cout << "Line " << yylineno << ": OPERATOR   -> " << yytext << endl; }
"*"          { cout << "Line " << yylineno << ": OPERATOR   -> " << yytext << endl; }
"/"          { cout << "Line " << yylineno << ": OPERATOR   -> " << yytext << endl; }
"="          { cout << "Line " << yylineno << ": ASSIGNMENT -> " << yytext << endl; }

";"          { cout << "Line " << yylineno << ": SEMICOLON  -> " << yytext << endl; }

[ \t\r]+    { /* Ignore whitespace */ }
\n          { yylineno++; }
.           { cout << "Line " << yylineno << ": UNKNOWN    -> " << yytext << endl; }
%%

int main(int argc, char *argv[]) {
    if (argc < 2) {
        cout << "Usage: " << argv[0] << " <input_file.txt>" << endl;
        return 1;
    }
    
    FILE *file = fopen(argv[1], "r");
    if (!file) {
        cout << "Error: Could not open file " << argv[1] << endl;
        return 1;
    }
    
    yylineno = 1; 
    yyin = file;  
    yylex();      
    
    fclose(file);
    return 0;
}