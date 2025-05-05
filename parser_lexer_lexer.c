#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h" // Include for yylval and token IDs
#include <string.h>

FILE *yyin = NULL;
char *yytext = NULL;
extern YYSTYPE yylval; // Declare yylval

int yylex (void) {
    if (!yyin) {
        yyin = fopen("tokens.txt", "r");
        if (!yyin) {
            perror("Error opening tokens.txt");
            return 0;
        }
    }

    int token_id;
    char lexeme_buffer[256];
    int result = fscanf(yyin, "%d %255[^\n]\n", &token_id, lexeme_buffer);

    if (result == 2) {
        if (yytext) {
            free(yytext);
        }
        yytext = strdup(lexeme_buffer);
        switch (token_id) {
            case T_IDENTIFIER:
            case T_STRING_LITERAL:
            case T_CHAR_LITERAL:
                yylval.string_val = strdup(yytext);
                break;
            case T_INT_LITERAL:
                yylval.int_val = atoi(yytext);
                break;
            case T_FLOAT_LITERAL:
                yylval.float_val = atof(yytext);
                break;
            case T_BOOL_LITERAL:
                yylval.bool_val = (strcmp(yytext, "true") == 0) ? 1 : 0; // Corrected
                break;
            default:
                // For tokens without a specific value, yylval might not need setting
                break;
        }

        printf("Lexer: Token ID = %d, Lexeme = \"%s\"\n", token_id, yytext); // Added debug print
        return token_id;
    } else {
        if (yyin) {
            fclose(yyin);
            yyin = NULL;
        }
        if (yytext) {
            free(yytext);
            yytext = NULL;
        }
        return 0;
    }
}
