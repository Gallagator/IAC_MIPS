	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, -15
    addiu $4, -14
    jr $0
    slt   $2, $3, $4
.end	main
