#include <stdlib.h>
#include <string.h>
#include "cesar.h"

char chr(int n) {
    return (char)n;
}

int ord(char c) {
    return (int)c;
}

char* cesar(char* input, int x) {
    // ASCII de la primer letra del alfabeto.
    int firstChar = ord('A');

    // Tamaño del alfabeto.
    int maxChars = 26;

    // Alocamos espacio para el resultado y pedimos 1 más de len para contemplar el NULL char al final.
    int len = strlen(input);
    char* res = malloc(sizeof(char) * (len + 1));

    // Hacemos el cifrado wrapeando para cualquier x.
    for (int i = 0; i < len; i++) {
        int newChar = firstChar + (ord(input[i]) + x - firstChar) % maxChars;
        res[i] = chr(newChar);
    }

    // Seteamos explícitamente el NULL char al final porque no sabemos qué hay en lo que devolvió malloc.
    res[len] = 0;

    return res;
}
