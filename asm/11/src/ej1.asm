global strArrayNew
global strArrayGetSize
global strArrayAddLast
global strArraySwap
global strArrayDelete
extern malloc
extern free
extern memcpy
extern strlen

section .data
%define OFFSET_SIZE 0
%define OFFSET_CAPACITY 1
%define OFFSET_DATA 8
%define SIZE_STR_ARRAY 16

section .text

; str_array_t* strArrayNew(uint8_t capacity)
; rdi = capacity
strArrayNew:
    push rbp
    mov rbp, rsp

    ; Preservamos en el stack los no volátiles que vamos a usar.
    push r12
    push r13

    ; Guardamos capacity en un registro no volátil.
    mov r12, rdi

    ; Calculamos la cantidad de memoria que necesitamos para data.
    mov rax, 8 ; Un puntero ocupa 8 bytes.
    mul r12    ; Multiplicamos por capacity (cantidad de punteros que vamos a tener).

    ; Pedimos memoria para data y lo guardamos en otro no volátil.
    mov rdi, rax
    call malloc
    mov r13, rax

    ; Pedimos memoria para el struct.
    mov rdi, SIZE_STR_ARRAY
    call malloc

    ; Inicializamos el struct.
    mov byte [rax + OFFSET_SIZE], 0
    mov [rax + OFFSET_CAPACITY], r12b
    mov [rax + OFFSET_DATA], r13

    ; Restauramos los registros.
    pop r13
    pop r12
    pop rbp

    ; Ya tenemos la dirección del struct en rax.
    ret

; uint8_t strArrayGetSize(str_array_t* a)
; rdi = a
strArrayGetSize:
    push rbp
    mov rbp, rsp

    xor rax, rax
    mov al, [rdi + OFFSET_SIZE]

    pop rbp
    ret

; void strArrayAddLast(str_array_t* a, char* data)
; rdi = a
; rsi = data
strArrayAddLast:
    push rbp
    mov rbp, rsp

    ; Preservamos en el stack los no volátiles que vamos a usar.
    push r12 ; lo usamos para: a
    push r13 ; lo usamos para: data
    push r14 ; lo usamos para: size
    push r15 ; lo usamos para: strlen(data) + 1

    ; Nos guardamos los argumentos en registros no volátiles.
    mov r12, rdi
    mov r13, rsi

    ; Cargamos size en un registro.
    xor r14, r14
    mov r14b, [r12 + OFFSET_SIZE]

    ; Chequeamos si queda lugar para agregar el nuevo string.
    cmp r14b, [r12 + OFFSET_CAPACITY]
    je .full ; sze == capacity

    ; Calculamos la longitud del string que vamos a agregar.
    mov rdi, r13
    call strlen
    mov r15, rax

    ; Le sumamos 1 para contemplar el NULL char.
    inc r15

    ; Pedimos memoria para el nuevo string.
    mov rdi, r15
    call malloc

    ; Guardamos el puntero al nuevo string en su lugar dentro de data.
    mov rdi, [r12 + OFFSET_DATA]
    mov [rdi + r14 * 8], rax

    ; Copiamos el string.
    mov rdi, rax
    mov rsi, r13
    mov rdx, r15
    call memcpy

    ; Incrementamos size en 1.
    inc byte [r12 + OFFSET_SIZE]

.full:
    mov rax, 0

.exit:
    ; Restauramos los registros.
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

; void strArraySwap(str_array_t* a, uint8_t i, uint8_t j)
; rdi = a
; rsi = i
; rdx = j
strArraySwap:
    push rbp
    mov rbp, rsp

    ; Cargamos size en un registro.
    xor r14, r14
    mov r14b, [rdi + OFFSET_SIZE]

    ; Chequeamos que los índices estén en rango.
    cmp rsi, r14
    jge .exit ; i >= size
    cmp rdx, r14
    jge .exit ; j >= size

    ; Guardamos la dirección de inicio de data.
    mov r12, [rdi + OFFSET_DATA]

    ; Cargamos los punteros de los strings a swapear.
    mov r13, [r12 + rsi * 8] ; i-ésimo string.
    mov r14, [r12 + rdx * 8] ; j-ésimo string.

    ; Swapeamos los strings en data.
    mov [r12 + rsi * 8], r14
    mov [r12 + rdx * 8], r13

.exit:
    pop rbp
    ret

; void strArrayDelete(str_array_t* a)
; rdi = a
strArrayDelete:
    push rbp
    mov rbp, rsp

    ; Preservamos en el stack los no volátiles que vamos a usar.
    push r12
    push r13
    push r14

    ; Guardamos el puntero al struct en un no volátil.
    mov r12, rdi

    ; Cargamos el puntero a data.
    mov r13, [r12 + OFFSET_DATA]

    ; Cargamos size en un registro para loopear y liberar la memoria de cada string.
    ; No usamos rcx porque es volátil, y en el cuerpo del ciclo vamos a hacer un call.
    xor r14, r14
    mov r14b, [rdi + OFFSET_SIZE]

.free_string:
    ; Chequeamos si terminamos de loopear.
    cmp r14, 0
    je .continue

    ; Actualizamos el contador del ciclo.
    dec r14

    ; Cargamos la dirección del string a liberar.
    mov rdi, [r13 + r14 * 8]
    call free

    jmp .free_string

.continue:
    ; Liberamos la memoria de data.
    mov rdi, r13
    call free

    ; Liberamos la memoria del struct.
    mov rdi, r12
    call free

    pop r14
    pop r13
    pop r12
    pop rbp
    ret
