#ifndef STR_H
#define STR_H

#include <stdint.h>
#include <stdio.h>

int32_t strCmp(char* a, char* b);

char* strClone(char* a);

void strDelete(char* a);

uint32_t strLen(char* a);

void strPrint(char* a, FILE* pFile);

#endif
