#include "ejs.h"
#include "str.h"


void strArrayPrint(str_array_t* a, FILE* pFile) {
    fprintf(pFile, "[");
    for(int i=0; i<a->size-1; i++) {
        strPrint(a->data[i], pFile);
        fprintf(pFile, ",");
    }
    if(a->size >= 1) {
        strPrint(a->data[a->size-1], pFile);
    }
    fprintf(pFile, "]");
}

char* strArrayRemove(str_array_t* a, uint8_t i) {
    char* ret = 0;
    if(a->size > i) {
        ret = a->data[i];
        for(int k=i+1;k<a->size;k++) {
            a->data[k-1] = a->data[k];
        }
        a->size = a->size - 1;
    }
    return ret;
}

char* strArrayGet(str_array_t* a, uint8_t i) {
    char* ret = 0;
    if(a->size > i)
        ret = a->data[i];
    return ret;
}
