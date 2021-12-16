	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    addiu $3, $3, 36
    addiu $4, $4, 56
    jalr $8, $3
    addiu $2, $2, 1
    jalr $31, $4
    addiu $2, $2, 2
    jr $0
    addiu $2, $2, 4

    addiu $2, $2, 8
    jr $8
    addiu $2, $2, 16
    jr $0
    addiu $2, $2, 32

    addiu $2, $2, 64
    jr $31
    addiu $2, $2, 128
    jr $0
    addiu $2, $2, 256

.end	main
