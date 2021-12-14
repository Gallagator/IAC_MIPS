.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $2, 5
    addu  $2, $2, $2
    addu  $2, $2, $2
    jr $0
.end	main
