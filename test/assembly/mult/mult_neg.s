	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, $3, -3
    addiu $4, $4, -4
    mult $3, $4
    mfhi $4
    jr $0
    mflo $2
.end	main
