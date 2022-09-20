#include <stdlib.h>
#include <stdio.h>
#include "cesar.h"

typedef char* (*cesar_func_ptr)(char*, int);

void call_cesar(cesar_func_ptr cesar_func, char* input, int x) {
    char* res = (*cesar_func)(input, x);
    printf("'%s' -> '%s'\n", input, res);
    free(res);
}

int main() {
    printf("Versión C\n");
    call_cesar(cesar, "CASA", 3);
    call_cesar(cesar, "CALABAZA", 7);
    call_cesar(cesar, "CALABAZA", 7 + 26 * 10);
    call_cesar(cesar, "", 1);

    printf("\nVersión ASM\n");
    call_cesar(cesar_asm, "CASA", 3);
    call_cesar(cesar_asm, "CALABAZA", 7);
    call_cesar(cesar_asm, "CALABAZA", 7 + 26 * 10);
    call_cesar(cesar_asm, "", 1);

    return 0;
}
