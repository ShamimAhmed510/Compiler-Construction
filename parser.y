%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
extern int yylineno;
extern char *yytext;
void yyerror(const char *s);
%}

/* Union definition to handle token values if needed later */
%union {
    char *sval;
}

/* Tokens declaration */
%token <sval> ID INT_LIT FLOAT_LIT
%token INT FLOAT IF ELSE FOR PRINTF RETURN
%token ASSIGN EQ LT GT PLUS MINUS MULT DIV MOD
%token LPAREN RPAREN LBRACE RBRACE SEMI COMMA

/* Operator Precedence & Associativity */
%right ASSIGN
%left LT GT EQ
%left PLUS MINUS
%left MULT DIV MOD

/* Resolving dangling-else conflict cleanly */
%nonassoc IFX
%nonassoc ELSE

%%

program:
    statement_list
    ;

statement_list:
    /* empty rule allows empty files or empty blocks */
    | statement_list statement
    ;

statement:
    declaration
    | assignment
    | conditional
    | loop
    | print_stmt
    | return_stmt
    | block
    | SEMI /* Handles lone semicolons safely */
    ;

block:
    LBRACE { printf("-> Entering block scope.\n"); } statement_list RBRACE { printf("-> Exiting block scope.\n"); }
    ;

type_specifier:
    INT
    | FLOAT
    ;

declaration:
    type_specifier ID SEMI
        { printf("[Success] Parsed declaration statement.\n"); }
    ;

assignment:
    ID ASSIGN expr SEMI
        { printf("[Success] Parsed assignment statement.\n"); }
    ;

conditional:
    IF LPAREN expr RPAREN statement %prec IFX
        { printf("[Success] Parsed IF statement.\n"); }
    | IF LPAREN expr RPAREN statement ELSE statement
        { printf("[Success] Parsed IF-ELSE statement.\n"); }
    ;

loop:
    FOR LPAREN type_specifier ID ASSIGN expr SEMI expr SEMI ID ASSIGN expr RPAREN statement
        { printf("[Success] Parsed FOR loop statement.\n"); }
    ;

print_stmt:
    PRINTF LPAREN expr RPAREN SEMI
        { printf("[Success] Parsed printf statement.\n"); }
    ;

return_stmt:
    RETURN expr SEMI
        { printf("[Success] Parsed return statement.\n"); }
    ;

expr:
    expr PLUS expr
    | expr MINUS expr
    | expr MULT expr
    | expr DIV expr
    | expr MOD expr
    | expr LT expr
    | expr GT expr
    | expr EQ expr
    | LPAREN expr RPAREN
    | ID
    | INT_LIT
    | FLOAT_LIT
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s at line %d (near \"%s\")\n", s, yylineno, yytext);
}

int main(int argc, char **argv) {
    extern FILE *yyin;
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
    }

    printf("--- Starting Parser ---\n");
    if (yyparse() == 0) {
        printf("\n>>> SUCCESS: Parsing completed without syntax errors.\n");
    } else {
        printf("\n>>> FAILURE: Parsing failed due to syntax error.\n");
    }
    return 0;
}