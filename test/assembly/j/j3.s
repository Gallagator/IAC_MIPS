	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    addiu $3, $3, 3
    addiu $5, $5, 5
    j next
    nop
    div $5, $3
    jr $0
    addiu $2, $2, 30

next:
    jr $0
    addu $2, $3, $5

.end	main

