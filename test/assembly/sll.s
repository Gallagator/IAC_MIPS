	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 2
    sll   $2, $3, 5
    jr $0
.end	main
