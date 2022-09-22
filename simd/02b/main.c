#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "dividir.h"

int main() {
    int vector[] = {
        10, 20, 30, 40,
        50, 60, 70, 80,
        10, 20, 30, 40,
        50, 60, 70, 80,
    };
    int dimension = sizeof(vector) / sizeof(vector[0]);

    dividir_vector_por_potencia_de_dos(vector, 2, dimension);

    printf("{");
    for(int i = 0; i < dimension; i++) {
        printf("%d", vector[i]);
        if (i != dimension - 1) printf(", ");
    }
    printf("}\n");

    return 0;
}
