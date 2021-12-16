	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    j next
    addiu $2, $2, 1
    jr $0
    addiu $2, $2, 2

next:
    j next2
    j next3
    addiu $2, $2, 32
    jr $0
    addiu $2, $2, 4

next2:
    jr $0
    addiu $2, $2, 8


next3:
    jr $0
    addiu $2, $2, 16


.end	main
