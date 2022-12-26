.data
	x: .space 4
	nr_cerinta: .space 4
	n: .space 4
	m1: .space 4
	m2: .space 4
	mres: .space 4
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
		shl $2, %eax

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
			shl $2, %eax
			pushl %eax
			addl %eax, 8(%ebp)

			movl 20(%ebp), %ecx
			movl -12(%ebp), %eax
			mull %ecx
			shl $2, %eax
			pushl %eax
			addl %eax, 12(%ebp)

			#fac c[i][j] = 8(%ebp) * 12(%ebp)
			movl 8(%ebp), %eax
			movl 0(%eax), %eax
			movl 12(%ebp), %ecx
			movl 0(%ecx), %ecx
			mull %ecx

			pushl %edi
			movl 16(%ebp), %edi
			movl 16(%ebp), %ecx
			movl 0(%ecx), %ecx
			addl %eax, %ecx
			xorl %eax, %eax
			movl %ecx, (%edi, %eax, 4)
			popl %edi


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

init:
	pushl %ebp
	movl %esp, %ebp
	subl $8, %esp

	movl $0, -4(%ebp)

for1_init:
	movl 12(%ebp), %eax
	cmpl %eax, -4(%ebp)
	je return_init

	movl -4(%ebp), %eax
	movl 12(%ebp), %ecx
	mull %ecx
	shl $2, %eax

	movl $0, -8(%ebp)

	addl %eax, 8(%ebp)
	pushl %eax
	for2_init:
		movl 12(%ebp), %eax
		cmpl %eax, -8(%ebp)
		je after_for2_init

		movl -8(%ebp), %eax
		shl $2, %eax
		addl %eax, 8(%ebp)
		movl 8(%ebp), %ecx
		movl $0, 0(%ecx)

		subl %eax, 8(%ebp)

		incl -8(%ebp)
		jmp for2_init

	after_for2_init:
	popl %eax
	subl %eax, 8(%ebp)
	incl -4(%ebp)
	jmp for1_init

return_init:
	addl $8, %esp
	popl %ebp
	ret

copy:
#copy (m1, m2) => m2 se copiaza in m1
	pushl %ebp
	movl %esp, %ebp
	subl $8, %esp

	movl $0, -4(%ebp)
for1_copy:
	movl -4(%ebp), %eax
	cmpl %eax, 16(%ebp)
	je return_copy

	movl 16(%ebp), %ecx
	mull %ecx
	shl $2, %eax

	addl %eax, 8(%ebp)
	addl %eax, 12(%ebp)
	pushl %eax

	movl $0, -8(%ebp)
	for2_copy:
		movl -8(%ebp), %eax
		cmpl %eax, 16(%ebp)
		je after_for2_copy

		shl $2, %eax
		addl %eax, 8(%ebp)
		addl %eax, 12(%ebp)

		pushl %eax
		movl 12(%ebp), %eax
		movl 0(%eax), %eax
		movl 8(%ebp), %ecx
		movl %eax, 0(%ecx)

		popl %eax
		subl %eax, 8(%ebp)
		subl %eax, 12(%ebp)

		incl -8(%ebp)
		jmp for2_copy

	after_for2_copy:
	popl %eax
	subl %eax, 8(%ebp)
	subl %eax, 12(%ebp)
	incl -4(%ebp)
	jmp for1_copy

return_copy:
	addl $8, %esp
	popl %ebp
	ret

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
	movl %eax, m1

	movl $192, %eax
	movl $0, %ebx
	movl $40000, %ecx
	movl $3, %edx
	movl $33, %esi
	movl $-1, %edi
	movl $0, %ebp
	int $0x80
	movl %eax, m2

	movl $192, %eax
	movl $0, %ebx
	movl $40000, %ecx
	movl $3, %edx
	movl $33, %esi
	movl $-1, %edi
	movl $0, %ebp
	int $0x80
	movl %eax, mres

citire_numar_cerinta:
	pushl $nr_cerinta
	pushl $read_format
	call scanf
	addl $8, %esp

citire_numar_noduri:
	pushl $n
	pushl $read_format
	call scanf
	addl $8, %esp

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
	movl m1, %esi
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
	cmpl $3, nr_cerinta
	je cerinta2
	jmp exit

cerinta1:
	xorl %ecx, %ecx
	movl m1, %esi
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
	pushl m1
	pushl m2
	call copy
	addl $12, %esp

	pushl %ebp
	movl %esp, %ebp
	subl $12, %esp

	subl $4, %ebp
	pushl %ebp
	addl $4, %ebp
	pushl $read_format
	call scanf
	addl $8, %esp

	subl $8, %ebp
	pushl %ebp
	addl $8,  %ebp
	pushl $read_format
	call scanf
	addl $8, %esp

	subl $12, %ebp
	pushl %ebp
	addl $12, %ebp
	pushl $read_format
	call scanf
	addl $8, %esp

	pushl n
	pushl m1
	pushl mres
	call copy
	addl $12, %esp
	movl -4(%ebp), %eax
	decl -4(%ebp)
for1_cerinta2:
	#matricea trb ridicata la lung_drumului adica -4(%ebp)
	movl -4(%ebp), %eax
	cmpl $0, %eax
	je afisare_cerinta2

	pushl n
	pushl mres
	pushl m2
	call copy
	addl $12, %esp

	pushl n
	pushl mres
	call init
	addl $8, %esp

	pushl n
	pushl mres
	pushl m2
	pushl m1
	call matrix_mult
	addl $16, %esp

	decl -4(%ebp)
	jmp for1_cerinta2

afisare_cerinta2:
	movl mres, %esi

	movl -8(%ebp), %eax
	movl -12(%ebp), %ecx
	mull n
	shl $2, %eax
	addl %eax, %esi

	pushl (%esi, %ecx, 4)
	pushl $print_format
	call printf
	addl $8, %esp

	pushl $flush_format
	call printf
	addl $4, %esp

golire_stiva_cerinta2:
	addl $12, %esp
	popl %ebp

exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
