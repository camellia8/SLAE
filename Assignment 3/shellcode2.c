#include<stdlib.h>
#include<stdio.h>
#include<string.h>

unsigned char egghunter[] = \
"\x66\x81\xc9\xff\x0f\x41\x6a\x43\x58"
"\xcd\x80\x3c\xf2\x74\xf1\xb8\x90\x50"
"\x90\x50\x89\xcf\xaf\x75\xec\xaf\x75"
"\xe9\xff\xe7";

unsigned char code[] = \
"\x90\x50\x90\x50\x90\x50\x90\x50" // EGG - [NOP, PUSH eax] x4
"\x31\xc0\xb0\x04\x31\xdb\xb3\x01" //shellcode to execte write(hello world)
"\x31\xd2\x52\x52\x6a\x0a\x68\x72"
"\x6c\x64\x21\x68\x6f\x20\x57\x6f"
"\x68\x48\x65\x6c\x6c\x89\xe1\xb2"
"\x0d\xcd\x80\x31\xc0\xb0\x01\x31"
"\xdb\xcd\x80";

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
	
