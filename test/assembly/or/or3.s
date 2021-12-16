	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 32767
    addiu $4, 0
    jr $0
    or   $2, $3, $4
.end	main
