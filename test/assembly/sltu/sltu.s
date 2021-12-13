	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 15
    addiu $4, 16
    jr $0
    sltu   $2, $3, $4
.end	main
