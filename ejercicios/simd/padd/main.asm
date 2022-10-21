global main

section .data
value0: dw 0x3892, 0xF145, 0xDEDA, 0xA164
value1: dw 0x532F, 0x1768, 0xE234, 0x94BA

section .text
main:
    ; PADDW - Packed ADD Word
    movq xmm0, [value0]
    movq xmm1, [value1]
    paddw xmm0, xmm1
    ; 0x8BC1, 0x8AD, 0xC10E, 0x361E

    ; PADDSW - Packed ADD signed Saturation Word
    movq xmm0, [value0]
    movq xmm1, [value1]
    paddsw xmm0, xmm1
    ; 0x7FFF, 0x8AD, 0xC10E, 0x8000

    ; PADDUSW - Packed ADD Unsigned Saturation Word
    movq xmm0, [value0]
    movq xmm1, [value1]
    paddusw xmm0, xmm1
    ; 0x8BC1, 0xFFFF, 0xFFFF, 0xFFFF

.exit:
    xor ebx, ebx ; exit code 0
    mov	eax, 1   ; exit()
	int	0x80     ; syscall
