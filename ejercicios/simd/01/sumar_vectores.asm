global sumar_vectores

section .text
sumar_vectores:
    ; void sumar_vectores(uint16_t *a, uint16_t *b, uint16_t *res, int dimension)
    ; rdi = a
    ; rsi = b
    ; rdx = res
    ; rcx = dimension

    ; Prólogo.
    push rbp
    mov rbp, rsp

    ; Calculamos la cantidad de chunks que vamos a procesar.
    shr rcx, 3

.add:
    ; Cargamos los chunks a procesar.
    movdqu xmm0, [rdi]
    movdqu xmm1, [rsi]

    ; Sumamos verticalmente de a words porque son arrays de uint16_t.
    ; Si fuesen de otro tamaño tendríamos que usar la variante correspondiente de padd:
    ; uint8_t = paddb
    ; uint16_t = paddw
    ; uint32_t = paddd
    ; uint64_t = paddq
    paddw xmm0, xmm1

    ; Movemos el chunk procesado al array de resultado.
    movdqu [rdx], xmm0

    ; Movemos los punteros al siguiente chunk.
    add rdi, 16
    add rsi, 16
    add rdx, 16

    loop .add

    ; Epílogo.
    pop rbp
    ret
