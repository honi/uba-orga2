#ifndef UTILS_H_
#define UTILS_H_

#include<stdint.h>
#include<stdio.h>

void display_progress(double progress);
void int16ToDouble(int16_t *input, double *output, int length);
void doubleToInt16(double *input, int16_t *output, int length);
void printSalida(FILE* pfile, int16_t* salida, int16_t* salida2, int size);

#endif //UTILS_H_
