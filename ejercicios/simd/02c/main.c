#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "filtrar_mayores.h"

int main() {
    short vector[] = {
        4, 4, 4, 4, 6, 6, 6, 6,
    };
    int dimension = sizeof(vector) / sizeof(vector[0]);

    filtrar_mayores(vector, 5, dimension);

    printf("{");
    for(int i = 0; i < dimension; i++) {
        printf("%d", vector[i]);
        if (i != dimension - 1) printf(", ");
    }
    printf("}\n");

    return 0;
}
