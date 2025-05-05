%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h" // Defines T_BOOL_LITERAL, etc.
#include <string.h>
#include "common.h"

// Updated getTokenName - Removed T_TRUE and T_FALSE cases
const char* getTokenName(int token) {
    switch (token) {
        case T_IF: return "T_IF";
        case T_ELSE: return "T_ELSE";
        // REMOVED case T_TRUE: return "T_TRUE";
        // REMOVED case T_FALSE: return "T_FALSE";
        case T_FN: return "T_FN";
        case T_RETURN: return "T_RETURN";
        case T_CLASS: return "T_CLASS";
        case T_FROM: return "T_FROM";
        case T_FOR: return "T_FOR";
        case T_WHILE: return "T_WHILE";
        case T_SWITCH: return "T_SWITCH";
        case T_DO: return "T_DO";
        case T_CONTINUE: return "T_CONTINUE";
        case T_CASE: return "T_CASE";
        case T_TRY: return "T_TRY";
        case T_CATCH: return "T_CATCH";
        case T_FINALLY: return "T_FINALLY";
        case T_IMPORT: return "T_IMPORT";
        case T_BREAK: return "T_BREAK";
        case T_STRING: return "T_STRING";
        case T_INT: return "T_INT";
        case T_FLOAT: return "T_FLOAT";
        case T_CHAR: return "T_CHAR";
        case T_BOOL: return "T_BOOL";
        case T_IDENTIFIER: return "T_IDENTIFIER";
        case T_STRING_LITERAL: return "T_STRING_LITERAL";
        case T_INT_LITERAL: return "T_INT_LITERAL";
        case T_FLOAT_LITERAL: return "T_FLOAT_LITERAL";
        case T_CHAR_LITERAL: return "T_CHAR_LITERAL";
        case T_BOOL_LITERAL: return "T_BOOL_LITERAL";
        case T_ARROW: return "T_ARROW";
        case T_EQ: return "T_EQ";
        case T_NEQ: return "T_NEQ";
        case T_LTE: return "T_LTE";
        case T_GTE: return "T_GTE";
        case T_TYPEANNOTATION: return "T_TYPEANNOTATION";
        default:
            // Handle single character tokens correctly using their ASCII values
            if (token > 0 && token < 128) {
                // Check for the specific characters used as tokens
                switch (token) {
                    case '=': return "'='";
                    case '<': return "'<'";
                    case '>': return "'>'";
                    case '+': return "'+'";
                    case '-': return "'-'";
                    case '*': return "'*'";
                    case '/': return "'/'";
                    case '(': return "'('";
                    case ')': return "')'";
                    case '{': return "'{'";
                    case '}': return "'}'";
                    case '[': return "'['";
                    case ']': return "']'";
                    case ',': return "','";
                    case ':': return "':'";
                    case ';': return "';'";
                    default: { // Fallback for other potential chars
                       static char buf[4];
                       sprintf(buf, "'%c'", token);
                       return buf;
                    }
                }
            }
            return "UNKNOWN_TOKEN";
    }
}

FILE *outfile;
int line_num = 1; // Note: Flex usually manages yylineno automatically
%}


/* Rest of your lexer remains exactly the same */

%option noyywrap
%option noinput
%option nounput

DIGIT         [0-9]
LETTER        [a-zA-Z]
ID_START      [_a-zA-Z]
ID_CHAR       [_a-zA-Z0-9]
WHITESPACE    [ \t\r\n]+
INT           {DIGIT}+
FLOAT         {DIGIT}+"."{DIGIT}*
CHARLIT       \'([^\\\n]|(\\.))\'
STRINGLIT     \"([^\\\n]|(\\.))*\"

%%

"if"          { return T_IF; }
"else"        { return T_ELSE; }
"true"        { return T_BOOL_LITERAL; }
"false"       { return T_BOOL_LITERAL; }
"fn"          { return T_FN; }
"return"      { return T_RETURN; }
"class"       { return T_CLASS; }
"from"        { return T_FROM; }
"for"         { return T_FOR; }
"while"       { return T_WHILE; }
"switch"      { return T_SWITCH; }
"do"          { return T_DO; }
"continue"    { return T_CONTINUE; }
"case"        { return T_CASE; }
"try"         { return T_TRY; }
"catch"       { return T_CATCH; }
"finally"     { return T_FINALLY; }
"import"      { return T_IMPORT; }
"break"       { return T_BREAK; }
"String"      { return T_STRING; }
"Int"         { return T_INT; }
"Float"       { return T_FLOAT; }
"Char"        { return T_CHAR; }
"Bool"        { return T_BOOL; }
{STRINGLIT}   { /* You might want to store the string value in yylval */ return T_STRING_LITERAL; }
{CHARLIT}     { /* Store char value in yylval */ return T_CHAR_LITERAL; }
{FLOAT}       { /* Store float value in yylval */ return T_FLOAT_LITERAL; }
{INT}         { /* Store int value in yylval */ return T_INT_LITERAL; }
{ID_START}{ID_CHAR}* { /* Store identifier string in yylval */ return T_IDENTIFIER; }
"=="          { return T_EQ; }
"!="          { return T_NEQ; }
"<="          { return T_LTE; }
">="          { return T_GTE; }
"::"          { return T_TYPEANNOTATION; }
"->"          { return T_ARROW; }

"=" { return '='; }
"+" { return '+'; }
"-" { return '-'; }
"*" { return '*'; }
"/" { return '/'; }
"(" { return '('; }
")" { return ')'; }
"{" { return '{'; }
"}" { return '}'; }
"[" { return '['; }
"]" { return ']'; }
"," { return ','; }
":" { return ':'; }
";" { return ';'; }
"<" { return '<'; }
">" { return '>'; }

"//"[^\n]* { /* Ignore single-line comments */ }
"/*"([^*]|\*+[^*/])*\*+"/" { /* Ignore multi-line comments */ }
{WHITESPACE}  { /* Ignore whitespace */ }
.             { printf("Unknown character '%s' on line %d\n", yytext, line_num); }

%%
