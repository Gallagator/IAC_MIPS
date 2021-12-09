	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 3278
    addiu $4, 1754
    and   $2, $3, $4
    jr $0
.end	main
