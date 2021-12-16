	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, $3, 3
    mult $3, $3
    mfhi $4
    mflo $2
    jr $0
.end	main
