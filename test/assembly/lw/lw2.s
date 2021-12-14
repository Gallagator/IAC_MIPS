    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $4, $0, 1234 
    addiu $5, $0, 0x30
    sw    $4, 8($5)
    lw    $2, 8($5)
    addu  $2, $2, $5
    sw    $2, 4($5)
    lw    $2, 4($5)
    jr $0
.end	main

