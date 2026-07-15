%{
#include <iostream>
#include <cstdlib>
#include "parser.tab.h" // Generated automatically by Bison

using namespace std;
%}

%option noyywrap

%%
[0-9]+(\.[0-9]+)?   { yylval.fval = atof(yytext); return NUMBER; }
"+"                 { return '+'; }
"-"                 { return '-'; }
"*"                 { return '*'; }
"/"                 { return '/'; }
"("                 { return '('; }
")"                 { return ')'; }
"\n"                { return '\n'; }
[ \t\r]+            { /* Ignore spaces and tabs */ }
.                   { cout << "Lexer Error: Unknown character " << yytext << endl; }
%%