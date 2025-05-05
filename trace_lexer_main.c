#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

extern int yylex();
extern char *yytext;
extern void *yy_scan_string(const char *str);
extern void yy_delete_buffer(void *buffer);
extern void yy_switch_to_buffer(void *buffer);
extern FILE *outfile;

int main() {
    outfile = fopen("C:\\Users\\benso\\Desktop\\Compilers\\trace\\tokens.txt", "w");
    if (!outfile) {
        perror("Error opening output file");
        return 1;
    }

    char *buffer = NULL;
    size_t buffer_size = 0;
    ssize_t line_size;

    printf("Enter your multi-line input (press Ctrl+D or Ctrl+Z then Enter to finish):\n");

    while ((line_size = getline(&buffer, &buffer_size, stdin)) != -1) {
        void *yy_buffer = yy_scan_string(buffer);
        if (!yy_buffer) {
            fprintf(stderr, "Flex failed to scan string.\n");
            continue;
        }

        yy_switch_to_buffer(yy_buffer);

        int token_id;
        while ((token_id = yylex())) {
            fprintf(outfile, "%d\t%s\n", token_id, yytext);
        }

        yy_delete_buffer(yy_buffer);
    }

    free(buffer);
    fclose(outfile);
    printf("Tokens written to tokens.txt\n");
    return 0;
}
