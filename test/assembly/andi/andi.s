	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $31, 91
    jr $0
    andi   $2, $31, 54
.end	main
