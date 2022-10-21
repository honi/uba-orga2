global filtro
extern malloc

section .data align=16
shuffle_mask: db 0,1,4,5,8,9,12,13,2,3,6,7,10,11,14,15

section .text
; int16_t* filtro (const int16_t* entrada, unsigned size)
; rdi = int16_t* entrada
; rsi = unsigned size
filtro:
    ; Prólogo.
    push rbp
    mov rbp, rsp

    ; Preservamos los registros no volátiles.
    push r12 ; desalineado
    push r13 ; alineado

    ; Preservamos los argumentos de entrada en registros no volátiles para no perderlos
    ; al llamar a malloc u otras funciones.
    mov r12, rdi ; int16_t* entrada
    mov r13, rsi ; unsigned size

    ; Pedimos memoria para el resultado.
    mov rdi, rsi
    sub rdi, 3  ; Restamos los 3 elementos del final.
    sal rdi, 2  ; Multiplicamos por 4 bytes de cada elemento (canales L+R).
    call malloc

    ; Ya tenemos el puntero al resultado en rax. Lo copiamos a otro registro porque
    ; vamos a ir incrementandolo mientras procesamos los chunks.
    mov r8, rax

    ; Calculamos la cantidad de pasadas.
    mov rcx, r13
    sub rcx, 3

.process_chunk:
    ; Cargamos el chunk.
    movdqu xmm0, [r12]

    ; Reordenamos los words para nos queden los 4 left y los 4 right juntos.
    pshufb xmm0, [shuffle_mask]

    ; Multiplicamos por 1/4 con trunqueo haciendo un shift right.
    ; Lo hacemos primero para mantenernos en el rango de representación.
    psraw xmm0, 2

    ; Hacemos 2 sumas horizontales para sumar los 4 elementos de left y right.
    ; Usamos la suma con saturación porque parece más razonable siendo un filtro de audio.
    phaddsw xmm0, xmm0
    phaddsw xmm0, xmm0

    ; Movemos los 2 elementos de left y right procesados al resultado.
    movd ebx, xmm0
    mov [r8], ebx

    ; Avanzamos los punteros para la próxima pasada.
    add r8, 4
    add r12, 4

    loop .process_chunk

    ; Restauramos los registros no volátiles.
    pop r13
    pop r12

    ; Epílogo.
    pop rbp
    ret
