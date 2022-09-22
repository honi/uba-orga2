#ifndef EJS_H
#define EJS_H

#include <stdio.h> 		//encabezado de funciones de entrada y salida fopen, fclose, fgetc, printf, fprintf ...
#include <stdlib.h>		//biblioteca estándar, atoi, atof, rand, srand, abort, exit, system, NULL, malloc, calloc, realloc...
#include <stdint.h>		//contiene la definición de tipos enteros ligados a tamaños int8_t, int16_t, uint8_t,...
#include <ctype.h>		//contiene funciones relacionadas a caracteres, isdigit, islower, tolower...
#include <string.h>		//contiene las funciones relacionadas a strings, memcmp, strcat, memset, memmove, strlen,strstr...
#include <math.h>		//define funciones matemáticas como cos, sin, abs, sqrt, log...
#include <stdbool.h>	//contiene las definiciones de datos booleanos, true (1), false (0)
#include <unistd.h>		//define constantes y tipos standard, NULL, R_OK, F_OK, STDIN_FILENO, STDOUT_FILENO, STDERR_FILENO...
#include <assert.h>		//provee la macro assert que evalúa una condición, y si no se cumple provee información diagnóstica y aborta la ejecución

//*************************************
//Declaración de estructuras
//*************************************

typedef struct str_array {
	uint8_t size;
	uint8_t capacity;
	char** data;
} str_array_t;


//*******************************
//Declaración de funciones de ej1
//*******************************

/*Crea un array de strings nuevo con capacidad indicada por capacity*/
str_array_t* strArrayNew(uint8_t capacity);

/*Obtiene la cantidad de elementos ocupados del arreglo.*/
uint8_t  strArrayGetSize(str_array_t* a);

/*	Agrega un string al final del arreglo. Si el arreglo no tiene capacidad suficiente, 
entonces no hace nada. Esta función debe hacer una copia del string. */
void  strArrayAddLast(str_array_t* a, char* data);

/* Obtiene el i-esimo elemento del arreglo, si i se encuentra fuera de rango, retorna 0.*/
char* strArrayGet(str_array_t* a, uint8_t i);

/* Quita el i-esimo elemento del arreglo, si i se encuentra fuera de rango, retorna 0.
El arreglo es reacomodado de forma que ese elemento indicado sea quitado y retornado. */
char* strArrayRemove(str_array_t* a, uint8_t i);

/*Invierte el contenido del i-ésimo elemento con el j-ésimo elemento. 
 Si alguno de los dos índices se encuentra fuera de rango, no realiza ninguna acción.*/
void  strArraySwap(str_array_t* a, uint8_t i, uint8_t j);

/*Borra el arreglo, para esto borra todos los strings que el arreglo contenga, 
junto con las estructuras propias del tipo arreglo.*/
void  strArrayDelete(str_array_t* a);

/*Escribe en el stream indicado por pFile el arreglo almacenado en a.
  Para cada string llama a la función de impresión strPrint.
  El formato del arreglo será: [x[0], ..., x[n-1]], suponiendo que x[i] es el resultado 
  de escribir el i-ésimo elemento.*/
void  strArrayPrint(str_array_t* a, FILE* pFile);




#endif
