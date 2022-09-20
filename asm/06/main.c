#include <stdlib.h>
#include <stdio.h>
#include "cesar.h"

int main() {
    char* res;

    printf("Versión C\n");

    res = cesar("CASA", 3);
    printf("%s\n", res);
    free(res);

    res = cesar("CALABAZA", 7);
    printf("%s\n", res);
    free(res);

    res = cesar("CALABAZA", 7 + 26 * 10);
    printf("%s\n", res);
    free(res);

    printf("Versión ASM\n");

    res = cesar_asm("CASA", 3);
    printf("%s\n", res);
    free(res);

    res = cesar_asm("CALABAZA", 7);
    printf("%s\n", res);
    free(res);

    res = cesar("CALABAZA", 7 + 26 * 10);
    printf("%s\n", res);
    free(res);

    return 0;
}
