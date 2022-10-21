#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <argp.h>
#include <math.h>

#include "utils.h"
#include "ej2.h"

int16_t* filtro_c (const int16_t* entrada, unsigned size) {

	int16_t* salida = (int16_t*) malloc((size*4)-(3*4));
	
	for (unsigned i = 0; i < size-3; i++){
		for (unsigned j = 0; j < 4; j++){
			salida[i*2]=trunc((entrada[i*2]+entrada[(i*2)+2]+entrada[(i*2)+4]+entrada[(i*2)+6])/4);
			salida[(i*2)+1]=trunc((entrada[(i*2)+1]+entrada[(i*2)+3]+entrada[(i*2)+5]+entrada[(i*2)+7])/4);		
		}
	}
	return salida;  
}

