extern printf
global main

section .data
%define ELEMENT_SIZE 4
vector: times 16 dd 1 ; Escribimos 16 veces consecutivas un dd = double word (4 bytes).
vector_size_b: equ $ - vector ; Calculamos el tamaño en bytes del vector.
printf_format: db `Suma: %d\n`, 0 ; Por qué tienen que ser backticks?

section .text
main:
    ; Preservamos el rbp de la invocadora y de paso alineamos el stack.
    push rbp
    mov rbp, rsp

    ; Inicializamos el registro contador del ciclo.
    ; Dividimos por 4 para obtener la cantidad de elementos en el vector.
    mov rcx, vector_size_b >> 2

    ; Pusheamos al stack todos los elementos del vector.
    ; Tenemos que primero leer los elementos a un registro y luego pushear al stack
    ; porque en 64bits no podemos pushear 32bits directo desde la sección .data.
    ; A confirmar.
.push_to_stack:
    mov edi, [vector + rcx * ELEMENT_SIZE - ELEMENT_SIZE]
    push rdi
    loop .push_to_stack

    ; Inicializamos rax en 0 para usarlo de acumulador.
    xor rax, rax

    ; Volvemos a inicializamos el registro contador del ciclo.
    mov rcx, vector_size_b >> 2

.sum_cycle:
    pop rdi
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
