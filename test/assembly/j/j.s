	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    j next
    addiu $2, $2, 3
    jr $0
    addiu $2, $2, 7

next:
    jr $0
    addiu $2, $2, 5

.end	main
