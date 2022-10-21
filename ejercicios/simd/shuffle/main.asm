global main

section .data
value:        dq 0x6677445522330011, 0xEEFFCCDDAABB8899
shuffle_mask: db 14, 15, 12, 13, 10, 11, 8, 9, 6, 7, 4, 5, 2, 3, 0, 1

section .text
main:
    movdqu xmm0, [value]
    movdqu xmm1, [shuffle_mask]
    pshufb xmm0, xmm1

.exit:
    xor ebx, ebx ; exit code 0
    mov	eax, 1   ; exit()
	int	0x80     ; syscall
