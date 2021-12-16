	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 32767
    jr $0
    ori   $2, $3, 65535
.end	main
