global agrupar
global debug
extern malloc
extern memcpy

section .data
; En mi máquina size_t me reporta 8 bytes.
%define OFFSET_MSG_TEXT 0
%define OFFSET_MSG_TEXT_LEN 8
%define OFFSET_MSG_TAG 16
%define SIZE_MSG_STRUCT 24
%define SIZE_POINTER 8
%define MAX_TAGS 4

section .text
; char** agrupar(msg_t* msgArr, size_t msgArr_len)
; rdi = msg_t* msgArr
; rsi = size_t msgArr_len
agrupar:
    ; Prólogo.
    push rbp
    mov rbp, rsp

    ; Preservamos los registros no volátiles.
    push r12 ; desalineado
    push r13 ; alineado
    push r14 ; desalineado
    push r15 ; alineado

    ; Preservamos los argumentos de entrada en registros no volátiles para no perderlos
    ; al llamar a malloc u otras funciones.
    mov r12, rdi ; msgArr
    mov r13, rsi ; msgArr_len

    ; Reservamos espacio en el stack para variables temporales.
    ; Asumimos que MAX_TAGS % 2 == 0 -> el stack queda alineado.
    ; Acá vamos a guardar la longitud total del mensaje de cada tag, que luego vamos a
    ; resetear y usar de contador para trackear dónde tenemos que copiar el siguiente
    ; mensaje.
    sub rsp, SIZE_POINTER * MAX_TAGS

    ; Inicializamos los contadores de longitud que están en el stack.
    mov rcx, MAX_TAGS ; Asumimos que MAX_TAGS > 0.

.init_tag_counters:
    mov qword [rsp + rcx * SIZE_POINTER - SIZE_POINTER], 0
    loop .init_tag_counters

    ; Recorremos una vez todos los mensajes para calcular la longitud total de cada tag.
    ; En rdi ya tenemos la dirección del primer mensaje (si es que existe).
    mov rcx, r13

.count_tags_max_length:
    ; Condición de iteración y ajuste del contador.
    cmp rcx, 0
    je .continue1
    dec rcx

    ; Cargamos el largo del mensaje y el tag.
    mov rax, [rdi + OFFSET_MSG_TEXT_LEN]
    mov ebx, [rdi + OFFSET_MSG_TAG]

    ; Incrementamos el acumulador por tag que está en el stack.
    add [rsp + rbx * SIZE_POINTER], rax

    ; Avanzamos al siguiente mensaje.
    add rdi, SIZE_MSG_STRUCT

    jmp .count_tags_max_length

.continue1:
    ; Pedimos memoria para el resultado.
    mov rdi, SIZE_POINTER * MAX_TAGS
    call malloc

    ; Guardamos el puntero al resultado en un no volátil.
    mov r14, rax

    ; Pedimos memoria para los mensajes de que cada tag.
    ; No podemos usar rcx porque es volátil.
    mov r15, MAX_TAGS

.malloc_tag_msg:
    ; Obtenemos la cantidad de caracteres totales que tienen todos los mensajes del tag.
    mov rdi, [rsp + r15 * SIZE_POINTER - SIZE_POINTER]

    ; Sumamos 1 para contemplar el NULL char.
    inc rdi

    ; Pedimos memoria y guardamos el puntero en el resultado.
    call malloc
    mov [r14 + r15 * SIZE_POINTER - SIZE_POINTER], rax

    ; Volvemos a obtener la cantidad de caracteres totales (sin contar el NULL char).
    mov rdi, [rsp + r15 * SIZE_POINTER - SIZE_POINTER]

    ; Escribimos el NULL char.
    mov byte [rax + rdi], 0

    ; Reseteamos el contador del tag ya que lo vamos a usar luego para trackear por
    ; dónde vamos copiando los mensajes.
    mov qword [rsp + r15 * SIZE_POINTER - SIZE_POINTER], 0

    ; Condición de iteración y ajuste del contador.
    dec r15
    cmp r15, 0
    jne .malloc_tag_msg

    ; Recorremos todos los mensajes una segunda vez y concatenamos todos los mensajes por tag.
    ; Ahora ya podemos destruir r12 y r13 porque no los vamos a usar más.

debug:
.concatenate_msgs:
    ; Condición de iteración y ajuste del contador.
    cmp r13, 0
    je .exit
    dec r13

    ; Cargamos el struct del mensaje.
    mov rax, [r12 + OFFSET_MSG_TEXT]
    mov rbx, [r12 + OFFSET_MSG_TEXT_LEN]
    mov ecx, [r12 + OFFSET_MSG_TAG]

    ; Cargamos la cantidad de caracteres que ya copiamos para este tag.
    ; Este es el offset desde donde vamos a colocar el mensaje que estamos procesando.
    mov r8, [rsp + rcx * SIZE_POINTER]

    ; Actualizamos la cantidad de caracteres que ya copiamos para este tag.
    add [rsp + rcx * SIZE_POINTER], rbx

    ; Cargamos el puntero al string que le corresponde al tag del mensaje.
    mov r9, [r14 + rcx * SIZE_POINTER]

    ; Le sumamos el offset.
    add r9, r8

    ; Concatenamos el mensaje con lo que ya tenemos.
    mov rdi, r9  ; dest
    mov rsi, rax ; src
    mov rdx, rbx ; size
    call memcpy

    ; Avanzamos al siguiente mensaje.
    add r12, SIZE_MSG_STRUCT

    jmp .concatenate_msgs

.exit:
    ; Devolvemos el puntero al resultado.
    mov rax, r14

    ; Liberamos el espacio del stack usado para las variables temporales.
    add rsp, SIZE_POINTER * MAX_TAGS

    ; Restauramos los registros no volátiles.
    pop r15
    pop r14
    pop r13
    pop r12

    ; Epílogo.
    pop rbp
    ret
