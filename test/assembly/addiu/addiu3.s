	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    addiu $2, $3, -1
    jr $0
.end	main
