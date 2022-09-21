#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "sumar_vectores.h"

// Tamaño de cada elemento: 2 bytes
// Tamaño del chunk de procesamiento (registros xmm): 16 bytes
// Cantidad de elementos procesados simultáneamente: 16 / 2 = 8 elementos
// => Dimensión es múltiplo de 8.

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
    int dimension = sizeof(a) / sizeof(a[0]);

    sumar_vectores(a, b, res, dimension);

    printf("res = {");
    for(int i = 0; i < dimension; i++) {
        printf("%u", res[i]);
        if (i != dimension - 1) printf(", ");
    }
    printf("}\n");

    free(res);
    return 0;
}
