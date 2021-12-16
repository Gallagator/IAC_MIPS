	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, -1
	addiu $7, 0
    jr $0
    andi   $2, $7, 7563
.end	main
