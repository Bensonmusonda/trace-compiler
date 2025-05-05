#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

extern FILE *yyin;
extern int yyparse();
extern char *yytext;
extern int yylex();
extern YYSTYPE yylval;
extern int yydebug;

int main(void) {
    yyin = fopen("C:\\Users\\benso\\Desktop\\Compilers\\trace\\tokens.txt", "r");
    if (!yyin) {
        perror("Error opening tokens.txt");
        return EXIT_FAILURE;
    }

    // Debug: Print tokens before parsing
    printf("Reading tokens from tokens.txt:\n");

    fpos_t pos;
    fgetpos(yyin, &pos); // Save position

    int token;
    while ((token = yylex()) != 0) {
        printf("Token ID: %d\tLexeme: %s\n", token, yytext);
    }

    // Reset file pointer so parser gets all tokens
    fsetpos(yyin, &pos);

    printf("\nStarting parsing...\n");
    yydebug = 1; // Enable debugging here
    int result = yyparse();
    printf("yyparse() returned: %d\n", result);

    if (result == 0) {
        printf("Parsing successful!\n");
    } else {
        printf("Parsing failed.\n");
    }

    fclose(yyin);
    return result;
}