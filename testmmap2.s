.data
	pointer1: .space 4
	pointer2: .space 4
.text
.globl main
main:
	movl $192, %eax
	movl $0, %ebx
	movl $40000, %ecx
	movl $3, %edx
	movl $33, %esi
	movl $-1, %edi
	movl $0, %ebp
	int $0x80

	movl %eax, pointer1

	movl $192, %eax
	movl $0, %ebx
	movl $40000, %ecx
	movl $3, %edx
	movl $33, %esi
	movl $-1, %edi
	movl $0, %ebp
	int $0x80

	movl $91, %eax
	movl pointer2, %ebx
	movl $40000, %ecx
	int $0x80

exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
