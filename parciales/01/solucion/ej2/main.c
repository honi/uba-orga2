#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <argp.h>

#include "utils.h"
#include "ej2.h"


int main (int argc, char *argv[]) {
	int16_t arreglo[16] = {1,1,1,1,2,2,2,2,3,3,3,3,4,4};
	int16_t* salida = (int16_t*) filtro(arreglo, 7);

	for (int i = 0; i < 8; i++) {
		printf("[%d]", salida[i]);
	}
	printf("\n");

	return 0;
}


// [1][1][1][1][2][2][2][2] [3][3][3][3][4][4][0][0]
// 7*4 = 28 bytes
// 4*4 = 16 bytes
// (7 - 3) = 4
