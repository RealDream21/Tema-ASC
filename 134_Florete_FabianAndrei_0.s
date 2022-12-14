.data
	nr_cerinta: .space 4
	n: .space 4
	v: .space 40000
	frecv_leg: .space 404
	read_format: .asciz "%ld"
.text
.globl main
main:
citire_numar_cerinta:
	pushl $nr_cerinta
	pushl $read_format
	call scanf
	subl $8, %esp

citire_numar_noduri:
	pushl $n
	pushl $read_format
	call scanf
	subl $8, %esp

creare_matrice:
#ebx = i-> i*4*nr_col = %eax. #ecx = j
#eax = i, #ecx = j in v[i][j]


initializre_legaturi:
	xorl %ecx, %ecx
	lea frecv_leg, %esi
#citesc frecventa nodurilor
for1:
	cmpl n, %ecx
	je after_for1

	pushl %ecx
	lea (%esi, %ecx, 4), %eax
	pushl %eax
	pushl $read_format
	call scanf
	addl $8, %esp
	popl %ecx

	incl %ecx
	jmp for1

after_for1:
#creez graficul, citesc legaturile fiecarui nod
#ecx parcurge vectorul de noduri
#ebx parcurge detinatia nodurilor
#v[i][[j] = 1

	xorl %ecx, %ecx
	lea v, %esi
	lea frecv_leg, %edi
for2:
	cmpl n, %ecx
	je select_cerinta

#pregatesc indicele liniei in %eax care va fi salvat pe stiva
	movl n, %eax
	mull %ecx
	shl $2, %eax
	movl (%edi, %ecx, 4), %ebx
	addl %eax, %esi
	pushl %eax
	for3:
		cmpl $0, %ebx
		je after_for3

		pushl %ecx
		subl $4, %esp
		pushl $read_format
		call scanf
		addl $4, %esp
		popl %eax
		popl %ecx

		movl $1, (%esi, %eax, 4)
		stop:
		decl %ebx
		jmp for3
	after_for3:
	popl %eax
	subl %eax, %esi
	incl %ecx
	jmp for2


select_cerinta:
	cmpl $1, nr_cerinta
	je cerinta1
	cmpl $2, nr_cerinta
	je cerinta2
	jmp exit

cerinta1:
cerinta2:

exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
