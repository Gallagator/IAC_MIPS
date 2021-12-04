	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 91
    ori   $2, $3, 54
    jr $0
.end	main
