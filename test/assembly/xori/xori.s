	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 1422
    xori   $2, $3, 843
    jr $0
.end	main
