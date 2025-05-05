#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
#include <string.h>
#include <errno.h>
#include "common.h"

FILE *yyin = NULL;
char *yytext = NULL;
extern YYSTYPE yylval;
extern int line_num;

int yylex(void) {
    static char line_buffer[256];
    static char lexeme_buffer[256];
    int token_id;

    if (!yyin) {
        fprintf(stderr, "Lexer: yyin is NULL!\n");
        return 0;
    }

    if (fgets(line_buffer, sizeof(line_buffer), yyin) != NULL) {
        int result = sscanf(line_buffer, "%d %255[^\n]", &token_id, lexeme_buffer);
        if (result == 2) {
            if (yytext) free(yytext);
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
                    yylval.bool_val = (strcmp(yytext, "true") == 0) ? 1 : 0;
                    break;
                default:
                    break;
            }

            return token_id;
        } else {
            fprintf(stderr, "Lexer: Malformed line: %s", line_buffer);
            return -1;
        }
    } else {
        return 0; // EOF
    }
}
