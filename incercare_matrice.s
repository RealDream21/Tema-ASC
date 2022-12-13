.data
	n: .space 4
	v: .space 40000
	read_format: .asciz "%ld"
	print_format: .asciz "V[%ld][%ld] = %ld"
	buffer_clear: .asciz "\n"
.text
.globl main
main:
citire_n:
	pushl $n
	pushl $read_format
	call scanf
	subl $8, %esp

#ecx va fi pentru coloana
#ebx va fi pentru linie. Totusi formula va fi %eax(%esi, %ecx, 4) pt ca voi face 4*%ebx

	lea v, %esi
	xorl %ebx, %ebx
for1:
	cmpl n, %ebx
	je afisare

	pushl %ebx
	movl %ebx, %eax
	movl $16, %ebx
	mull %ebx
	popl %ebx
	xorl %ecx, %ecx

	addl %eax, %esi
	for2:
		cmpl n, %ecx
		je after_for2
		pushl %ecx
		pushl %eax
		lea (%esi, %ecx, 4), %eax
		pushl %eax
		pushl $read_format
		call scanf
		after:
		addl $8, %esp
		popl %eax
		popl %ecx

		incl %ecx
		jmp for2
	after_for2:
	subl %eax, %esi

	incl %ebx
	jmp for1

afisare:


exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
