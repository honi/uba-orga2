global inicializar_vector

section .text
inicializar_vector:
    ; void inicializar_vector(short *a, short valor_inicial, int dimension);
    ; rdi = a
    ; rsi = valor_inicial
    ; rdx = dimension

    push rbp
    mov rbp, rsp

    ; Movemos el valor inicial a un registro.
    movd xmm1, esi

    ; Calculamos la cantidad de chunks que vamos a procesar.
    mov rcx, rdx
    shr rcx, 3

.loop:
    ; Si el CPU soporta AVX2 podemos usar broadcast.
    vpbroadcastw xmm0, xmm1

    ; Sino, podemos hacer así. Shuffleamos el valor inicial a toda la parte baja del xmm0,
    ; y luego unpackeamos xmm0 con si mismo para repetir valor inicial por todo xmm0.
    ; pshuflw xmm0, xmm1, 0
    ; punpcklwd xmm0, xmm0

    ; Movemos el chunk procesado al array de resultado.
    movdqu [rdi], xmm0

    ; Movemos los punteros al siguiente chunk.
    add rdi, 16

    loop .loop

    pop rbp
    ret
