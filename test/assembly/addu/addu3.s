.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 5
    addiu $7, 7
    addiu $10, 65530
    addu $7, $10, $3
    jr $0
.end	main
