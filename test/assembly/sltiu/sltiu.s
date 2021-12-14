	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 10
    jr $0
    sltiu   $2, $3, 11
.end	main
