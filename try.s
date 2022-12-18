.data
	x: .space 4
	nr_cerinta: .space 4
	n: .space 4
	m1: .space 40000
	m2: .space 40000
	mres: .space 40000
	frecv_leg: .space 404
	read_format: .asciz "%ld"
	print_format: .asciz "%ld "
	flush_format: .asciz "\n"
.text
#matrix_mult(m1, m2, mres, n)
matrix_mult:
	pushl %ebp
	movl %esp,  %ebp

	subl $12,  %esp

	#adresa de inceput a m1 in %esi, adresa de inceput a m2 in %edi
	#adresa mres este in 16(%ebp)

	movl $0, -4(%ebp)

#20(%ebp) are n-ul
#-4(%ebp) are cnt_for1
#-8(%ebp) are cnt_for2
#-12(%ebp) are cnt_for3
for1_matrix:
	movl 20(%ebp), %eax
	cmpl %eax, -4(%ebp)
	je return
	#for(int i = 0; i < n; i++)

	movl $0, -8(%ebp)

	movl -4(%ebp), %eax
	movl 20(%ebp), %ecx
	mull %ecx
	shl $2, %eax

	addl %eax, 8(%ebp)
	addl %eax, 16(%ebp)
	#in 8(%ebp) ar trb acum sa fie pozitionata linia de inceput pt a[i][k]. Adica am a[i][] pana acum. pushl %eax ca sa stiu cat sa scad dupa
	#calculez intre timp si c[i][j]

	pushl %eax
	for2_matrix:
		movl 20(%ebp), %eax
		cmpl %eax, -8(%ebp)
		je after_for2_matrix
		#for(int j = 0; j < n; j++)

		movl $0, -12(%ebp)
		movl -8(%ebp), %eax
		addl %eax, 12(%ebp)
		addl %eax, 16(%ebp)
		pushl %eax
		for3_matrix:
			movl 20(%ebp), %eax
			cmpl %eax, -12(%ebp)
			je after_for3_matrix

			#for(int k = 0; k < n; k++)
			#c[i][j] += a[i][k] * b[k][j]
			#momentan am a[i][] si b[][j]
			#=> la a[i][] mai adun k si la b[][j] mai adun k*len << 2
			#=> 8(%ebp) += k
			#=> 12(%ebp) += k * len << 2

			movl -12(%ebp), %eax
			pushl %eax
			addl %eax, 8(%ebp)

			movl 20(%ebp), %ecx
			mull %ecx
			shl $2, %eax
			pushl %eax
			addl %eax, 12(%ebp)

			#fac c[i][j] = 8(%ebp) * 12(%ebp)

			movl 8(%ebp), %eax
			movl 12(%ebp), %ecx
			mult:
			mull %ecx

			movl 16(%ebp), %ecx
			addl %eax, %ecx
			movl %ecx, 16(%ebp)

			popl %eax
			subl %eax, 12(%ebp)
			popl %eax
			subl %eax, 8(%ebp)

			incl -12(%ebp)
			jmp for3_matrix
		after_for3_matrix:
		popl %eax
		subl %eax, 12(%ebp)
		subl %eax, 16(%ebp)
		incl -8(%ebp)
		jmp for2_matrix
	after_for2_matrix:
	popl %eax
	subl %eax, 8(%ebp)
	subl %eax, 16(%ebp)
	incl -4(%ebp)
	jmp for1_matrix

return:
	addl $12, %esp
	popl %ebp
	ret


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
	lea m1, %esi
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
		pushl $x
		pushl $read_format
		call scanf
		addl $4, %esp
		movl x, %eax
		addl $4, %esp
		popl %ecx

		test:
		movl $1, (%esi, %eax, 4)

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
	xorl %ecx, %ecx
	lea m1, %esi
for1_cerinta1:
	cmpl n, %ecx
	je exit

	movl n, %eax
	mull %ecx
	shl $2, %eax

	addl %eax, %esi
	xorl %ebx, %ebx

	pushl %eax
	pushl %ecx
	for2_cerinta1:
		cmpl n, %ebx
		je after_for2_cerinta1

		pushl (%esi, %ebx, 4)
		pushl $print_format
		call printf
		addl $8, %esp

		incl %ebx
		jmp for2_cerinta1

	after_for2_cerinta1:
	pushl $flush_format
	call printf
	addl $4, %esp

	popl %ecx
	popl %eax
	subl %eax, %esi
	incl %ecx
	jmp for1_cerinta1

cerinta2:
	pushl n
	pushl $mres
	pushl $m1
	pushl $m1
	call matrix_mult
	addl $16, %esp

exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80

