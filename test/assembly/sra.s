	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 1
    sll   $4, $3, 31
    sra   $2, $4, 5
    jr $0
.end	main
