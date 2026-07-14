%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
%}

%option yylineno
%option noyywrap

/* Regular Expressions definitions */
DIGIT   [0-9]
ID      [a-zA-Z_][a-zA-Z0-9_]*

%%

"int"                   { return INT; }
"float"                 { return FLOAT; }
"if"                    { return IF; }
"else"                  { return ELSE; }
"for"                   { return FOR; }
"printf"                { return PRINTF; }
"return"                { return RETURN; }

"=="                    { return EQ; }
"="                     { return ASSIGN; }
"<"                     { return LT; }
">"                     { return GT; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return MULT; }
"/"                     { return DIV; }
"%"                     { return MOD; }
"("                     { return LPAREN; }
")"                     { return RPAREN; }
"{"                     { return LBRACE; }
"}"                     { return RBRACE; }
";"                     { return SEMI; }
","                     { return COMMA; }

{DIGIT}+"."{DIGIT}+     { yylval.sval = strdup(yytext); return FLOAT_LIT; }
{DIGIT}+                { yylval.sval = strdup(yytext); return INT_LIT; }
{ID}                    { yylval.sval = strdup(yytext); return ID; }

[ \t\r\n]+              { /* Ignore all whitespaces and newlines */ }
.                       { printf("Lexical Error: Unknown character '%s' at line %d\n", yytext, yylineno); }

%%