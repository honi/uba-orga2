extern printf
global main

section .data
%define INVOCADA_ARG 2 ; Cuánto sumar a la dirección de retorno.
printf_fmt_result:   db `Result:   %#018x\n`, 0
printf_fmt_expected: db `Expected: %#018x\n`, 0

section .text
main:
    ; Prólogo.
    push rbp
    mov rbp, rsp

    call llamadora

.print_result:
    mov rdi, printf_fmt_result ; Primer argumento: string con el formato.
    mov rsi, rax               ; Segundo argumento: valor a imprimir.
    xor al, al                 ; Magia para que no crashee printf.
    call printf

.print_return_address:
    mov rdi, printf_fmt_expected
    mov rsi, return_address
    xor al, al
    call printf

.exit:
    ; Epílogo.
    pop rbp

    xor ebx, ebx ; exit code 0
    mov	eax, 1   ; exit()
	int	0x80     ; syscall

llamadora:
    mov rdi, INVOCADA_ARG
    call invocada
    return_address: equ $
    ret

invocada:
    mov rax, [rsp]
    add rax, rdi
    ret
