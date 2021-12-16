	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, -1
    addiu $4, 4567
    jr $0
    and   $2, $3, $4
.end	main
