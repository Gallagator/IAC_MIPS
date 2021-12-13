	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 3
    addiu $4, 7
    jr $0
    sllv   $2, $3, $4
.end	main
