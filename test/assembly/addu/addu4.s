.text
	.align	2
	.globl	main
	.ent	main
main:
    .set noreorder
    addiu $3, -1
    addiu $7, -33
    addiu $10, 6553
    addu $7, $10, $3 
    jr $0
    addu $2, $7, $3
.end main
 