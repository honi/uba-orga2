global cesar_asm
extern strlen
extern malloc

section .data
%define FIRST_CHAR 65 ; ord('A')
%define MAX_CHARS 26

section .text
cesar_asm:
    ; rdi = char* input
    ; rsi = int x

    ; Prólogo
    push rbp
    mov rbp, rsp

    ; Guardamos los argumentos en el stack.
    push rdi ; desalineado
    push rsi ; alineado

    ; Calculamos strlen(input).
    ; En rdi ya tenemos char* input.
    call strlen
    ; Guardamos la longitud de input en un no volátil.
    mov r12, rax

    ; Hacemos malloc para el resultado.
    mov rdi, r12
    inc rdi ; Le sumamos 1 para contemplar el NULL char.
    call malloc
    mov r13, rax ; En r13 nos queda el puntero char* para guardar el resultado.

    ; Recuperamos los argumentos.
    pop rsi ; desalineado
    pop rdi ; alineado

    ; Limpiamos rax porque solo vamos a usar el byte menos significativo.
    xor rax, rax

    ; Movemos esta constante a r8 para luego dividir por r8 y obtener el resto.
    mov r8, MAX_CHARS

    ; Inicializamos el contador del loop.
    mov rcx, r12

    ; Seteamos el NULL char al final.
    mov byte [r13 + rcx], 0

    ; Si la longitud del input es 0 ya terminamos.
    cmp rcx, 0
    je .exit

    ; Hacemos el cifrado caracter por caracter desde atrás.
.cesar_loop:
    ; Leemos el caracter a transformar en al.
    mov al, [rdi + rcx - 1]

    ; Transformamos el caracter usando el argumento x (rsi) de la función.
    add rax, rsi
    sub rax, FIRST_CHAR
    xor rdx, rdx
    div r8
    mov rax, rdx
    add rax, FIRST_CHAR

    ; Copiamos el caracter transformado en el string de resultado y loopeamos.
    mov [r13 + rcx - 1], al
    loop .cesar_loop

.exit:
    ; Colocamos el puntero al resultado en el registro de retorno.
    mov rax, r13

    ; Epílogo
    pop rbp
    ret
