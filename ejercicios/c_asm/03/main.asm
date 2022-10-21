extern printf
global main

section .data
%define ELEMENT_SIZE 4
vector: times 16 dd 1 ; Escribimos 16 veces consecutivas un dd = double word (4 bytes).
printf_format: db `Suma: %d\n`, 0

section .text
main:
    ; Preservamos el rbp de la invocadora y de paso alineamos el stack.
    push rbp
    mov rbp, rsp

    ; Preservamos los registros no volátiles en el stack.
    push rbx ; desalineado
    push rbp ; alineado
    push r12 ; desalineado
    push r13 ; alineado
    push r14 ; desalineado
    push r15 ; alineado

    ; Cargamos los elementos del vector en registros.
    mov eax, [vector]
    mov ebx, [vector + ELEMENT_SIZE]
    mov ecx, [vector + ELEMENT_SIZE * 2]
    mov edx, [vector + ELEMENT_SIZE * 3]
    ; mov esp, [vector + ELEMENT_SIZE * 4] ; No podemos hacer esto porque perdemos la referencia al tope del stack.
    mov ebp, [vector + ELEMENT_SIZE * 4]
    mov esi, [vector + ELEMENT_SIZE * 5]
    mov edi, [vector + ELEMENT_SIZE * 6]
    mov r8d, [vector + ELEMENT_SIZE * 7]
    mov r9d, [vector + ELEMENT_SIZE * 8]
    mov r10d, [vector + ELEMENT_SIZE * 9]
    mov r11d, [vector + ELEMENT_SIZE * 10]
    mov r12d, [vector + ELEMENT_SIZE * 11]
    mov r13d, [vector + ELEMENT_SIZE * 12]
    mov r14d, [vector + ELEMENT_SIZE * 13]
    mov r15d, [vector + ELEMENT_SIZE * 14]

    ; Sumamos todos los registros en rax.
    add rax, rbx
    add rax, rcx
    add rax, rdx
    add rax, rbp
    add rax, rsi
    add rax, rdi
    add rax, r8
    add rax, r9
    add rax, r10
    add rax, r11
    add rax, r12
    add rax, r13
    add rax, r14
    add rax, r15

    ; Nos quedó pendiente sumar el último elemento del vector.
    ; Reutilizamos algún otro registro para eso.
    mov r15d, [vector + ELEMENT_SIZE * 15]
    add rax, r15

.print_result:
    mov rdi, printf_format ; Primer argumento: string con el formato.
    mov rsi, rax           ; Segundo argumento: valor a imprimir.
    xor al, al             ; Magia para que no crashee printf.
    call printf

.exit:
    ; Restauramos los registros no volátiles desde el stack.
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx

    ; Restauramos rbp para la invocadora.
    pop rbp

    xor ebx, ebx ; exit code 0
    mov	eax, 1   ; exit()
	int	0x80     ; syscall
