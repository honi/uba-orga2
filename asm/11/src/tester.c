#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <assert.h>
#include <math.h>
#include <stdbool.h>
#include <float.h>
#include "ejs.h"
#include "str.h"

#define ROLL_LENGTH 100

#define RUN(filename, action) pfile=fopen(filename,"a"); action; fclose(pfile);
#define NL(filename) pfile=fopen(filename,"a"); fprintf(pfile,"\n"); fclose(pfile);

char *filename_ej1 =  "salida.propios.ej1.txt";
void test_ej1(char* filename);


int main() {
	srand(0);
    remove(filename_ej1);
	test_ej1(filename_ej1);
	return 0;
}


static uint32_t x[ROLL_LENGTH];
static float f[ROLL_LENGTH];

void shuffle(uint32_t max){
	for(int i = 0; i < ROLL_LENGTH; i++){
		x[i] = (uint32_t) rand() % max;
        f[i] = ((float)rand()/(float)(RAND_MAX)) * max;
	}
}

#define LENGTH 11

char* strings[LENGTH] = {"Mikasa","Eren","Levi","Erwin","Annie","Reiner","Armin","Jean","Sasha","Hanji",""};

void test_ej1(char* filename) {
    FILE* pfile;
    str_array_t* a;
    void* data;

    RUN(filename, fprintf(pfile, "== Ejercicio 1 ==\n");) NL(filename)

    // Agregar
    RUN(filename, fprintf(pfile, "Agregar\n");) NL(filename)
    a = strArrayNew(20);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    strArrayAddLast(a,strings[0]);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    strArrayAddLast(a,strings[1]);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    strArrayAddLast(a,strings[2]);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    NL(filename)
    // Get
    RUN(filename, fprintf(pfile, "Get\n");) NL(filename)
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    data = strArrayGet(a,0);
    RUN(filename, fprintf(pfile, "%s\n", (char*)data);)
    data = strArrayGet(a,1);
    RUN(filename, fprintf(pfile, "%s\n", (char*)data);)
    data = strArrayGet(a,2);
    RUN(filename, fprintf(pfile, "%s\n", (char*)data);)
    data = strArrayGet(a,3);
    RUN(filename, fprintf(pfile, "%s\n", (char*)data);)
    NL(filename)

    // Quitar
    RUN(filename, fprintf(pfile, "Quitar\n");) NL(filename)
    data = strArrayRemove(a,0);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) RUN(filename, fprintf(pfile, " - %s\n", (char*)data);)
    strDelete((char*)data);
    data = strArrayRemove(a,1);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) RUN(filename, fprintf(pfile, " - %s\n", (char*)data);)
    strDelete((char*)data);
    data = strArrayRemove(a,0);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) RUN(filename, fprintf(pfile, " - %s\n", (char*)data);)
    strDelete((char*)data);
    NL(filename)
    // Swap
    RUN(filename, fprintf(pfile, "Swap\n");) NL(filename)
    strArrayAddLast(a,strings[0]); strArrayAddLast(a,strings[1]); strArrayAddLast(a,strings[2]);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    strArraySwap(a, 0, 0);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    strArraySwap(a, 1, 1);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    strArraySwap(a, 2, 2);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    strArraySwap(a, 0, 2);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    strArraySwap(a, 2, 0);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    strArraySwap(a, 0, 1);
    strArraySwap(a, 1, 2);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    NL(filename)
    // Agregar de mas
    RUN(filename, fprintf(pfile, "Agregar de mas\n");) NL(filename)
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    for(int j=0; j<3; j++) {
        for(int i=0; i<LENGTH; i++) {
            strArrayAddLast(a,strings[i]);
            RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
        }
    }
    NL(filename)
    // Quitar de mas
    RUN(filename, fprintf(pfile, "Quitar de mas\n");) NL(filename)
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    for(int j=0; j<3; j++) {
        for(int i=0; i<LENGTH; i++) {
            data = strArrayRemove(a,i);
            RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) RUN(filename, fprintf(pfile, " - %s\n", (char*)data);)
            strDelete((char*)data);
        }
    }
    data = strArrayRemove(a,0);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) RUN(filename, fprintf(pfile, " - %s\n", (char*)data);)
    strDelete((char*)data);
    data = strArrayRemove(a,0);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) RUN(filename, fprintf(pfile, " - %s\n", (char*)data);)
    strDelete((char*)data);
    data = strArrayRemove(a,LENGTH);
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) RUN(filename, fprintf(pfile, " - %s\n", (char*)data);)
    strDelete((char*)data);
    NL(filename)
    // Delete
    RUN(filename, fprintf(pfile, "Delete\n");) NL(filename)
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    for(int i=0; i<LENGTH; i++) {
        strArrayAddLast(a,strings[i]);
    }
    RUN(filename, fprintf(pfile, "%i - ", strArrayGetSize(a));) RUN(filename, strArrayPrint(a,pfile);) NL(filename)
    strArrayDelete(a);
    NL(filename)
}


