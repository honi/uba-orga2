#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include "utils.h"

void int16ToDouble(int16_t *input, double *output, int length)
{
    int i;
 
    for ( i = 0; i < length; i++ ) {
        output[i] = (double)input[i];
    }
}
 
void doubleToInt16( double *input, int16_t *output, int length )
{
    int i;
 
    for ( i = 0; i < length; i++ ) {
        if ( input[i] > INT16_MAX) {
            input[i] = INT16_MAX;
        } else if ( input[i] < INT16_MIN ) {
            input[i] = INT16_MIN;
        }
        // convert
        output[i] = (int16_t)input[i];
    }
}


int cmp(int16_t a, int16_t b, int16_t e){
	int c = 1;
	if(abs(a)-abs(b)>e || abs(a)-abs(b)<-e){
	    c=0;
	}	
	return c;
}	
	
void printSalida(FILE* pfile, int16_t* salida, int16_t* salida2, int size){

	
	for (int i=0; i<size; i++){
		if (cmp(salida[i], salida2[i], 4)){
		    fprintf(pfile, "Y%i=%s ",i, "OK");
		} else {
		    fprintf(pfile, "Y%i=%d ",i, salida[i]-salida2[i]);
		}
	}
	
	fprintf(pfile, "\n");
	

}

