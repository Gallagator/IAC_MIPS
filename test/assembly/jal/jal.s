	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    jal procedure
    addiu $2, $2, 3
    jr $0
    addiu $2, $2, 7

    procedure:
    jr $0
    addiu $2, $2, 5

.end	main
