	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 32767
    addiu $14, 843
    jr $0
    xor   $2, $3, $0
.end	main
