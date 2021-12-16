	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    addiu $3, $3, 28
    addiu $2, $2, 16
    jalr $7, $3
    addiu $2, $2, 1
    jr $0
    addiu $2, $2, 2

    addiu $2, $2, 4
    jr $7
    addiu $2, $2, 8
    jr $0
    addiu $2, $2, 32

.end	main
