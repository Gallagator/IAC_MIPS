    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    lui   $4, 0xABCD
    addiu $4, $4, 0x1234 
    sw    $4, 0($0)
    sw    $4, 4($0)
    jr $0
    lw   $2, 4($0)
.end	main
