	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, $3, -3
    addiu $4, $4, 5
    div $4, $3
    mfhi $5
    jr $0
    mflo $2
.end	main
