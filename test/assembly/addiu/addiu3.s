	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    addiu $2, $3, 0xFFFF
    jr $0
.end	main
