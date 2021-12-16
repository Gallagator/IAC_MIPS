	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 8967
    jr $0
    ori   $2, $3, 0
.end	main
