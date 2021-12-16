	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, -1
    jr $0
    andi   $2, $3, 9847
.end	main
