	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 2920
    addiu $4, 3348
    jr $0
    or   $2, $3, $4
.end	main
