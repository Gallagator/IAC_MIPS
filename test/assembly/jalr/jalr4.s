	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    jalr next
    addiu $2, $2, 1
    jr $0
    addiu $2, $2, 2

next:
    addiu $2, $2, 4
    jalr next2, $14
    addiu $2, $2, 8
    jr $31
    addiu $2, $2, 16
    jr $0
    addiu $2, $2, 32

next2:
    addiu $2, $2, 64
    jr $14
    addiu $2, $2, 128
    jr 0$
    addiu $2, $2, 256

.end	main