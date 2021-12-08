	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $4, $0, 1234 
    addiu $5, $0, 0x30
    sw    $4, 10($5)
    lw    $2, 10($5)
    jr $0
.end	main

