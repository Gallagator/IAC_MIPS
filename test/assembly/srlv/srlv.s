	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 4678
    addiu $4, 9
    jr $0
    srlv   $2, $3, $4
.end	main
