	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 4678
    addiu $4, 9
    srlv   $2, $3, $4
    jr $0
.end	main
