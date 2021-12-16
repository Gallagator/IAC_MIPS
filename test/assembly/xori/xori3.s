	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, -1
    jr $0
    xori   $2, $3, 32767
.end	main
