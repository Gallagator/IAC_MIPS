	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    addiu $3, $3, 7
    addiu $30, $3, 8
    addiu $2, $30, 5
    jr $0
.end	main
