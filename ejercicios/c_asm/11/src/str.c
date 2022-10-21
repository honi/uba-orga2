#include <stdlib.h>
#include <stdio.h>

#include "str.h"

int32_t strCmp(char* a, char* b) {
    int i=0;
    while(a[i]==b[i] && a[i]!=0 && b[i]!=0) i++;
    if(a[i]==0 && b[i]==0) return 0;
    if(a[i]==0) return 1;
    if(b[i]==0) return -1;
    return (a[i]<b[i])? 1 : -1;
}

char* strClone(char* a) {
    uint32_t len = strLen(a) + 1;
    char* s = malloc(len);
    while(len-- != 0)
        { s[len]=a[len];}
    return s;
}

void strDelete(char* a) {
    free(a);
}

void strPrint(char* a, FILE* pFile) {
    if(strLen(a)!=0)
        fprintf(pFile, "%s", a);
    else
        fprintf(pFile, "NULL");
}

uint32_t strLen(char* a) {
    uint32_t i=0;
    while(a[i]!=0) i++;
    return i;
}