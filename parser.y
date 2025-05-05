%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
#include <string.h>
#include "common.h"

extern int yylex();
extern char *yytext;
extern int line_num;

void yyerror(const char *s);
int yydebug = 1;
%}

%union {
    char *string_val;
    int int_val;
    float float_val;
    int bool_val;
}

%token T_IF T_ELSE T_FN T_RETURN T_CLASS T_FROM
       T_FOR T_WHILE T_SWITCH T_DO T_CONTINUE T_CASE T_TRY T_CATCH
       T_FINALLY T_IMPORT T_BREAK
       T_STRING T_INT T_FLOAT T_CHAR T_BOOL
       <string_val> T_IDENTIFIER T_STRING_LITERAL T_CHAR_LITERAL
       <int_val> T_INT_LITERAL <bool_val> T_BOOL_LITERAL
       <float_val> T_FLOAT_LITERAL
       T_ARROW T_EQ T_NEQ T_LTE T_GTE
       T_TYPEANNOTATION
       // DO NOT add T_LT or T_GT here if using character literals

%start program

%nonassoc T_TYPEANNOTATION
%nonassoc T_ARROW
%left '+' '-'
%left '*' '/'
%left '<' '>' T_LTE T_GTE // Add precedence for '<' and '>' too
%left T_EQ T_NEQ         // Add precedence for == and !=

%%

program:
    statements
;

statements:
    statements statement
    | statement
;

statement:
    declaration_statement ';'
    | function_definition
    | expression_statement ';'
    | control_structure
;

declaration_statement:
    T_IDENTIFIER T_TYPEANNOTATION primitive_type '=' expression
    { printf("DEBUG: Found primitive type in declaration.\n"); }
;

function_definition:
    T_FN T_IDENTIFIER '(' parameter_list ')' T_ARROW primitive_type block
    | T_FN T_IDENTIFIER '(' ')' T_ARROW primitive_type block
;

parameter_list:
    parameter
    | parameter_list ',' parameter
;

parameter:
    T_IDENTIFIER T_TYPEANNOTATION primitive_type
;

primitive_type:
    T_STRING  { printf("DEBUG: Recognized type String.\n"); }
    | T_INT     { printf("DEBUG: Recognized type Int.\n"); }
    | T_FLOAT   { printf("DEBUG: Recognized type Float.\n"); }
    | T_CHAR    { printf("DEBUG: Recognized type Char.\n"); }
    | T_BOOL    { printf("DEBUG: Recognized type Bool.\n"); }
;

block:
    '{' statements '}'
    { printf("DEBUG: Entered a block.\n"); }
;

control_structure:
    if_statement
    | while_statement
    | for_statement
;

if_statement:
    T_IF expression T_ARROW block
    | T_IF expression T_ARROW block T_ELSE T_ARROW block
;

while_statement:
    T_WHILE expression T_ARROW block
    { printf("DEBUG: Entering while_statement.\n"); }
;

for_statement:
    T_FOR declaration_statement ';' expression ';' expression T_ARROW block
;

expression_statement:
    expression
    | T_RETURN expression
;

expression:
    T_INT_LITERAL
    | T_FLOAT_LITERAL
    | T_STRING_LITERAL
    | T_CHAR_LITERAL
    | T_BOOL_LITERAL
    | T_IDENTIFIER
    | T_IDENTIFIER '(' argument_list ')'
    | T_IDENTIFIER '(' ')'
    | expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    | expression T_EQ expression
    | expression T_NEQ expression
    | expression '<' expression
    | expression '>' expression
    | expression T_LTE expression
    | expression T_GTE expression
    | '(' expression ')'
    | T_IDENTIFIER '=' expression  // Add this for assignment
    { printf("DEBUG: Parsed an assignment expression.\n"); }
;

argument_list:
    expression
    | argument_list ',' expression
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error at line %d: %s\n", line_num, s);
}