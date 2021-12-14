	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 91
    jr $0
    andi   $2, $3, 54
.end	main
