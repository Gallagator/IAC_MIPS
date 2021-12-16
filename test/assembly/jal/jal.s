	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    jal next
    addiu $2, $2, 1
    jr $0
    addiu $2, $2, 7

next:
    addiu $2, $2, 2
    jr $31
    addiu $2, $2, 3
    addiu $2, $2, 5

.end	main
