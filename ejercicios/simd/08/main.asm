; Hecho con Rafa Romani :)

global main
global debug
extern printf

section .data
; El vector lo definimos como una secuencia de bytes.
; Pero recordemos que en realidad cada elemento del vector ocupa 1 byte y medio (12 bits).
; Vamos a tener que hacer una secuencia de operaciones para reacomodar los elementos
; en words (16 bits) ya que sino no podemos operar con ellos, pues las operaciones de
; simd trabajan con elementos de tamaño estándar (byte, word, double word, etc).

vector:   db 0x00, 0x10, 0x02, 0x00, 0x30, 0x04, 0x00, 0x50, 0x06, 0x00, 0x70, 0x08, 0x00, 0x90, 0x0a, 0x00, 0xb0, 0x0c, 0x00, 0xd0, 0x0e, 0x00, 0xf0, 0x10, 0x01, 0x10, 0x12, 0x01, 0x30, 0x14, 0x01, 0x50, 0x16, 0x01, 0x70, 0x18
mask1:    db 0xFF, 0xF0, 0x00, 0xFF, 0xF0, 0x00, 0xFF, 0xF0, 0x00, 0xFF, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00
mask2:    db 0x00, 0x0F, 0xFF, 0x00, 0x0F, 0xFF, 0x00, 0x0F, 0xFF, 0x00, 0x0F, 0xFF, 0x00, 0x00, 0x00, 0x00
shuffle1: db 0x01, 0x00, 0xFF, 0xFF, 0x04, 0x03, 0xFF, 0xFF, 0x07, 0x06, 0xFF, 0xFF, 0x0A, 0x09, 0xFF, 0xFF
shuffle2: db 0xFF, 0xFF, 0x02, 0x01, 0xFF, 0xFF, 0x05, 0x04, 0xFF, 0xFF, 0x08, 0x07, 0xFF, 0xFF, 0x0B, 0x0A
shuffle3: db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0D, 0x0C

printf_fmt_ordenado: db `Ordenado\n`, 0
printf_fmt_desordenado: db `Desordenado\n`, 0

section .text
main:
    ; Prólogo.
    push rbp
    mov rbp, rsp

    ; Cargamos las máscaras para usar luego.
    movdqu xmm3, [mask1]
    movdqu xmm4, [mask2]
    movdqu xmm5, [shuffle1]
    movdqu xmm6, [shuffle2]
    movdqu xmm7, [shuffle3]

    ; ----------------------------------------------------------------------------------

    ; Empezamos cargando un registro xmm (128 bits) donde entran 10 elementos completos,
    ; porque cada elemento tiene 12 bits. Al final nos queda un elemento incompleto.
    ; Por cada pasada solo vamos a usar los primeros 9 elementos para determinar si los
    ; primeros 8 elementos están en orden.
    ; [11][12] [22][33] [34][44] [55][56] [66][77] [78][88] [99][9A] [AA][BB]
    movdqu xmm0, [vector]

    ; Los duplicamos en estos otros registros porque lo vamos a necesitar después.
    movdqu xmm1, xmm0
    movdqu xmm2, xmm0

    ; Nos quedamos con los primeros 4 elementos en posiciones pares.
    ; [11][1-] [--][33] [3-][--] [55][5-] [--][77] [7-][--] [--][--] [--][--]
    pand xmm0, xmm3

    ; Shuffleamos para colocar cada elemento en un word.
    ; [1-][11] [--][--] [3-][33] [--][--] [5-][55] [--][--] [7-][77] [--][--]
    pshufb xmm0, xmm5

    ; Shifteamos a la derecha 1 nibble (4 bits) para alinear a word.
    ; [-1][11] [--][--] [-3][33] [--][--] [-5][55] [--][--] [-7][77] [--][--]
    psrlw xmm0, 4

    ; Ahora nos quedamos con los primeros 4 elementos en posiciones impares.
    ; [--][-2] [22][--] [-4][44] [--][-6] [66][--] [-8][88] [--][--] [--][--]
    pand xmm1, xmm4

    ; Shuffleamos para colocar cada elemento en un word. Ya están alineados.
    ; [--][--] [22][-2] [--][--] [44][-4] [--][--] [66][-6] [--][--] [88][-8]
    pshufb xmm1, xmm6

    ; Unimos los elementos pares e impares en ambos registros.
    ; [-1][11] [-2][22] [-3][33] [-4][44] [-5][55] [-6][66] [-7][77] [-8][88]
    por xmm0, xmm1
    por xmm1, xmm0

    ; Shiteamos 1 word hacia la izquierda para después comparar verticalmente cada
    ; elemento con el que le sigue.
    ; [-2][22] [-3][33] [-4][44] [-5][55] [-6][66] [-7][77] [-8][88] [--][--]
    psrldq xmm1, 2

    ; Shuffleamos para colocar el noveno elemento en la última word.
    ; [--][--] [--][--] [--][--] [--][--] [--][--] [--][--] [--][--] [9A][99]
    pshufb xmm2, xmm7

    ; Shifteamos a la derecha 1 nibble (4 bits) para alinear a word.
    ; [--][--] [--][--] [--][--] [--][--] [--][--] [--][--] [--][--] [-9][99]
    psrlw xmm2, 4

    ; Colocamos el noveno elemento en su lugar.
    ; [-2][22] [-3][33] [-4][44] [-5][55] [-6][66] [-7][77] [-8][88] [-9][99]
    por xmm1, xmm2

    ; Comparamos verticalmente cada elemento con el que le sigue.
    ; Si están ordenados, xmm0 va a quedar todo en 0.
    ; xmm0 = [-1][11] [-2][22] [-3][33] [-4][44] [-5][55] [-6][66] [-7][77] [-8][88]
    ;           >         >         >       >        >        >        >        >
    ; xmm1 = [-2][22] [-3][33] [-4][44] [-5][55] [-6][66] [-7][77] [-8][88] [-9][99]
    pcmpgtw xmm0, xmm1
    ; Compactamos los 0s en 64 bits.
    phaddw xmm0, xmm0
    movq rax, xmm0
    cmp rax, 0
    jne desordenado

    ; ----------------------------------------------------------------------------------

    movdqu xmm0, [vector + 12]

    movdqu xmm1, xmm0
    movdqu xmm2, xmm0

    pand xmm0, xmm3

    pshufb xmm0, xmm5

    psrlw xmm0, 4

    pand xmm1, xmm4

    pshufb xmm1, xmm6

    por xmm0, xmm1
    por xmm1, xmm0

    psrldq xmm1, 2

    pshufb xmm2, xmm7

    psrlw xmm2, 4

    por xmm1, xmm2

    pcmpgtw xmm0, xmm1
    phaddw xmm0, xmm0
    movq rax, xmm0
    cmp rax, 0
    jne desordenado

    ; ----------------------------------------------------------------------------------

    movdqu xmm0, [vector + 24]

    movdqu xmm1, xmm0
    movdqu xmm2, xmm0

    pand xmm0, xmm3

    pshufb xmm0, xmm5

    psrlw xmm0, 4

    pand xmm1, xmm4

    pshufb xmm1, xmm6

    por xmm0, xmm1
    por xmm1, xmm0

    psrldq xmm1, 2

    ; Shuffleamos para colocar el último elemento otra vez como última word para comparar.
    ; [--][--] [--][--] [--][--] [--][--] [--][--] [--][--] [--][--] [0F][FF]
debug:
    mov eax, 0x7FFF
    pinsrw xmm1, eax, 0x7

    pcmpgtw xmm0, xmm1
    phaddw xmm0, xmm0
    movq rax, xmm0
    cmp rax, 0
    jne desordenado

print_ordenado:
    mov rdi, printf_fmt_ordenado
    xor al, al
    call printf
    jmp exit

desordenado:
    mov rdi, printf_fmt_desordenado
    xor al, al
    call printf
    jmp exit

exit:
    ; Epílogo.
    pop rbp
    xor ebx, ebx ; exit code 0
    mov	eax, 1   ; exit()
	int	0x80     ; syscall
