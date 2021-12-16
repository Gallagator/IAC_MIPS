	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 0
    addiu $4, 2345
    jr $0
    and   $2, $3, $4
.end	main
