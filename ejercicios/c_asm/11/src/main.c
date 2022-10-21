#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "ejs.h"

int main (void){
	uint8_t capacity = 4;
	str_array_t *s = strArrayNew(capacity);

	printf("strArrayNew(%d)\n", capacity);
	printf("strArrayGetSize = %d\n", strArrayGetSize(s));
	strArrayPrint(s, stdout);
	printf("\n");

	strArrayAddLast(s, "Joni aprender a programar en assembler");
	printf("strArrayGetSize = %d\n", strArrayGetSize(s));
	strArrayPrint(s, stdout);
	printf("\n");

	strArrayAddLast(s, "A Joni le gusta assembler");
	printf("strArrayGetSize = %d\n", strArrayGetSize(s));
	strArrayPrint(s, stdout);
	printf("\n");

	strArraySwap(s, 2, 0);
	strArraySwap(s, 0, 1);
	strArrayPrint(s, stdout);
	printf("\n");

	strArrayDelete(s);
	return 0;
}
