global filtrar_mayores

section .text
filtrar_mayores:
    ; void filtrar_mayores(int *a, short umbral, int dimension);
    ; rdi = a
    ; rsi = umbral
    ; rdx = dimension

    push rbp
    mov rbp, rsp

    ; Cargamos el umbral 4 veces para comparar contra cada double word.
    movd xmm1, esi
    vpbroadcastw xmm1, xmm1

    ; Calculamos la cantidad de chunks que vamos a procesar.
    mov rcx, rdx
    shr rcx, 3

.loop:
    ; Cargamos el chunk a procesar.
    movdqu xmm0, [rdi]

    ; Packed CoMPare Greater Than Word
    pcmpgtw xmm0, xmm1

    ; Movemos el chunk procesado al array de resultado.
    movdqu [rdi], xmm0

    ; Movemos el puntero al siguiente chunk.
    add rdi, 16

    loop .loop

    pop rbp
    ret
