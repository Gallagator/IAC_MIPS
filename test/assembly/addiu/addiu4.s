	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    addiu $2, $3, 6553
    addiu $2, $2, 2
	jr $0
.end	main

