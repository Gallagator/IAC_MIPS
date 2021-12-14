.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 5
    addiu $7, 7
    addu  $2, $3, $7
    jr $0
.end	main
