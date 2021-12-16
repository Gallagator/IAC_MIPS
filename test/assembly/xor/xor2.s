	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $31, 32767
    addiu $12, -32768
    jr $0
    xor   $2, $31, $12
.end	main
