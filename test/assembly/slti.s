	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, -20
    slti   $2, $3, -15
    jr $0
.end	main
