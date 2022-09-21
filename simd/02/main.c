#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "inicializar_vector.h"

int main() {
    int elementos_por_chunk = (16 / sizeof(short)); // 16 es el tamaño en bytes de los xmm.
    int chunks = 4;
    int dimension = elementos_por_chunk * chunks;

    short *vector = malloc(sizeof(short) * dimension);
    short valor_inicial = 42;

    inicializar_vector(vector, valor_inicial, dimension);

    printf("res = {");
    for(int i = 0; i < dimension; i++) {
        printf("%d", vector[i]);
        if (i != dimension - 1) printf(", ");
    }
    printf("}\n");

    free(vector);
    return 0;
}
