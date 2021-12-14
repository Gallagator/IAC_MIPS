    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    jr $0
    addiu $2, $2, 4
	addiu $2, $2, 4
.end	main
