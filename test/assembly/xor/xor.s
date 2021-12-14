	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 1422
    addiu $4, 843
    jr $0
    xor   $2, $3, $4
.end	main
