#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "sumar.h"

// Tamaño de cada elemento: 2 bytes
// Cantidad de elementos: 32
// Dimensión: 32 * 2 bytes = 64 bytes

int main() {
    uint16_t a[] = {
        1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1,
    };
    uint16_t b[] = {
        2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2,
    };
    uint16_t *res = malloc(sizeof(a));
    int length = sizeof(a) / sizeof(a[0]);

    sumar_vectores(a, b, res, sizeof(a));

    printf("res = {");
    for(int i = 0; i < length; i++) {
        printf("%u", res[i]);
        if (i != length - 1) printf(", ");
    }
    printf("}\n");

    free(res);
    return 0;
}
