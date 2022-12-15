init:
        xorl %ebx, %ebx
        lea v, %esi
for1:
        cmpl n, %ebx
        je select_cerinta

        movl n, %eax
        movl $4, %ecx
        mull %ecx
        mull %ebx

        xorl %ecx, %ecx
        addl %eax, %esi
        for2:
                cmpl n, %ecx
                je after_for1

                movl $69, (%esi, %ecx, 4)
                incl %ecx
                jmp for2
        after_for1:
        subl %eax, %esi
        incl %ebx
        jmp for1
