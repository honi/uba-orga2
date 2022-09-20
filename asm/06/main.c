#include <stdlib.h>
#include <stdio.h>
#include "cesar.h"

typedef char* (*cesar_func_ptr)(char*, int);

void call_cesar_aux(cesar_func_ptr cesar_func, char* func_name, char* input, int x) {
    char* res = (*cesar_func)(input, x);
    printf("%s(\"%s\", %d) -> \"%s\"\n", func_name, input, x, res);
    free(res);
}

void call_cesar(char* input, int x) {
    call_cesar_aux(cesar, "    cesar", input, x);
    call_cesar_aux(cesar_asm, "cesar_asm", input, x);
}

int main() {
    call_cesar("CASA", 3);
    call_cesar("CALABAZA", 7);
    call_cesar("CALABAZA", 7 + 26 * 10);
    call_cesar("", 1);
    return 0;
}
