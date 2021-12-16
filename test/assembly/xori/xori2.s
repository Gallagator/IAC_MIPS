	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $2, 1422
    jr $0
    xori   $2, $0, 32767
.end	main
