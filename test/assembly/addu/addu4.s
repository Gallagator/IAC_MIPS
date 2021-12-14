.text
	.align	2
	.globl	main
	.ent	main
main:
    addiu $3, 1
    addiu $7, 34
    addiu $10, 65530
    addu $7, $10, $3
    addu $4, $7, $3
	.set	noreorder
 .end	main
 