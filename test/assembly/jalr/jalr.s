	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    addiu $2, $2, 16
    jalr next, $7
    addiu $2, $2, 1
    jr $0
    addiu $2, $2, 2

next:
    addiu $2, $2, 4
    jr $7
    addiu $2, $2, 8
    jr $0
    addiu $2, $2, 32

.end	main
