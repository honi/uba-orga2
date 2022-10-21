global dividir_vector_por_potencia_de_dos

section .text
dividir_vector_por_potencia_de_dos:
    ; void dividir_vector_por_potencia_de_dos(int *a, int potencia, int dimension);
    ; rdi = a
    ; rsi = potencia
    ; rdx = dimension

    push rbp
    mov rbp, rsp

    ; Movemos la potencia a un registro.
    movd xmm1, esi

    ; Calculamos la cantidad de chunks que vamos a procesar.
    mov rcx, rdx
    shr rcx, 2

.loop:
    ; Cargamos el chunk a procesar.
    movdqu xmm0, [rdi]

    ; Packed Shift Right Arithmetic Dword.
    psrad xmm0, xmm1

    ; Movemos el chunk procesado al array de resultado.
    movdqu [rdi], xmm0

    ; Movemos el puntero al siguiente chunk.
    add rdi, 16

    loop .loop

    pop rbp
    ret
