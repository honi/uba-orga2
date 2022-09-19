extern printf
global main

section .data
%define ELEMENT_SIZE 4
vector: times 16 dd 1 ; Escribimos 16 veces consecutivas un dd = double word (4 bytes).
vector_size_b: equ $ - vector ; Calculamos el tamaño en bytes del vector.
printf_format: db `Suma: %d\n`, 0

section .text
main:
    ; Preservamos el rbp de la invocadora y de paso alineamos el stack.
    push rbp
    mov rbp, rsp

    ; Inicializamos el registro contador del ciclo.
    ; Dividimos por 4 para obtener la cantidad de elementos en el vector.
    mov rcx, vector_size_b >> 2

    ; Inicializamos rax en 0 para usarlo de acumulador.
    ; A pesar de estar sumando enteros de 4 bytes, usamos rax que tiene 8 bytes para
    ; evitar overflow al sumar demasiados valores grandes.
    xor rax, rax

    ; Inicializamos rdi en 0 porque vamos a usar solo la parte baja de este registro
    ; para cargar los elementos del vector desde memoria.
    ; Esto es necesario? Creo que no porque al hacer mov a un registro de 32bits se
    ; limpian automáticamente los 32bits de la parte alta.
    xor rdi, rdi

.sum_cycle:
    ; Recorrido de rcx durante el ciclo: #elementos..1
    mov edi, [vector + rcx * ELEMENT_SIZE - ELEMENT_SIZE]
    add rax, rdi
    loop .sum_cycle

.print_result:
    mov rdi, printf_format ; Primer argumento: string con el formato.
    mov rsi, rax           ; Segundo argumento: valor a imprimir.
    xor al, al             ; Magia para que no crashee printf.
    call printf

.exit:
    ; Restauramos rbp para la invocadora.
    pop rbp

    xor ebx, ebx ; exit code 0
    mov	eax, 1   ; exit()
	int	0x80     ; syscall
