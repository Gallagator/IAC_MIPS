	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    addiu $3, $3, 79
    addiu $4, $4, 79
    beq $3, $4, .E1
    jr $0
    addiu $2, $0, 7

.E1:
    jr $0
    addiu $2, $0, 5
.end	main
